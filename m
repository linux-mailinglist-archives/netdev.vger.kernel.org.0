Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EA6B5158EA
	for <lists+netdev@lfdr.de>; Sat, 30 Apr 2022 01:22:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381494AbiD2XZd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 19:25:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232129AbiD2XZc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 19:25:32 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CD3185678;
        Fri, 29 Apr 2022 16:22:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651274532; x=1682810532;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=WTQ1fGIlb3aCh6XinqdNPUBC60QYJ9Id7TJsIdo7UkA=;
  b=VO6f3xJofgloPmYuFcdyTAiKby2Gc+Ug3MQHbPzs3cymjAz6AHZe6nE/
   RYlEFEFwi7QNWMrjopGEK4wvbCl8XDIwtUkkkZLOeKpNxVshIZdjWNW4X
   0labW5UF8+rMCFMTM+kBWMP6/3qru+bDU/QYdqNKZA/gdFTdMFnyoKeXH
   VpbIKdu6FLyHzgsWOJB6vXlHmJB5NjGzr7RKiGLTNCRQanV1FIfORjK23
   E+3Yx232VN9Y1tzImS2Oh3ZPql5SQdww28Eyd3oVKVZt20t7oE7KGD8UH
   +vdppX4nUYHxTjd8B4YOaJ4OD9/w6YTm7RbusNgTZCGBviXMHLdQB3jj4
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10332"; a="327298234"
X-IronPort-AV: E=Sophos;i="5.91,186,1647327600"; 
   d="scan'208";a="327298234"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2022 16:22:12 -0700
X-IronPort-AV: E=Sophos;i="5.91,186,1647327600"; 
   d="scan'208";a="560621871"
Received: from mdbellow-mobl.amr.corp.intel.com ([10.209.122.4])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2022 16:22:11 -0700
Date:   Fri, 29 Apr 2022 16:22:11 -0700 (PDT)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     Geliang Tang <geliang.tang@suse.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        mptcp@lists.linux.dev,
        Matthieu Baerts <matthieu.baerts@tessares.net>
Subject: Re: [PATCH bpf-next v2 7/8] selftests: bpf: verify ca_name of struct
 mptcp_sock
In-Reply-To: <20220429220204.353225-8-mathew.j.martineau@linux.intel.com>
Message-ID: <6cb5d7dc-1162-1bd1-452-a11089b018a3@linux.intel.com>
References: <20220429220204.353225-1-mathew.j.martineau@linux.intel.com> <20220429220204.353225-8-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 29 Apr 2022, Mat Martineau wrote:

