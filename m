Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C069B4DA8D1
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 04:17:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353423AbiCPDSZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 23:18:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234584AbiCPDSY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 23:18:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB84E5E15C;
        Tue, 15 Mar 2022 20:17:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A336FB8181C;
        Wed, 16 Mar 2022 03:17:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6187C340E8;
        Wed, 16 Mar 2022 03:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647400628;
        bh=PlSgv56mxNRopY1yc16lOuudQ7ENlgRXJivgph2Ss9M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UGPsFoLJYgTGlZ8MU0IVJ+3MuoMplzorQGMbSsXLoCyfFEKaiRK3+TYtaOfynic2m
         hZWSpYmyL6rCTW/6D3M0L26M1HviLCZjpIuKbvq1gYizHSCjiKPZ/KmvvQMuNwUcyt
         xOBuGqSHSC4W3sDacQczboPIPIksiFQ4notEKneTAEIB+ATiZl8qmGlAIUVOMV3Ms1
         Nw1azlYZNZi58uJTV56EoeGZRK5SIuAo1+1kzgbGHjpbFKi7j7FOG2EWccTsNeK7qb
         BgMB2kTc+O8VBHFLVtIfz+wDbeNAcIVv8u7BivUe2mwN6v2v7ml2bVCclcmNydvjLl
         JRa/hfmpuIvDQ==
Date:   Tue, 15 Mar 2022 20:17:06 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     menglong8.dong@gmail.com
Cc:     dsahern@kernel.org, rostedt@goodmis.org, mingo@redhat.com,
        xeb@mail.ru, davem@davemloft.net, yoshfuji@linux-ipv6.org,
        imagedong@tencent.com, edumazet@google.com, kafai@fb.com,
        talalahmad@google.com, keescook@chromium.org, alobakin@pm.me,
        flyingpeng@tencent.com, mengensun@tencent.com,
        dongli.zhang@oracle.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Biao Jiang <benbjiang@tencent.com>
Subject: Re: [PATCH net-next 3/3] net: ipgre: add skb drop reasons to
 gre_rcv()
Message-ID: <20220315201706.464d5ecd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220314133312.336653-4-imagedong@tencent.com>
References: <20220314133312.336653-1-imagedong@tencent.com>
        <20220314133312.336653-4-imagedong@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Mar 2022 21:33:12 +0800 menglong8.dong@gmail.com wrote:
> From: Menglong Dong <imagedong@tencent.com>
> 
> Replace kfree_skb() used in gre_rcv() with kfree_skb_reason(). With
> previous patch, we can tell that no tunnel device is found when
> PACKET_NEXT is returned by erspan_rcv() or ipgre_rcv().
> 
> In this commit, following new drop reasons are added:
> 
> SKB_DROP_REASON_GRE_CSUM
> SKB_DROP_REASON_GRE_NOTUNNEL
> 
> Reviewed-by: Hao Peng <flyingpeng@tencent.com>
> Reviewed-by: Biao Jiang <benbjiang@tencent.com>
> Signed-off-by: Menglong Dong <imagedong@tencent.com>
> ---
>  include/linux/skbuff.h     |  2 ++
>  include/trace/events/skb.h |  2 ++
>  net/ipv4/ip_gre.c          | 28 ++++++++++++++++++----------
>  3 files changed, 22 insertions(+), 10 deletions(-)
> 
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index 5edb704af5bb..4f5e58e717ee 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -448,6 +448,8 @@ enum skb_drop_reason {
>  	SKB_DROP_REASON_GRE_NOHANDLER,	/* no handler found (version not
>  					 * supported?)
>  					 */
> +	SKB_DROP_REASON_GRE_CSUM,	/* GRE csum error */
> +	SKB_DROP_REASON_GRE_NOTUNNEL,	/* no tunnel device found */
>  	SKB_DROP_REASON_MAX,
>  };
>  
> diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
> index f2bcffdc4bae..e8f95c96cf9d 100644
> --- a/include/trace/events/skb.h
> +++ b/include/trace/events/skb.h
> @@ -63,6 +63,8 @@
>  	EM(SKB_DROP_REASON_TAP_TXFILTER, TAP_TXFILTER)		\
>  	EM(SKB_DROP_REASON_GRE_VERSION, GRE_VERSION)		\
>  	EM(SKB_DROP_REASON_GRE_NOHANDLER, GRE_NOHANDLER)	\
> +	EM(SKB_DROP_REASON_GRE_CSUM, GRE_CSUM)			\
> +	EM(SKB_DROP_REASON_GRE_NOTUNNEL, GRE_NOTUNNEL)		\
>  	EMe(SKB_DROP_REASON_MAX, MAX)
>  
>  #undef EM
> diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
> index b1579d8374fd..b989239e4abc 100644
> --- a/net/ipv4/ip_gre.c
> +++ b/net/ipv4/ip_gre.c
> @@ -421,9 +421,10 @@ static int ipgre_rcv(struct sk_buff *skb, const struct tnl_ptk_info *tpi,
>  
>  static int gre_rcv(struct sk_buff *skb)
>  {
> +	enum skb_drop_reason reason = SKB_DROP_REASON_NOT_SPECIFIED;
>  	struct tnl_ptk_info tpi;
>  	bool csum_err = false;
> -	int hdr_len;
> +	int hdr_len, ret;
>  
>  #ifdef CONFIG_NET_IPGRE_BROADCAST
>  	if (ipv4_is_multicast(ip_hdr(skb)->daddr)) {
> @@ -438,19 +439,26 @@ static int gre_rcv(struct sk_buff *skb)

I feel like gre_parse_header() is a good candidate for converting
to return a reason instead of errno.


>  		goto drop;
>  
>  	if (unlikely(tpi.proto == htons(ETH_P_ERSPAN) ||
> -		     tpi.proto == htons(ETH_P_ERSPAN2))) {
> -		if (erspan_rcv(skb, &tpi, hdr_len) == PACKET_RCVD)
> -			return 0;
> -		goto out;
> -	}
> +		     tpi.proto == htons(ETH_P_ERSPAN2)))
> +		ret = erspan_rcv(skb, &tpi, hdr_len);
> +	else
> +		ret = ipgre_rcv(skb, &tpi, hdr_len);

ipgre_rcv() OTOH may be better off taking the reason as an output
argument. Assuming PACKET_REJECT means NOMEM is a little fragile.

>  
> -	if (ipgre_rcv(skb, &tpi, hdr_len) == PACKET_RCVD)
> +	switch (ret) {
> +	case PACKET_NEXT:
> +		reason = SKB_DROP_REASON_GRE_NOTUNNEL;
> +		break;
> +	case PACKET_RCVD:
>  		return 0;
> -
> -out:
> +	case PACKET_REJECT:
> +		reason = SKB_DROP_REASON_NOMEM;
> +		break;
> +	}
>  	icmp_send(skb, ICMP_DEST_UNREACH, ICMP_PORT_UNREACH, 0);
>  drop:
> -	kfree_skb(skb);
> +	if (csum_err)
> +		reason = SKB_DROP_REASON_GRE_CSUM;
> +	kfree_skb_reason(skb, reason);
>  	return 0;
>  }
>  

