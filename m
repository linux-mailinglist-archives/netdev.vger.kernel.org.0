Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3AE8435D4D
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 10:48:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231419AbhJUIui (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 04:50:38 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:26334 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230385AbhJUIuh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Oct 2021 04:50:37 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1634806101; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=fGTORJsyflzni7NU7S3f+ketqwKwriawQfcTUKvSUSo=; b=GOW2HwA3+ck7TdunG7zz86OMf7Af4EsUMD+/0v5Bpwn0tj4Acxy2gspEExkwJeTw9vcsKUrn
 oGj4kLb2DjbvNEUX9h1lhiWqvvtOEWw80SCpWEegc4XHivfZHs3XFpuoBa/oYpVI3zKrvptJ
 PEJQbaitIyzwreM1SzU6jHln/3Q=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-east-1.postgun.com with SMTP id
 6171295559612e010090ef91 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 21 Oct 2021 08:48:21
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 99081C4360D; Thu, 21 Oct 2021 08:48:20 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from tykki (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id BCF07C4338F;
        Thu, 21 Oct 2021 08:48:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org BCF07C4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Pkshih <pkshih@realtek.com>
Cc:     Colin King <colin.king@canonical.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-janitors\@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][next] rtw89: Fix potential dereference of the null pointer sta
References: <20211015154530.34356-1-colin.king@canonical.com>
        <9cc681c217a449519aee524b35e6b6bc@realtek.com>
        <87pms2ttvi.fsf@codeaurora.org>
        <abc2e3a274694d48aa468491df334349@realtek.com>
        <87h7dcf5zj.fsf@codeaurora.org>
        <35c096e5251f49c1abfbb51f761eab82@realtek.com>
Date:   Thu, 21 Oct 2021 11:48:13 +0300
In-Reply-To: <35c096e5251f49c1abfbb51f761eab82@realtek.com> (Pkshih's message
        of "Thu, 21 Oct 2021 05:46:15 +0000")
Message-ID: <87y26mepbm.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pkshih <pkshih@realtek.com> writes:

>> >> > I check the size of object files before/after this patch, and
>> >> > the original one is smaller.
>> >> >
>> >> >    text    data     bss     dec     hex filename
>> >> >   16781    3392       1   20174    4ece core-0.o  // original
>> >> >   16819    3392       1   20212    4ef4 core-1.o  // after this patch
>> >> >
>> >> > Do you think it is worth to apply this patch?
>> >>
>> >> I think that we should apply the patch. Even though the compiler _may_
>> >> reorder the code, it might choose not to do that.
>> >
>> > Understand.
>> >
>> > I have another way to fix this coverity warning, like:
>> >
>> > @@ -1617,7 +1617,7 @@ static bool rtw89_core_txq_agg_wait(struct rtw89_dev *rtwdev,
>> >  {
>> >         struct rtw89_txq *rtwtxq = (struct rtw89_txq *)txq->drv_priv;
>> >         struct ieee80211_sta *sta = txq->sta;
>> > -       struct rtw89_sta *rtwsta = (struct rtw89_sta *)sta->drv_priv;
>> > +       struct rtw89_sta *rtwsta = sta ? (struct rtw89_sta *)sta->drv_priv : NULL;
>> >
>> >         if (!sta || rtwsta->max_agg_wait <= 0)
>> >                 return false;
>> >
>> > Is this acceptable?
>> > It has a little redundant checking of 'sta', but the code looks clean.
>> 
>> I feel that Colin's fix is more readable, but this is just matter of
>> taste. You can choose.
>
> I would like my version. 
>
> There are three similar warnings reported by smatch, so I will fix them by
> myself. Please drop this patch.

Ok, dropped.

> But, still thank Colin to point out this issue.

Indeed, thanks Colin. A good way to thank is to add Reported-by to the
commit log.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
