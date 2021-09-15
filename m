Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C87240C2F1
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 11:49:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237010AbhIOJuh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 05:50:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232046AbhIOJuc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Sep 2021 05:50:32 -0400
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A653FC061574;
        Wed, 15 Sep 2021 02:49:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:Subject:From:References:Cc:To:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=uBSC+UP9PeMZXmiRRocmqxiy4fu/aY9BBVkaqRDY24Q=; b=XkYHuvDygrf6X+nNo7iF5BkJQb
        gymhJ5QvZuH8mJYuJm5iizimdP0XJl4woKTukUH7EEQ0XkXMwkpQG+n3z+vf6N4QAhAijfeLM8KjU
        Ii6N2Adtzx6ckx89PMXWTL3zhVPgFnORVzaWa0g+KW/KbybViNK8PBhJOn753y+ZScMQ=;
Received: from p57a6f913.dip0.t-ipconnect.de ([87.166.249.19] helo=nf.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1mQRXE-0006CG-Lo; Wed, 15 Sep 2021 11:48:56 +0200
To:     =?UTF-8?Q?Linus_L=c3=bcssing?= <linus.luessing@c0d3.blue>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sujith Manoharan <c_manoha@qca.qualcomm.com>,
        ath9k-devel@qca.qualcomm.com
Cc:     linux-wireless@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "John W . Linville" <linville@tuxdriver.com>,
        Felix Fietkau <nbd@openwrt.org>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Sven Eckelmann <sven@narfation.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?Q?Linus_L=c3=bcssing?= <ll@simonwunderlich.de>
References: <20210914192515.9273-1-linus.luessing@c0d3.blue>
 <20210914192515.9273-4-linus.luessing@c0d3.blue>
From:   Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH 3/3] ath9k: Fix potential hw interrupt resume during reset
Message-ID: <255a49c7-d763-50d9-87e0-da22f4a9b053@nbd.name>
Date:   Wed, 15 Sep 2021 11:48:55 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20210914192515.9273-4-linus.luessing@c0d3.blue>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021-09-14 21:25, Linus Lüssing wrote:
> From: Linus Lüssing <ll@simonwunderlich.de>
> 
> There is a small risk of the ath9k hw interrupts being reenabled in the
> following way:
> 
> 1) ath_reset_internal()
>    ...
>    -> disable_irq()
>       ...
>       <- returns
> 
>                       2) ath9k_tasklet()
>                          ...
>                          -> ath9k_hw_resume_interrupts()
>                          ...
> 
> 1) ath_reset_internal() continued:
>    -> tasklet_disable(&sc->intr_tq); (= ath9k_tasklet() off)
> 
> By first disabling the ath9k interrupt there is a small window
> afterwards which allows ath9k hw interrupts being reenabled through
> the ath9k_tasklet() before we disable this tasklet in
> ath_reset_internal(). Leading to having the ath9k hw interrupts enabled
> during the reset, which we should avoid.
I don't see a way in which interrupts can be re-enabled through the
tasklet. disable_irq disables the entire PCI IRQ (not through ath9k hw
registers), and they will only be re-enabled by the corresponding
enable_irq call.

- Felix
