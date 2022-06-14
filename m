Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EE0054B29D
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 15:57:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243942AbiFNNzi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 09:55:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243934AbiFNNze (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 09:55:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 03AAA3A5DE
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 06:55:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655214920;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rVbYRVnyFw3R6s8hRXIRtuQq0e/yxXZFk/ynYToTtPE=;
        b=VsJcpUpLXCpii81i5p+FAVV+YA9AmdR014ooCXcX9248UupK5FkynsSITtxk+EeFwmRsIv
        nX/B0d6/NHNSdLRdiNWNkFhHQj+1QyMUdmM96zEkEi0J2+Pgm6UxeyiOa/pIgj6l1FBoat
        9eNx0sjyes8t0ro7FPB+AN0/UyQ85E8=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-205-Hqf51W39OJ6LeUid4O3ieA-1; Tue, 14 Jun 2022 09:55:18 -0400
X-MC-Unique: Hqf51W39OJ6LeUid4O3ieA-1
Received: by mail-qk1-f198.google.com with SMTP id bs17-20020a05620a471100b006a734d3910dso7465163qkb.22
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 06:55:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=rVbYRVnyFw3R6s8hRXIRtuQq0e/yxXZFk/ynYToTtPE=;
        b=Qg++GTd7LWxCPTVAtXzlAkoDPFUJPBTD3U6p5h+4wWeSZVwssn+aLMsdPxKkBF/RHl
         LfLd6S8ffueMtNVkPClTUSXBcbP4VbFJfH7q0k8pX+TGI3Dtv3BxPuVfiDS5kwB9GvUa
         bcrGtLaLarvZMIbRh0suRdKzD3k4IEdvQMM7QEYdBcVgP55CtG2T4mNCYc7NdTVO1E36
         UPI8JGNNtU2NgSxjIKAMCMP8a/6WI+HzoNt00E4eiqgAKjKHvplxzhm1/rlWF67ZU91H
         xwwS1I+rKPdad/+Pm4ZyS2igpVKNTseZfQjMzl7Snw3+6sYdju5TGeETrq5Kqg1w/6yq
         4OMg==
X-Gm-Message-State: AJIora+ci2XS/wu4EFa+CqEULDzQoPiYKQarTKIT5riIkwaEX6uscAhI
        BH0wUfaZOUE6q8t0UvAxg7qoqPvc29jteHxIQfG+8LCotbP1OhvNssqtO4AR6LcjSNN8sF1gLWS
        12svP5Hg2MaHkakt6
X-Received: by 2002:a05:6214:20ee:b0:46b:c872:ce11 with SMTP id 14-20020a05621420ee00b0046bc872ce11mr3563637qvk.78.1655214917225;
        Tue, 14 Jun 2022 06:55:17 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vsJcW0/kdhUH2sw7gND8OBCIqbnrku5S1v3YB5aUpnoJB9ZuZKIoTpXk4zKNFNXdPssgSyqA==
X-Received: by 2002:a05:6214:20ee:b0:46b:c872:ce11 with SMTP id 14-20020a05621420ee00b0046bc872ce11mr3563614qvk.78.1655214916914;
        Tue, 14 Jun 2022 06:55:16 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-113-202.dyn.eolo.it. [146.241.113.202])
        by smtp.gmail.com with ESMTPSA id i15-20020a05620a248f00b006a6bb044740sm10127305qkn.66.2022.06.14.06.55.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 06:55:16 -0700 (PDT)
Message-ID: <e95ebed542745609619701b21220647668c89081.camel@redhat.com>
Subject: Re: [PATCH net-next v3 2/3] net/macsec: Add MACsec skb extension Rx
 Data path support
From:   Paolo Abeni <pabeni@redhat.com>
To:     Lior Nahmanson <liorna@nvidia.com>, edumazet@google.com,
        kuba@kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        Raed Salem <raeds@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Ben Ben-Ishay <benishay@nvidia.com>
Date:   Tue, 14 Jun 2022 15:55:13 +0200
In-Reply-To: <20220613111942.12726-3-liorna@nvidia.com>
References: <20220613111942.12726-1-liorna@nvidia.com>
         <20220613111942.12726-3-liorna@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2022-06-13 at 14:19 +0300, Lior Nahmanson wrote:
