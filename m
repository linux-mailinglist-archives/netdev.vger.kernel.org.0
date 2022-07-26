Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 163695810A6
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 12:01:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232708AbiGZKBA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 06:01:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232837AbiGZKA6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 06:00:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6DD6130F6E
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 03:00:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658829655;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=im270tm6XU5oPnYdALVxjMHjuSTNmljwqXxGSw+Tblo=;
        b=gm8YT6E9Vs3gHSlWqF6BZXYEaYwfo0gzl1NUInkMdwnSakG3ppKqhdRlLHbybN9Zdc316O
        97Tu5USqsgPFXxv0nHLHgk+wMUTFFU148RM5NTs9+Ra2grqkXxXdQT8KG5aJ4Hg3y++KAZ
        NxAexMgOIu2SaW/n0yTV9xUO2Dr9ZN0=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-639-0zKQF0czPGy1DHv2JfDNEg-1; Tue, 26 Jul 2022 06:00:50 -0400
X-MC-Unique: 0zKQF0czPGy1DHv2JfDNEg-1
Received: by mail-wm1-f69.google.com with SMTP id p36-20020a05600c1da400b003a33a8c14f2so6350651wms.7
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 03:00:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=im270tm6XU5oPnYdALVxjMHjuSTNmljwqXxGSw+Tblo=;
        b=Ho8bxJR2BTGhQHIWVhga0+lUpg6lSjQcHmSTneOrqSsH5QRwNQ7F//0YoqZlNzR6dP
         vwpu3LBBaDG7HsWCGqfyMbMBpJHOrR0tmKLWKViJ/sDSM/tN4VkWXK4a2n6VoAL40FNd
         Eun/9pZZkQY/wUOFqPnXFrH/so81KqmcUzP8zTIcVohrU/9wOBnnZk6FpxMS1U1zgiyq
         YZKZKpePPNaFLTo9oGVlmkDF6N88bwM0kKeyrLHNLAy5kv+fyGE26zA5oTG7I5t7Pwm/
         rfCCbmMDj9GkyTq+NvJ7N4iPh3u0e+gFN8LPWWAEbjeL9GAxDMYSC4DwdxG6Eox3LTO8
         xtsA==
X-Gm-Message-State: AJIora9cCFUjolL3SlcvF1PVHUrXohkY/gihVdva9dXiXW/NHmzVxoaZ
        645U5YVeUdWLlbhjw1eFS+MJHwBBI3eFjTjyCbXzE2IXxihWstd016b572ineDEnimRpuJDoPOW
        TKfg71CP0UXdFGThy
X-Received: by 2002:a5d:6d8b:0:b0:21d:a6ac:b34b with SMTP id l11-20020a5d6d8b000000b0021da6acb34bmr10528417wrs.35.1658829649129;
        Tue, 26 Jul 2022 03:00:49 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1s/5WZKthQnFmT1in15NA71Lhrm+N6uEx2QPBvHjAu9cKD3egYzPPm/Kxt3pymzcLo2LNjucw==
X-Received: by 2002:a5d:6d8b:0:b0:21d:a6ac:b34b with SMTP id l11-20020a5d6d8b000000b0021da6acb34bmr10528387wrs.35.1658829648680;
        Tue, 26 Jul 2022 03:00:48 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-104-164.dyn.eolo.it. [146.241.104.164])
        by smtp.gmail.com with ESMTPSA id az28-20020a05600c601c00b003a325bd8517sm20186514wmb.5.2022.07.26.03.00.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jul 2022 03:00:48 -0700 (PDT)
Message-ID: <843286034774bec118d98e9b4531093faef036f9.camel@redhat.com>
Subject: Re: [PATCH net-next] add missing includes and forward declarations
 to networking includes under linux/
From:   Paolo Abeni <pabeni@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com
Date:   Tue, 26 Jul 2022 12:00:47 +0200
In-Reply-To: <20220723045755.2676857-1-kuba@kernel.org>
References: <20220723045755.2676857-1-kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2022-07-22 at 21:57 -0700, Jakub Kicinski wrote:
> Similarly to a recent include/net/ cleanup, this patch adds
> missing includes to networking headers under include/linux.
> All these problems are currently masked by the existing users
> including the missing dependency before the broken header.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  include/linux/atm_tcp.h         | 3 +++
>  include/linux/dsa/tag_qca.h     | 6 ++++++
>  include/linux/hippidevice.h     | 4 ++++
>  include/linux/if_eql.h          | 1 +
>  include/linux/if_hsr.h          | 4 ++++
>  include/linux/if_rmnet.h        | 2 ++
>  include/linux/if_tap.h          | 2 ++
>  include/linux/mdio/mdio-xgene.h | 4 ++++
>  include/linux/nl802154.h        | 2 ++
>  include/linux/phy_fixed.h       | 3 +++
>  include/linux/ppp-comp.h        | 2 +-
>  include/linux/ppp_channel.h     | 2 ++
>  include/linux/ptp_kvm.h         | 2 ++
>  include/linux/ptp_pch.h         | 4 ++++
>  include/linux/seq_file_net.h    | 1 +
>  include/linux/sungem_phy.h      | 2 ++
>  include/linux/usb/usbnet.h      | 6 ++++++
>  include/net/llc_s_st.h          | 6 ++++++
>  18 files changed, 55 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/atm_tcp.h b/include/linux/atm_tcp.h
> index c8ecf6f68fb5..ba4fe690bff0 100644
> --- a/include/linux/atm_tcp.h
> +++ b/include/linux/atm_tcp.h
> @@ -9,6 +9,9 @@
>  
>  #include <uapi/linux/atm_tcp.h>
>  
> +struct atm_tcp_ops;

