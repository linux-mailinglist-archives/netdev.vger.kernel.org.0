Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22D34FA944
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 05:58:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727140AbfKME6g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 23:58:36 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:50416 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726979AbfKME6f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 23:58:35 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id E62EE60A1D; Wed, 13 Nov 2019 04:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573621114;
        bh=/8Tlva5em/LSnhT8Vg5AUVKm/xL3Wg21CN8IPxwNqZ4=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=lyPhCI6fN/EJnfGGZM1sjwI/HsScZo4/oUtgPN2pWfKdio9wCAov+7IXoW2hiNVo3
         tarEHiJEQHB20EWe2Tg+rgEiFLZlyiq0GqbiPEWYnXXi7wh8K/E3bzwYG7BTWqJA0D
         vz6XW1AJq4EY+cUlVoxLBnGGSXlI6Vn1DrF+f5fc=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id E331A60913;
        Wed, 13 Nov 2019 04:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573621110;
        bh=/8Tlva5em/LSnhT8Vg5AUVKm/xL3Wg21CN8IPxwNqZ4=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=W8CON7SIdSb5+Pn5U3gsmoiFnZimeIo4u+K6B+0y43aPaFb1EEXT6xP3vncZtk4LX
         xxmdC1kFTsTdDXOB+9w9R0+8sQouo6siPQBdmur6f8FnMV9bE97Cij9ugPsK7schnQ
         O2sIw/nZxivPeL0S0kscU1XYiCOjrQ5qz++4/n+Y=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org E331A60913
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
Cc:     Simon Horman <simon.horman@netronome.com>, davem@davemloft.net,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, MSM <linux-arm-msm@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ath10k: Handle "invalid" BDFs for msm8998 devices
References: <20191106234712.2380-1-jeffrey.l.hugo@gmail.com>
        <20191112090444.ak2xu67eawfgpdgb@netronome.com>
        <CAOCk7NoXv2-8GO=VYS8dNPJF6sj=S3RbkfqQGW0kvvVmR8V1kw@mail.gmail.com>
Date:   Wed, 13 Nov 2019 06:58:25 +0200
In-Reply-To: <CAOCk7NoXv2-8GO=VYS8dNPJF6sj=S3RbkfqQGW0kvvVmR8V1kw@mail.gmail.com>
        (Jeffrey Hugo's message of "Tue, 12 Nov 2019 08:53:51 -0700")
Message-ID: <878soks77y.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jeffrey Hugo <jeffrey.l.hugo@gmail.com> writes:

> On Tue, Nov 12, 2019 at 2:04 AM Simon Horman <simon.horman@netronome.com> wrote:
>>
>> On Wed, Nov 06, 2019 at 03:47:12PM -0800, Jeffrey Hugo wrote:
>> > When the BDF download QMI message has the end field set to 1, it signals
>> > the end of the transfer, and triggers the firmware to do a CRC check.  The
>> > BDFs for msm8998 devices fail this check, yet the firmware is happy to
>> > still use the BDF.  It appears that this error is not caught by the
>> > downstream drive by concidence, therefore there are production devices
>> > in the field where this issue needs to be handled otherwise we cannot
>> > support wifi on them.  So, attempt to detect this scenario as best we can
>> > and treat it as non-fatal.
>> >
>> > Signed-off-by: Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
>> > ---
>> >  drivers/net/wireless/ath/ath10k/qmi.c | 11 +++++++----
>> >  1 file changed, 7 insertions(+), 4 deletions(-)
>> >
>> > diff --git a/drivers/net/wireless/ath/ath10k/qmi.c b/drivers/net/wireless/ath/ath10k/qmi.c
>> > index eb618a2652db..5ff8cfc93778 100644
>> > --- a/drivers/net/wireless/ath/ath10k/qmi.c
>> > +++ b/drivers/net/wireless/ath/ath10k/qmi.c
>> > @@ -265,10 +265,13 @@ static int ath10k_qmi_bdf_dnld_send_sync(struct ath10k_qmi *qmi)
>> >                       goto out;
>> >
>> >               if (resp.resp.result != QMI_RESULT_SUCCESS_V01) {
>> > -                     ath10k_err(ar, "failed to download board data file: %d\n",
>> > -                                resp.resp.error);
>> > -                     ret = -EINVAL;
>> > -                     goto out;
>> > +                     if (!(req->end == 1 &&
>> > +                           resp.resp.result == QMI_ERR_MALFORMED_MSG_V01)) {
>>
>> Would it make sense to combine the inner and outer condition,
>> something like this (completely untested) ?
>
> I guess, make sense from what perspective?  Looks like the assembly
> ends up being the same, so it would be down to "readability" which is
> subjective - I personally don't see a major advantage to one way or
> the other.  It does look like Kalle already picked up this patch, so
> I'm guessing that if folks feel your suggestion is superior, then it
> would need to be a follow on.

Same here, it's only on the pending branch so changes are still
possible.

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
