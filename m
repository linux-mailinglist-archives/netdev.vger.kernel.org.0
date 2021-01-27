Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E97A1305977
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 12:21:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236305AbhA0LUq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 06:20:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235978AbhA0Khu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 05:37:50 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ACC2C061573;
        Wed, 27 Jan 2021 02:37:10 -0800 (PST)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1l4iBx-00CMrJ-Pj; Wed, 27 Jan 2021 11:36:54 +0100
Message-ID: <64336aa2e21936095eb7e52ee32289b30b855863.camel@sipsolutions.net>
Subject: Re: [PATCH] ath9k: fix build error with LEDS_CLASS=m
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Kalle Valo <kvalo@codeaurora.org>, Arnd Bergmann <arnd@kernel.org>
Cc:     Krzysztof Kozlowski <krzk@kernel.org>,
        QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Flavio Suligoi <f.suligoi@asem.it>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date:   Wed, 27 Jan 2021 11:36:34 +0100
In-Reply-To: <87bldaacqu.fsf@codeaurora.org>
References: <20210125113654.2408057-1-arnd@kernel.org>
         <CAJKOXPfteJ3Jia4Qd9DabjxcOtax3uDgi1fSbz4_+cHsJ1prQQ@mail.gmail.com>
         <CAK8P3a0apBUbck9Z3UMKfwSJw8a-UbbXLTLUvSyOKEwTgPLjqg@mail.gmail.com>
         <CAJKOXPc6LWnqiyO9WgxUZPo-vitNcQQr2oDoyD44P2YTSJ7j=g@mail.gmail.com>
         <CAK8P3a1NEbZtXVA0Z4P3K97L9waBp7nkCWOkdYjR3+7FUF0P0Q@mail.gmail.com>
         <CAJKOXPdWouEFtCp_iG+py1JcyrEU2Fj98jBAPTKZXQXCDQE54A@mail.gmail.com>
         <CAK8P3a3ygYTEwjLbFuArdfNF1-yydVjtS2NZDAURKjOJGAxkAQ@mail.gmail.com>
         <87bldaacqu.fsf@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2021-01-27 at 12:35 +0200, Kalle Valo wrote:
> Arnd Bergmann <arnd@kernel.org> writes:
> 
> > On Mon, Jan 25, 2021 at 4:04 PM Krzysztof Kozlowski <krzk@kernel.org> wrote:
> > > On Mon, 25 Jan 2021 at 15:38, Arnd Bergmann <arnd@kernel.org> wrote:
> > > > On Mon, Jan 25, 2021 at 2:27 PM Krzysztof Kozlowski <krzk@kernel.org> wrote:
> > > 
> > > I meant that having MAC80211_LEDS selected causes the ath9k driver to
> > > toggle on/off the WiFi LED. Every second, regardless whether it's
> > > doing something or not. In my setup, I have problems with a WiFi
> > > dongle somehow crashing (WiFi disappears, nothing comes from the
> > > dongle... maybe it's Atheros FW, maybe some HW problem) and I found
> > > this LED on/off slightly increases the chances of this dongle-crash.
> > > That was the actual reason behind my commits.
> > > 
> > > Second reason is that I don't want to send USB commands every second
> > > when the device is idle. It unnecessarily consumes power on my
> > > low-power device.
> > 
> > Ok, I see.
> > 
> > > Of course another solution is to just disable the trigger via sysfs
> > > LED API. It would also work but my patch allows entire code to be
> > > compiled-out (which was conditional in ath9k already).
> > > 
> > > Therefore the patch I sent allows the ath9k LED option to be fully
> > > choosable. Someone wants every-second-LED-blink, sure, enable
> > > ATH9K_LEDS and you have it. Someone wants to reduce the kernel size,
> > > don't enable ATH9K_LEDS.
> > 
> > Originally, I think this is what CONFIG_MAC80211_LEDS was meant
> > for, but it seems that this is not actually practical, since this also
> > gets selected by half of the drivers using it, while the other half have
> > a dependency on it. Out of the ones that select it, some in turn
> > select LEDS_CLASS, while some depend on it.
> > 
> > I think this needs a larger-scale cleanup for consistency between
> > (at least) all the wireless drivers using LEDs.
> 
> I agree, this needs cleanup.
> 
> > Either your patch or mine should get applied in the meantime, and I
> > don't care much which one in this case, as we still have the remaining
> > inconsistency.
> 
> My problem with Krzysztof's patch[1] is that it adds a new Kconfig
> option for ath9k, is that really necessary? Like Arnd said, we should
> fix drivers to use CONFIG_MAC80211_LEDS instead of having driver
> specific options.
> 
> So I would prefer take this Arnd's patch instead and queue it for v5.11.
> But as it modifies mac80211 I'll need an ack from Johannes, what do you
> think?

Sure, that seems fine.

Acked-by: Johannes Berg <johannes@sipsolutions.net>

johannes

