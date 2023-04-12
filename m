Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 934466DF930
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 16:58:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229609AbjDLO6y convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 12 Apr 2023 10:58:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbjDLO6x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 10:58:53 -0400
Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [205.139.111.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01981101
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 07:58:49 -0700 (PDT)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-610-eFgwHzawPZetn5F8c__RHQ-1; Wed, 12 Apr 2023 10:58:45 -0400
X-MC-Unique: eFgwHzawPZetn5F8c__RHQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3F106185A78B;
        Wed, 12 Apr 2023 14:58:45 +0000 (UTC)
Received: from hog (unknown [10.39.192.141])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3CB2EFD6E;
        Wed, 12 Apr 2023 14:58:44 +0000 (UTC)
Date:   Wed, 12 Apr 2023 16:58:43 +0200
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     Emeel Hakim <ehakim@nvidia.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org, leon@kernel.org
Subject: Re: [PATCH net-next v4 5/5] macsec: Add MACsec rx_handler change
 support
Message-ID: <ZDbHI/VLKkGib3kQ@hog>
References: <20230408105735.22935-1-ehakim@nvidia.com>
 <20230408105735.22935-6-ehakim@nvidia.com>
MIME-Version: 1.0
In-Reply-To: <20230408105735.22935-6-ehakim@nvidia.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2023-04-08, 13:57:35 +0300, Emeel Hakim wrote:
> Offloading device drivers will mark offloaded MACsec SKBs with the
> corresponding SCI in the skb_metadata_dst so the macsec rx handler will
> know to which interface to divert those skbs, in case of a marked skb
> and a mismatch on the dst MAC address, divert the skb to the macsec
> net_device where the macsec rx_handler will be called.

Quoting my reply to v2:

========

Sorry, I don't understand what you're trying to say here and in the
subject line.

To me, "Add MACsec rx_handler change support" sounds like you're
changing what function is used as ->rx_handler, which is not what this
patch is doing.

========

> Example of such a case is having a MACsec with VLAN as an inner header
> ETHERNET | SECTAG | VLAN packet.
> 
> Signed-off-by: Emeel Hakim <ehakim@nvidia.com>
> ---
>  drivers/net/macsec.c | 16 ++++++++++++++--
>  1 file changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
> index 25616247d7a5..4e58d2b4f0e1 100644
> --- a/drivers/net/macsec.c
> +++ b/drivers/net/macsec.c
> @@ -1016,14 +1016,18 @@ static enum rx_handler_result handle_not_macsec(struct sk_buff *skb)
>  		struct sk_buff *nskb;
>  		struct pcpu_secy_stats *secy_stats = this_cpu_ptr(macsec->stats);
>  		struct net_device *ndev = macsec->secy.netdev;
> +		struct macsec_rx_sc *rx_sc_found = NULL;

I don't think "_found" is adding any information. "rx_sc" is
enough. And since it's only used in the if block below, it could be
defined down there.

And btw I don't think we even need to check "&& rx_sc_found" in the
code you're adding, but maybe I need more coffee. Anyway, I'd be fine
with saving the result of find_rx_sc and reusing it.

if (A && !rx_sc)
    continue;

[...]

if (A) // here we know rx_sc can't be NULL, otherwise we would have hit the continue earlier
    packet_host etc

>  		/* If h/w offloading is enabled, HW decodes frames and strips
>  		 * the SecTAG, so we have to deduce which port to deliver to.
>  		 */
>  		if (macsec_is_offloaded(macsec) && netif_running(ndev)) {
> -			if (md_dst && md_dst->type == METADATA_MACSEC &&
> -			    (!find_rx_sc(&macsec->secy, md_dst->u.macsec_info.sci)))
> +			rx_sc_found = (md_dst && md_dst->type == METADATA_MACSEC) ?
> +				      find_rx_sc(&macsec->secy, md_dst->u.macsec_info.sci) : NULL;
> +
> +			if (md_dst && md_dst->type == METADATA_MACSEC && !rx_sc_found) {
>  				continue;
> +			}

{} not needed around a single line.

>  
>  			if (ether_addr_equal_64bits(hdr->h_dest,
>  						    ndev->dev_addr)) {
> @@ -1048,6 +1052,14 @@ static enum rx_handler_result handle_not_macsec(struct sk_buff *skb)
>  
>  				__netif_rx(nskb);
>  			}
> +
> +			if (md_dst && md_dst->type == METADATA_MACSEC && rx_sc_found) {
> +				skb->dev = ndev;
> +				skb->pkt_type = PACKET_HOST;
> +				ret = RX_HANDLER_ANOTHER;
> +				goto out;
> +			}
> +
>  			continue;
>  		}
>  
> -- 
> 2.21.3
> 

-- 
Sabrina

