Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11BBD6943B4
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 12:02:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbjBMLCM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 06:02:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229978AbjBMLCK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 06:02:10 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CD92DBD5;
        Mon, 13 Feb 2023 03:02:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=TzexFku4QIp/gLO3pXU4JjS5NDKao+W0F8c5U7LUrxo=;
        t=1676286127; x=1677495727; b=falFHV5tih6Vp+aWMFVa0uwFx+YVpemHdr6OItmkaBb/MJ+
        TzXHsSk9D/LZ6bthEsGf/hikkygCgyrEM/FIkP7g3Ld2Y+UxVhncQmgCGf+hxhwHRRxg+Q3kq7Lqn
        bXfn//7BInPh2/gzDel4R0sOEXE1aqCbtFDbi9W8VXkDjOYD5nzt9zVSfoZED3s0pxu3AFrS4bq4v
        dzGfVT8upR0Uz6k7mE4Bsvi4uj3Ef7O7yKVOS8Sog3Wb8zlg+PCSBhDjv9U2FJWSbeGFsdP6o6XgT
        tzM462v5XEWXtxboCRYPVttPTMJ3iBIhnW8FwecwOBT3UI9j5r05TCdlvFmJmnkQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1pRWaf-00B8Cx-0v;
        Mon, 13 Feb 2023 12:01:45 +0100
Message-ID: <5a1d1244c8d3e20408732858442f264d26cc2768.camel@sipsolutions.net>
Subject: Re: [PATCH v2] Set ssid when authenticating
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Marc Bornand <dev.mbornand@systemb.ch>,
        linux-wireless@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kalle Valo <kvalo@kernel.org>,
        Yohan Prod'homme <kernel@zoddo.fr>, stable@vger.kernel.org
Date:   Mon, 13 Feb 2023 12:01:43 +0100
In-Reply-To: <20230213105436.595245-1-dev.mbornand@systemb.ch>
References: <20230213105436.595245-1-dev.mbornand@systemb.ch>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2023-02-13 at 10:55 +0000, Marc Bornand wrote:
> changes since v1:
> - add some informations
> - test it on wireless-2023-01-18 tag
> - no real code change
>=20
> When a connexion was established without going through
> NL80211_CMD_CONNECT, the ssid was never set in the wireless_dev struct.
> Now we set it during when an NL80211_CMD_AUTHENTICATE is issued.

This is incorrect, doing an authentication doesn't require doing an
association afterwards, and doesn't necessarily imply any state change
in the kernel.

> alternatives:
> 1. Do the same but during association and not authentication.

Which should probably be done _after_ successful authentication, even in
the CONNECT command case, which currently does it in cfg80211_connect()
but I guess that should move to __cfg80211_connect_result().

> 2. use ieee80211_bss_get_elem in nl80211_send_iface, this would report
>    the right ssid to userspace, but this would not fix the root cause,
>    this alos wa the behavior prior to 7b0a0e3c3a882 when the bug was
>    introduced.

That would be OK too but the reason I changed it there (missing the fact
that it wasn't set) is that we have multiple BSSes with MLO. So it's
hard to get one to do this with.

johannes
