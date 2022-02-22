Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 192A14C000C
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 18:22:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232836AbiBVRWa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 12:22:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231342AbiBVRW3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 12:22:29 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E781B108568
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 09:22:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645550522;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9Rov6ncWmYdTpBP7J4wDIuhDW3idvx8q/MaZIno7w/U=;
        b=XL8JKxDIiqU5kitqMBXXYrSmO321HOlt5ZbeV4CGtluqwVNsT7vEC13fcirB4uDAQiWCdd
        xO4WhNjo7vapSmZI9faLcw/t5masIjfh/zgVMybEbC9bSHTDtNia+LEW7WyUuhkR/obX0p
        FMQYRDmYD/JPdYHnUa3V0fZ97Gl/ZbY=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-230-xa3Su8VLPqGbw3qk670gZw-1; Tue, 22 Feb 2022 12:22:00 -0500
X-MC-Unique: xa3Su8VLPqGbw3qk670gZw-1
Received: by mail-wr1-f71.google.com with SMTP id u9-20020adfae49000000b001e89793bcb0so7750679wrd.17
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 09:22:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=9Rov6ncWmYdTpBP7J4wDIuhDW3idvx8q/MaZIno7w/U=;
        b=udw2UzzHZutqgkxMqS8xs4X4oj1U+uAgtuLyJhrplWOqoUEB406bPrKPD8OmtwbZS6
         bEnqL0KPY0UmsRIZvK9rs0/5yyr7fi1a4ClhYUGIX029L5OU92xFqq2X23YFEByI7x+Z
         nbJ2iIdRQVjuzEg4ZJTwsYCNcY6FpnLpDtEZHLZIzo+SdooL6tRCSB28oAr8qITBuon9
         UA09T1KG0O02NBGVLjcIuwZL/fV5d1z8OdtHLdvozxNy4jp5JM26o/gP8XAt/qrLqbRK
         BhiXVPdyw2kcVnRDicfpyg80eAcfKNv/o/ofy8wQ3S1dVyvpZemcUcqPS/0w4AJz7L85
         jBxw==
X-Gm-Message-State: AOAM533R/3/y/MyZHqRBh/M9CO840gqtT3v2zoMmwVATrT05PQZLnAdE
        7/YTbJUaueiPYOaYykUxzFFJpgfsgoLRlFHYEfl9hFL0WLUDnJUMUbqNk2ZWNf4h55EEuCSHVlK
        2vRmMdKkqL+yOKdLo
X-Received: by 2002:adf:db4f:0:b0:1e6:8b9a:f96c with SMTP id f15-20020adfdb4f000000b001e68b9af96cmr19760536wrj.454.1645550519112;
        Tue, 22 Feb 2022 09:21:59 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzU0F81CvONtbml/nEQM9lMsb1ySsOfNVDClBM4DT9J6t+jRiYpdSCfDFDOSLFWru6zTY4NVg==
X-Received: by 2002:adf:db4f:0:b0:1e6:8b9a:f96c with SMTP id f15-20020adfdb4f000000b001e68b9af96cmr19760514wrj.454.1645550518808;
        Tue, 22 Feb 2022 09:21:58 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-108-216.dyn.eolo.it. [146.241.108.216])
        by smtp.gmail.com with ESMTPSA id i15sm3599765wmq.23.2022.02.22.09.21.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Feb 2022 09:21:58 -0800 (PST)
Message-ID: <0c9bc29843cd1697aa89ebceb61b8efe8156a9e8.camel@redhat.com>
Subject: Re: [PATCH v2 bpf-next 3/3] veth: allow jumbo frames in xdp mode
From:   Paolo Abeni <pabeni@redhat.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, brouer@redhat.com, toke@redhat.com,
        echaudro@redhat.com, lorenzo.bianconi@redhat.com,
        toshiaki.makita1@gmail.com, andrii@kernel.org
Date:   Tue, 22 Feb 2022 18:21:56 +0100
In-Reply-To: <15943b59b1638515770b7ab841b0d741dc314c3a.1644930125.git.lorenzo@kernel.org>
References: <cover.1644930124.git.lorenzo@kernel.org>
         <15943b59b1638515770b7ab841b0d741dc314c3a.1644930125.git.lorenzo@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.3 (3.42.3-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-02-15 at 14:08 +0100, Lorenzo Bianconi wrote:
> Allow increasing the MTU over page boundaries on veth devices
> if the attached xdp program declares to support xdp fragments.
> Enable NETIF_F_ALL_TSO when the device is running in xdp mode.
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  drivers/net/veth.c | 26 +++++++++++---------------
>  1 file changed, 11 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/net/veth.c b/drivers/net/veth.c
> index a45aaaecc21f..2e048f957bc6 100644
> --- a/drivers/net/veth.c
> +++ b/drivers/net/veth.c
> @@ -292,8 +292,6 @@ static int veth_forward_skb(struct net_device *dev, struct sk_buff *skb,
>  /* return true if the specified skb has chances of GRO aggregation
>   * Don't strive for accuracy, but try to avoid GRO overhead in the most
>   * common scenarios.
> - * When XDP is enabled, all traffic is considered eligible, as the xmit
> - * device has TSO off.
>   * When TSO is enabled on the xmit device, we are likely interested only
>   * in UDP aggregation, explicitly check for that if the skb is suspected
>   * - the sock_wfree destructor is used by UDP, ICMP and XDP sockets -
> @@ -334,7 +332,8 @@ static netdev_tx_t veth_xmit(struct sk_buff *skb, struct net_device *dev)
>  		 * Don't bother with napi/GRO if the skb can't be aggregated
>  		 */
>  		use_napi = rcu_access_pointer(rq->napi) &&
> -			   veth_skb_is_eligible_for_gro(dev, rcv, skb);
> +			   (rcu_access_pointer(rq->xdp_prog) ||
> +			    veth_skb_is_eligible_for_gro(dev, rcv, skb));

Sorry for the late feedback. I think the code would be more readable if
you move the additional check inside 'veth_skb_is_eligible_for_gro' and
adjust veth_skb_is_eligible_for_gro() comment accordingly.

Thanks!

Paolo

