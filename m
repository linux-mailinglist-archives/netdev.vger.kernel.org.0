Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59EF02776BB
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 18:27:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728602AbgIXQ1w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 12:27:52 -0400
Received: from m42-4.mailgun.net ([69.72.42.4]:40774 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728583AbgIXQ1o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Sep 2020 12:27:44 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1600964863; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=H7xOaaB817aiULShu/d8nxmq9YAErkwo2R+VMgY3kb4=; b=oKFAVSI33lHC8MB1kCm9lPNXydrP78baE3OQEHdN9TErdDMR2q+19hrQ4cbbLpcLPEY9/Df4
 0tMoUUhhRCFCav6ykjLS50ApAEMCzmbwt7ufEUR0HZ7+5dAfDb+GKsxPPvfEBQMYhj6F5er/
 uGV7bOU364xkc6Rz2Pf0C4iaCHg=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-east-1.postgun.com with SMTP id
 5f6cc8ff89f51cb4f12ab145 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 24 Sep 2020 16:27:43
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 7FAC3C433A0; Thu, 24 Sep 2020 16:27:42 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id F2382C433FF;
        Thu, 24 Sep 2020 16:27:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org F2382C433FF
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Julian Calaby <julian.calaby@gmail.com>
Cc:     Alex Dewar <alex.dewar90@gmail.com>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, ath10k@lists.infradead.org,
        Jakub Kicinski <kuba@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v2] ath10k: sdio: remove redundant check in for loop
References: <c2987351e3bdad16510dd35847991c2412a9db6b.camel@nvidia.com>
        <20200916165748.20927-1-alex.dewar90@gmail.com>
        <CAGRGNgWoFfCnK9FcWTf_f0b57JNEjsm6ZNQB5X_AMf8L3FyNcQ@mail.gmail.com>
Date:   Thu, 24 Sep 2020 19:27:36 +0300
In-Reply-To: <CAGRGNgWoFfCnK9FcWTf_f0b57JNEjsm6ZNQB5X_AMf8L3FyNcQ@mail.gmail.com>
        (Julian Calaby's message of "Thu, 17 Sep 2020 10:45:33 +1000")
Message-ID: <87h7rnnnrb.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Julian Calaby <julian.calaby@gmail.com> writes:

> On Thu, Sep 17, 2020 at 3:09 AM Alex Dewar <alex.dewar90@gmail.com> wrote:
>>
>> The for loop checks whether cur_section is NULL on every iteration, but
>> we know it can never be NULL as there is another check towards the
>> bottom of the loop body. Refactor to avoid this unnecessary check.
>>
>> Also, increment the variable i inline for clarity
>
> Comments below.
>
>> Addresses-Coverity: 1496984 ("Null pointer dereferences)
>> Suggested-by: Saeed Mahameed <saeedm@nvidia.com>
>> Signed-off-by: Alex Dewar <alex.dewar90@gmail.com>
>> ---
>> v2: refactor in the manner suggested by Saeed
>>
>>  drivers/net/wireless/ath/ath10k/sdio.c | 12 +++---------
>>  1 file changed, 3 insertions(+), 9 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath10k/sdio.c b/drivers/net/wireless/ath/ath10k/sdio.c
>> index 81ddaafb6721..486886c74e6a 100644
>> --- a/drivers/net/wireless/ath/ath10k/sdio.c
>> +++ b/drivers/net/wireless/ath/ath10k/sdio.c
>> @@ -2307,8 +2307,8 @@ static int ath10k_sdio_dump_memory_section(struct ath10k *ar,
>>         }
>>
>>         count = 0;
>> -
>> -       for (i = 0; cur_section; i++) {
>> +       i = 0;
>> +       for (; cur_section; cur_section = next_section) {
>
> You can have multiple statements in each section of a for() if you need to, e.g.
>
> for (i = 1; cur_section; cur_section = next_section, i++) {
>
> which means that the increment of i isn't hidden deep in the function body.

Yeah, I was thinking the same. But I'll apply this patch anyway, it's
still an improvement.

> That said, this function is a mess. Something (approximately) like
> this might be more readable:
>
> prev_end = memregion->start;
> for (i = 0; i < mem_region->section_table.size; i++) {
>     cur_section = &mem_region->section_table.sections[i];
>
>     // fail if prev_end is greater than cur_section->start - message
> from line 2329 and 2294
>     // check section size - from line 2315
>
>     skip_size = cur_section->start - prev_end;
>
>     // check buffer size - from line 2339 - needs to account for the
> skip size too.
>     // fill in the skip size amount - from line 2358 and 2304
>     // ath10k_sdio_read_mem - from line 2346
>
>     prev_end = cur_section->end;
> }

I agree. Anyone can come up with a patch?

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
