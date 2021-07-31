Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5CF73DC511
	for <lists+netdev@lfdr.de>; Sat, 31 Jul 2021 10:38:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232395AbhGaIiv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Jul 2021 04:38:51 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:59201 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232048AbhGaIiu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 31 Jul 2021 04:38:50 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1627720724; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=GmmWfCUra51DdcDZI83pLqJ9O3jdxFx8YXjXVt6UXbw=; b=n/b8OGVpUXIehj0Z683Bl6ahWwR/wNd2z3lr0b5XO9msVgDAjVIB76DOXBNfsUA+lmig/Xzh
 w/6ghibBj6Jdu0zQxjJEM2oWZ4XpMDMeoyYt8WC5sj59me7ktQZau+bqrV6JQdWCf0CdBxij
 beBOJkSc430qjr2aJA72p0okQ48=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-west-2.postgun.com with SMTP id
 61050bfc9771b05b24117f4e (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sat, 31 Jul 2021 08:38:20
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id BCD6CC433D3; Sat, 31 Jul 2021 08:38:20 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from tykki (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 98AC2C433D3;
        Sat, 31 Jul 2021 08:38:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 98AC2C433D3
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
        Shayne Chen <shayne.chen@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Soul Huang <Soul.Huang@mediatek.com>,
        Deren Wu <deren.wu@mediatek.com>,
        Xing Song <xing.song@mediatek.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mt76: fix enum type mismatch
References: <20210721150745.1914829-1-arnd@kernel.org>
Date:   Sat, 31 Jul 2021 11:38:11 +0300
In-Reply-To: <20210721150745.1914829-1-arnd@kernel.org> (Arnd Bergmann's
        message of "Wed, 21 Jul 2021 17:06:56 +0200")
Message-ID: <87tukaev4c.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Arnd Bergmann <arnd@kernel.org> writes:

> From: Arnd Bergmann <arnd@arndb.de>
>
> There is no 'NONE' version of 'enum mcu_cipher_type', and returning
> 'MT_CIPHER_NONE' causes a warning:
>
> drivers/net/wireless/mediatek/mt76/mt7921/mcu.c: In function 'mt7921_mcu_get_cipher':
> drivers/net/wireless/mediatek/mt76/mt7921/mcu.c:114:24: error: implicit conversion from 'enum mt76_cipher_type' to 'enum mcu_cipher_type' [-Werror=enum-conversion]
>   114 |                 return MT_CIPHER_NONE;
>       |                        ^~~~~~~~~~~~~~
>
> Add the missing MCU_CIPHER_NONE defintion that fits in here with
> the same value.
>
> Fixes: c368362c36d3 ("mt76: fix iv and CCMP header insertion")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> This problem currently exists in 5.14-rc2, please ignore my patch
> if a fix is already queued up elsewhere.

Should I take this to wireless-drivers? Felix, ack?

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
