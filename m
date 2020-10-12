Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E0DB28B3A9
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 13:21:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388073AbgJLLVY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 07:21:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387859AbgJLLVY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 07:21:24 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 499A6C0613CE;
        Mon, 12 Oct 2020 04:21:24 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kRvtA-0046Wq-DO; Mon, 12 Oct 2020 13:21:12 +0200
Message-ID: <af396e563aa41c4f0cce812afa11667ecab09ab0.camel@sipsolutions.net>
Subject: Re: [PATCH v2 0/3] [PATCH v2 0/3] [PATCH v2 0/3] net, mac80211,
 kernel: enable KCOV remote coverage collection for 802.11 frame handling
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Aleksandr Nogikh <a.nogikh@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, akpm@linux-foundation.org,
        Eric Dumazet <edumazet@google.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Marco Elver <elver@google.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        nogikh@google.com
Date:   Mon, 12 Oct 2020 13:21:11 +0200
In-Reply-To: <CADpXja8NZDZ_3AMHUMnj90nbQbW2pA_aP=_Y2w2tSfy8EcRZkw@mail.gmail.com> (sfid-20201012_131900_623711_9BAE6766)
References: <20201009170202.103512-1-a.nogikh@gmail.com>
         <5d71472dcef4d88786ea6e8f30f0816f8b920bb7.camel@sipsolutions.net>
         <CADpXja8NZDZ_3AMHUMnj90nbQbW2pA_aP=_Y2w2tSfy8EcRZkw@mail.gmail.com>
         (sfid-20201012_131900_623711_9BAE6766)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2020-10-12 at 14:18 +0300, Aleksandr Nogikh wrote:
> 
> Currently we're injecting frames via mac80211_hwsim (by pretenting to
> be wmediumd -
> https://github.com/google/syzkaller/blob/4a77ae0bdc5cd75ebe88ce7c896aae6bbf457a29/executor/common_linux.h#L4922).

Ah, ok, of course that works too :-)

> Injecting via RAW sockets would definitely be a much cleaner way, but
> to do that we need to keep a separate monitor interface. That's pretty
> hard as the fuzzer is constantly trying to break things, and direct
> injection via mac80211_hwsim seems to be a much more robust way - it
> will work as long as the virtual device is alive. hwsim0 is
> unfortunately not available as fuzzer processes are run in separate
> network namespaces, while this one is created during mac80211_hwsim
> initialization.

Oh, OK. I guess we _could_ move that also to the new namespace or
something, but if the wmediumd approach works then I think it's not
worth it.

> The current approach seems to work fine for management frames - I was
> able to create seed programs that inject valid management frames and
> these frames have the expected effect on the subsystem (e.g. injecting
> AP responses during scan/authentication/authorization forces a station
> to believe that it has successfully connected to an AP).

Great!

johannes

