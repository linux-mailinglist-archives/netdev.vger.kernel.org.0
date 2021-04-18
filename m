Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E89593633F6
	for <lists+netdev@lfdr.de>; Sun, 18 Apr 2021 08:10:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232607AbhDRGK6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Apr 2021 02:10:58 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:63296 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229993AbhDRGK5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Apr 2021 02:10:57 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1618726230; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=ypVoKjPH+9m+B6mFc4YokwEv6kqniBKcP4p0b5RWi0I=;
 b=ll2HFQaRi9/BX2h/EHjLSxa75dL8NIF9BxDDYktKz38OrGefoMAPtYBC6c25Dt5B0pBbd21u
 wakDmAWFqf3NQw0C3Bu3Gmiq9ylx3JwMVK83xIFan4WD4l8BJTINvakJao9BTaxfbT6rxvr+
 8SoxnaE7xH8JjYEal94W0/dv2vc=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-east-1.postgun.com with SMTP id
 607bcd4e853c0a2c460b612b (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sun, 18 Apr 2021 06:10:22
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id AB25CC43217; Sun, 18 Apr 2021 06:10:21 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        MISSING_DATE,MISSING_MID,SPF_FAIL autolearn=no autolearn_force=no
        version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 7A0C5C433D3;
        Sun, 18 Apr 2021 06:10:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 7A0C5C433D3
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] brcmsmac: fix shift on 4 bit masked value
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20210318164513.19600-1-colin.king@canonical.com>
References: <20210318164513.19600-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Chung-hsien Hsu <chung-hsien.hsu@infineon.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20210418061021.AB25CC43217@smtp.codeaurora.org>
Date:   Sun, 18 Apr 2021 06:10:21 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Colin King <colin.king@canonical.com> wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> The calculation of offtune_val seems incorrect, the u16 value in
> pi->tx_rx_cal_radio_saveregs[2] is being masked with 0xf0 and then
> shifted 8 places right so that always ends up as a zero result. I
> believe the intended shift was 4 bits to the right. Fix this.
> 
> [Note: not tested, I don't have the H/W]
> 
> Addresses-Coverity: ("Operands don't affect result")
> Fixes: 5b435de0d786 ("net: wireless: add brcm80211 drivers")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

I think this needs review from someone familiar with the hardware.

Patch set to Changes Requested.

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20210318164513.19600-1-colin.king@canonical.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

