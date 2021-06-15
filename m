Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 425653A7C21
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 12:37:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231785AbhFOKj4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 06:39:56 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:10868 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231324AbhFOKjw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Jun 2021 06:39:52 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1623753468; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=E4E+s3D3+4bovq58bDRtKTnzJl0tADNy2QmmvJf7UbY=;
 b=vd5sDfw72OE7h9LJ0Rm/uYRVZax2rW8yn19JiNPaZGy3kkdaI3XDN4k5pCvCDmlT52PGTCWj
 p8O+hCYgfX3JvaxGd8fKAkmwCR0WVvFkvmMSd1gilhA3yWtrRgO6evGvQRYp3WHn6X4NgBe8
 cfEQWnQLUngrhrs8fZCzm57RXas=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n02.prod.us-west-2.postgun.com with SMTP id
 60c882f72eaeb98b5e3b3a0b (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 15 Jun 2021 10:37:43
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 5C4FCC4360C; Tue, 15 Jun 2021 10:37:43 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,MISSING_MID,SPF_FAIL autolearn=no autolearn_force=no
        version=3.4.0
Received: from tykki.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 12D0FC433F1;
        Tue, 15 Jun 2021 10:37:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 12D0FC433F1
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH -next] brcmfmac: Fix a double-free in brcmf_sdio_bus_reset
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20210601100128.69561-1-tongtiangen@huawei.com>
References: <20210601100128.69561-1-tongtiangen@huawei.com>
To:     Tong Tiangen <tongtiangen@huawei.com>
Cc:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Chung-hsien Hsu <chung-hsien.hsu@infineon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        <linux-wireless@vger.kernel.org>,
        <brcm80211-dev-list.pdl@broadcom.com>,
        <SHA-cyfmac-dev-list@infineon.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Tong Tiangen <tongtiangen@huawei.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-Id: <20210615103743.5C4FCC4360C@smtp.codeaurora.org>
Date:   Tue, 15 Jun 2021 10:37:43 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tong Tiangen <tongtiangen@huawei.com> wrote:

> brcmf_sdiod_remove has been called inside brcmf_sdiod_probe when fails,
> so there's no need to call another one. Otherwise, sdiodev->freezer
> would be double freed.
> 
> Fixes: 7836102a750a ("brcmfmac: reset SDIO bus on a firmware crash")
> Signed-off-by: Tong Tiangen <tongtiangen@huawei.com>
> Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>

Patch applied to wireless-drivers-next.git, thanks.

7ea7a1e05c7f brcmfmac: Fix a double-free in brcmf_sdio_bus_reset

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20210601100128.69561-1-tongtiangen@huawei.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

