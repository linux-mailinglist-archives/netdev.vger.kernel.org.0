Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9C2A4B7908
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 21:53:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244168AbiBOUtb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 15:49:31 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244172AbiBOUtX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 15:49:23 -0500
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB527BC32;
        Tue, 15 Feb 2022 12:49:11 -0800 (PST)
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1nK4l2-0005xz-Ph; Tue, 15 Feb 2022 21:49:08 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1nK4l2-000Rq9-HL; Tue, 15 Feb 2022 21:49:08 +0100
Subject: Re: [PATCH v4 net-next 1/8] net: Add skb->mono_delivery_time to
 distinguish mono delivery_time from (rcv) timestamp
To:     Martin KaFai Lau <kafai@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, kernel-team@fb.com,
        Willem de Bruijn <willemb@google.com>
References: <20220211071232.885225-1-kafai@fb.com>
 <20220211071238.885669-1-kafai@fb.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <1d03f759-3eea-0032-18fc-1f6fed2c14bc@iogearbox.net>
Date:   Tue, 15 Feb 2022 21:49:07 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20220211071238.885669-1-kafai@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.5/26454/Tue Feb 15 10:32:17 2022)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/11/22 8:12 AM, Martin KaFai Lau wrote:
[...]
> The current use case is to keep the TCP mono delivery_time (EDT) and
> to be used with sch_fq.  A later patch will also allow tc-bpf@ingress
> to read and change the mono delivery_time.
> 
> In the future, another bit (e.g. skb->user_delivery_time) can be added
[...]
> ---
>   include/linux/skbuff.h                     | 13 +++++++++++++
>   net/bridge/netfilter/nf_conntrack_bridge.c |  5 +++--
>   net/ipv4/ip_output.c                       |  7 +++++--
>   net/ipv4/tcp_output.c                      | 16 +++++++++-------
>   net/ipv6/ip6_output.c                      |  5 +++--
>   net/ipv6/netfilter.c                       |  5 +++--
>   net/ipv6/tcp_ipv6.c                        |  2 +-
>   7 files changed, 37 insertions(+), 16 deletions(-)
> 
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index a5adbf6b51e8..32c793de3801 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -747,6 +747,10 @@ typedef unsigned char *sk_buff_data_t;
>    *	@dst_pending_confirm: need to confirm neighbour
>    *	@decrypted: Decrypted SKB
>    *	@slow_gro: state present at GRO time, slower prepare step required
> + *	@mono_delivery_time: When set, skb->tstamp has the
> + *		delivery_time in mono clock base (i.e. EDT).  Otherwise, the
> + *		skb->tstamp has the (rcv) timestamp at ingress and
> + *		delivery_time at egress.
>    *	@napi_id: id of the NAPI struct this skb came from
>    *	@sender_cpu: (aka @napi_id) source CPU in XPS
>    *	@secmark: security marking
> @@ -917,6 +921,7 @@ struct sk_buff {
>   	__u8			decrypted:1;
>   #endif
>   	__u8			slow_gro:1;
> +	__u8			mono_delivery_time:1;
>   

Don't you also need to extend sch_fq to treat any non-mono_delivery_time marked
skb similar as if it hadn't been marked with a delivery time?
