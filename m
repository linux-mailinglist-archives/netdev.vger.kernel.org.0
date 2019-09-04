Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0439DA7B96
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 08:21:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728532AbfIDGVs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 02:21:48 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:38192 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725267AbfIDGVr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Sep 2019 02:21:47 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id B6D60611C5; Wed,  4 Sep 2019 06:21:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1567578106;
        bh=TPgwvKctOwymLvmyyZZR51ik0MV3E88Ok8sQi1Pt0ik=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=ISfgP38VuLvEgqxm7IFujKsnfnYGs/t8g3hKuPggbeTb+t5rtdE40G6/1cnQV3r/I
         Jh78KqRzTzKFiPQ3gq7PiiPBRP3eplxlMLFoQNfFuUIA047CRQ8ktfLNJa2m5Ud4R1
         wKsWXvYQ8Zaei8K2m2uElNGHp74EA7v1Hidp3Lqw=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 78032602A7;
        Wed,  4 Sep 2019 06:21:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1567578106;
        bh=TPgwvKctOwymLvmyyZZR51ik0MV3E88Ok8sQi1Pt0ik=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=CZKc/atyhx0Bz9SPu1S3FG5C0jMBpRU3ENSWD0EpysigTTM9J37BVmTea8Y4ya0U9
         d8pLxn9NOavUJHkDBxBny/ZXv9VwGmOreFWb2qQXeV/KC8PHfRvi2UPd4YlzVUchuO
         CLcATN06vJ7T63Vi0OOyyMkphPMsx+j0s5JEUMHQ=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 78032602A7
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath6kl: Fix a possible null-pointer dereference in
 ath6kl_htc_mbox_create()
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190729030305.18410-1-baijiaju1990@gmail.com>
References: <20190729030305.18410-1-baijiaju1990@gmail.com>
To:     Jia-Ju Bai <baijiaju1990@gmail.com>
Cc:     davem@davemloft.net, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jia-Ju Bai <baijiaju1990@gmail.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190904062146.B6D60611C5@smtp.codeaurora.org>
Date:   Wed,  4 Sep 2019 06:21:46 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jia-Ju Bai <baijiaju1990@gmail.com> wrote:

> In ath6kl_htc_mbox_create(), when kzalloc() on line 2855 fails,
> target->dev is assigned to NULL, and ath6kl_htc_mbox_cleanup(target) is
> called on line 2885.
> 
> In ath6kl_htc_mbox_cleanup(), target->dev is used on line 2895:
>     ath6kl_hif_cleanup_scatter(target->dev->ar);
> 
> Thus, a null-pointer dereference may occur.
> 
> To fix this bug, kfree(target) is called and NULL is returned when
> kzalloc() on line 2855 fails.
> 
> This bug is found by a static analysis tool STCheck written by us.
> 
> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

0e7bf23e4967 ath6kl: Fix a possible null-pointer dereference in ath6kl_htc_mbox_create()

-- 
https://patchwork.kernel.org/patch/11063157/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

