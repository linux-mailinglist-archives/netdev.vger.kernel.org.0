Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A80A4BEFDA
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 04:16:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239740AbiBVDOV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 22:14:21 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239769AbiBVDOQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 22:14:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62400DFBA;
        Mon, 21 Feb 2022 19:13:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1A547B80AEA;
        Tue, 22 Feb 2022 03:13:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA96DC340EC;
        Tue, 22 Feb 2022 03:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645499627;
        bh=YmZe8dc2DlKJ6VILu0MT3a2fmSJlqnzdfuGDMeCCXyg=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=MM7vA4NkCiqRipXRQhpjw35mGitw1VqsSohK4/IoZKCEW1mITIr+L1oSEK19AwVyj
         vVMc1wUHrb0KSyX7D1OaCsDfmQcVE/9YGE+losz+S+L6gkhOtRpawzSbp799M5XZnK
         rq2UKyIeJAycAWYuq/kZnLu1hre9gN/Jp55wfJMEAotaCvLvx1l28VzxvlsZ9omVnY
         WAknNuz7xJi9HtHuuaDE8HL21W23CCkB4eF42YoKMI3SKjkgQ1fthGECYiABSWbqxT
         ++sKXSmxyXl0wp7aViJ2QP95hVrgXYU/q7oNBrhckkyM42iV306RMtHptwvOFGYW9O
         hCcc22yRmTyqQ==
Message-ID: <3183c3c9-6644-b2de-885e-9e3699138102@kernel.org>
Date:   Mon, 21 Feb 2022 20:13:46 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.0
Subject: Re: [PATCH net-next 1/3] net: ip: add skb drop reasons for ip egress
 path
Content-Language: en-US
To:     menglong8.dong@gmail.com, kuba@kernel.org
Cc:     rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, imagedong@tencent.com,
        edumazet@google.com, alobakin@pm.me, cong.wang@bytedance.com,
        paulb@nvidia.com, talalahmad@google.com, keescook@chromium.org,
        ilias.apalodimas@linaro.org, memxor@gmail.com,
        flyingpeng@tencent.com, mengensun@tencent.com,
        daniel@iogearbox.net, yajun.deng@linux.dev, roopa@nvidia.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <20220220155705.194266-1-imagedong@tencent.com>
 <20220220155705.194266-2-imagedong@tencent.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220220155705.194266-2-imagedong@tencent.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/20/22 8:57 AM, menglong8.dong@gmail.com wrote:
> From: Menglong Dong <imagedong@tencent.com>
> 
> Replace kfree_skb() with kfree_skb_reason() in the packet egress path of
> IP layer (both IPv4 and IPv6 are considered).
> 
> Following functions are involved:
> 
> __ip_queue_xmit()
> ip_finish_output()
> ip_mc_finish_output()
> ip6_output()
> ip6_finish_output()
> ip6_finish_output2()
> 
> Following new drop reasons are introduced:
> 
> SKB_DROP_REASON_IP_OUTNOROUTES
> SKB_DROP_REASON_BPF_CGROUP_EGRESS
> SKB_DROP_REASON_IPV6DSIABLED
> 
> Reviewed-by: Mengen Sun <mengensun@tencent.com>
> Reviewed-by: Hao Peng <flyingpeng@tencent.com>
> Signed-off-by: Menglong Dong <imagedong@tencent.com>
> ---
>  include/linux/skbuff.h     | 13 +++++++++++++
>  include/trace/events/skb.h |  4 ++++
>  net/ipv4/ip_output.c       |  6 +++---
>  net/ipv6/ip6_output.c      |  6 +++---
>  4 files changed, 23 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index a3e90efe6586..c310a4a8fc86 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -380,6 +380,19 @@ enum skb_drop_reason {
>  					 * the ofo queue, corresponding to
>  					 * LINUX_MIB_TCPOFOMERGE
>  					 */
> +	SKB_DROP_REASON_IP_OUTNOROUTES,	/* route lookup failed during
> +					 * packet outputting
> +					 */

This should be good enough since the name contains OUT.

/* route lookup failed */

> +	SKB_DROP_REASON_BPF_CGROUP_EGRESS,	/* dropped by eBPF program
> +						 * with type of BPF_PROG_TYPE_CGROUP_SKB
> +						 * and attach type of
> +						 * BPF_CGROUP_INET_EGRESS
> +						 * during packet sending
> +						 */

/* dropped by BPF_CGROUP_INET_EGRESS eBPF program */

> +	SKB_DROP_REASON_IPV6DSIABLED,	/* IPv6 is disabled on the device,
> +					 * see the doc for disable_ipv6
> +					 * in ip-sysctl.rst for detail
> +					 */

Just /* IPv6 is disabled on the device */


>  	SKB_DROP_REASON_MAX,
>  };
>  

> diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
> index 0c0574eb5f5b..df549b7415fb 100644
> --- a/net/ipv4/ip_output.c
> +++ b/net/ipv4/ip_output.c

This file has other relevant drops. e.g., ip_finish_output2 when a neigh
entry can not be created and after skb_gso_segment. The other set for
tun/tap devices has SKB_DROP_REASON_SKB_GSO_SEG which can be used for
the latter. That set also adds kfree_skb_list_reason for the frag drops.


> diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
> index 0c6c971ce0a5..4cd9e5fd25e4 100644
> --- a/net/ipv6/ip6_output.c
> +++ b/net/ipv6/ip6_output.c

Similarly here. The other set should land in the next few days, so you
cna put this set on top of it.

