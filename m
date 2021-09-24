Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F17ED416D15
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 09:47:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244500AbhIXHrr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 03:47:47 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:53623 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235134AbhIXHrq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Sep 2021 03:47:46 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1632469574; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=4pokcUcPJIxn2KXPjIfMunrzRkE8hR/S1cWZM8vb9wY=; b=SHwbCsZCXz+JN0EFxxbZzF4IZV38SaaJZjKvIs5/nY8r4KSqE+3Hnnl1gM3l9o/qROKUIWan
 vl6QZaivBCKpyWkdDMJIjlfcWESLEnJ/wlRZW1cDRtU2R0GqCFz1v+BKuFUo8ZGtBzuwCPxw
 ZeET9GzwgS3zuboRF9Q6666Y668=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-west-2.postgun.com with SMTP id
 614d8245648642cc1c250c95 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 24 Sep 2021 07:46:13
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 4D297C4360D; Fri, 24 Sep 2021 07:46:13 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from tykki (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id E68E2C43460;
        Fri, 24 Sep 2021 07:46:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org E68E2C43460
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Cc:     Luca Coelho <luciano.coelho@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Julien Wajsberg <felash@gmail.com>
Subject: Re: [PATCH v2] iwlwifi: pcie: add configuration of a Wi-Fi adapter on Dell XPS 15
References: <20210923143840.2226042-1-vladimir.zapolskiy@linaro.org>
Date:   Fri, 24 Sep 2021 10:46:07 +0300
In-Reply-To: <20210923143840.2226042-1-vladimir.zapolskiy@linaro.org>
        (Vladimir Zapolskiy's message of "Thu, 23 Sep 2021 17:38:40 +0300")
Message-ID: <87k0j6to00.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org> writes:

> There is a Killer AX1650 2x2 Wi-Fi 6 and Bluetooth 5.1 wireless adapter
> found on Dell XPS 15 (9510) laptop, its configuration was present on
> Linux v5.7, however accidentally it has been removed from the list of
> supported devices, let's add it back.
>
> The problem is manifested on driver initialization:
>
>   Intel(R) Wireless WiFi driver for Linux
>   iwlwifi 0000:00:14.3: enabling device (0000 -> 0002)
>   iwlwifi: No config found for PCI dev 43f0/1651, rev=0x354, rfid=0x10a100
>   iwlwifi: probe of 0000:00:14.3 failed with error -22
>
> Bug: https://bugzilla.kernel.org/show_bug.cgi?id=213939
> Fixes: 3f910a25839b ("iwlwifi: pcie: convert all AX101 devices to the device tables")
> Cc: Julien Wajsberg <felash@gmail.com>
> Signed-off-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>

Luca, can I take this to wireless-drivers? Ack?

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
