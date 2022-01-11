Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91F2248BB6C
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 00:31:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346825AbiAKXb3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 18:31:29 -0500
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.49]:40380 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1346822AbiAKXb1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 18:31:27 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.67.122])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id B3DCD1C007E;
        Tue, 11 Jan 2022 23:31:25 +0000 (UTC)
Received: from mail3.candelatech.com (mail2.candelatech.com [208.74.158.173])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id D0A6540073;
        Tue, 11 Jan 2022 23:31:24 +0000 (UTC)
Received: from [192.168.100.195] (50-251-239-81-static.hfc.comcastbusiness.net [50.251.239.81])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id 0D18A13C2B0;
        Tue, 11 Jan 2022 15:31:24 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 0D18A13C2B0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1641943884;
        bh=Cjva8Ua9mKRM9CDkoS1tPMFTEcoAovDoxh2PNKu05/w=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=fvtmz02TvQHDUK+UJHIjvfJVMYY/A6JoSmMEaQgAijPgFPpclk78n/5CEbVfxkax5
         rpIfMWcU44E2WR6+2FocEfzLV6r8ojFu2ThHSJ9VIEdVsoiOpnj3hL8m3MZCP0DPAU
         0gFhyB3JJkjT3bHbfKACmWovs8waE+4IoCFc3WU8=
Subject: Re: [Bug] mt7921e driver in 5.16 causes kernel panic
To:     Khalid Aziz <khalid@gonehiking.org>, nbd@nbd.name,
        lorenzo.bianconi83@gmail.com, ryder.lee@mediatek.com,
        shayne.chen@mediatek.com, sean.wang@mediatek.com, kvalo@kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, matthias.bgg@gmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <5cee9a36-b094-37a0-e961-d7404b3dafe2@gonehiking.org>
From:   Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
Message-ID: <7b15fa7c-9130-db8c-875e-8c0eb1dcc530@candelatech.com>
Date:   Tue, 11 Jan 2022 15:31:23 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <5cee9a36-b094-37a0-e961-d7404b3dafe2@gonehiking.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-MDID: 1641943886-ush-JagAYBMd
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/11/22 3:17 PM, Khalid Aziz wrote:
> I am seeing an intermittent bug in mt7921e driver. When the driver module is loaded
> and is being initialized, almost every other time it seems to write to some wild
> memory location. This results in driver failing to initialize with message
> "Timeout for driver own" and at the same time I start to see "Bad page state" messages
> for random processes. Here is the relevant part of dmesg:

Please see if this helps?

From: Ben Greear <greearb@candelatech.com>

If the nic fails to start, it is possible that the
reset_work has already been scheduled.  Ensure the
work item is canceled so we do not have use-after-free
crash in case cleanup is called before the work item
is executed.

This fixes crash on my x86_64 apu2 when mt7921k radio
fails to work.  Radio still fails, but OS does not
crash.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
  drivers/net/wireless/mediatek/mt76/mt7921/main.c | 1 +
  1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/main.c b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
index 6073bedaa1c08..9b33002dcba4a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
@@ -272,6 +272,7 @@ static void mt7921_stop(struct ieee80211_hw *hw)

  	cancel_delayed_work_sync(&dev->pm.ps_work);
  	cancel_work_sync(&dev->pm.wake_work);
+	cancel_work_sync(&dev->reset_work);
  	mt76_connac_free_pending_tx_skbs(&dev->pm, NULL);

  	mt7921_mutex_acquire(dev);
-- 
2.26.3


Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

