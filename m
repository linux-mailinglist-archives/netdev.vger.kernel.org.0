Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E5B228A97B
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 20:50:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728673AbgJKSuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 14:50:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727550AbgJKSuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Oct 2020 14:50:19 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECCCFC0613CE;
        Sun, 11 Oct 2020 11:50:18 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kRgPy-003enP-Cf; Sun, 11 Oct 2020 20:50:02 +0200
Message-ID: <5d71472dcef4d88786ea6e8f30f0816f8b920bb7.camel@sipsolutions.net>
Subject: Re: [PATCH v2 0/3] [PATCH v2 0/3] [PATCH v2 0/3] net, mac80211,
 kernel: enable KCOV remote coverage collection for 802.11 frame handling
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Aleksandr Nogikh <a.nogikh@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, akpm@linux-foundation.org
Cc:     edumazet@google.com, andreyknvl@google.com, dvyukov@google.com,
        elver@google.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        nogikh@google.com
Date:   Sun, 11 Oct 2020 20:50:00 +0200
In-Reply-To: <20201009170202.103512-1-a.nogikh@gmail.com> (sfid-20201009_190209_250951_9651A9CD)
References: <20201009170202.103512-1-a.nogikh@gmail.com>
         (sfid-20201009_190209_250951_9651A9CD)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2020-10-09 at 17:01 +0000, Aleksandr Nogikh wrote:
> From: Aleksandr Nogikh <nogikh@google.com>
> 
> This patch series enables remote KCOV coverage collection during
> 802.11 frames processing. These changes make it possible to perform
> coverage-guided fuzzing in search of remotely triggerable bugs.

Btw, it occurred to me that I don't know at all - is this related to
syzkaller? Or is there some other fuzzing you're working on? Can we get
the bug reports from it if it's different? :)


Also, unrelated to that (but I see Dmitry CC'ed), I started wondering if
it'd be helpful to have an easier raw 802.11 inject path on top of say
hwsim0; I noticed some syzbot reports where it created raw sockets, but
that only gets you into the *data* plane of the wifi stack, not into the
*management* plane. Theoretically you could add a monitor interface, but
right now the wifi setup (according to the current docs on github) is
using two IBSS interfaces.

Perhaps an inject path on the mac80211-hwsim "hwsim0" interface would be
something to consider? Or simply adding a third radio that's in
"monitor" mode, so that a raw socket bound to *that* interface can
inject with a radiotap header followed by an 802.11 frame, getting to
arbitrary frame handling code, not just data frames.

Any thoughts?

johannes

