Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CE553667A0
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 11:08:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235762AbhDUJIc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 05:08:32 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:62717 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235170AbhDUJIb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 05:08:31 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1618996079; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=OX6XiY6joBfdyzSpmKbHuqcmnZRR1EQFEvTqQUGxAWo=; b=fMgEVtHLnsgqze9YydJRqnHdYp3N1l5SJqsbfdqAwiBI6WJdDzqhGcH2PW8oIfi9U39R0qIL
 +FglBMhoiUGMoLIFvxgwyFQZrEzIWzlqpf84+Xao4OPEZvJiUSiLpmn9IF+hYTNT81YrdRQd
 Z8TDFl66ElbLuYlZZ3w4SDxs6iQ=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-west-2.postgun.com with SMTP id
 607feb54f34440a9d470a601 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 21 Apr 2021 09:07:32
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 648BDC43147; Wed, 21 Apr 2021 09:07:31 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D3F43C43217;
        Wed, 21 Apr 2021 09:07:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org D3F43C43217
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Joe Perches <joe@perches.com>
Cc:     Colin King <colin.king@canonical.com>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Chung-hsien Hsu <chung-hsien.hsu@infineon.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] brcmsmac: fix shift on 4 bit masked value
References: <20210318164513.19600-1-colin.king@canonical.com>
        <20210418061021.AB25CC43217@smtp.codeaurora.org>
        <78ad5b527aa1da06569fd5ae422ea2a403ef40a0.camel@perches.com>
Date:   Wed, 21 Apr 2021 12:07:24 +0300
In-Reply-To: <78ad5b527aa1da06569fd5ae422ea2a403ef40a0.camel@perches.com> (Joe
        Perches's message of "Sun, 18 Apr 2021 00:58:40 -0700")
Message-ID: <87pmyoj99v.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Joe Perches <joe@perches.com> writes:

> On Sun, 2021-04-18 at 06:10 +0000, Kalle Valo wrote:
>> Colin King <colin.king@canonical.com> wrote:
>> 
>> > From: Colin Ian King <colin.king@canonical.com>
>> > 
>> > The calculation of offtune_val seems incorrect, the u16 value in
>> > pi->tx_rx_cal_radio_saveregs[2] is being masked with 0xf0 and then
>> > shifted 8 places right so that always ends up as a zero result. I
>> > believe the intended shift was 4 bits to the right. Fix this.
>> > 
>> > [Note: not tested, I don't have the H/W]
>> > 
>> > Addresses-Coverity: ("Operands don't affect result")
>> > Fixes: 5b435de0d786 ("net: wireless: add brcm80211 drivers")
>> > Signed-off-by: Colin Ian King <colin.king@canonical.com>
>> 
>> I think this needs review from someone familiar with the hardware.
>> 
>> Patch set to Changes Requested.
>
> What "change" are you requesting here?

Don't take patchwork states literally, a better name for this state
would be "Needs work" or something like that.

> Likely there needs to be some other setting for the patch.
>
> Perhaps "deferred" as you seem to be requesting a review
> and there's no actual change necessary, just approval from
> someone with the hardware and that someone test the patch.

I already asked for help on April 7th and nobody replied, so I'm
dropping this now. The patch can be resent if/when the change is
confirmed to be correct.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
