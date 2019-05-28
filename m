Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E10F2C58C
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 13:39:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726725AbfE1LjX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 07:39:23 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:57326 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726553AbfE1LjX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 07:39:23 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 062376077A; Tue, 28 May 2019 11:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1559043563;
        bh=c3sNut8JDvcBDnwmKxoXocAd1hhWsAcc9vRUjO4cMEw=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=npW7wyj+lbSMyrhhE/FZN9Z4hwjB8zbHqYrLD9U03vnoKHZSNtMPRZfVDRmBJgtXx
         X2QS36q/zhLmUkqe8XATf5kQ4WA4KKAWKLuiwKYRtcmEAAP/pF/I4QMNc2XrZ7mmtT
         wmL7hRPa4GLYRsVBE6gU3OKc6aHj8dSgF3mSEpg4=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,MISSING_DATE,MISSING_MID,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 6B9FB6034D;
        Tue, 28 May 2019 11:39:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1559043562;
        bh=c3sNut8JDvcBDnwmKxoXocAd1hhWsAcc9vRUjO4cMEw=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=QhBnrF/loAEzvhjV0PLYnZJHgZh38bdMlVbnmrc8HstH9EndRn334ytMaeYGxnqF9
         T8m/GvCKT8/vlEF9VVelOXr+4vGO+7II+vhOe+3tStHOg/SLYfwRPFchliUVE2Pbkj
         tlS/D5iy+QGTLybYV3IWcwbTm/6I1T2SGBF8d+TQ=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 6B9FB6034D
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wlcore: spi: Fix a memory leaking bug in wl1271_probe()
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190524030117.GA6024@zhanggen-UX430UQ>
References: <20190524030117.GA6024@zhanggen-UX430UQ>
To:     Gen Zhang <blackgod016574@gmail.com>
Cc:     davem@davemloft.net, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190528113923.062376077A@smtp.codeaurora.org>
Date:   Tue, 28 May 2019 11:39:23 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Gen Zhang <blackgod016574@gmail.com> wrote:

> In wl1271_probe(), 'glue->core' is allocated by platform_device_alloc(),
> when this allocation fails, ENOMEM is returned. However, 'pdev_data'
> and 'glue' are allocated by devm_kzalloc() before 'glue->core'. When
> platform_device_alloc() returns NULL, we should also free 'pdev_data'
> and 'glue' before wl1271_probe() ends to prevent leaking memory.
> 
> Similarly, we shoulf free 'pdev_data' when 'glue' is NULL. And we should
> free 'pdev_data' and 'glue' when 'glue->reg' is error and when 'ret' is
> error.
> 
> Further, we should free 'glue->core', 'pdev_data' and 'glue' when this 
> function normally ends to prevent leaking memory.
> 
> Signed-off-by: Gen Zhang <blackgod016574@gmail.com>

Same questions as with similar SDIO patch:

https://patchwork.kernel.org/patch/10959049/

Patch set to Changes Requested.

-- 
https://patchwork.kernel.org/patch/10959053/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