> Like in the Tx changes, packet that don't have SecTAG
> header aren't necessary been offloaded by the HW.
> Therefore, the MACsec driver needs to distinguish if the packet
> was offloaded or not and handle accordingly.
> Moreover, if there are more than one MACsec device with the same MAC
> address as in the packet's destination MAC, the packet will forward only
> to this device and only to the desired one.
> 
> Used SKB extension and marking it by the HW if the packet was offloaded
> and to which MACsec offload device it belongs according to the packet's
> SCI.
> 
> Signed-off-by: Lior Nahmanson <liorna@nvidia.com>
> Reviewed-by: Raed Salem <raeds@nvidia.com>
> Reviewed-by: Jiri Pirko <jiri@nvidia.com>
> Reviewed-by: Ben Ben-Ishay <benishay@nvidia.com>
> ---
> v1->v2:
> - added GRO support
> - added offloaded field to struct macsec_ext
> v2->v3:
> - removed Issue and Change-Id from commit message
> ---
>  drivers/net/macsec.c |  8 +++++++-
>  include/net/macsec.h |  1 +
>  net/core/gro.c       | 16 ++++++++++++++++
>  3 files changed, 24 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
> index 9be0606d70da..7b7baf3dd596 100644
> --- a/drivers/net/macsec.c
> +++ b/drivers/net/macsec.c
> @@ -999,11 +999,13 @@ static enum rx_handler_result handle_not_macsec(struct sk_buff *skb)
>  	/* Deliver to the uncontrolled port by default */
>  	enum rx_handler_result ret = RX_HANDLER_PASS;
>  	struct ethhdr *hdr = eth_hdr(skb);
> +	struct macsec_ext *macsec_ext;
>  	struct macsec_rxh_data *rxd;
>  	struct macsec_dev *macsec;
>  
>  	rcu_read_lock();
>  	rxd = macsec_data_rcu(skb->dev);
> +	macsec_ext = skb_ext_find(skb, SKB_EXT_MACSEC);
>  
>  	list_for_each_entry_rcu(macsec, &rxd->secys, secys) {
>  		struct sk_buff *nskb;
> @@ -1013,7 +1015,11 @@ static enum rx_handler_result handle_not_macsec(struct sk_buff *skb)
>  		/* If h/w offloading is enabled, HW decodes frames and strips
>  		 * the SecTAG, so we have to deduce which port to deliver to.
>  		 */
> -		if (macsec_is_offloaded(macsec) && netif_running(ndev)) {
> +		if (macsec_is_offloaded(macsec) && netif_running(ndev) &&
> +		    (!macsec_ext || macsec_ext->offloaded)) {
> +			if ((macsec_ext) && (!find_rx_sc(&macsec->secy, macsec_ext->sci)))
> +				continue;
> +
>  			if (ether_addr_equal_64bits(hdr->h_dest,
>  						    ndev->dev_addr)) {
>  				/* exact match, divert skb to this port */
> diff --git a/include/net/macsec.h b/include/net/macsec.h
> index 6de49d9c98bc..fcbca963c04d 100644
> --- a/include/net/macsec.h
> +++ b/include/net/macsec.h
> @@ -23,6 +23,7 @@ typedef u32 __bitwise ssci_t;
>  /* MACsec sk_buff extension data */
>  struct macsec_ext {
>  	sci_t sci;
> +	bool offloaded;
>  };
>  
>  typedef union salt {
> diff --git a/net/core/gro.c b/net/core/gro.c
> index b4190eb08467..f68e950be37f 100644
> --- a/net/core/gro.c
> +++ b/net/core/gro.c
> @@ -1,5 +1,6 @@
>  // SPDX-License-Identifier: GPL-2.0-or-later
>  #include <net/gro.h>
> +#include <net/macsec.h>
>  #include <net/dst_metadata.h>
>  #include <net/busy_poll.h>
>  #include <trace/events/net.h>
> @@ -390,6 +391,10 @@ static void gro_list_prepare(const struct list_head *head,
>  			struct tc_skb_ext *skb_ext;
>  			struct tc_skb_ext *p_ext;
>  #endif
> +#if IS_ENABLED(CONFIG_SKB_EXTENSIONS) && IS_ENABLED(CONFIG_MACSEC)
> +			struct macsec_ext *macsec_skb_ext;
> +			struct macsec_ext *macsec_p_ext;
> +#endif
>  
>  			diffs |= p->sk != skb->sk;
>  			diffs |= skb_metadata_dst_cmp(p, skb);
> @@ -402,6 +407,17 @@ static void gro_list_prepare(const struct list_head *head,
>  			diffs |= (!!p_ext) ^ (!!skb_ext);
>  			if (!diffs && unlikely(skb_ext))
>  				diffs |= p_ext->chain ^ skb_ext->chain;
> +#endif
> +#if IS_ENABLED(CONFIG_SKB_EXTENSIONS) && IS_ENABLED(CONFIG_MACSEC)
> +			macsec_skb_ext = skb_ext_find(skb, SKB_EXT_MACSEC);
> +			macsec_p_ext = skb_ext_find(p, SKB_EXT_MACSEC);
> +
> +			diffs |= (!!macsec_p_ext) ^ (!!macsec_skb_ext);
> +			if (!diffs && unlikely(macsec_skb_ext)) {
> +				diffs |= (__force unsigned long)macsec_p_ext->sci ^
> +					 (__force unsigned long)macsec_skb_ext->sci;
> +				diffs |= macsec_p_ext->offloaded ^ macsec_skb_ext->offloaded;
> +			}
>  #endif 		}
> 
The main reason I suggested to look for the a possible alternative to
the skb extension is that the GRO stage is becoming bigger (and slower)
with any of such addition.

The 'slow_gro' protects the common use-case from any additional
conditionals and intructions, I still have some concerns due to the
increased code size.

This is not a reject, I'm mostly looking for a 2nd opinion.

Thanks,

Paolo

