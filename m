Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B5F3305FD7
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 16:41:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236426AbhA0Pke (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 10:40:34 -0500
Received: from m42-8.mailgun.net ([69.72.42.8]:49505 "EHLO m42-8.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236208AbhA0PeL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Jan 2021 10:34:11 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1611761632; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=6DkDkEV7TGoJ4NLBbSGZElh1mjjPhmyjl8xd9psqcTo=; b=gCsh8GDN5EpUHJatooqGAn4wXdLHDidNNF06jdR150eAgFQ0kwA5vlnw2VurOylp8apAp1zO
 Why+XUuoeJKNXOQxaT2TiPRDhmgFhcEWhnaIQRcoh/A7UHQ52PPiFMnPevZnhycPrPnxbmgA
 kqNlexThs4EepTaHXeRh0DBU3W0=
X-Mailgun-Sending-Ip: 69.72.42.8
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-east-1.postgun.com with SMTP id
 601187bc2c36b2106d390521 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 27 Jan 2021 15:33:16
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id C163FC43463; Wed, 27 Jan 2021 15:33:15 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 45BA3C43463;
        Wed, 27 Jan 2021 15:33:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 45BA3C43463
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Emil Renner Berthing <kernel@esmil.dk>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Ping-Ke Shih <pkshih@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Allen Pais <allen.lkml@gmail.com>,
        Romain Perier <romain.perier@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rtlwifi: use tasklet_setup to initialize rx_work_tasklet
References: <20210126171550.3066-1-kernel@esmil.dk>
        <CAF=yD-LGoVkf5ARHPsGAMbsruDq7iQ=X8c3cZRp5XaZC936EMw@mail.gmail.com>
        <87pn1q8l0t.fsf@codeaurora.org>
        <CANBLGcwmTt2bmpwST1qHzOFhVoYYPC_gEz3nARzR9mOOg6nOHA@mail.gmail.com>
Date:   Wed, 27 Jan 2021 17:33:10 +0200
In-Reply-To: <CANBLGcwmTt2bmpwST1qHzOFhVoYYPC_gEz3nARzR9mOOg6nOHA@mail.gmail.com>
        (Emil Renner Berthing's message of "Wed, 27 Jan 2021 16:25:39 +0100")
Message-ID: <87lfce8keh.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Emil Renner Berthing <kernel@esmil.dk> writes:

> On Wed, 27 Jan 2021 at 16:20, Kalle Valo <kvalo@codeaurora.org> wrote:
>>
>> Willem de Bruijn <willemdebruijn.kernel@gmail.com> writes:
>>
>> > On Wed, Jan 27, 2021 at 5:23 AM Emil Renner Berthing <kernel@esmil.dk> wrote:
>> >>
>> >> In commit d3ccc14dfe95 most of the tasklets in this driver was
>> >> updated to the new API. However for the rx_work_tasklet only the
>> >> type of the callback was changed from
>> >>   void _rtl_rx_work(unsigned long data)
>> >> to
>> >>   void _rtl_rx_work(struct tasklet_struct *t).
>> >>
>> >> The initialization of rx_work_tasklet was still open-coded and the
>> >> function pointer just cast into the old type, and hence nothing sets
>> >> rx_work_tasklet.use_callback = true and the callback was still called as
>> >>
>> >>   t->func(t->data);
>> >>
>> >> with uninitialized/zero t->data.
>> >>
>> >> Commit 6b8c7574a5f8 changed the casting of _rtl_rx_work a bit and
>> >> initialized t->data to a pointer to the tasklet cast to an unsigned
>> >> long.
>> >>
>> >> This way calling t->func(t->data) might actually work through all the
>> >> casting, but it still doesn't update the code to use the new tasklet
>> >> API.
>> >>
>> >> Let's use the new tasklet_setup to initialize rx_work_tasklet properly
>> >> and set rx_work_tasklet.use_callback = true so that the callback is
>> >> called as
>> >>
>> >>   t->callback(t);
>> >>
>> >> without all the casting.
>> >>
>> >> Fixes: 6b8c7574a5f8 ("rtlwifi: fix build warning")
>> >> Fixes: d3ccc14dfe95 ("rtlwifi/rtw88: convert tasklets to use new
>> >> tasklet_setup() API")
>> >> Signed-off-by: Emil Renner Berthing <kernel@esmil.dk>
>> >
>> > Since the current code works, this could target net-next
>>
>> This should go to wireless-drivers-next, not net-next.
>>
>> > without Fixes tags.
>>
>> Correct, no need for Fixes tag as there's no bug to fix. This is only
>> cleanup AFAICS.

Forgot to mention that I can remove the Fixes tags during commit, so no
need to resend just because of those.

> I can definitely see how you can reasonably disagree, but I would not
> be comfortable having code that only works because the calling
> conventions of all relevant architectures happen to put the first
> unsigned long argument and the first pointer argument in the same
> register.

If there's a bug this patch fixes please explain it clearly in the
commit log. But as I read it (though I admit very quickly) I understood
this is just cleanup.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
