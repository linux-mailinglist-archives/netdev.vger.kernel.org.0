Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C0BA2FF722
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 22:25:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726952AbhAUVZQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 16:25:16 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:44879 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726147AbhAUVZM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 16:25:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1611264312; x=1642800312;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=RcvzoDwdXu0HyJ7NtFExgJfQk/8fBcALd33MGBHzuDQ=;
  b=sBH0+MLVLKXv3xCcZlbLiaIDaQr4yBQECd6DLEMcznKo7MCOvLkMeLAR
   hTwHiaUaW7Fusg0VVOX0I96idIrLGTriEGrtHnz3VkFSb/T/d++FiynFQ
   CxAJVAoEZWZVipp4tfPHfyXUfK1/S5BCGanmp3kVHHd5Y1fYzl9dUssEH
   8Ye6j9o3EU7QI5ecsQb0Tnt3hKZaDWi+0GIuIVVvHrK6tbMaiR0Lz/g0k
   xQ8w3JoVnKdqmJ0PmzMU1ACW0sdID+7/boStOYBxdvoC5qAfUbjIj8TiS
   dOcGk1o83DozBf/ZW+n8QR6nZTIUPwQ8jhdfZG2NNovT81wgBL2Gpc0Y/
   Q==;
IronPort-SDR: WDfhLT0v3Dhq5l8KA3JGWgwsMka1h0FYs5MCIWfmEOlU+CFegiWsWbZUUd65YgQXmmvyETD7w8
 tRCOAUPZvvK0xdfeBVUnjasqd3oBdKhli75P8E7LYOZxRCQtBPkgnjdrH9ucKPCuXtYQidyHiv
 zap0hYF2xBmlR7y1up72b2pTSHEcCSLaRDheNqQo+5tilCbqguxxsg8c1Qe4Q9v7UrXE/a58gv
 ftELzWXcmCxZyyA0lFq7GCmvUMXYbn/aEGMG5K8V6lYOur1GhbU4jF3a83k3rPF/7FKA0faY9l
 czw=
X-IronPort-AV: E=Sophos;i="5.79,365,1602572400"; 
   d="scan'208";a="41277081"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 21 Jan 2021 14:23:44 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 21 Jan 2021 14:23:44 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Thu, 21 Jan 2021 14:23:43 -0700
Date:   Thu, 21 Jan 2021 22:23:40 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>
CC:     <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net v2 1/2] net: mrp: fix definitions of MRP test packets
Message-ID: <20210121212340.dtvdkm4nnqcqjhss@soft-dev3.localdomain>
References: <20210121204037.61390-1-rasmus.villemoes@prevas.dk>
 <20210121204037.61390-2-rasmus.villemoes@prevas.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20210121204037.61390-2-rasmus.villemoes@prevas.dk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 01/21/2021 21:40, Rasmus Villemoes wrote:

It seems that is missing a Fixes tag, other than that it looks fine.

Reviewed-by: Horatiu Vultur <horatiu.vultur@microchip.com>

> 
> Wireshark says that the MRP test packets cannot be decoded - and the
> reason for that is that there's a two-byte hole filled with garbage
> between the "transitions" and "timestamp" members.
> 
> So Wireshark decodes the two garbage bytes and the top two bytes of
> the timestamp written by the kernel as the timestamp value (which thus
> fluctuates wildly), and interprets the lower two bytes of the
> timestamp as a new (type, length) pair, which is of course broken.
> 
> Even though this makes the timestamp field in the struct unaligned, it
> actually makes it end up on a 32 bit boundary in the frame as mandated
> by the standard, since it is preceded by a two byte TLV header.
> 
> The struct definitions live under include/uapi/, but they are not
> really part of any kernel<->userspace API/ABI, so fixing the
> definitions by adding the packed attribute should not cause any
> compatibility issues.
> 
> Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
> ---
>  include/uapi/linux/mrp_bridge.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/uapi/linux/mrp_bridge.h b/include/uapi/linux/mrp_bridge.h
> index 6aeb13ef0b1e..d1d0cf65916d 100644
> --- a/include/uapi/linux/mrp_bridge.h
> +++ b/include/uapi/linux/mrp_bridge.h
> @@ -96,7 +96,7 @@ struct br_mrp_ring_test_hdr {
>         __be16 state;
>         __be16 transitions;
>         __be32 timestamp;
> -};
> +} __attribute__((__packed__));
> 
>  struct br_mrp_ring_topo_hdr {
>         __be16 prio;
> @@ -141,7 +141,7 @@ struct br_mrp_in_test_hdr {
>         __be16 state;
>         __be16 transitions;
>         __be32 timestamp;
> -};
> +} __attribute__((__packed__));
> 
>  struct br_mrp_in_topo_hdr {
>         __u8 sa[ETH_ALEN];
> --
> 2.23.0
> 

-- 
/Horatiu
