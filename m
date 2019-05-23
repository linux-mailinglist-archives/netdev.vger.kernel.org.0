Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBE3D28067
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 17:00:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731037AbfEWPA1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 11:00:27 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:47866 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730741AbfEWPA0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 11:00:26 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id DB79160A42; Thu, 23 May 2019 15:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1558623625;
        bh=xjX2dCoX++xPQ70yBZuiq+wW8s0TyrMClqMEGpholq0=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=WtzwBrSHxC98Nc3KswSuxRp1VN96Pmu74SOXVvvNAXqNaFFA2OJmPaF9ZaCn0RNll
         /Y3aTKxSGn3pEcG90HsoI6OGjtd4ueW38oJ+zOOLvRlaTP80VT2CSWsV5Gv4qw+fM5
         apiqSik983/sk2+OlO6xpJUl3XsqIRazum3T2GDY=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 2B4ED607B9;
        Thu, 23 May 2019 15:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1558623625;
        bh=xjX2dCoX++xPQ70yBZuiq+wW8s0TyrMClqMEGpholq0=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=WtzwBrSHxC98Nc3KswSuxRp1VN96Pmu74SOXVvvNAXqNaFFA2OJmPaF9ZaCn0RNll
         /Y3aTKxSGn3pEcG90HsoI6OGjtd4ueW38oJ+zOOLvRlaTP80VT2CSWsV5Gv4qw+fM5
         apiqSik983/sk2+OlO6xpJUl3XsqIRazum3T2GDY=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 2B4ED607B9
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Gen Zhang <blackgod016574@gmail.com>
Cc:     eyalreizer@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] sdio: Fix a memory leaking bug in wl1271_probe()
References: <20190523144425.GA26766@zhanggen-UX430UQ>
Date:   Thu, 23 May 2019 18:00:21 +0300
In-Reply-To: <20190523144425.GA26766@zhanggen-UX430UQ> (Gen Zhang's message of
        "Thu, 23 May 2019 22:44:25 +0800")
Message-ID: <87d0k9b4hm.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+ linux-wireless

Gen Zhang <blackgod016574@gmail.com> writes:

> In wl1271_probe(), 'glue->core' is allocated by platform_device_alloc(),
> when this allocation fails, ENOMEM is returned. However, 'pdev_data'
> and 'glue' are allocated by devm_kzalloc() before 'glue->core'. When
> platform_device_alloc() returns NULL, we should also free 'pdev_data'
> and 'glue' before wl1271_probe() ends to prevent leaking memory.
>
> Similarly, we should free 'pdev_data' when 'glue' is NULL. And we
> should free 'pdev_data' and 'glue' when 'ret' is error.
>
> Further, we shoulf free 'glue->dev', 'pdev_data' and 'glue' when this
> function normally ends to prevent memory leaking.
>
> Signed-off-by: Gen Zhang <blackgod016574@gmail.com>
> ---
> diff --git a/drivers/net/wireless/ti/wlcore/sdio.c b/drivers/net/wireless/ti/wlcore/sdio.c
> index 4d4b0770..232ce5f 100644
> --- a/drivers/net/wireless/ti/wlcore/sdio.c
> +++ b/drivers/net/wireless/ti/wlcore/sdio.c

You need to CC linux-wireless, otherwise patchwork won't see the patch
and it will not be applied. Also you should use prefix "wlcore:".

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#commit_title_is_wrong

-- 
Kalle Valo
