Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A75B2E2B2
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 18:59:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726652AbfE2Q7m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 12:59:42 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:50967 "EHLO
        smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725948AbfE2Q7m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 12:59:42 -0400
Received: from cpe-2606-a000-111b-405a-0-0-0-162e.dyn6.twc.com ([2606:a000:111b:405a::162e] helo=localhost)
        by smtp.tuxdriver.com with esmtpsa (TLSv1:AES256-SHA:256)
        (Exim 4.63)
        (envelope-from <nhorman@tuxdriver.com>)
        id 1hW1vJ-0002nK-FP; Wed, 29 May 2019 12:59:39 -0400
Date:   Wed, 29 May 2019 12:59:06 -0400
From:   Neil Horman <nhorman@tuxdriver.com>
To:     Matteo Croce <mcroce@redhat.com>
Cc:     linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        Vlad Yasevich <vyasevich@gmail.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] sctp: deduplicate identical skb_checksum_ops
Message-ID: <20190529165906.GD31099@hmswarspite.think-freely.org>
References: <20190529153941.12166-1-mcroce@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190529153941.12166-1-mcroce@redhat.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Spam-Score: -2.9 (--)
X-Spam-Status: No
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 29, 2019 at 05:39:41PM +0200, Matteo Croce wrote:
> The same skb_checksum_ops struct is defined twice in two different places,
> leading to code duplication. Declare it as a global variable into a common
> header instead of allocating it on the stack on each function call.
> bloat-o-meter reports a slight code shrink.
> 
> add/remove: 1/1 grow/shrink: 0/10 up/down: 128/-1282 (-1154)
> Function                                     old     new   delta
> sctp_csum_ops                                  -     128    +128
> crc32c_csum_ops                               16       -     -16
> sctp_rcv                                    6616    6583     -33
> sctp_packet_pack                            4542    4504     -38
> nf_conntrack_sctp_packet                    4980    4926     -54
> execute_masked_set_action                   6453    6389     -64
> tcf_csum_sctp                                575     428    -147
> sctp_gso_segment                            1292    1126    -166
> sctp_csum_check                              579     412    -167
> sctp_snat_handler                            957     772    -185
> sctp_dnat_handler                           1321    1132    -189
> l4proto_manip_pkt                           2536    2313    -223
> Total: Before=359297613, After=359296459, chg -0.00%
> 
> Reviewed-by: Xin Long <lucien.xin@gmail.com>
> Signed-off-by: Matteo Croce <mcroce@redhat.com>
> ---
>  include/net/sctp/checksum.h | 12 +++++++-----
>  net/sctp/offload.c          |  7 +------
>  2 files changed, 8 insertions(+), 11 deletions(-)
> 
> diff --git a/include/net/sctp/checksum.h b/include/net/sctp/checksum.h
> index 314699333bec..5a9bb09f32b6 100644
> --- a/include/net/sctp/checksum.h
> +++ b/include/net/sctp/checksum.h
> @@ -43,19 +43,21 @@ static inline __wsum sctp_csum_combine(__wsum csum, __wsum csum2,
>  						   (__force __u32)csum2, len);
>  }
>  
> +static const struct skb_checksum_ops sctp_csum_ops = {
> +	.update  = sctp_csum_update,
> +	.combine = sctp_csum_combine,
> +};
> +
>  static inline __le32 sctp_compute_cksum(const struct sk_buff *skb,
>  					unsigned int offset)
>  {
>  	struct sctphdr *sh = (struct sctphdr *)(skb->data + offset);
> -	const struct skb_checksum_ops ops = {
> -		.update  = sctp_csum_update,
> -		.combine = sctp_csum_combine,
> -	};
>  	__le32 old = sh->checksum;
>  	__wsum new;
>  
>  	sh->checksum = 0;
> -	new = ~__skb_checksum(skb, offset, skb->len - offset, ~(__wsum)0, &ops);
> +	new = ~__skb_checksum(skb, offset, skb->len - offset, ~(__wsum)0,
> +			      &sctp_csum_ops);
>  	sh->checksum = old;
>  
>  	return cpu_to_le32((__force __u32)new);
> diff --git a/net/sctp/offload.c b/net/sctp/offload.c
> index edfcf16e704c..dac46dfadab5 100644
> --- a/net/sctp/offload.c
> +++ b/net/sctp/offload.c
> @@ -103,11 +103,6 @@ static const struct net_offload sctp6_offload = {
>  	},
>  };
>  
> -static const struct skb_checksum_ops crc32c_csum_ops = {
> -	.update  = sctp_csum_update,
> -	.combine = sctp_csum_combine,
> -};
> -
>  int __init sctp_offload_init(void)
>  {
>  	int ret;
> @@ -120,7 +115,7 @@ int __init sctp_offload_init(void)
>  	if (ret)
>  		goto ipv4;
>  
> -	crc32c_csum_stub = &crc32c_csum_ops;
> +	crc32c_csum_stub = &sctp_csum_ops;
>  	return ret;
>  
>  ipv4:
> -- 
> 2.21.0
> 
> 
Acked-by: Neil Horman <nhorman@tuxdriver.com>

