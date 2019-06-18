Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E82E4AC76
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 23:02:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730700AbfFRVCi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 17:02:38 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:48164 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730102AbfFRVCi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 17:02:38 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hdLFE-0007LA-Ng; Tue, 18 Jun 2019 23:02:20 +0200
Message-ID: <6e7f0fb2f85d5062a9e23d37c47d311e10aa4624.camel@sipsolutions.net>
Subject: Re: [PATCH v2 00/17] net: introduce Qualcomm IPA driver
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Alex Elder <elder@linaro.org>, abhishek.esse@gmail.com,
        Ben Chan <benchan@google.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        cpratapa@codeaurora.org, David Miller <davem@davemloft.net>,
        Dan Williams <dcbw@redhat.com>,
        DTML <devicetree@vger.kernel.org>,
        Eric Caruso <ejcaruso@google.com>, evgreen@chromium.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-arm-msm@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-soc@vger.kernel.org, Networking <netdev@vger.kernel.org>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        syadagir@codeaurora.org
Date:   Tue, 18 Jun 2019 23:02:18 +0200
In-Reply-To: <CAK8P3a2onXpxiE4y9PzRwuPM2dh=h_BKz7Eb0=LLPgBbZoK1bQ@mail.gmail.com> (sfid-20190618_225543_624686_3B7D51E7)
References: <380a6185-7ad1-6be0-060b-e6e5d4126917@linaro.org>
         <a94676381a5ca662c848f7a725562f721c43ce76.camel@sipsolutions.net>
         <CAK8P3a0kV-i7BJJ2X6C=5n65rSGfo8fUiC4J_G-+M8EctYKbkg@mail.gmail.com>
         <066e9b39f937586f0f922abf801351553ec2ba1d.camel@sipsolutions.net>
         <b3686626-e2d8-bc9c-6dd0-9ebb137715af@linaro.org>
         <b23a83c18055470c5308fcd1eed018056371fc1d.camel@sipsolutions.net>
         <CAK8P3a1FeUQR3pgoQxHoRK05JGORyR+TFATVQiijLWtFKTv6OQ@mail.gmail.com>
         <613cdfde488eb23d7207c7ba6258662702d04840.camel@sipsolutions.net>
         <CAK8P3a2onXpxiE4y9PzRwuPM2dh=h_BKz7Eb0=LLPgBbZoK1bQ@mail.gmail.com>
         (sfid-20190618_225543_624686_3B7D51E7)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2019-06-18 at 22:55 +0200, Arnd Bergmann wrote:
> On Tue, Jun 18, 2019 at 10:36 PM Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > 
> > On Tue, 2019-06-18 at 21:59 +0200, Arnd Bergmann wrote:
> > > 
> > > From my understanding, the ioctl interface would create the lower
> > > netdev after talking to the firmware, and then user space would use
> > > the rmnet interface to create a matching upper-level device for that.
> > > This is an artifact of the strong separation of ipa and rmnet in the
> > > code.
> > 
> > Huh. But if rmnet has muxing, and IPA supports that, why would you ever
> > need multiple lower netdevs?
> 
> From my reading of the code, there is always exactly a 1:1 relationship
> between an rmnet netdev an an ipa netdev. rmnet does the encapsulation/
> decapsulation of the qmap data and forwards it to the ipa netdev,
> which then just passes data through between a hardware queue and
> its netdevice.

I'll take your word for it. Seems very odd, given that the whole point
of the QMAP header seems to be ... muxing?

> [side note: on top of that, rmnet also does "aggregation", which may
>  be a confusing term that only means transferring multiple frames
>  at once]

Right, but it's not all that much interesting in the context of this
discussion.

> Sure, I definitely understand what you mean, and I agree that would
> be the right way to do it. All I said is that this is not how it was done
> in rmnet (this was again my main concern about the rmnet design
> after I learned it was required for ipa) ;-)

:-)

Well, I guess though if the firmware wants us to listen to those on/off
messages we'll have to do that one way or the other.

Oh. Maybe it's just *because* rmnet is layered on top, and thus you
fundamentally cannot do flow control the way I described - not because
you have multiple session on the same hardware ring, but because you
abstracted the hardware ring away too much ...


johannes

