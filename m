Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 442592F11B9
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 12:46:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729902AbhAKLp3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 06:45:29 -0500
Received: from m43-15.mailgun.net ([69.72.43.15]:48218 "EHLO
        m43-15.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729770AbhAKLp3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 06:45:29 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1610365505; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=/zAmJ+29rI7Hmfs0HvwvL7kL3/lcUmum7keDkzWEwYk=; b=WkRO2zZ9YTXA22SsXztSPhg7i5xkcsAYUiTJoVXE08RtahHNtma3geEiDpEM3DxbjhJlazSi
 BfS12+thCSXQocVC1IpqE/2s551f0+6VlE/vJE9gKaMi9/ewI7mspwoDOo4+dfspo5NDXWcV
 J3UcSG7BMnbYUfGCEsFVDwqmlu8=
X-Mailgun-Sending-Ip: 69.72.43.15
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-east-1.postgun.com with SMTP id
 5ffc3a188fb3cda82f47f5ee (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 11 Jan 2021 11:44:24
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 4DC0EC433C6; Mon, 11 Jan 2021 11:44:23 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A0CD0C433CA;
        Mon, 11 Jan 2021 11:44:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org A0CD0C433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Ryder Lee <ryder.lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <objelf@gmail.com>,
        Wan-Feng Jiang <Wan-Feng.Jiang@mediatek.com>,
        Shayne Chen <shayne.chen@mediatek.com>,
        Yiwei Chung <yiwei.chung@mediatek.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mt76: fix enum conversion warning
References: <20201230145824.3203726-1-arnd@kernel.org>
Date:   Mon, 11 Jan 2021 13:44:16 +0200
In-Reply-To: <20201230145824.3203726-1-arnd@kernel.org> (Arnd Bergmann's
        message of "Wed, 30 Dec 2020 15:57:55 +0100")
Message-ID: <878s8zk8a7.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Arnd Bergmann <arnd@kernel.org> writes:

> From: Arnd Bergmann <arnd@arndb.de>
>
> A recent patch changed some enum values, but not the type
> declaration for the assignment:
>
> drivers/net/wireless/mediatek/mt76/mt7615/mcu.c:238:9: error: implicit conversion from enumeration type 'enum mt76_mcuq_id' to different enumeration type 'enum mt76_txq_id' [-Werror,-Wenum-conversion]
>                 qid = MT_MCUQ_WM;
>                     ~ ^~~~~~~~~~
> drivers/net/wireless/mediatek/mt76/mt7615/mcu.c:240:9: error: implicit conversion from enumeration type 'enum mt76_mcuq_id' to different enumeration type 'enum mt76_txq_id' [-Werror,-Wenum-conversion]
>                 qid = MT_MCUQ_FWDL;
>                     ~ ^~~~~~~~~~~~
>
> Change the type to match again.
>
> Fixes: e637763b606b ("mt76: move mcu queues to mt76_dev q_mcu array")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Nathan submitted a similar (but not identical) patch:

https://patchwork.kernel.org/project/linux-wireless/patch/20201229211548.1348077-1-natechancellor@gmail.com/

As Nathan was first we take that one.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
