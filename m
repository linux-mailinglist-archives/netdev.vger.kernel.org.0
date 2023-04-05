Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33A2D6D7882
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 11:36:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237396AbjDEJgr convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 5 Apr 2023 05:36:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237241AbjDEJgi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 05:36:38 -0400
Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [205.139.111.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 095EB5593
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 02:36:16 -0700 (PDT)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-622-QGmrBNcZMb6t1HDq-eXjYg-1; Wed, 05 Apr 2023 05:35:32 -0400
X-MC-Unique: QGmrBNcZMb6t1HDq-eXjYg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 30B678996E3;
        Wed,  5 Apr 2023 09:35:32 +0000 (UTC)
Received: from hog (unknown [10.39.192.141])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 416C5140EBF4;
        Wed,  5 Apr 2023 09:35:31 +0000 (UTC)
Date:   Wed, 5 Apr 2023 11:35:30 +0200
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     Emeel Hakim <ehakim@nvidia.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 4/4] macsec: Add MACsec rx_handler change support
Message-ID: <ZC1A4r9TtR8VP3sr@hog>
References: <20230329122107.22658-1-ehakim@nvidia.com>
 <20230329122107.22658-5-ehakim@nvidia.com>
MIME-Version: 1.0
In-Reply-To: <20230329122107.22658-5-ehakim@nvidia.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-0.7 required=5.0 tests=RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2023-03-29, 15:21:07 +0300, Emeel Hakim wrote:
> Offloading device drivers will mark offloaded MACsec SKBs with the
> corresponding SCI in the skb_metadata_dst so the macsec rx handler will
> know to which interface to divert those skbs, in case of a marked skb
> and a mismatch on the dst MAC address, divert the skb to the macsec
> net_device where the macsec rx_handler will be called.

Sorry, I don't understand what you're trying to say here and in the
subject line.

To me, "Add MACsec rx_handler change support" sounds like you're
changing what function is used as ->rx_handler, which is not what this
patch is doing.

> Example of such a case is having a MACsec with VLAN as an inner header
> ETHERNET | SECTAG | VLAN packet.
> 
> Signed-off-by: Emeel Hakim <ehakim@nvidia.com>
> ---
>  drivers/net/macsec.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
> index 25616247d7a5..88b00ea4af68 100644
> --- a/drivers/net/macsec.c
> +++ b/drivers/net/macsec.c
> @@ -1048,6 +1048,15 @@ static enum rx_handler_result handle_not_macsec(struct sk_buff *skb)
>  
>  				__netif_rx(nskb);
>  			}
> +
> +			if (md_dst && md_dst->type == METADATA_MACSEC &&
> +			    (find_rx_sc(&macsec->secy, md_dst->u.macsec_info.sci))) {

We already do that exact find_rx_sc call earlier in the same loop,
can't we skip it now?

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

