Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A2C7217AA1
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 23:44:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728870AbgGGVoi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 17:44:38 -0400
Received: from www62.your-server.de ([213.133.104.62]:59392 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726273AbgGGVoh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 17:44:37 -0400
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jsvOF-0001dg-2q; Tue, 07 Jul 2020 23:44:35 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jsvOE-000WW5-TU; Tue, 07 Jul 2020 23:44:34 +0200
Subject: Re: [PATCH bpf-next v4 4/4] selftests/bpf: test
 BPF_CGROUP_INET_SOCK_RELEASE
To:     Stanislav Fomichev <sdf@google.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org
References: <20200706230128.4073544-1-sdf@google.com>
 <20200706230128.4073544-5-sdf@google.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <294755e5-58e7-5512-a2f5-2dc37f200acf@iogearbox.net>
Date:   Tue, 7 Jul 2020 23:44:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200706230128.4073544-5-sdf@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25866/Tue Jul  7 15:47:52 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/7/20 1:01 AM, Stanislav Fomichev wrote:
> Simple test that enforces a single SOCK_DGRAM socker per cgroup.
> 
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---
>   .../selftests/bpf/prog_tests/udp_limit.c      | 75 +++++++++++++++++++
>   tools/testing/selftests/bpf/progs/udp_limit.c | 42 +++++++++++
>   2 files changed, 117 insertions(+)
>   create mode 100644 tools/testing/selftests/bpf/prog_tests/udp_limit.c
>   create mode 100644 tools/testing/selftests/bpf/progs/udp_limit.c
> 
> diff --git a/tools/testing/selftests/bpf/prog_tests/udp_limit.c b/tools/testing/selftests/bpf/prog_tests/udp_limit.c
> new file mode 100644
> index 000000000000..2aba09d4d01b
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/udp_limit.c
> @@ -0,0 +1,75 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#include <test_progs.h>
> +#include "udp_limit.skel.h"
> +
> +#include <sys/types.h>
> +#include <sys/socket.h>
> +
> +static int duration;
> +
> +void test_udp_limit(void)
> +{
> +	struct udp_limit *skel;
> +	int fd1 = -1, fd2 = -1;
> +	int cgroup_fd;
> +
> +	cgroup_fd = test__join_cgroup("/udp_limit");
> +	if (CHECK(cgroup_fd < 0, "cg-join", "errno %d", errno))
> +		return;
> +
> +	skel = udp_limit__open_and_load();
> +	if (CHECK(!skel, "skel-load", "errno %d", errno))
> +		goto close_cgroup_fd;
> +
> +	skel->links.sock = bpf_program__attach_cgroup(skel->progs.sock, cgroup_fd);
> +	skel->links.sock_release = bpf_program__attach_cgroup(skel->progs.sock_release, cgroup_fd);
> +	if (CHECK(IS_ERR(skel->links.sock) || IS_ERR(skel->links.sock_release),
> +		  "cg-attach", "sock %ld sock_release %ld",
> +		  PTR_ERR(skel->links.sock),
> +		  PTR_ERR(skel->links.sock_release)))
> +		goto close_skeleton;
> +
> +	/* BPF program enforces a single UDP socket per cgroup,
> +	 * verify that.
> +	 */
> +	fd1 = socket(AF_INET, SOCK_DGRAM, 0);
> +	if (CHECK(fd1 < 0, "fd1", "errno %d", errno))
> +		goto close_skeleton;
> +
> +	fd2 = socket(AF_INET, SOCK_DGRAM, 0);
> +	if (CHECK(fd2 >= 0, "fd2", "errno %d", errno))
> +		goto close_skeleton;
> +
> +	/* We can reopen again after close. */
> +	close(fd1);
> +	fd1 = -1;
> +
> +	fd1 = socket(AF_INET, SOCK_DGRAM, 0);
> +	if (CHECK(fd1 < 0, "fd1-again", "errno %d", errno))
> +		goto close_skeleton;
> +
> +	/* Make sure the program was invoked the expected
> +	 * number of times:
> +	 * - open fd1           - BPF_CGROUP_INET_SOCK_CREATE
> +	 * - attempt to openfd2 - BPF_CGROUP_INET_SOCK_CREATE
> +	 * - close fd1          - BPF_CGROUP_INET_SOCK_RELEASE
> +	 * - open fd1 again     - BPF_CGROUP_INET_SOCK_CREATE
> +	 */
> +	if (CHECK(skel->bss->invocations != 4, "bss-invocations",
> +		  "invocations=%d", skel->bss->invocations))
> +		goto close_skeleton;
> +
> +	/* We should still have a single socket in use */
> +	if (CHECK(skel->bss->in_use != 1, "bss-in_use",
> +		  "in_use=%d", skel->bss->in_use))
> +		goto close_skeleton;
> +
> +close_skeleton:
> +	if (fd1 >= 0)
> +		close(fd1);
> +	if (fd2 >= 0)
> +		close(fd2);
> +	udp_limit__destroy(skel);
> +close_cgroup_fd:
> +	close(cgroup_fd);
> +}
> diff --git a/tools/testing/selftests/bpf/progs/udp_limit.c b/tools/testing/selftests/bpf/progs/udp_limit.c
> new file mode 100644
> index 000000000000..edbb30a27e63
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/udp_limit.c
> @@ -0,0 +1,42 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +
> +#include <sys/socket.h>
> +#include <linux/bpf.h>
> +#include <bpf/bpf_helpers.h>
> +
> +int invocations = 0, in_use = 0;
> +
> +SEC("cgroup/sock")

nit: Doesn't matter overly much, but given you've added `cgroup/sock_create`
earlier in patch 2/4 intention was probably to use it as well. But either is
fine as it resolved to the same.

> +int sock(struct bpf_sock *ctx)
> +{
> +	__u32 key;
> +
> +	if (ctx->type != SOCK_DGRAM)
> +		return 1;
> +
> +	__sync_fetch_and_add(&invocations, 1);
> +
> +	if (in_use > 0) {
> +		/* BPF_CGROUP_INET_SOCK_RELEASE is _not_ called
> +		 * when we return an error from the BPF
> +		 * program!
> +		 */
> +		return 0;
> +	}
> +
> +	__sync_fetch_and_add(&in_use, 1);
> +	return 1;
> +}
> +
> +SEC("cgroup/sock_release")
> +int sock_release(struct bpf_sock *ctx)
> +{
> +	__u32 key;
> +
> +	if (ctx->type != SOCK_DGRAM)
> +		return 1;
> +
> +	__sync_fetch_and_add(&invocations, 1);
> +	__sync_fetch_and_add(&in_use, -1);
> +	return 1;
> +}
> 

