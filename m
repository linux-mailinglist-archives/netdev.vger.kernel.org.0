Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05E4361F372
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 13:37:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232252AbiKGMhV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 07:37:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231476AbiKGMhT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 07:37:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A887CEE36;
        Mon,  7 Nov 2022 04:37:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 469B061029;
        Mon,  7 Nov 2022 12:37:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68B75C433D7;
        Mon,  7 Nov 2022 12:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667824637;
        bh=xA25/VVL0qYxxCrpXdz6ciSZ4H10xYZeAAxjaaCmrEI=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=FelJuhxKtxMgkWwOtuD4O9C9g/JPZHUktOM114X1HRUVv98gp8F2qEXJLzqcX4A6h
         fwHrGmXP1i6tEiA0hY85NmeY5u+2/Bf5WWNdq4YHD7a/pRDkIgrnyu+9Cx8tIDwCZh
         ifCFujL5/KYf9Z+briHwSM8WT/U+Up++nM6eOeCvYjP4ALrEXx95DLeGXwkYn54lS/
         iNRz9AiH8nUEW9UD/3s44T1dgf8gJoysmxUvA1Q1HRrJlSfLFn1Vv4rOU48fE76Qgn
         xz8tbu0UhB/NSRuEPLbBcqq2QUL2bX5NWTiV8I69u9JOqU6Ui0gHS/315jwtTAVYrZ
         bP9Fvl2Sr1TmQ==
From:   Kalle Valo <kvalo@kernel.org>
To:     Marek Vasut <marex@denx.de>
Cc:     linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Angus Ainslie <angus@akkea.ca>,
        Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Martin Fuzzey <martin.fuzzey@flowbird.group>,
        Martin Kepplinger <martink@posteo.de>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>,
        Siva Rebbagondla <siva8118@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH v5] wifi: rsi: Fix handling of 802.3 EAPOL frames sent via control port
References: <20221104163339.227432-1-marex@denx.de>
Date:   Mon, 07 Nov 2022 14:37:11 +0200
In-Reply-To: <20221104163339.227432-1-marex@denx.de> (Marek Vasut's message of
        "Fri, 4 Nov 2022 17:33:39 +0100")
Message-ID: <87o7tjszyg.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Marek Vasut <marex@denx.de> writes:

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
> ---
> NOTE: I am really unsure about the method of finding out the exact
>       place of ethernet header in the encapsulated packet and then
>       extracting the ethertype from it. Is there maybe some sort of
>       helper function for that purpose ?
> ---
> V2: - Turn the duplicated code into common function
> V3: - Simplify the TX EAPOL detection (Johannes)
> V4: - Drop the double !!() from test
>     - Update commit message
> V5: - Inline the rsi_is_tx_eapol() again, undoes V2 change completely

BTW did you test this on a real device?

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
