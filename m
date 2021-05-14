Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47904380528
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 10:26:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231590AbhENI1w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 04:27:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230459AbhENI1v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 04:27:51 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63BF5C061574;
        Fri, 14 May 2021 01:26:40 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1lhT9O-008yB6-De; Fri, 14 May 2021 10:26:26 +0200
Message-ID: <57d41364f14ea660915b7afeebaa5912c4300541.camel@sipsolutions.net>
Subject: Re: [BUG] Deadlock in _cfg80211_unregister_wdev()
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Maximilian Luz <luzmaximilian@gmail.com>,
        linux-wireless@vger.kernel.org
Cc:     Marek Szyprowski <m.szyprowski@samsung.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>
Date:   Fri, 14 May 2021 10:26:25 +0200
In-Reply-To: <98392296-40ee-6300-369c-32e16cff3725@gmail.com> (sfid-20210514_010737_196027_BACAA222)
References: <98392296-40ee-6300-369c-32e16cff3725@gmail.com>
         (sfid-20210514_010737_196027_BACAA222)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2021-05-14 at 01:07 +0200, Maximilian Luz wrote:
> Following commit a05829a7222e ("cfg80211: avoid holding the RTNL when
> calling the driver"), the mwifiex_pcie module fails to unload. This also
> prevents the device from rebooting / shutting down.
> 
> Attempting to unload the module
> 

I'm *guessing* that you're attempting to unload the module while the
interface is still up, i.e. you didn't "ip link set wlan0 down" first?

If so, that is likely fixed by this commit as well:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=ea6b2098dd02789f68770fd3d5a373732207be2f

However, your log says:

> [  245.504764]       Tainted: G         C OE     5.11.0-1-surface-dev #2

so I have no idea what kernel you're using, because 5.11 did *not*
contain commit a05829a7222e ("cfg80211: avoid holding the RTNL when
calling the driver"). If you backported the bug you get to be
responsible for backporting the fixes too?


If that's all not solving the issue then please try to resolve with gdb
what line of code "cfg80211_netdev_notifier_call+0x12a" is, and please
also clarify exactly what (upstream!) kernel you're using.

johannes


