Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 642CD2E8C4D
	for <lists+netdev@lfdr.de>; Sun,  3 Jan 2021 14:33:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726469AbhACNbJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jan 2021 08:31:09 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:43803 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725889AbhACNbI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Jan 2021 08:31:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1609680667; x=1641216667;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=2xhwRXanK/i/CgEZSHgyYCytHzT0rGYxDNhCQisJU7U=;
  b=FnYOreZYxjbw5WgLk0zNbC4n8LemhfJuo7OnhF5NCYQAbSJCLZ66+KMK
   d5zjZpCVpu9VNmat0F7aaLsm3dSeFW60W3LdopNIPHX/68J3N6i4S5ZdI
   gl4FMeaTSGMQpOracTDZUeaymFBE6Nxs+zdO0UHGoINWZlAICIlElhnG+
   KV/jGdNDjNgAY9B0dWANYNA0t/o8pRJKLA6iGxyfqafjhBNJST6zgUs6e
   FNNvCSRUgWsoeWx0xzXxwYSv7bUsD/xiY/4oiXIpf1L5mPG6UDuPS/n3q
   XRrqkNmYqQ888pNXjccinJ+Q2bi8dcusYspheXjMJNsZDFVp7OoMV4xGM
   A==;
IronPort-SDR: J4JX1EmVSuUKw3HTuCwO6yaQSrDj9oRudX3J0VRyWKCspIIM9+We3udRRR73MX6nhr2kt2Kax8
 U3JU+1mLDxebAoLoIQTJCYIkWueRVuMBQF6rgTpQ3Ij6sqcDk4DxPov3Su7oZ0moPOTPxrbqe9
 8sCQjgWkBbwPvd2XUUctqd1ONXM6dsind0aq+yfTPUnq7e5B3sOvImo2W5urYb8GKZWy9wobj8
 FEfWHMuoUWoqEgTtqj8aaAjAj8PnsxZ2AcU8efC50737WW9I1tOu7M1PgjxaL/ecYCu3+LMgW8
 3W8=
X-IronPort-AV: E=Sophos;i="5.78,471,1599548400"; 
   d="scan'208";a="109610295"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 03 Jan 2021 06:29:51 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Sun, 3 Jan 2021 06:29:51 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Sun, 3 Jan 2021 06:29:51 -0700
Date:   Sun, 3 Jan 2021 14:29:50 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net 1/2] net: mrp: fix definitions of MRP test packets
Message-ID: <20210103132950.khcn3kzmwrai5fxx@soft-dev3.localdomain>
References: <20201223144533.4145-1-rasmus.villemoes@prevas.dk>
 <20201223144533.4145-2-rasmus.villemoes@prevas.dk>
 <20201228142411.1c752b2e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20201228142411.1c752b2e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 12/28/2020 14:24, Jakub Kicinski wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> On Wed, 23 Dec 2020 15:45:32 +0100 Rasmus Villemoes wrote:
> > Wireshark says that the MRP test packets cannot be decoded - and the
> > reason for that is that there's a two-byte hole filled with garbage
> > between the "transitions" and "timestamp" members.
> >
> > So Wireshark decodes the two garbage bytes and the top two bytes of
> > the timestamp written by the kernel as the timestamp value (which thus
> > fluctuates wildly), and interprets the lower two bytes of the
> > timestamp as a new (type, length) pair, which is of course broken.
> >
> > While my copy of the MRP standard is still under way [*], I cannot
> > imagine the standard specifying a two-byte hole here, and whoever
> > wrote the Wireshark decoding code seems to agree with that.
> >
> > The struct definitions live under include/uapi/, but they are not
> > really part of any kernel<->userspace API/ABI, so fixing the
> > definitions by adding the packed attribute should not cause any
> > compatibility issues.
> >
> > The remaining on-the-wire packet formats likely also don't contain
> > holes, but pahole and manual inspection says the current definitions
> > suffice. So adding the packed attribute to those is not strictly
> > needed, but might be done for good measure.
> >
> > [*] I will never understand how something hidden behind a +1000$
> > paywall can be called a standard.
> >
> > Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
> > ---
> >  include/uapi/linux/mrp_bridge.h | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/include/uapi/linux/mrp_bridge.h b/include/uapi/linux/mrp_bridge.h
> > index 6aeb13ef0b1e..d1d0cf65916d 100644
> > --- a/include/uapi/linux/mrp_bridge.h
> > +++ b/include/uapi/linux/mrp_bridge.h
> > @@ -96,7 +96,7 @@ struct br_mrp_ring_test_hdr {
> >       __be16 state;
> >       __be16 transitions;
> >       __be32 timestamp;
> > -};
> > +} __attribute__((__packed__));
> >
> >  struct br_mrp_ring_topo_hdr {
> >       __be16 prio;
> > @@ -141,7 +141,7 @@ struct br_mrp_in_test_hdr {
> >       __be16 state;
> >       __be16 transitions;
> >       __be32 timestamp;
> > -};
> > +} __attribute__((__packed__));
> >
> >  struct br_mrp_in_topo_hdr {
> >       __u8 sa[ETH_ALEN];
> 
> Can we use this opportunity to move the definitions of these structures
> out of the uAPI to a normal kernel header?

Or maybe we can just remove them, especially if they are not used by the
kernel.

-- 
/Horatiu
