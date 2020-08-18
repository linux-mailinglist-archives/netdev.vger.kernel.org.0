Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 692AD248187
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 11:09:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbgHRJJg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 05:09:36 -0400
Received: from mail29.static.mailgun.info ([104.130.122.29]:47942 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726636AbgHRJJc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 05:09:32 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1597741772; h=Content-Transfer-Encoding: Content-Type:
 MIME-Version: Message-ID: In-Reply-To: Date: References: Subject: Cc:
 To: From: Sender; bh=xbw7f7EvWXObjIipWjGcoTIEGzRejBWjPZyzXh3div8=; b=azgT+amb4etpm1l58XAC/zfmQxnsLQk95jgTF2Tfke+qPTdNofbMj9zKR4R3Tl4V2VO2onQd
 +90SQvRVtF0qeeJn7lJ0dwKJ4MGB35NfSOqMjFUh0JDGUlSTo9u4aZLciyKfwr0ESDgp5nm9
 pYwLo2Bl8oXUZJpEeUqjAAz9amE=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-east-1.postgun.com with SMTP id
 5f3b9aa0440a07969ad2b826 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 18 Aug 2020 09:08:48
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 62C06C43387; Tue, 18 Aug 2020 09:08:47 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 1C4A3C433CA;
        Tue, 18 Aug 2020 09:08:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 1C4A3C433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Tang Bin <tangbin@cmss.chinamobile.com>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        davem@davemloft.net, ath10k@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ath10k: fix the status check and wrong return
References: <20200814144844.1920-1-tangbin@cmss.chinamobile.com>
        <87y2mdjqkx.fsf@codeaurora.org>
        <e53ee8ca-9c2b-2313-6fd7-8f73ae33e1a2@cmss.chinamobile.com>
Date:   Tue, 18 Aug 2020 12:08:42 +0300
In-Reply-To: <e53ee8ca-9c2b-2313-6fd7-8f73ae33e1a2@cmss.chinamobile.com> (Tang
        Bin's message of "Tue, 18 Aug 2020 09:42:03 +0800")
Message-ID: <87lficjp7p.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tang Bin <tangbin@cmss.chinamobile.com> writes:

> =E5=9C=A8 2020/8/17 22:26, Kalle Valo =E5=86=99=E9=81=93:
>>> In the function ath10k_ahb_clock_init(), devm_clk_get() doesn't
>>> return NULL. Thus use IS_ERR() and PTR_ERR() to validate
>>> the returned value instead of IS_ERR_OR_NULL().
>> Why? What's the benefit of this patch? Or what harm does
>> IS_ERR_OR_NULL() create?
>
> Thanks for you reply, the benefit of this patch is simplify the code,
> because in
>
> this function, I don't think the situation of 'devm_clk_get() return
> NULL' exists.
>
> So please think about it, thanks.

I think you missed my comment below:

>> devm_clk_get() can return NULL if CONFIG_HAVE_CLK is disabled:
>>
>> static inline struct clk *devm_clk_get(struct device *dev, const char *i=
d)
>> {
>> 	return NULL;
>> }

So I think this patch just creates a new bug and does not improve
anything.

--=20
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
