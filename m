Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F5384034CF
	for <lists+netdev@lfdr.de>; Wed,  8 Sep 2021 09:11:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347962AbhIHHK3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Sep 2021 03:10:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244941AbhIHHK2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Sep 2021 03:10:28 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93E0BC061575;
        Wed,  8 Sep 2021 00:09:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=wWBrUbCsB4xvV0bZD7qpKnJoKJm0HMR1PnjxZ0LeMKg=;
        t=1631084960; x=1632294560; b=XtCNST81j44UixELd7x42UUYWChVqZKS63Rh07Htbe5J4MW
        1pFsFkEFYqMgLPauQNidnwzWbXgzUJSjfCRJS2RRkiNUDkUYilr5At6ctO8Zk0yeWIkWkbKEEvZBa
        dp0Rda2Tk394wVkKM4wbSqbAT18zN9pNla/gzLBq5KSc+UHiuyfXeMgeeAWyOxGZrJSsIIN/OXHMr
        ahA7b9ZILu1DTk71MKMxoLWtcgC/sCSedpa+GzTDfJZ70djkq0zaCN+p77SdpuwLtdyFHGu7JDmRY
        vjBZdeK82BsQo2cWVz1xJ7GBeXw/6v91qh6+iUNc0+SCMWuTcVy35vYw+oa3Q+WA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95-RC2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1mNrhi-004EJx-8I;
        Wed, 08 Sep 2021 09:09:06 +0200
Message-ID: <4d7ecfd46d327d43466e2821112de867f483bfad.camel@sipsolutions.net>
Subject: Re: ipv4/tcp.c:4234:1: error: the frame size of 1152 bytes is
 larger than 1024 bytes [-Werror=frame-larger-than=]
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Brendan Higgins <brendanhiggins@google.com>,
        Ariel Elior <aelior@marvell.com>,
        GR-everest-linux-l2@marvell.com, Wei Liu <wei.liu@kernel.org>
Cc:     Linux ARM <linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>, lkft-triage@lists.linaro.org,
        Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Date:   Wed, 08 Sep 2021 09:09:04 +0200
In-Reply-To: <CAHk-=whF9F89vsfH8E9TGc0tZA-yhzi2Di8wOtquNB5vRkFX5w@mail.gmail.com>
References: <CA+G9fYtFvJdtBknaDKR54HHMf4XsXKD4UD3qXkQ1KhgY19n3tw@mail.gmail.com>
         <CAHk-=wisUqoX5Njrnnpp0pDx+bxSAJdPxfgEUv82tZkvUqoN1w@mail.gmail.com>
         <CAHk-=whF9F89vsfH8E9TGc0tZA-yhzi2Di8wOtquNB5vRkFX5w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2021-09-07 at 16:14 -0700, Linus Torvalds wrote:
> 
> The mac802.11 one seems to be due to 'struct ieee802_11_elems' being
> big, and allocated on the stack. I think it's probably made worse
> there with inlining, ie
> 
>  - ieee80211_sta_rx_queued_mgmt() has one copy
> 
>  - ieee80211_rx_mgmt_beacon() is possibly inlined, and has its own copy
> 
> but even if it isn't due to that kind of duplication due to inlining,
> that code is dangerous. Exactly because it has two nested stack frames
> with that big structure, and they are active at the same time in the
> callchain whether inlined or not.
> 
> And it's *pointlessly* dangerous, because the 'struct ieee802_11_elems
> elems' in ieee80211_sta_rx_queued_mgmt() is only used for the
> IEEE80211_STYPE_ACTION case, so it is entirely disjoint from the
> IEEE80211_STYPE_BEACON case, and those stack allocations simply should
> not nest like that in the first place.
> 
> Making the IEEE80211_STYPE_ACTION case be its own function - like the
> other cases - and moving the struct there should fix it. Possibly a
> "noinline" or two necessary to make sure that the compiler doesn't
> then undo the "these two cases are disjoint" thing.

Yeah, I'm aware, and I agree. We've been looking at it every now and
then. This got made worse by us actually adding a fair amount of
pointers to the struct recently (in this merge window).

Ultimately, every new spec addition ends up needing to add something
there, so I think ultimately we'll probably want to either dynamically
allocate it somewhere (perhaps in a data structure used here already),
or possibly not have this at all and just find a way to return only the
bits that are interesting. Even parsing a ~1k frame (typical, max ~2k) a
handful of times is probably not even worse than having this large a
structure that gets filled data that's probably useless in many cases (I
think the different cases all just need a subset). But not sure, I'll
take a look.

johannes

