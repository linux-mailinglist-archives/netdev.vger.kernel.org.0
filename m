Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 898C358F169
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 19:18:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233479AbiHJRSC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 13:18:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233654AbiHJRRZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 13:17:25 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 540417AC2F
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 10:17:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=wX+mBOyJ8rIYzJj9H6rtGSkSb65G+lUxbv6gTe/fVnA=;
        t=1660151843; x=1661361443; b=PMeIeNzbxQN+YrtZpCSG364fLwLBseOci8UtaQN+KM0ow4K
        9W5g4Baji20Rij9D1vyFqhlJTbBZi9SAidE73fZ+28hv+vneQYULIh+9gvIvcYpI719om+PCP76E1
        BOaQRtuLGC3ziowPlv0r+/yZkZwl3lzKQAKz3Ggc3w6lqeP2oObPQpxgaAPsVzCxpLIOeSCgzvoBg
        b5TlYewsHOfgLB1t7J67IiZ9dvUaYDnLmTpfHWeYpqAXpkUM0g9Vkp/rlyKAlnYvq0a2ePD2HCaqv
        j2+DvC5Vf+8RJ7pZMXntmuJhqTeWm+Tj0MVMMPt1MKxmgNTxLFIpufewISbmRYlA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1oLpKa-004Guv-2W;
        Wed, 10 Aug 2022 19:17:20 +0200
Message-ID: <9ec77cf1ffaa29aedd57c29ac77b525d0e700acf.camel@sipsolutions.net>
Subject: Re: [RFC 1/1] net: move IFF_LIVE_ADDR_CHANGE to public flag
From:   Johannes Berg <johannes@sipsolutions.net>
To:     James Prestwood <prestwoj@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org
Date:   Wed, 10 Aug 2022 19:17:19 +0200
In-Reply-To: <d585f719af13d7a7194e7cb734c5a7446954bf01.camel@gmail.com>
References: <20220804174307.448527-1-prestwoj@gmail.com>
         <20220804174307.448527-2-prestwoj@gmail.com>
         <20220804114342.71d2cff0@kernel.org>
         <b6b11b492622b75e50712385947e1ba6103b8e44.camel@gmail.com>
         <f03b4330c7e9d131d9ad198900a3370de4508304.camel@gmail.com>
         <0fc27b144ca3adb4ff6b3057f2654040392ef2d8.camel@sipsolutions.net>
         <d585f719af13d7a7194e7cb734c5a7446954bf01.camel@gmail.com>
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

On Wed, 2022-08-10 at 09:26 -0700, James Prestwood wrote:
>=20
> Ok, so this is how I originally did it in those old patches:
>=20
> https://lore.kernel.org/linux-wireless/20190913195908.7871-2-prestwoj@gma=
il.com/
>=20
> i.e. remove_interface, change the mac, add_interface.=20

Hah, I didn't even remember that ... sorry.

> But before I revive those I want to make sure a flag can be advertised
> to userspace e.g. NL80211_EXT_FEATURE_LIVE_ADDRESS_CHANGE. (or
> POWERED). Since this was the reason the patches got dropped in the
> first place.
>=20

Well it seems that my objection then was basically that you have a
feature flag in nl80211, but it affects an RT netlink operation ...
which is a bit strange.

Thinking about that now, maybe it's not _that_ bad? Especially given
that "live" can mean different things (as discussed here), and for
wireless that doesn't necessarily mean IFF_UP, but rather something like
"IFF_UP + not active".

Jakub, what do you think?


(I'll also note you also have error handling problems in your patch, so
if/when you revive, please take a look at handling errors from add and
remove interface. Also indentation, and a comment on station/p2p-client
might be good, and the scanning check is wrong, can check scan_sdata
regardless of the iftype.)

johannes
