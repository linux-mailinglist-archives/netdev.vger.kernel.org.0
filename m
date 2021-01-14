Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BA852F69E4
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 19:50:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729481AbhANSp6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 13:45:58 -0500
Received: from m43-15.mailgun.net ([69.72.43.15]:26683 "EHLO
        m43-15.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728335AbhANSp6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 13:45:58 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1610649933; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=3zjXkQXLJWqqe3jg+JhaQfBk8Fz3LZHrdbV179oe6tw=;
 b=eQVf6TQV6SDwDkTNGzCkIBbcDsPjjDNANpaV3FD5TNJhF9PxkpS59g7cKFp0oRjGkYdRbc8z
 HCnTANZHdxIxTiWtt5wyOTlsOKOKglQ2c8FHpu8T6sX8vta4di8xpIPsAfOQjEBYynfzjA/p
 5hG/skRPuwc8EA4m7CVkDk2J/Lk=
X-Mailgun-Sending-Ip: 69.72.43.15
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-west-2.postgun.com with SMTP id
 600091314104d9478dc728af (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 14 Jan 2021 18:45:05
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 54D81C43467; Thu, 14 Jan 2021 18:45:05 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,MISSING_MID,SPF_FAIL,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 09882C433C6;
        Thu, 14 Jan 2021 18:45:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 09882C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 4/7] wil6210: select CONFIG_CRC32
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20210103213645.1994783-4-arnd@kernel.org>
References: <20210103213645.1994783-4-arnd@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Maya Erez <merez@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "John W. Linville" <linville@tuxdriver.com>,
        Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20210114184505.54D81C43467@smtp.codeaurora.org>
Date:   Thu, 14 Jan 2021 18:45:05 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Arnd Bergmann <arnd@kernel.org> wrote:

> From: Arnd Bergmann <arnd@arndb.de>
> 
> Without crc32, the driver fails to link:
> 
> arm-linux-gnueabi-ld: drivers/net/wireless/ath/wil6210/fw.o: in function `wil_fw_verify':
> fw.c:(.text+0x74c): undefined reference to `crc32_le'
> arm-linux-gnueabi-ld: drivers/net/wireless/ath/wil6210/fw.o:fw.c:(.text+0x758): more undefined references to `crc32_le' follow
> 
> Fixes: 151a9706503f ("wil6210: firmware download")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Dave had already applied this so dropping from my queue.

Patch set to Not Applicable.

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20210103213645.1994783-4-arnd@kernel.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

