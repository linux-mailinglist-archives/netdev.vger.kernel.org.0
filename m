Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B462267E233
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 11:50:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232419AbjA0Kuh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 05:50:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232409AbjA0Kug (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 05:50:36 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1989468AE3
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 02:49:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674816596;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=f+qUsIvPWlolxwMkp3iJfyb2fF8yY5Z3zFObDH67p2U=;
        b=M4civEyIs9u+VhjuJh3z3otW+T+f3zfIti/DFgDNvskenci0QKoBKsCyZs3PtiR9gGFERD
        5vMRNm9gKrfJnAiSfiOW3TXcyHU5bYhH+UBhhDPsevqmnD4aw8hH34Wq2/J35AgTLdxlW7
        5hBkW7PCnPpXr+nAFfbxpJPWpPzT6UU=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-640-TbVM3XY9MySSPexb9zFB4g-1; Fri, 27 Jan 2023 05:49:55 -0500
X-MC-Unique: TbVM3XY9MySSPexb9zFB4g-1
Received: by mail-ej1-f72.google.com with SMTP id hr22-20020a1709073f9600b0086ffb73ac1cso3201648ejc.23
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 02:49:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=f+qUsIvPWlolxwMkp3iJfyb2fF8yY5Z3zFObDH67p2U=;
        b=2gI2IVW1zoz1CVJibpNBLaHx15Ma6BDzlq8VfQFL3RDiyzHZGYGL4MF5m9JsaFXKb0
         G4atff5W9OiQYiBHTDUb64k1uAXR8E0FPsvBYRCEA31dRU6xtM0AWwi759VBKdm9kDe3
         eVM36cfAy3MmVQLyAPwdaVR+payMzd5PIQSf1PTjFCbb1fUae6OQduP2KfSWoHrpwJcr
         +0s/3GwAXp3BS+ilNA1zV6OUhaI599aWcsYxxTq5VvML2ryUkvklaxQP7GZRJ0mTARHl
         EFBLAt8YFrQ7pp01btL7wyVYWNbWG5C3vysjbYgkxCmFJgm5EW2gqBUxa3m1dMznE8Yk
         Dk4w==
X-Gm-Message-State: AO0yUKU6QRmKKTUmQqrSLx9UENvh+6PP6s2rYwoAd8uNMegzKnTiZg0N
        TQlsAo5s6NEk4YD4O4RgIQqj6ahmO1ka2jf4udaawCgEZWVLDAxmxmc574hsZD8nOjNe2VuxUsJ
        0fSZG1lQO0Iqh1yw5
X-Received: by 2002:a50:cd8a:0:b0:4a1:fc2e:a1ad with SMTP id p10-20020a50cd8a000000b004a1fc2ea1admr1638678edi.19.1674816593791;
        Fri, 27 Jan 2023 02:49:53 -0800 (PST)
X-Google-Smtp-Source: AK7set/9zetAfFyAor8bEeKpPs9mPfgViTgUECua2FXucFKXLKXCl6gDxwPhzTTqZ6nntD7tfx/67g==
X-Received: by 2002:a50:cd8a:0:b0:4a1:fc2e:a1ad with SMTP id p10-20020a50cd8a000000b004a1fc2ea1admr1638660edi.19.1674816593547;
        Fri, 27 Jan 2023 02:49:53 -0800 (PST)
Received: from redhat.com ([2.52.137.69])
        by smtp.gmail.com with ESMTPSA id i12-20020aa7dd0c000000b0045ce419ecffsm2102130edv.58.2023.01.27.02.49.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jan 2023 02:49:52 -0800 (PST)
Date:   Fri, 27 Jan 2023 05:49:47 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com, maciej.fijalkowski@intel.com,
        kuba@kernel.org, toke@redhat.com, pabeni@redhat.com,
        davem@davemloft.net, aelior@marvell.com, manishc@marvell.com,
        horatiu.vultur@microchip.com, UNGLinuxDriver@microchip.com,
        jasowang@redhat.com, ioana.ciornei@nxp.com, madalin.bucur@nxp.com,
        bpf@vger.kernel.org
Subject: Re: [PATCH net v2 3/5] virtio-net: execute xdp_do_flush() before
 napi_complete_done()
Message-ID: <20230127054935-mutt-send-email-mst@kernel.org>
References: <20230125074901.2737-1-magnus.karlsson@gmail.com>
 <20230125074901.2737-4-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230125074901.2737-4-magnus.karlsson@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 25, 2023 at 08:48:59AM +0100, Magnus Karlsson wrote:
> From: Magnus Karlsson <magnus.karlsson@intel.com>
> 
> Make sure that xdp_do_flush() is always executed before
> napi_complete_done(). This is important for two reasons. First, a
> redirect to an XSKMAP assumes that a call to xdp_do_redirect() from
> napi context X on CPU Y will be followed by a xdp_do_flush() from the
> same napi context and CPU. This is not guaranteed if the
> napi_complete_done() is executed before xdp_do_flush(), as it tells
> the napi logic that it is fine to schedule napi context X on another
> CPU. Details from a production system triggering this bug using the
> veth driver can be found following the first link below.
> 
> The second reason is that the XDP_REDIRECT logic in itself relies on
> being inside a single NAPI instance through to the xdp_do_flush() call
> for RCU protection of all in-kernel data structures. Details can be
> found in the second link below.
> 
> Fixes: 186b3c998c50 ("virtio-net: support XDP_REDIRECT")
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>
> Link: https://lore.kernel.org/r/20221220185903.1105011-1-sbohrer@cloudflare.com
> Link: https://lore.kernel.org/all/20210624160609.292325-1-toke@redhat.com/

Acked-by: Michael S. Tsirkin <mst@redhat.com>

> ---
>  drivers/net/virtio_net.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 18b3de854aeb..6df14dd5bf46 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -1677,13 +1677,13 @@ static int virtnet_poll(struct napi_struct *napi, int budget)
>  
>  	received = virtnet_receive(rq, budget, &xdp_xmit);
>  
> +	if (xdp_xmit & VIRTIO_XDP_REDIR)
> +		xdp_do_flush();
> +
>  	/* Out of packets? */
>  	if (received < budget)
>  		virtqueue_napi_complete(napi, rq->vq, received);
>  
> -	if (xdp_xmit & VIRTIO_XDP_REDIR)
> -		xdp_do_flush();
> -
>  	if (xdp_xmit & VIRTIO_XDP_TX) {
>  		sq = virtnet_xdp_get_sq(vi);
>  		if (virtqueue_kick_prepare(sq->vq) && virtqueue_notify(sq->vq)) {
> -- 
> 2.34.1