> From: Geliang Tang <geliang.tang@suse.com>
>
> This patch verifies another member of struct mptcp_sock, ca_name. Add a
> new function get_msk_ca_name() to read the sysctl tcp_congestion_control
> and verify it in verify_msk().
>
> Acked-by: Matthieu Baerts <matthieu.baerts@tessares.net>
> Signed-off-by: Geliang Tang <geliang.tang@suse.com>
> Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
> ---
> .../testing/selftests/bpf/bpf_mptcp_helpers.h |  1 +
> tools/testing/selftests/bpf/bpf_tcp_helpers.h |  4 ++++
> .../testing/selftests/bpf/prog_tests/mptcp.c  | 24 +++++++++++++++++++
> .../testing/selftests/bpf/progs/mptcp_sock.c  |  4 ++++
> 4 files changed, 33 insertions(+)
>
> diff --git a/tools/testing/selftests/bpf/bpf_mptcp_helpers.h b/tools/testing/selftests/bpf/bpf_mptcp_helpers.h
> index 87e15810997d..463e4e061c96 100644
> --- a/tools/testing/selftests/bpf/bpf_mptcp_helpers.h
> +++ b/tools/testing/selftests/bpf/bpf_mptcp_helpers.h
> @@ -10,6 +10,7 @@ struct mptcp_sock {
> 	struct inet_connection_sock	sk;
>
> 	__u32		token;
> +	char		ca_name[TCP_CA_NAME_MAX];
> } __attribute__((preserve_access_index));
>
> #endif
> diff --git a/tools/testing/selftests/bpf/bpf_tcp_helpers.h b/tools/testing/selftests/bpf/bpf_tcp_helpers.h
> index b1ede6f0b821..89750d732cfa 100644
> --- a/tools/testing/selftests/bpf/bpf_tcp_helpers.h
> +++ b/tools/testing/selftests/bpf/bpf_tcp_helpers.h
> @@ -16,6 +16,10 @@ BPF_PROG(name, args)
> #define SOL_TCP 6
> #endif
>
> +#ifndef TCP_CA_NAME_MAX
> +#define TCP_CA_NAME_MAX	16
> +#endif
> +
> #define tcp_jiffies32 ((__u32)bpf_jiffies64())
>
> struct sock_common {
> diff --git a/tools/testing/selftests/bpf/prog_tests/mptcp.c b/tools/testing/selftests/bpf/prog_tests/mptcp.c
> index c5d96ba81e04..4518aa6e661e 100644
> --- a/tools/testing/selftests/bpf/prog_tests/mptcp.c
> +++ b/tools/testing/selftests/bpf/prog_tests/mptcp.c
> @@ -5,10 +5,15 @@
> #include "cgroup_helpers.h"
> #include "network_helpers.h"
>
> +#ifndef TCP_CA_NAME_MAX
> +#define TCP_CA_NAME_MAX	16
> +#endif
> +
> struct mptcp_storage {
> 	__u32 invoked;
> 	__u32 is_mptcp;
> 	__u32 token;
> +	char ca_name[TCP_CA_NAME_MAX];
> };
>
> static char monitor_log_path[64];
> @@ -79,11 +84,22 @@ static __u32 get_msk_token(void)
> 	return token;
> }
>
> +void get_msk_ca_name(char ca_name[])
> +{
> +	FILE *stream = popen("sysctl -b net.ipv4.tcp_congestion_control", "r");

The BPF CI is failing because it uses busybox for the sysctl command, 
which doesn't support all the command line parameters that procps-ng 
sysctl does:

https://github.com/kernel-patches/bpf/runs/6235741017?check_suite_focus=true#step:6:4259


Geliang, can you update this self test to instead read the default 
congestion control string from /proc/sys/net/ipv4/tcp_congestion_control?

Thanks,

Mat

> +
> +	if (!fgets(ca_name, TCP_CA_NAME_MAX, stream))
> +		log_err("Failed to read ca_name");
> +
> +	pclose(stream);
> +}
> +
> static int verify_msk(int map_fd, int client_fd)
> {
> 	char *msg = "MPTCP subflow socket";
> 	int err = 0, cfd = client_fd;
> 	struct mptcp_storage val;
> +	char ca_name[TCP_CA_NAME_MAX];
> 	__u32 token;
>
> 	token = get_msk_token();
> @@ -92,6 +108,8 @@ static int verify_msk(int map_fd, int client_fd)
> 		return -1;
> 	}
>
> +	get_msk_ca_name(ca_name);
> +
> 	if (CHECK_FAIL(bpf_map_lookup_elem(map_fd, &cfd, &val) < 0)) {
> 		perror("Failed to read socket storage");
> 		return -1;
> @@ -115,6 +133,12 @@ static int verify_msk(int map_fd, int client_fd)
> 		err++;
> 	}
>
> +	if (strncmp(val.ca_name, ca_name, TCP_CA_NAME_MAX)) {
> +		log_err("Unexpected mptcp_sock.ca_name %s != %s",
> +			val.ca_name, ca_name);
> +		err++;
> +	}
> +
> 	return err;
> }
>
> diff --git a/tools/testing/selftests/bpf/progs/mptcp_sock.c b/tools/testing/selftests/bpf/progs/mptcp_sock.c
> index c58c191d8416..226571673800 100644
> --- a/tools/testing/selftests/bpf/progs/mptcp_sock.c
> +++ b/tools/testing/selftests/bpf/progs/mptcp_sock.c
> @@ -1,6 +1,7 @@
> // SPDX-License-Identifier: GPL-2.0
> /* Copyright (c) 2020, Tessares SA. */
>
> +#include <string.h>
> #include <linux/bpf.h>
> #include <bpf/bpf_helpers.h>
> #include "bpf_mptcp_helpers.h"
> @@ -13,6 +14,7 @@ struct mptcp_storage {
> 	__u32 invoked;
> 	__u32 is_mptcp;
> 	__u32 token;
> +	char ca_name[TCP_CA_NAME_MAX];
> };
>
> struct {
> @@ -49,6 +51,7 @@ int _sockops(struct bpf_sock_ops *ctx)
> 			return 1;
>
> 		storage->token = 0;
> +		bzero(storage->ca_name, TCP_CA_NAME_MAX);
> 	} else {
> 		if (!CONFIG_MPTCP)
> 			return 1;
> @@ -63,6 +66,7 @@ int _sockops(struct bpf_sock_ops *ctx)
> 			return 1;
>
> 		storage->token = msk->token;
> +		memcpy(storage->ca_name, msk->ca_name, TCP_CA_NAME_MAX);
> 	}
> 	storage->invoked++;
> 	storage->is_mptcp = tcp_sk->is_mptcp;
> -- 
> 2.36.0
>
>

--
Mat Martineau
Intel
