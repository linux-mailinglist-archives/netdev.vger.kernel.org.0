Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7357B65E8A6
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 11:10:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231596AbjAEKKI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 05:10:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231524AbjAEKKG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 05:10:06 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0156B2DC8
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 02:09:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672913358;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=L6GYaqFKC7qj174roSMxNm7tuCjRBIh6dzRL2khY6uQ=;
        b=NUCa5ruQWAvh3n2WJHBXQTVnElCKK9T+G8BiFbxxBelAHXd0rxQy0zEPmB8Ev+rzAvKrEZ
        89Po+Aql0Ms/+MdhyIkMcCKzCOLqEfIErwNkBSZCN1pJFH5AHFQ4gIlMDDhlWg0dMmZVt6
        5Y6v1z/Tl8nu/FUKj8rvzZt6dBGZTjM=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-246-FDeljoIcMf2G33WUWc2F4w-1; Thu, 05 Jan 2023 05:09:12 -0500
X-MC-Unique: FDeljoIcMf2G33WUWc2F4w-1
Received: by mail-wr1-f69.google.com with SMTP id k11-20020adfb34b000000b0027811695ca6so3627622wrd.16
        for <netdev@vger.kernel.org>; Thu, 05 Jan 2023 02:09:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=L6GYaqFKC7qj174roSMxNm7tuCjRBIh6dzRL2khY6uQ=;
        b=SYc0hAHFFhSDu43ZU0746X3Z6Q09etYeJx34TckJtXM1D0U5N/Cz0j+fB0BUIB/sHZ
         2eHZ/vR8kbLcjplvvlZoN2Z13byNmrXbAoWqwn/OXmoFMbUapacY85uiA1O0v2Va/0Xw
         P2ypEyVexBXz1R3x9AVwTnhWBwqiHPVGBZM2vWTCwt1LEFOYUDQFQFbGb8y7Sl3C3Brb
         NXpUC/iHY64sFPv0ZxLwhNKyVbR/WcESvranoS6IaLVVFj0I462CO9mwv504Tb9DJpOW
         TS38lWumHiHUIWZJWhvG794R0u2LjIvjWlL4QkZEerFPLQL2jy67mci84PDOmxuLnTtR
         uYQg==
X-Gm-Message-State: AFqh2ko+JF8uqdeaZKpE2TmWTc1helqzORj+3u3tfWCyh9uqqBKEEGMQ
        ixCEJ4SztuMY33dL0KVuXpAmVe9i8tMka2Ev/T1cl40Wa4PB59fVx19Ix5qkd2HlPXDIO5z2/jN
        LL/LuykyvwZrDOh+x
X-Received: by 2002:a05:600c:d1:b0:3d3:4d21:704d with SMTP id u17-20020a05600c00d100b003d34d21704dmr35930985wmm.14.1672913351700;
        Thu, 05 Jan 2023 02:09:11 -0800 (PST)
X-Google-Smtp-Source: AMrXdXtz0y53hRKJSi1Xhkay1mw3bGsPdZ8K3gZ78H1SFuc5lfXpTsfitcVyjDqYKKlObOl1Vp0v5g==
X-Received: by 2002:a05:600c:d1:b0:3d3:4d21:704d with SMTP id u17-20020a05600c00d100b003d34d21704dmr35930975wmm.14.1672913351432;
        Thu, 05 Jan 2023 02:09:11 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-105-31.dyn.eolo.it. [146.241.105.31])
        by smtp.gmail.com with ESMTPSA id o5-20020a05600c510500b003b4ff30e566sm6364999wms.3.2023.01.05.02.09.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jan 2023 02:09:10 -0800 (PST)
Message-ID: <27e0335f6ed15722feff27c17428410982a02e3c.camel@redhat.com>
Subject: Re: [Patch net-next v7 06/13] net: ptp: add helper for one-step P2P
 clocks
From:   Paolo Abeni <pabeni@redhat.com>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, linux@armlinux.org.uk, Tristram.Ha@microchip.com,
        richardcochran@gmail.com, ceggers@arri.de
Date:   Thu, 05 Jan 2023 11:09:09 +0100
In-Reply-To: <20230104084316.4281-7-arun.ramadoss@microchip.com>
References: <20230104084316.4281-1-arun.ramadoss@microchip.com>
         <20230104084316.4281-7-arun.ramadoss@microchip.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Wed, 2023-01-04 at 14:13 +0530, Arun Ramadoss wrote:
