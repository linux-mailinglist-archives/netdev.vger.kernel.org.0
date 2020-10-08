Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 965242872C5
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 12:46:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729602AbgJHKqv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 06:46:51 -0400
Received: from z5.mailgun.us ([104.130.96.5]:32842 "EHLO z5.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729592AbgJHKqt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Oct 2020 06:46:49 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1602154009; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=vSIBoUltBzERS6y2ZxsSsX/nq3b4lLc6UgpZFPvxNKA=;
 b=Hnu6+nEwb7LZ5gD/FEXELxuMVOGCl9VbWZBuZKz3xU9bcoW3cX1lTLnWMCS7Ax+iG19PhLxP
 zl1b1/4vE91OAkJiRe8nIdVfAxo8z9n7VvW6cDKBkBu4hzCGMkgcGTcEuJBz2uZdVXy968ve
 7QuhOb5NuNo3sdQ6BI4effT98As=
X-Mailgun-Sending-Ip: 104.130.96.5
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-west-2.postgun.com with SMTP id
 5f7eee1406d81bc48d29235c (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 08 Oct 2020 10:46:44
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id DF562C433A1; Thu,  8 Oct 2020 10:46:43 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 53F36C433CB;
        Thu,  8 Oct 2020 10:46:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 53F36C433CB
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: mwifiex: fix double free
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20201004131931.29782-1-trix@redhat.com>
References: <20201004131931.29782-1-trix@redhat.com>
To:     trix@redhat.com
Cc:     amitkarwar@gmail.com, ganapathi.bhat@nxp.com,
        huxinming820@gmail.com, davem@davemloft.net, kuba@kernel.org,
        natechancellor@gmail.com, ndesaulniers@google.com,
        linville@tuxdriver.com, nishants@marvell.com, rramesh@marvell.com,
        bzhao@marvell.com, frankh@marvell.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com,
        Tom Rix <trix@redhat.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20201008104643.DF562C433A1@smtp.codeaurora.org>
Date:   Thu,  8 Oct 2020 10:46:43 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

trix@redhat.com wrote:

> From: Tom Rix <trix@redhat.com>
> 
> clang static analysis reports this problem:
> 
> sdio.c:2403:3: warning: Attempt to free released memory
>         kfree(card->mpa_rx.buf);
>         ^~~~~~~~~~~~~~~~~~~~~~~
> 
> When mwifiex_init_sdio() fails in its first call to
> mwifiex_alloc_sdio_mpa_buffer, it falls back to calling it
> again.  If the second alloc of mpa_tx.buf fails, the error
> handler will try to free the old, previously freed mpa_rx.buf.
> Reviewing the code, it looks like a second double free would
> happen with mwifiex_cleanup_sdio().
> 
> So set both pointers to NULL when they are freed.
> 
> Fixes: 5e6e3a92b9a4 ("wireless: mwifiex: initial commit for Marvell mwifiex driver")
> Signed-off-by: Tom Rix <trix@redhat.com>
> Reviewed-by: Brian Norris <briannorris@chromium.org>

Patch applied to wireless-drivers-next.git, thanks.

53708f4fd9cf mwifiex: fix double free

-- 
https://patchwork.kernel.org/patch/11815655/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

