Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A90F026946A
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 20:08:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726149AbgINSID (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 14:08:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:38334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726142AbgINSHp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Sep 2020 14:07:45 -0400
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E328421BE5;
        Mon, 14 Sep 2020 18:07:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600106864;
        bh=urbtEzAStq9D8KVHTpwpJn7jcktQ6xC9fDu3gqRUPFY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=NFTeoWN5BtSyuRAkk3F3SSt0TKQNWr5/wwsVvf2VWeFhvOic4nJw99gnG4AI5nCk2
         fVtUprdLbmrmRpszi0/2pIvVrivYCeEIcFu0qw2qKEygXwV4EA0RwiQ3dZcDLjLg8U
         G3PXt85ubBilRmGyyCaN3nv244fWnikl+9wGDjd8=
Received: by mail-lf1-f49.google.com with SMTP id m5so251456lfp.7;
        Mon, 14 Sep 2020 11:07:43 -0700 (PDT)
X-Gm-Message-State: AOAM531tdWmu5PJcAvQbHvJv6mL/64onvHLXXB0nPJjh6ibB2y3g5lN6
        FolqOERlnf3gXu9t6qglIgnshGToxpcLuoKCRHQ=
X-Google-Smtp-Source: ABdhPJyREUEE8MAAwOs63WnZ92YdJHUoIdZ/ETZfDrACdaP4fhOS0Obz6X1gohOICs2Ujw3g1l+QQn5wORhY2QkJ/24=
X-Received: by 2002:a19:8907:: with SMTP id l7mr4802438lfd.105.1600106862141;
 Mon, 14 Sep 2020 11:07:42 -0700 (PDT)
MIME-Version: 1.0
References: <20200911143022.414783-1-nicolas.rybowski@tessares.net> <20200911143022.414783-4-nicolas.rybowski@tessares.net>
In-Reply-To: <20200911143022.414783-4-nicolas.rybowski@tessares.net>
From:   Song Liu <song@kernel.org>
Date:   Mon, 14 Sep 2020 11:07:30 -0700
X-Gmail-Original-Message-ID: <CAPhsuW5Gbx2pWgM1XcSYqVsN6L=q+0u3QFNxG7A+Qez=Tziu2A@mail.gmail.com>
Message-ID: <CAPhsuW5Gbx2pWgM1XcSYqVsN6L=q+0u3QFNxG7A+Qez=Tziu2A@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 4/5] bpf: selftests: add MPTCP test base
To:     Nicolas Rybowski <nicolas.rybowski@tessares.net>
Cc:     Shuah Khan <shuah@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        open list <linux-kernel@vger.kernel.org>,
        linux-kselftest@vger.kernel.org,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 11, 2020 at 8:02 AM Nicolas Rybowski
<nicolas.rybowski@tessares.net> wrote:
>
> This patch adds a base for MPTCP specific tests.
>
> It is currently limited to the is_mptcp field in case of plain TCP
> connection because for the moment there is no easy way to get the subflow
> sk from a msk in userspace. This implies that we cannot lookup the
> sk_storage attached to the subflow sk in the sockops program.
>
> Acked-by: Matthieu Baerts <matthieu.baerts@tessares.net>
> Signed-off-by: Nicolas Rybowski <nicolas.rybowski@tessares.net>

Acked-by: Song Liu <songliubraving@fb.com>

With some nitpicks below.

> ---
>
> Notes:
>     v1 -> v2:
>     - new patch: mandatory selftests (Alexei)
>
[...]
>                      int timeout_ms);
> diff --git a/tools/testing/selftests/bpf/prog_tests/mptcp.c b/tools/testing/selftests/bpf/prog_tests/mptcp.c
> new file mode 100644
> index 000000000000..0e65d64868e9
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/mptcp.c
> @@ -0,0 +1,119 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#include <test_progs.h>
> +#include "cgroup_helpers.h"
> +#include "network_helpers.h"
> +
> +struct mptcp_storage {
> +       __u32 invoked;
> +       __u32 is_mptcp;
> +};
> +
> +static int verify_sk(int map_fd, int client_fd, const char *msg, __u32 is_mptcp)
> +{
> +       int err = 0, cfd = client_fd;
> +       struct mptcp_storage val;
> +
> +       /* Currently there is no easy way to get back the subflow sk from the MPTCP
> +        * sk, thus we cannot access here the sk_storage associated to the subflow
> +        * sk. Also, there is no sk_storage associated with the MPTCP sk since it
> +        * does not trigger sockops events.
> +        * We silently pass this situation at the moment.
> +        */
> +       if (is_mptcp == 1)
> +               return 0;
> +
> +       if (CHECK_FAIL(bpf_map_lookup_elem(map_fd, &cfd, &val) < 0)) {
> +               perror("Failed to read socket storage");

Maybe simplify this with CHECK(), which contains a customized error message?
Same for some other calls.

> +               return -1;
> +       }
> +
> +       if (val.invoked != 1) {
> +               log_err("%s: unexpected invoked count %d != %d",
> +                       msg, val.invoked, 1);
> +               err++;
> +       }
> +
> +       if (val.is_mptcp != is_mptcp) {
> +               log_err("%s: unexpected bpf_tcp_sock.is_mptcp %d != %d",
> +                       msg, val.is_mptcp, is_mptcp);
> +               err++;
> +       }
> +
> +       return err;
> +}
> +
> +static int run_test(int cgroup_fd, int server_fd, bool is_mptcp)
[...]

> +
> +       client_fd = is_mptcp ? connect_to_mptcp_fd(server_fd, 0) :
> +                              connect_to_fd(server_fd, 0);
> +       if (client_fd < 0) {
> +               err = -1;
> +               goto close_client_fd;

This should be "goto close_bpf_object;", and we don't really need the label
close_client_fd.

> +       }
> +
> +       err += is_mptcp ? verify_sk(map_fd, client_fd, "MPTCP subflow socket", 1) :

It doesn't really change the logic, but I guess we only need "err = xxx"?

> +                         verify_sk(map_fd, client_fd, "plain TCP socket", 0);
> +
> +close_client_fd:
> +       close(client_fd);
> +
> +close_bpf_object:
> +       bpf_object__close(obj);
> +       return err;
> +}
> +