> From: Christian Eggers <ceggers@arri.de>
> 
> For P2P delay measurement, the ingress time stamp of the PDelay_Req is
> required for the correction field of the PDelay_Resp. The application
> echoes back the correction field of the PDelay_Req when sending the
> PDelay_Resp.
> 
> Some hardware (like the ZHAW InES PTP time stamping IP core) subtracts
> the ingress timestamp autonomously from the correction field, so that
> the hardware only needs to add the egress timestamp on tx. Other
> hardware (like the Microchip KSZ9563) reports the ingress time stamp via
> an interrupt and requires that the software provides this time stamp via
> tail-tag on tx.
> 
> In order to avoid introducing a further application interface for this,
> the driver can simply emulate the behavior of the InES device and
> subtract the ingress time stamp in software from the correction field.
> 
> On egress, the correction field can either be kept as it is (and the
> time stamp field in the tail-tag is set to zero) or move the value from
> the correction field back to the tail-tag.
> 
> Changing the correction field requires updating the UDP checksum (if UDP
> is used as transport).
> 
> Signed-off-by: Christian Eggers <ceggers@arri.de>
> Co-developed-by: Arun Ramadoss <arun.ramadoss@microchip.com>
> Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
> ---
> v1 -> v2
> - Fixed compilation issue when PTP_CLASSIFY not selected in menuconfig
> as reported by kernel test robot <lkp@intel.com>
> ---
>  include/linux/ptp_classify.h | 71 ++++++++++++++++++++++++++++++++++++
>  1 file changed, 71 insertions(+)
> 
> diff --git a/include/linux/ptp_classify.h b/include/linux/ptp_classify.h
> index 2b6ea36ad162..6e5869c2504c 100644
> --- a/include/linux/ptp_classify.h
> +++ b/include/linux/ptp_classify.h
> @@ -10,8 +10,12 @@
>  #ifndef _PTP_CLASSIFY_H_
>  #define _PTP_CLASSIFY_H_
>  
> +#include <asm/unaligned.h>
>  #include <linux/ip.h>
> +#include <linux/ktime.h>
>  #include <linux/skbuff.h>
> +#include <linux/udp.h>
> +#include <net/checksum.h>
>  
>  #define PTP_CLASS_NONE  0x00 /* not a PTP event message */
>  #define PTP_CLASS_V1    0x01 /* protocol version 1 */
> @@ -129,6 +133,67 @@ static inline u8 ptp_get_msgtype(const struct ptp_header *hdr,
>  	return msgtype;
>  }
>  
> +/**
> + * ptp_check_diff8 - Computes new checksum (when altering a 64-bit field)
> + * @old: old field value
> + * @new: new field value
> + * @oldsum: previous checksum
> + *
> + * This function can be used to calculate a new checksum when only a single
> + * field is changed. Similar as ip_vs_check_diff*() in ip_vs.h.
> + *
> + * Return: Updated checksum
> + */
> +static inline __wsum ptp_check_diff8(__be64 old, __be64 new, __wsum oldsum)
> +{
> +	__be64 diff[2] = { ~old, new };
> +
> +	return csum_partial(diff, sizeof(diff), oldsum);
> +}
> +
> +/**
> + * ptp_header_update_correction - Update PTP header's correction field
> + * @skb: packet buffer
> + * @type: type of the packet (see ptp_classify_raw())
> + * @hdr: ptp header
> + * @correction: new correction value
> + *
> + * This updates the correction field of a PTP header and updates the UDP
> + * checksum (if UDP is used as transport). It is needed for hardware capable of
> + * one-step P2P that does not already modify the correction field of Pdelay_Req
> + * event messages on ingress.
> + */
> +static inline
> +void ptp_header_update_correction(struct sk_buff *skb, unsigned int type,
> +				  struct ptp_header *hdr, s64 correction)
> +{
> +	__be64 correction_old;
> +	struct udphdr *uhdr;
> +
> +	/* previous correction value is required for checksum update. */
> +	memcpy(&correction_old,  &hdr->correction, sizeof(correction_old));
> +
> +	/* write new correction value */
> +	put_unaligned_be64((u64)correction, &hdr->correction);
> +
> +	switch (type & PTP_CLASS_PMASK) {
> +	case PTP_CLASS_IPV4:
> +	case PTP_CLASS_IPV6:
> +		/* locate udp header */
> +		uhdr = (struct udphdr *)((char *)hdr - sizeof(struct udphdr));
> +		break;
> +	default:
> +		return;
> +	}
> +
> +	/* update checksum */
> +	uhdr->check = csum_fold(ptp_check_diff8(correction_old,
> +						hdr->correction,
> +						~csum_unfold(uhdr->check)));
> +	if (!uhdr->check)
> +		uhdr->check = CSUM_MANGLED_0;

AFAICS the above works under the assumption that skb->ip_summed !=
CHECKSUM_COMPLETE, and such assumption is true for the existing DSA
devices.

Still the new helper is a generic one, so perhaps it should take care
of CHECKSUM_COMPLETE, too? Or at least add a big fat warning in the
helper documentation and/or a warn_on_once(CHECKSUM_COMPLETE).

Thanks!

Paolo

