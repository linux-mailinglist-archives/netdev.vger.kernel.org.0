Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA4A119F60A
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 14:48:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728074AbgDFMr7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 08:47:59 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:57874 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728009AbgDFMr6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Apr 2020 08:47:58 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1jLRAH-009lCO-7m; Mon, 06 Apr 2020 14:47:45 +0200
Message-ID: <1e352e2130e19aec5aa5fc42db397ad50bb4ad05.camel@sipsolutions.net>
Subject: Re: [PATCH] mac80211: fix race in ieee80211_register_hw()
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Kalle Valo <kvalo@codeaurora.org>,
        Sumit Garg <sumit.garg@linaro.org>
Cc:     linux-wireless@vger.kernel.org, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, matthias.schoepfer@ithinx.io,
        Philipp.Berg@liebherr.com, Michael.Weitner@liebherr.com,
        daniel.thompson@linaro.org, loic.poulain@linaro.org,
        stable@vger.kernel.org
Date:   Mon, 06 Apr 2020 14:47:43 +0200
In-Reply-To: <87ftdgokao.fsf@tynnyri.adurom.net>
References: <1586175677-3061-1-git-send-email-sumit.garg@linaro.org>
         <87ftdgokao.fsf@tynnyri.adurom.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2020-04-06 at 15:44 +0300, Kalle Valo wrote:
> 
> >     user-space  ieee80211_register_hw()  RX IRQ
> >     +++++++++++++++++++++++++++++++++++++++++++++
> >        |                    |             |
> >        |<---wlan0---wiphy_register()      |
> >        |----start wlan0---->|             |
> >        |                    |<---IRQ---(RX packet)
> >        |              Kernel crash        |
> >        |              due to unallocated  |
> >        |              workqueue.          |

[snip]

> I have understood that no frames should be received until mac80211 calls
> struct ieee80211_ops::start:
> 
>  * @start: Called before the first netdevice attached to the hardware
>  *         is enabled. This should turn on the hardware and must turn on
>  *         frame reception (for possibly enabled monitor interfaces.)

True, but I think he's saying that you can actually add and configure an
interface as soon as the wiphy is registered?

The "wlan0" is kinda wrong there, should be "phy0" I guess, and then
interface added from iw?

johannes

