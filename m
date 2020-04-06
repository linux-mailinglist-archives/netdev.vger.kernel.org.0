Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0930919F66E
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 15:08:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728260AbgDFNIG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 09:08:06 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:58226 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728154AbgDFNIF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Apr 2020 09:08:05 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1jLRTq-009oJ0-Nc; Mon, 06 Apr 2020 15:07:58 +0200
Message-ID: <ee168acb768d87776db2be4e978616f9187908d0.camel@sipsolutions.net>
Subject: Re: [PATCH] mac80211: fix race in ieee80211_register_hw()
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Sumit Garg <sumit.garg@linaro.org>, linux-wireless@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, matthias.schoepfer@ithinx.io,
        Philipp.Berg@liebherr.com, Michael.Weitner@liebherr.com,
        daniel.thompson@linaro.org, loic.poulain@linaro.org,
        stable@vger.kernel.org
Date:   Mon, 06 Apr 2020 15:07:57 +0200
In-Reply-To: <87imiczrwm.fsf@kamboji.qca.qualcomm.com>
References: <1586175677-3061-1-git-send-email-sumit.garg@linaro.org>
         <87ftdgokao.fsf@tynnyri.adurom.net>
         <1e352e2130e19aec5aa5fc42db397ad50bb4ad05.camel@sipsolutions.net>
         <87r1x0zsgk.fsf@kamboji.qca.qualcomm.com>
         <a7e3e8cceff1301f5de5fb2c9aac62b372922b3e.camel@sipsolutions.net>
         <87imiczrwm.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2020-04-06 at 16:04 +0300, Kalle Valo wrote:
> Johannes Berg <johannes@sipsolutions.net> writes:
> 
> > On Mon, 2020-04-06 at 15:52 +0300, Kalle Valo wrote:
> > > Johannes Berg <johannes@sipsolutions.net> writes:
> > > 
> > > > On Mon, 2020-04-06 at 15:44 +0300, Kalle Valo wrote:
> > > > > >     user-space  ieee80211_register_hw()  RX IRQ
> > > > > >     +++++++++++++++++++++++++++++++++++++++++++++
> > > > > >        |                    |             |
> > > > > >        |<---wlan0---wiphy_register()      |
> > > > > >        |----start wlan0---->|             |
> > > > > >        |                    |<---IRQ---(RX packet)
> > > > > >        |              Kernel crash        |
> > > > > >        |              due to unallocated  |
> > > > > >        |              workqueue.          |
> > > > 
> > > > [snip]
> > > > 
> > > > > I have understood that no frames should be received until mac80211 calls
> > > > > struct ieee80211_ops::start:
> > > > > 
> > > > >  * @start: Called before the first netdevice attached to the hardware
> > > > >  *         is enabled. This should turn on the hardware and must turn on
> > > > >  *         frame reception (for possibly enabled monitor interfaces.)
> > > > 
> > > > True, but I think he's saying that you can actually add and configure an
> > > > interface as soon as the wiphy is registered?
> > > 
> > > With '<---IRQ---(RX packet)' I assumed wcn36xx is delivering a frame to
> > > mac80211 using ieee80211_rx(), but of course I'm just guessing here.
> > 
> > Yeah, but that could be legitimate?
> 
> Ah, I misunderstood then. The way I have understood is that no rx frames
> should be delivered (= calling ieee80211_rx()_ before start() is called,
> but if that's not the case please ignore me :)

No no, that _is_ the case. But I think the "start wlan0" could end up
calling it?

johannes

