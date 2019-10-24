Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B98ECE2A1B
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 07:47:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408475AbfJXFrg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 01:47:36 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:52718 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404449AbfJXFrg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 01:47:36 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 190CA60E74; Thu, 24 Oct 2019 05:47:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1571896055;
        bh=BlBZrDdxf5hDGcLaD5++u0J7VzDdhO05PgZI3U6TU9o=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=R9/6jv7en+NU3SBDZyqHZFDbAWEPiKcyh1Dkf2h+0oqcCH7Yx62wteBOhOuGlerNc
         g5yaouuvOYCFigomvmCm065UFwAnQCj7fJ/V2LAMLPImxRQIDewWvvXJH/axQDiWsA
         vqqK8Bz4CiFQSIADDcW2VjOhMIunS9p/X9R7gggc=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,MISSING_DATE,MISSING_MID,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.0
Received: from potku.adurom.net (unknown [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 5A92A60DA9;
        Thu, 24 Oct 2019 05:47:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1571896054;
        bh=BlBZrDdxf5hDGcLaD5++u0J7VzDdhO05PgZI3U6TU9o=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=EN7O/WmcBlVyiFh/dO4VY3sguD7/n4LaYv2OIuFGsIkPNyU65Lmmmg8I+7t1Bq6ep
         ipW7px+VecYGWxequOxvAvzHX3Asbq2rxE+pWrEAsR8ukFv5C5QlEtBlsvNWMh1uDo
         4FK96xboB9rayBbiCg+JHx6aNL2R2yGAHwj7Q6nk=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 5A92A60DA9
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rtlwifi: Remove unnecessary NULL check in rtl_regd_init
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20191023004703.39710-1-natechancellor@gmail.com>
References: <20191023004703.39710-1-natechancellor@gmail.com>
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com,
        Nathan Chancellor <natechancellor@gmail.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20191024054735.190CA60E74@smtp.codeaurora.org>
Date:   Thu, 24 Oct 2019 05:47:35 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Nathan Chancellor <natechancellor@gmail.com> wrote:

> When building with Clang + -Wtautological-pointer-compare:
> 
> drivers/net/wireless/realtek/rtlwifi/regd.c:389:33: warning: comparison
> of address of 'rtlpriv->regd' equal to a null pointer is always false
> [-Wtautological-pointer-compare]
>         if (wiphy == NULL || &rtlpriv->regd == NULL)
>                               ~~~~~~~~~^~~~    ~~~~
> 1 warning generated.
> 
> The address of an array member is never NULL unless it is the first
> struct member so remove the unnecessary check. This was addressed in
> the staging version of the driver in commit f986978b32b3 ("Staging:
> rtlwifi: remove unnecessary NULL check").
> 
> While we are here, fix the following checkpatch warning:
> 
> CHECK: Comparison to NULL could be written "!wiphy"
> 35: FILE: drivers/net/wireless/realtek/rtlwifi/regd.c:389:
> +       if (wiphy == NULL)
> 
> Fixes: 0c8173385e54 ("rtl8192ce: Add new driver")
> Link:https://github.com/ClangBuiltLinux/linux/issues/750
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>

Patch applied to wireless-drivers-next.git, thanks.

091c6e9c083f rtlwifi: Remove unnecessary NULL check in rtl_regd_init

-- 
https://patchwork.kernel.org/patch/11205577/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

