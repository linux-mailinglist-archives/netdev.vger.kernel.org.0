Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA251424CC5
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 07:27:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbhJGF3e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 01:29:34 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:56302 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240124AbhJGF3d (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 01:29:33 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1633584460; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=YUm80ODbiGWTsPeWV648iKuR+M8nQMtKs1vZZWQm4jE=; b=Odc+e2sEOZlt/OhpR7w4wi3pveFJUoRbZTdBIH33GpuNOiiZxWAFK1ECC62mE29jK+pCjqQP
 Pjc4DQCZpg39foAFmxhzRR1C7xvcxPGxca2IniEk/S1iFsQSDwt4rLW+1YnpkSkTwX5wgXO1
 BoZCnFv0xxn0pw0sortYNKSwlls=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-west-2.postgun.com with SMTP id
 615e8539ff0285fb0a2b129b (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 07 Oct 2021 05:27:21
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 3F7BCC4338F; Thu,  7 Oct 2021 05:27:21 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from tykki (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A9325C4338F;
        Thu,  7 Oct 2021 05:27:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org A9325C4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Cc:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Stanimir Varbanov <svarbanov@mm-sol.com>,
        linux-arm-msm@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v1 00/15] create power sequencing subsystem
References: <20211006035407.1147909-1-dmitry.baryshkov@linaro.org>
Date:   Thu, 07 Oct 2021 08:27:12 +0300
In-Reply-To: <20211006035407.1147909-1-dmitry.baryshkov@linaro.org> (Dmitry
        Baryshkov's message of "Wed, 6 Oct 2021 06:53:52 +0300")
Message-ID: <87ee8xe767.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dmitry Baryshkov <dmitry.baryshkov@linaro.org> writes:

> This is a proposed power sequencer subsystem. This is a
> generification of the MMC pwrseq code. The subsystem tries to abstract
> the idea of complex power-up/power-down/reset of the devices.
>
> The primary set of devices that promted me to create this patchset is
> the Qualcomm BT+WiFi family of chips. They reside on serial+platform
> or serial + SDIO interfaces (older generations) or on serial+PCIe (newer
> generations).

Instead of older and newer, it would be more unstandable to mention
specific chips. For example I have no clue what you mean with older
generation.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
