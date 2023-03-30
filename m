Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B79386CFDDD
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 10:14:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbjC3IOX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 04:14:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjC3IOW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 04:14:22 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59ACF1727;
        Thu, 30 Mar 2023 01:14:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=OjyVW32qUB1+V6Fh1lA7I+JT2rpPP6fA1g6ZRAvHt7M=;
        t=1680164061; x=1681373661; b=N2InJzZusqYcx/X7B6LrQmLydroC4oczlHlPZHLahA4Ku6n
        TZWQCK60SLOx0wCQu6/l4mjfG27YH1qKL2XPuUKKvechh72R1zA3gwYQi3ZH9PMw2QR0tZQvVTujq
        Jlaf7rAzRWomot/8D2bR8LaP4z72gOVksxEld1r2ORyuLvzt5mh1t2xqc8X5YW61N26CCO7lX0w0M
        PHh60oyk4vlBepa8g3GyxnOfEhQVMMqI75TZCwbBeoFCyWwy9D7fZOt5OdrTIcL/u9zmpXnc4XFSu
        j5NPomAmwEqQh7M1+pDdL5YNr+KpwrLzEtQZ5yy3bGBaY8/FIErHEmbNdoigtq5Q==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1phnQJ-000wY6-2T;
        Thu, 30 Mar 2023 10:14:19 +0200
Message-ID: <3529dbe11a6067f0e959beab77762c74365ae2e7.camel@sipsolutions.net>
Subject: Re: [RFC PATCH 2/2] mac80211: use the new drop reasons
 infrastructure
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Date:   Thu, 30 Mar 2023 10:14:18 +0200
In-Reply-To: <20230329210557.3a5890fd@kernel.org>
References: <20230329214620.131636-1-johannes@sipsolutions.net>
         <20230329234613.5bcb4d8dcade.Iea29d70af97ce2ed590a00dbebee2ab4d013dfd5@changeid>
         <20230329210557.3a5890fd@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2023-03-29 at 21:05 -0700, Jakub Kicinski wrote:
> On Wed, 29 Mar 2023 23:46:20 +0200 Johannes Berg wrote:
> > +	/** @SKB_DROP_REASON_SUBSYS_MAC80211_UNUSABLE: mac80211 drop reasons
> > +	 * for unusable frames, see net/mac80211/drop.h
> > +	 */
> > +	SKB_DROP_REASON_SUBSYS_MAC80211_UNUSABLE,
> > +
> > +	/** @SKB_DROP_REASON_SUBSYS_MAC80211_MONITOR: mac80211 drop reasons
> > +	 * for frames still going to monitor, see net/mac80211/drop.h
> > +	 */
> > +	SKB_DROP_REASON_SUBSYS_MAC80211_MONITOR,
>=20
> heh, didn't expect you'd have two different subsystems TBH
>=20

Hah, me neither!

But then when I came to implement it, I wanted to use some bit in the
reason for he drop/unusable distinction. In fact I did that at first,
until I got to the string list, and realised that no matter how I sliced
it, I'd always have a very sparse array there. If I use the lowest bit
it'd be as compact as possible, but I'd expect the two spaces to not be
equivalently filled, so I'd still get a whole bunch NULLs in the array.

So then I switched to using two subsystems, since that way we have two
distinct string lists.

johannes
