Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF1985A3D1F
	for <lists+netdev@lfdr.de>; Sun, 28 Aug 2022 12:07:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229469AbiH1KHE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Aug 2022 06:07:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiH1KHC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Aug 2022 06:07:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D74155019C
        for <netdev@vger.kernel.org>; Sun, 28 Aug 2022 03:07:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661681220;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=14CrMrsMqvL52d0T4i+Eis9sUHf/qEXpAevdr1VIHQ4=;
        b=Fuzf2maYxI4k+LXrIWQ4QJTc4TmRWINd16ECvoHIDQGBFqfcryHCBtXfQbVgddCFkUmBuu
        BjzueI21mCQNICvhdw9vOd086CA3PdPH1vUCWoy8I6gwIbEh71S1XkmP+YKeaZEJpwdE9A
        0QFL1LU3/QJLhYSTkW/9szfZS2zLB8Y=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-412-ek95qOA5NU-ZrPYQiUEXeQ-1; Sun, 28 Aug 2022 06:06:59 -0400
X-MC-Unique: ek95qOA5NU-ZrPYQiUEXeQ-1
Received: by mail-ed1-f71.google.com with SMTP id z6-20020a05640240c600b0043e1d52fd98so3917555edb.22
        for <netdev@vger.kernel.org>; Sun, 28 Aug 2022 03:06:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=14CrMrsMqvL52d0T4i+Eis9sUHf/qEXpAevdr1VIHQ4=;
        b=cOJkk29xXAq0UdIzU/AYbkHdSVuh9VZ1dQGoUFGi/Yb2ceZNq12b3kgrH73SquoAM+
         Eh5XFs2t88v/ghTAYR+kS1e7/nFY9dgThH2+nFTykH9iib9WJKGTeX/McMIPF9RUBk9X
         JWty3h/hTbWKGFxiriXd2qCamfcsBDcGDBpMG0p4EMyTVgIJheH4CcqYoqCI7IRw7gD/
         HnB/kHNKaWjSZk5zMfZcIEwjgqHJk55y8P39QSzDrff6TGeoITg/SmXoNceDx0bA/6fg
         pDVJADrklwc8ssyzvPod5jggfMOG/949aIJ4agy39HRVkMi6BKIo/M/P39YW6SHRxLgc
         n3zw==
X-Gm-Message-State: ACgBeo2VWmKQUDhueEbLnWoPhqIM74meI9yz9qugm+ZkwyuRJBboBWZP
        hSu+pR+OA2atW96BAk1pKiX2Ge99xc5UHi2tQ7aR0xP4zAqbbb7WavBaWPF+mKaWE1k1+TF2nbQ
        G1x4+pBDpvVQvHPM6
X-Received: by 2002:a17:907:7e92:b0:741:5f7e:f1ac with SMTP id qb18-20020a1709077e9200b007415f7ef1acmr2550295ejc.176.1661681218135;
        Sun, 28 Aug 2022 03:06:58 -0700 (PDT)
X-Google-Smtp-Source: AA6agR49h+fcAPKsk2axqfcGtUxsXDLnwykWThCOpo+s8NAVOUfMmGKoEiLZFHA2oDTMuS6moodiOw==
X-Received: by 2002:a17:907:7e92:b0:741:5f7e:f1ac with SMTP id qb18-20020a1709077e9200b007415f7ef1acmr2550289ejc.176.1661681217926;
        Sun, 28 Aug 2022 03:06:57 -0700 (PDT)
Received: from redhat.com ([2.55.191.225])
        by smtp.gmail.com with ESMTPSA id w17-20020aa7dcd1000000b004479df2ff82sm4138855edu.51.2022.08.28.03.06.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Aug 2022 03:06:56 -0700 (PDT)
Date:   Sun, 28 Aug 2022 06:06:53 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Alvaro Karsz <alvaro.karsz@solid-run.com>
Cc:     netdev@vger.kernel.org, Jason Wang <jasowang@redhat.com>
Subject: Re: [PATCH] net: virtio_net: fix notification coalescing comments
Message-ID: <20220828060617-mutt-send-email-mst@kernel.org>
References: <20220823073947.14774-1-alvaro.karsz@solid-run.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220823073947.14774-1-alvaro.karsz@solid-run.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 23, 2022 at 10:39:47AM +0300, Alvaro Karsz wrote:
> Fix wording in comments for the notifications coalescing feature.
> 
> Signed-off-by: Alvaro Karsz <alvaro.karsz@solid-run.com>

Acked-by: Michael S. Tsirkin <mst@redhat.com>


> ---
>  include/uapi/linux/virtio_net.h | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/include/uapi/linux/virtio_net.h b/include/uapi/linux/virtio_net.h
> index 29ced55514d..6cb842ea897 100644
> --- a/include/uapi/linux/virtio_net.h
> +++ b/include/uapi/linux/virtio_net.h
> @@ -56,7 +56,7 @@
>  #define VIRTIO_NET_F_MQ	22	/* Device supports Receive Flow
>  					 * Steering */
>  #define VIRTIO_NET_F_CTRL_MAC_ADDR 23	/* Set MAC address */
> -#define VIRTIO_NET_F_NOTF_COAL	53	/* Guest can handle notifications coalescing */
> +#define VIRTIO_NET_F_NOTF_COAL	53	/* Device supports notifications coalescing */
>  #define VIRTIO_NET_F_HASH_REPORT  57	/* Supports hash report */
>  #define VIRTIO_NET_F_RSS	  60	/* Supports RSS RX steering */
>  #define VIRTIO_NET_F_RSC_EXT	  61	/* extended coalescing info */
> @@ -364,24 +364,24 @@ struct virtio_net_hash_config {
>   */
>  #define VIRTIO_NET_CTRL_NOTF_COAL		6
>  /*
> - * Set the tx-usecs/tx-max-packets patameters.
> - * tx-usecs - Maximum number of usecs to delay a TX notification.
> - * tx-max-packets - Maximum number of packets to send before a TX notification.
> + * Set the tx-usecs/tx-max-packets parameters.
>   */
>  struct virtio_net_ctrl_coal_tx {
> +	/* Maximum number of packets to send before a TX notification */
>  	__le32 tx_max_packets;
> +	/* Maximum number of usecs to delay a TX notification */
>  	__le32 tx_usecs;
>  };
>  
>  #define VIRTIO_NET_CTRL_NOTF_COAL_TX_SET		0
>  
>  /*
> - * Set the rx-usecs/rx-max-packets patameters.
> - * rx-usecs - Maximum number of usecs to delay a RX notification.
> - * rx-max-frames - Maximum number of packets to receive before a RX notification.
> + * Set the rx-usecs/rx-max-packets parameters.
>   */
>  struct virtio_net_ctrl_coal_rx {
> +	/* Maximum number of packets to receive before a RX notification */
>  	__le32 rx_max_packets;
> +	/* Maximum number of usecs to delay a RX notification */
>  	__le32 rx_usecs;
>  };
>  
> -- 
> 2.32.0

