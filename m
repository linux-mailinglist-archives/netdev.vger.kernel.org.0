Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35C9228F808
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 20:00:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732446AbgJOR7p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 13:59:45 -0400
Received: from mailout08.rmx.de ([94.199.90.85]:52124 "EHLO mailout08.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732412AbgJOR7p (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Oct 2020 13:59:45 -0400
Received: from kdin02.retarus.com (kdin02.dmz1.retloc [172.19.17.49])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout08.rmx.de (Postfix) with ESMTPS id 4CBxrF21QvzMnSt;
        Thu, 15 Oct 2020 19:59:41 +0200 (CEST)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin02.retarus.com (Postfix) with ESMTPS id 4CBxqy2x4Tz2TRlS;
        Thu, 15 Oct 2020 19:59:26 +0200 (CEST)
Received: from n95hx1g2.localnet (192.168.54.13) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.408.0; Thu, 15 Oct
 2020 19:58:53 +0200
From:   Christian Eggers <ceggers@arri.de>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     Woojung Huh <woojung.huh@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: Re: [PATCH net] net: dsa: ksz: fix padding size of skb
Date:   Thu, 15 Oct 2020 19:58:52 +0200
Message-ID: <1647199.FWNDY5eN7L@n95hx1g2>
Organization: Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
In-Reply-To: <20201014173103.26nvgqtrpewqskg4@skbuf>
References: <20201014161719.30289-1-ceggers@arri.de> <3253541.RgjG7ZtOS4@n95hx1g2> <20201014173103.26nvgqtrpewqskg4@skbuf>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [192.168.54.13]
X-RMX-ID: 20201015-195932-4CBxqy2x4Tz2TRlS-0@kdin02
X-RMX-SOURCE: 217.111.95.66
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

sorry for the delay, getting answers to all you questions seems to be 
challenging for me. Unfortunately it's about 1 year ago when I was originally 
working on this particular problem and obviously I didn't understand the full 
problem...

On Wednesday, 14 October 2020, 19:31:03 CEST, Vladimir Oltean wrote:
> On Wed, Oct 14, 2020 at 07:02:13PM +0200, Christian Eggers wrote:
> > > Otherwise said, the frame must be padded to
> > > max(skb->len, ETH_ZLEN) + tail tag length.
> > 
> > At first I thought the same when working on this. But IMHO the padding
> > must
> > only ensure the minimum required size, there is no need to pad to the
> > "real" size of the skb. The check for the tailroom above ensures that
> > enough memory for the "real" size is available.
> 
> Yes, that's right, that's the current logic, but what's the point of
> your patch, then, if the call to __skb_put_padto is only supposed to
> ensure ETH_ZLEN length?
After checking __skb_put_padto, I realized that I didn't knew what it actually 
does. The problem in my case is, that the condition

skb_tailroom(skb) >= padlen + len

may not be met anymore after __skb_put_padto(..., skb->len + padlen, ...) 
returns. If skb has previously been cloned, __skb_put_padto() will allocate a 
copy which may have a size of equal / only slightly more than skb->len + 
padlen, which misses the full space for the tail tag. Further calls to 
skb_put() may not find enough tailroom for placing the tail tag.

> In fact, __skb_put_padto fundamentally does:
> - an extension of skb->len to the requested argument, via __skb_put
> - a zero-filling of the extra area
> So if you include the length of the tag in the call to __skb_put_padto,
> then what's the other skb_put() from ksz8795_xmit, ksz9477_xmit,
> ksz9893_xmit going to do? Aren't you increasing the frame length twice
> by the length of one tag when you are doing this?
I initially thought that __skb_put_padto() would perform some sort of 
allocation which can later be used by skb_put(). You are right that my change 
would increase the frame twice. The only reason why this worked for me was 
because the newly allocated skb had enough tailroom due to alignment.

> What problem are you actually trying to solve?
After (hopefully) understanding the important bits, I would like to solve the 
problem that after calling __skb_put_padto() there may be no tailroom for the 
tail tag.

The conditions where this can happen are quite special. You need a skb->len < 
ETH_ZLEN and the skb must be marked as cloned. One condition where this 
happens in practice is when the skb has been selected for TX time stamping in 
dsa_skb_tx_timestamp() [cloned] and L2 is used as transport for PTP [size < 
ETH_ZLEN]. But maybe cloned sk_buffs can also happen for other reasons.

I now suggest the following:
-	if (skb_tailroom(skb) >= padlen + len) {
+	if (skb_tailroom(skb) >= padlen + len && !skb_cloned(skb)) {

This would avoid allocation of a new skb in __skb_put_padto() which may be 
finally too small.

> Can you show a skb_dump(KERN_ERR, skb, true) before and after your change?

Best regards
Christian