This looks not needed? 'struct atm_tcp_ops' is defined a few lines
below...

> +struct atm_vcc;
> +struct module;
>  
>  struct atm_tcp_ops {
>  	int (*attach)(struct atm_vcc *vcc,int itf);
> diff --git a/include/linux/dsa/tag_qca.h b/include/linux/dsa/tag_qca.h
> index 4359fb0221cf..e357df561e55 100644
> --- a/include/linux/dsa/tag_qca.h
> +++ b/include/linux/dsa/tag_qca.h
> @@ -3,6 +3,12 @@
>  #ifndef __TAG_QCA_H
>  #define __TAG_QCA_H
>  
> +#include <linux/types.h>
> +
> +struct dsa_switch;
> +struct net_device;

It looks like 'struct net_device' is not used in this header file.

> +struct sk_buff;
> +
>  #define QCA_HDR_LEN	2
>  #define QCA_HDR_VERSION	0x2
>  

[...]
> diff --git a/include/linux/if_tap.h b/include/linux/if_tap.h
> index 915a187cfabd..f21f87952b20 100644
> --- a/include/linux/if_tap.h
> +++ b/include/linux/if_tap.h
> @@ -2,6 +2,8 @@
>  #ifndef _LINUX_IF_TAP_H_
>  #define _LINUX_IF_TAP_H_
>  
> +struct file;

I guess even:

struct socket;
struct ptr_ring;

are needed, and you can remove the forward declaration from the #else
branch.

> +
>  #if IS_ENABLED(CONFIG_TAP)
>  struct socket *tap_get_socket(struct file *);
>  struct ptr_ring *tap_get_ptr_ring(struct file *file);
> diff --git a/include/linux/mdio/mdio-xgene.h b/include/linux/mdio/mdio-xgene.h
> index 8af93ada8b64..9e588965dc83 100644
> --- a/include/linux/mdio/mdio-xgene.h
> +++ b/include/linux/mdio/mdio-xgene.h
> @@ -8,6 +8,10 @@
>  #ifndef __MDIO_XGENE_H__
>  #define __MDIO_XGENE_H__
>  
> +#include <linux/bits.h>
> +#include <linux/spinlock.h>
> +#include <linux/types.h>
> +

possibly even:

struct clk;
struct device;
struct mii_bus;

used below.

>  #define BLOCK_XG_MDIO_CSR_OFFSET	0x5000
>  #define BLOCK_DIAG_CSR_OFFSET		0xd000
>  #define XGENET_CONFIG_REG_ADDR		0x20

[...]

> diff --git a/include/linux/sungem_phy.h b/include/linux/sungem_phy.h
> index 3a11fa41a131..c505f30e8b68 100644
> --- a/include/linux/sungem_phy.h
> +++ b/include/linux/sungem_phy.h
> @@ -2,6 +2,8 @@
>  #ifndef __SUNGEM_PHY_H__
>  #define __SUNGEM_PHY_H__
>  
> +#include <linux/types.h>
> +
>  struct mii_phy;

Possibly even:

struct net_device;

used below.

>  
>  /* Operations supported by any kind of PHY */
> diff --git a/include/linux/usb/usbnet.h b/include/linux/usb/usbnet.h
> index 1b4d72d5e891..b42b72391a8d 100644
> --- a/include/linux/usb/usbnet.h
> +++ b/include/linux/usb/usbnet.h
> @@ -23,6 +23,12 @@
>  #ifndef	__LINUX_USB_USBNET_H
>  #define	__LINUX_USB_USBNET_H
>  
> +#include <linux/mii.h>
> +#include <linux/netdevice.h>
> +#include <linux/skbuff.h>
> +#include <linux/types.h>

'linux/types.h' should not be needed: already included via skbuff.h ->
atomic.h -> types.h

> +#include <linux/usb.h>
> +
>  /* interface from usbnet core to each USB networking link we handle */
>  struct usbnet {
>  	/* housekeeping */

Cheers,

Paolo

