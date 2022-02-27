Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC4B74C59F3
	for <lists+netdev@lfdr.de>; Sun, 27 Feb 2022 09:00:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230125AbiB0IAt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Feb 2022 03:00:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229769AbiB0IAs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Feb 2022 03:00:48 -0500
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 940552BB0F
        for <netdev@vger.kernel.org>; Sun, 27 Feb 2022 00:00:10 -0800 (PST)
Received: from uucp by ganesha.gnumonks.org with local-bsmtp (Exim 4.94.2)
        (envelope-from <laforge@gnumonks.org>)
        id 1nOETN-00432p-2x; Sun, 27 Feb 2022 09:00:05 +0100
Received: from laforge by localhost.localdomain with local (Exim 4.95)
        (envelope-from <laforge@gnumonks.org>)
        id 1nOEPH-00389W-A2;
        Sun, 27 Feb 2022 08:55:51 +0100
Date:   Sun, 27 Feb 2022 08:55:51 +0100
From:   Harald Welte <laforge@gnumonks.org>
To:     Jonas Bonn <jonas@norrbonn.se>
Cc:     Wojciech Drewek <wojciech.drewek@intel.com>,
        netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org
Subject: Re: [PATCH iproute2-next v3 1/2] ip: GTP support in ip link
Message-ID: <YhsuhzsncG9s1KtX@nataraja>
References: <20220211182902.11542-1-wojciech.drewek@intel.com>
 <20220211182902.11542-2-wojciech.drewek@intel.com>
 <a651c26e-24e7-560e-544d-24b4e0a9ae6a@norrbonn.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a651c26e-24e7-560e-544d-24b4e0a9ae6a@norrbonn.se>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Jonas,

On Sun, Feb 27, 2022 at 07:57:02AM +0100, Jonas Bonn wrote:
> On 11/02/2022 19:29, Wojciech Drewek wrote:
> > Support for creating GTP devices through ip link. Two arguments
> > can be specified by the user when adding device of the GTP type.
> >   - role (sgsn or ggsn) - indicates whether we are on the GGSN or SGSN
> 
> It would be really nice to modernize these names before exposing this API.

I am very skeptical about this.  The features were implemented with this use
case in mind, and as you know, they only match rather partially to the requirements
of later generation technology (4G/LTE/EPC) due to their lack of support for
dedicated bearers / TFTs.

> When I added the role property to the driver, it was largely to complement
> the behaviour of the OpenGGSN library, who was essentially the only user of
> this module at the time.  However, even at that time the choice of name was
> awkward because we were well into the 4G era so SGSN/GGSN was already
> somewhat legacy terminology; today, these terms are starting to raise some
> eyebrows amongst younger developers who may be well versed in 4G/5G, but for
> whom 3G is somewhat ancient history.

The fact that some later generation of technology _also_ is using parts of older
generations of technology does not mean that the older terminology is in any way
superseded.  A SGSN remains a SGSN even today, likewise a GGSN.  And those network
elements are used in production, very much so even in 2022.

> 3GPP has a well-accepted definition of "uplink" and "downlink" which is
> probably what we should be using instead.  So sgsn becomes "uplink" and ggsn
> becomes "downlink", with the distinction here being whether packets are
> routed by source or destination IP address.

Could you please provide a 3GPP spec reference for this?  I am working
every day in the 3GPP world for something like 15+ years now, and I
would be _seriously_ surprised if such terminology was adopted for the
use case you describe. I have not come across it so far in that way.

"uplink" and "downlink" to me
a) define a direction, and not a network element / function.
b) are very general terms which depend on the point of view.

This is why directions, in 3GPP, traditionally, are called
"mobile-originated" and "mobile-terminated".  This has an unambiguous
meaning as to which direction is used.

But in any case, here we want to name logical network elements or
functions within such elements, and not directions.

Those elements / functions have new names in each generation of mobile
technology, so you have SGSN or S-GW on the one hand side, and GGSN or
P-GW on the other side.  The P-GW has then optionally been decomposed
into the UPF and SMF.  And then you have a variety of other use cases
(interfaces) where the GTPv1U protocol was later introduced, such as the
use between eNB and S-GW.

So you cannot use S-GW and P-GW as names for the roles of the GTP tunnel
driver, as S-GW actually performs both "roles": You can think of it as
decapsulationg the traffic on the eNB-SGW interface and as encapsulating
the traffic on the SGW-PGW side.

I'm not fundamentally opposed to any renaming, but any such renaming
must have a unambiguous definition.

In the context of TS 29.060, there are a number of references to uplink
and downlink.  However, they - as far as I can tell -

* specify a direction (like the QoS Parameters like AMBR for uplink / downlink)

* are used within the context of TEIDs.  So there is an "uplink tunnel
  endpoint identifier" which is chosen by the GGSN, and which is used by
  the SGSN to send data.  So again it is used to signify a direction.

If we look at 3GPP TS 29.281, there are one mention of 'uplink' and
'downlink', and both are also again referring to a direction of traffic.

Regards,
	Harald

-- 
- Harald Welte <laforge@gnumonks.org>           http://laforge.gnumonks.org/
============================================================================
"Privacy in residential applications is a desirable marketing option."
                                                  (ETSI EN 300 175-7 Ch. A6)
