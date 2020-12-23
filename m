Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9401A2E2047
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 19:00:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728043AbgLWSA2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 13:00:28 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:53779 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726554AbgLWSA1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Dec 2020 13:00:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1608746427; x=1640282427;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=47r11GPRFhq3kFKg3DEtYYb9IpOCEZgBgEMABlO6tnQ=;
  b=K78l9kP6cv7pXXDye8hsQ9+Zztb/ba48efmGMdQvOd+mKfn2lhWaqNxn
   WsGu1cZg8UoUKsIBckzSIHhQahgsexyel3wdGD1gIjpFfaiiDCt0bNm2w
   XhPMagy79gSCD2HQ4yLKh/eds/rvJvfTEvGVJTtF+HP6ojaLAfevwuVhT
   qD2Ys+0TYYna3zwAne1rYxk/MoJ6B1ZazMgyeJ0Ys6+9uM3xnpnvlPGqc
   x09wsHSowg/TWBDMXPU6zCmDB3Nw5xxF95y6B+Pph/9tLTzkPWGVdCibc
   kYmgHljgTR9dhuJMxc91CO+3kP1iYIGgO0cw+CIgSQ1NhbouyE6DbHkph
   Q==;
IronPort-SDR: VbMItp7eqgc6S1n0XuY9L3oN/3JOHEV5urxycxQ78oZy7UX33+VepDUFlH4w2nNTzNNRFWgdyk
 Yd7wq3OaODn/Ope0K1IvCTA3PQDGm4IjzLQKLXTZ1uq5l3T0v8dXmTG80X/oxghIfLYwA+b81B
 C4E9nSs39d2SOa8N2qLCZok9JIB+U0ygEcLecAbHwl6AemmB5y0H2Ygt1Zs9NEhCXSd3H4b2BI
 6Q98u6W8VixUYIqON/esoAPdNIYS7mfM30loudA1xKTXDITWjTnCAdM3Bfhd7/RxejA7cCWiku
 YU8=
X-IronPort-AV: E=Sophos;i="5.78,441,1599548400"; 
   d="scan'208";a="98105173"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 23 Dec 2020 10:59:11 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 23 Dec 2020 10:59:11 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Wed, 23 Dec 2020 10:59:10 -0700
Date:   Wed, 23 Dec 2020 18:59:10 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net 1/2] net: mrp: fix definitions of MRP test packets
Message-ID: <20201223175910.2ipmowhcn63mqtqt@soft-dev3.localdomain>
References: <20201223144533.4145-1-rasmus.villemoes@prevas.dk>
 <20201223144533.4145-2-rasmus.villemoes@prevas.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20201223144533.4145-2-rasmus.villemoes@prevas.dk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 12/23/2020 15:45, Rasmus Villemoes wrote:

Hi Rasmus,
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
> While my copy of the MRP standard is still under way [*], I cannot
> imagine the standard specifying a two-byte hole here, and whoever
> wrote the Wireshark decoding code seems to agree with that.
> 
> The struct definitions live under include/uapi/, but they are not
> really part of any kernel<->userspace API/ABI, so fixing the
> definitions by adding the packed attribute should not cause any
> compatibility issues.
> 
> The remaining on-the-wire packet formats likely also don't contain
> holes, but pahole and manual inspection says the current definitions
> suffice. So adding the packed attribute to those is not strictly
> needed, but might be done for good measure.
> 
> [*] I will never understand how something hidden behind a +1000$
> paywall can be called a standard.
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

Yes, I agree that this should be packed but it also needs to be 32 bit
alligned, so extra 2 bytes are needed.
The same will apply also for 'br_mrp_ring_topo_hdr'

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
