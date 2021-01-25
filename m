Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BD34304A95
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 21:51:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730630AbhAZFC5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 00:02:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728268AbhAYMpG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 07:45:06 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34670C06121F;
        Mon, 25 Jan 2021 04:34:18 -0800 (PST)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1l414R-00BPl8-Jp; Mon, 25 Jan 2021 13:34:15 +0100
Message-ID: <9cf620a5ae47bce0cf6344db502589a8763fc861.camel@sipsolutions.net>
Subject: Re: [PATCH v2] cfg80211: avoid holding the RTNL when calling the
 driver
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, Oliver Neukum <oneukum@suse.com>
Date:   Mon, 25 Jan 2021 13:34:14 +0100
In-Reply-To: <b425cbc3-63a8-3252-e828-bcb7b336b783@samsung.com>
References: <20210119102145.99917b8fc5d6.Iacd5916c0e01f71342159f6d419e56dc4c3f07a2@changeid>
         <CGME20210122121108eucas1p2d153ab9c3a95015221b470a66a0c8458@eucas1p2.samsung.com>
         <6569c83a-11b0-7f13-4b4c-c0318780895c@samsung.com>
         <4ae7a27c32cbf85b4ddb05cc2a16e52918663633.camel@sipsolutions.net>
         <b425cbc3-63a8-3252-e828-bcb7b336b783@samsung.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marek,

> I've checked today's linux-next with the updated commit 27bc93583e35 
> ("cfg80211: avoid holding the RTNL when calling the driver") and there 
> is still an issue there, but at least it doesn't cause a deadlock:
> 
> cfg80211: Loading compiled-in X.509 certificates for regulatory database
> Bluetooth: vendor=0x2df, device=0x912a, class=255, fn=2
> cfg80211: Loaded X.509 cert 'sforshee: 00b28ddf47aef9cea7'
> Bluetooth: FW download over, size 533976 bytes
> btmrvl_sdio mmc3:0001:2: sdio device tree data not available
> mwifiex_sdio mmc3:0001:1: WLAN FW already running! Skip FW dnld
> mwifiex_sdio mmc3:0001:1: WLAN FW is active
> mwifiex_sdio mmc3:0001:1: CMD_RESP: cmd 0x242 error, result=0x2
> mwifiex_sdio mmc3:0001:1: mwifiex_process_cmdresp: cmd 0x242 failed 
> during       initialization
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 5 at net/wireless/core.c:1336 
> cfg80211_register_netdevice+0xa4/0x198 [cfg80211]

Yeah, umm, brown paper bag style bug.

I meant to _move_ that line down, but somehow managed to _copy_ it down.
Need to just remove it since rdev is not even initialized at that point.

I've updated my tree to include this:

diff --git a/net/wireless/core.c b/net/wireless/core.c
index 5e8b523dc645..200cd9f5fd5f 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -1333,7 +1333,6 @@ int cfg80211_register_netdevice(struct net_device *dev)
        int ret;
 
        ASSERT_RTNL();
-       lockdep_assert_held(&rdev->wiphy.mtx);
 
        if (WARN_ON(!wdev))
                return -EINVAL;

johannes

