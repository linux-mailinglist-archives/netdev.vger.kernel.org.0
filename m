Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 339226CB84D
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 09:38:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232183AbjC1HiR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 03:38:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229718AbjC1HiH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 03:38:07 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70C014C02;
        Tue, 28 Mar 2023 00:37:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=cDmmfN1kjoHt+ZFACgO3fNMHms11/UzrOt0Hx+3ewYY=;
        t=1679989068; x=1681198668; b=MXqW4BBo/+oXzuC+XHUbLbq8JOcPsuomGLIHriQLAwVGl49
        u3iYiNnKjHWUz4mS4DetBnfM702JxsXweDh9rZcvKIzkuEK/eIpVCmLR+62raB0t1p/OGJjlQFcnz
        EEVhYIA7ijwBLS/WwKEo+MDC5r+LNG9PDDvRWDnX/wOri5UhvyI5sUVwqXEbQXAPmYrch9UnvUs2i
        8z1LXwvZXYicRdMd0aYeWCOqgIXkCT4SI+oCgUhMaftj1HcdNvea8GLUdVafUPSbCXhSeJEV/+gnl
        peqxtqriIfl/gF3dhGYbcIiddzKa1mrXiaNgk0E7fpi8UEIu5cy6eZQfq47IWqMg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1ph3tp-00Ga3o-0Q;
        Tue, 28 Mar 2023 09:37:45 +0200
Message-ID: <abcf4b9aed8adad05841234dad103ced15f9bfb2.camel@sipsolutions.net>
Subject: Re: traceability of wifi packet drops
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Date:   Tue, 28 Mar 2023 09:37:43 +0200
In-Reply-To: <20230327180950.79e064da@kernel.org>
References: <00659771ed54353f92027702c5bbb84702da62ce.camel@sipsolutions.net>
         <20230327180950.79e064da@kernel.org>
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

On Mon, 2023-03-27 at 18:09 -0700, Jakub Kicinski wrote:
> > Anyone have any great ideas?
>=20
> We need something that'd scale to more subsystems, so I don't think
> having all the definitions in enum skb_drop_reason directly is an
> option.

Fair enough.

> My knee jerk idea would be to either use the top 8 bits of the
> skb reason enum to denote the space. And then we'd say 0 is core
> 1 is wifi (enum ieee80211_rx_result) etc. Within the WiFi space=20
> you can use whatever encoding you like.

Right. That's not _that_ far from what I proposed above, except you pull
the core out=20

> On a quick look nothing is indexed by the reason directly, so no
> problems with using the high bits.

I think you missed he drop_reasons[] array in skbuff.c, but I guess we
could just not add these to the DEFINE_DROP_REASON() macro (and couldn't
really add them anyway).

The only user seems to be drop_monitor, which anyway checks the array
bounds (in the trace hit function.)

Or we change the design of this to actually have each subsystem provide
an array/a callback for their namespace, if the strings are important?
Some registration/unregistration might be needed for modules, but that
could be done.

> Option #2 is to add one main drop reason called SKB_DROP_REASON_MAC80211
> and have a separate tracepoint which exposes the detailed wifi
> reason and any necessary context. mac80211 would then have its own
> wrapper around kfree_skb_reason() which triggers the tracepoint.

Yeah, I considered doing that with just the line number, but who knows
what people might want to use this for in the end, so that's not a great
idea either I guess :-)

I would prefer the version with the drop reasons, since then also you
only have to worry about one tracepoint.

johannes
