Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E03853A8110
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 15:42:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231298AbhFONor (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 09:44:47 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:34828 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231420AbhFONoE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 09:44:04 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1623764520; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=2zoi8y9DH7UWPNKBoHX5xlXK7HjEa8Z0Nb+7WOjhtQU=;
 b=AwyR1b/DG7h0L7rXchHoYU16roal/PnNzAAcEFpDrs/Hr4/0tbJ/AE6MCGuGKt0U30wGmAAH
 ZqIUNXtYlzpF+jQCvsss+3x3k9ao0vKrGHNlpsRdWHDmVBJZ+OkYTsQRnnX6h9Bjcj7/FTcc
 P8pdbBVj7csKjvzFXf9DvNWza18=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-west-2.postgun.com with SMTP id
 60c8ae0ded59bf69ccfdfabd (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 15 Jun 2021 13:41:33
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 1BACCC43460; Tue, 15 Jun 2021 13:41:33 +0000 (UTC)
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id E40B0C43460;
        Tue, 15 Jun 2021 13:41:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org E40B0C43460
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] cw1200: Revert unnecessary patches that fix unreal
 use-after-free bugs
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20210521223238.25020-1-zh.nvgt@gmail.com>
References: <20210521223238.25020-1-zh.nvgt@gmail.com>
To:     Hang Zhang <zh.nvgt@gmail.com>
Cc:     unlisted-recipients:; (no To-header on input)
        Solomon Peachy <pizza@shaftnet.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jia-Ju Bai <baijiaju1990@gmail.com>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hang Zhang <zh.nvgt@gmail.com>
Illegal-Object: Syntax error in Cc: address found on vger.kernel.org:
        Cc:     unlisted-recipients:; (no To-header on input)Solomon Peachy <pizza@shaftnet.org>
                                                                     ^-missing end of address
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-Id: <20210615134133.1BACCC43460@smtp.codeaurora.org>
Date:   Tue, 15 Jun 2021 13:41:33 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hang Zhang <zh.nvgt@gmail.com> wrote:

> A previous commit 4f68ef64cd7f ("cw1200: Fix concurrency 
> use-after-free bugs in cw1200_hw_scan()") tried to fix a seemingly
> use-after-free bug between cw1200_bss_info_changed() and
> cw1200_hw_scan(), where the former frees a sk_buff pointed
> to by frame.skb, and the latter accesses the sk_buff
> pointed to by frame.skb. However, this issue should be a
> false alarm because:
> 
> (1) "frame.skb" is not a shared variable between the above 
> two functions, because "frame" is a local function variable,
> each of the two functions has its own local "frame" - they
> just happen to have the same variable name.
> 
> (2) the sk_buff(s) pointed to by these two "frame.skb" are
> also two different object instances, they are individually
> allocated by different dev_alloc_skb() within the two above
> functions. To free one object instance will not invalidate 
> the access of another different one.
> 
> Based on these facts, the previous commit should be unnecessary.
> Moreover, it also introduced a missing unlock which was 
> addressed in a subsequent commit 51c8d24101c7 ("cw1200: fix missing 
> unlock on error in cw1200_hw_scan()"). Now that the
> original use-after-free is unreal, these two commits should
> be reverted. This patch performs the reversion.
> 
> Fixes: 4f68ef64cd7f ("cw1200: Fix concurrency use-after-free bugs in cw1200_hw_scan()")
> Fixes: 51c8d24101c7 ("cw1200: fix missing unlock on error in cw1200_hw_scan()")
> Signed-off-by: Hang Zhang <zh.nvgt@gmail.com>
> Acked-by: Jia-Ju Bai <baijiaju1990@gmail.com>

Patch applied to wireless-drivers-next.git, thanks.

3f60f4685699 cw1200: Revert unnecessary patches that fix unreal use-after-free bugs

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20210521223238.25020-1-zh.nvgt@gmail.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

