Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE7EA58DFF2
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 21:13:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346044AbiHITM4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 15:12:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348702AbiHITMT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 15:12:19 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04FBB2A410
        for <netdev@vger.kernel.org>; Tue,  9 Aug 2022 12:04:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=tSTzpfcXrI5uqlzD2cbZ4itdhS2mwAbKtRBGNmoJ91M=;
        t=1660071863; x=1661281463; b=BzfHTEIzJF3xsnBRgEHCqPi52dpf9qDaYFo946ylberXrIG
        PEJQ/UHwkaH+Sk2HDzo+FWcfcr8xdc8ajmxt7iUcwQ52GN0DbgXCMT1yLAX2lGZIMBKrbUE9AvP5B
        gtKa/1kppVIXiFDLScZpdtCIJY6Z0F5ZJw9QHHgfbaX1iNLevsQodMAfXos2GBfpD2yAxNqLEQ9Ee
        l51y/B5Qio/8qRCOR+bZZjuS4AxQcBcO5mIl/Apf9mLI2FY3Ex6UPcz2Y17MOg8XSE8xHe2cMFihY
        0cg9bp2oo9Hrhbhoi3gqXbocwtuDQ1t6RKQ+l/nHq+/H+gy7BBn8fCVCwQprtqJQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1oLUWa-003IY9-2v;
        Tue, 09 Aug 2022 21:04:21 +0200
Message-ID: <0fc27b144ca3adb4ff6b3057f2654040392ef2d8.camel@sipsolutions.net>
Subject: Re: [RFC 1/1] net: move IFF_LIVE_ADDR_CHANGE to public flag
From:   Johannes Berg <johannes@sipsolutions.net>
To:     James Prestwood <prestwoj@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org
Date:   Tue, 09 Aug 2022 21:04:20 +0200
In-Reply-To: <f03b4330c7e9d131d9ad198900a3370de4508304.camel@gmail.com>
References: <20220804174307.448527-1-prestwoj@gmail.com>
         <20220804174307.448527-2-prestwoj@gmail.com>
         <20220804114342.71d2cff0@kernel.org>
         <b6b11b492622b75e50712385947e1ba6103b8e44.camel@gmail.com>
         <f03b4330c7e9d131d9ad198900a3370de4508304.camel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-1.fc36) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2022-08-04 at 12:49 -0700, James Prestwood wrote:
> > >=20
> > > The semantics in wireless are also a little stretched because
> > > normally
> > > if the flag is not set the netdev will _refuse_ (-EBUSY) to change
> > > the
> > > address while running, not do some crazy fw reset.
> >=20
> > Sorry if I wasn't clear, but its not nl80211 doing the fw reset
> > automatically. The wireless subsystem actually completely disallows a
> > MAC change if the device is running, this flag isn't even checked.
> > This
> > means userspace has to bring the device down itself, then change the
> > MAC.
> >=20
> > I plan on also modifying mac80211 to first check this flag and allow
> > a
> > live MAC change if possible. But ultimately userspace still needs to
> > be
> > aware of the support.
> >=20

I'm not sure this is the right approach.

For the stated purpose (not powering down the NIC), with most mac80211
drivers the following would work:

 - add a new virtual interface of any supported type, and bring it up
 - bring down the other interface, change MAC address, bring it up again
 - remove the interface added in step 1

though obviously that's not a good way to do it!

But internally in mac80211, there's a distinction between

 ->stop() to turn off the NIC, and
 ->remove_interface() to remove the interface.

Changing the MAC address should always be possible when the interface
doesn't exist in the driver (remove_interface), but without stop()ing
the NIC.

However, obviously remove_interface() implies that you break the
connection first, and obviously you cannot change the MAC address
without breaking the connection (stopping AP, etc.)

Therefore, the semantics of this flag don't make sense - you cannot
change the MAC address in a "live" way while there's a connection, and
at least internally you need not stop the NIC to change it. Since
ethernet has no concept of a "connection" in the same way, things are
different there.

Not sure how to really solve this - perhaps a wireless-specific way of
changing the MAC address could be added, though that's quite ugly, or we
might be able to permit changing the MAC address while not active in any
way (connected, scanning etc.) by removing from/re-adding to the driver
at least as far as mac80211 is concerned.

johannes
