Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24161620A8C
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 08:42:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233698AbiKHHlv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 02:41:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233734AbiKHHla (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 02:41:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46EB818E39;
        Mon,  7 Nov 2022 23:41:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E7B31B818A4;
        Tue,  8 Nov 2022 07:41:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8504C433D6;
        Tue,  8 Nov 2022 07:41:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667893274;
        bh=ByJfhaoaY6HddmbTF0YfvhHmft9TNEzZg+mTg1/kn80=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=acLhMm23m3W06kYTWEo4bJXgzhmTkMMNI2WDDDGLFrBVovrJl65Xpkm7fRudWNMIc
         KMbKrXpn3PjXh50Z6WTQIDB5RW6EoBZxusmPU82W+Q9qXlbVOpKQ0SwBhKPZOWRrMt
         vdBgzMuMTL9Vd5Yl0suvg/YVcPa3iMAi5Msu5wpsbumipo4PwbWkBZEiG7qgFY/Kkq
         uBCRR8Drz54qK5EPBkLh5ZZZiiTxi0cPhYvAqSSLkUUfbaqhn3//YuDI5U5/UHZKo9
         Si8jOM0K4h7mr17FFO7X5UHLjS9LYYplJreE863HTtkMUoA2s2ZGrch0Q40gmTjmMZ
         aY9wvbbivWTCA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v5] wifi: rsi: Fix handling of 802.3 EAPOL frames sent via
 control port
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20221104163339.227432-1-marex@denx.de>
References: <20221104163339.227432-1-marex@denx.de>
To:     Marek Vasut <marex@denx.de>
Cc:     linux-wireless@vger.kernel.org, Marek Vasut <marex@denx.de>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Angus Ainslie <angus@akkea.ca>,
        Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Martin Fuzzey <martin.fuzzey@flowbird.group>,
        Martin Kepplinger <martink@posteo.de>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>,
        Siva Rebbagondla <siva8118@gmail.com>, netdev@vger.kernel.org
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <166789327017.4985.4306929119411941567.kvalo@kernel.org>
Date:   Tue,  8 Nov 2022 07:41:11 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Marek Vasut <marex@denx.de> wrote:

> When using wpa_supplicant v2.10, this driver is no longer able to
> associate with any AP and fails in the EAPOL 4-way handshake while
> sending the 2/4 message to the AP. The problem is not present in
> wpa_supplicant v2.9 or older. The problem stems from HostAP commit
> 144314eaa ("wpa_supplicant: Send EAPOL frames over nl80211 where available")
> which changes the way EAPOL frames are sent, from them being send
> at L2 frames to them being sent via nl80211 control port.
> 
> An EAPOL frame sent as L2 frame is passed to the WiFi driver with
> skb->protocol ETH_P_PAE, while EAPOL frame sent via nl80211 control
> port has skb->protocol set to ETH_P_802_3 . The later happens in
> ieee80211_tx_control_port(), where the EAPOL frame is encapsulated
> into 802.3 frame.
> 
> The rsi_91x driver handles ETH_P_PAE EAPOL frames as high-priority
> frames and sends them via highest-priority transmit queue, while
> the ETH_P_802_3 frames are sent as regular frames. The EAPOL 4-way
> handshake frames must be sent as highest-priority, otherwise the
> 4-way handshake times out.
> 
> Therefore, to fix this problem, inspect the skb control flags and
> if flag IEEE80211_TX_CTRL_PORT_CTRL_PROTO is set, assume this is
> an EAPOL frame and transmit the frame via high-priority queue just
> like other ETH_P_PAE frames.
> 
> Fixes: 0eb42586cf87 ("rsi: data packet descriptor enhancements")
> Signed-off-by: Marek Vasut <marex@denx.de>

Patch applied to wireless-next.git, thanks.

b8f6efccbb9d wifi: rsi: Fix handling of 802.3 EAPOL frames sent via control port

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20221104163339.227432-1-marex@denx.de/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

