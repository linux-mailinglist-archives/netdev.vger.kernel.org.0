Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01F2AFA940
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 05:57:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727137AbfKME5c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 23:57:32 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:47782 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726979AbfKME5c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 23:57:32 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 5DDFA60A37; Wed, 13 Nov 2019 04:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573621051;
        bh=oLIySlzm4waF73QkfWLZI//4DD73A8oR0Svrmit18ig=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=KpuqFiw3V4zh2+iqt14Ai+g7Bg8b/gQmVj3u2uXbk2w6XAbk+6mMOQ/rbdxcaoLUJ
         y0eMYanu86bNuwTQb0Lje1dRGsS3LAfw/PQtPILdSZu9q7xKr4AEiUwulTso/ifC4l
         xupZ7XKP7wg6aHHKAxT7ja7kCTDb2yoiKPXPE0fI=
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
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D687260A0A;
        Wed, 13 Nov 2019 04:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573621049;
        bh=oLIySlzm4waF73QkfWLZI//4DD73A8oR0Svrmit18ig=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=UfHIW2C9MORMYVLzwOiuDEPOLILGK1lU6oRok92Sh9zYD2uORll36UC7pBoblhQK1
         3O2rSxgHQRU0TLihMVMYqfVsbq5ABxu+pEtAEmTBl2m9LD3kMElRWxga9/fbNczTYf
         6wOwsJQcxzt68H5geCAQtOlPpNFVVCPlwKM5RuaY=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org D687260A0A
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
Cc:     Simon Horman <simon.horman@netronome.com>, davem@davemloft.net,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, MSM <linux-arm-msm@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ath10k: Fix qmi init error handling
References: <20191106231650.1580-1-jeffrey.l.hugo@gmail.com>
        <20191112084225.casuncbo7z54vu4g@netronome.com>
        <CAOCk7NpNgtTSus2KtBMe=jGLFyBumVfRVxKxtHoEDUEt2-6tqQ@mail.gmail.com>
Date:   Wed, 13 Nov 2019 06:57:25 +0200
In-Reply-To: <CAOCk7NpNgtTSus2KtBMe=jGLFyBumVfRVxKxtHoEDUEt2-6tqQ@mail.gmail.com>
        (Jeffrey Hugo's message of "Tue, 12 Nov 2019 08:51:28 -0700")
Message-ID: <87d0dws79m.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jeffrey Hugo <jeffrey.l.hugo@gmail.com> writes:

> On Tue, Nov 12, 2019 at 1:42 AM Simon Horman <simon.horman@netronome.com> wrote:
>>
>> On Wed, Nov 06, 2019 at 03:16:50PM -0800, Jeffrey Hugo wrote:
>> > When ath10k_qmi_init() fails, the error handling does not free the irq
>> > resources, which causes an issue if we EPROBE_DEFER as we'll attempt to
>> > (re-)register irqs which are already registered.
>> >
>> > Fixes: ba94c753ccb4 ("ath10k: add QMI message handshake for wcn3990 client")
>> > Signed-off-by: Jeffrey Hugo <jeffrey.l.hugo@gmail.com>
>> > ---
>> >  drivers/net/wireless/ath/ath10k/snoc.c | 2 +-
>> >  1 file changed, 1 insertion(+), 1 deletion(-)
>> >
>> > diff --git a/drivers/net/wireless/ath/ath10k/snoc.c b/drivers/net/wireless/ath/ath10k/snoc.c
>> > index fc15a0037f0e..f2a0b7aaad3b 100644
>> > --- a/drivers/net/wireless/ath/ath10k/snoc.c
>> > +++ b/drivers/net/wireless/ath/ath10k/snoc.c
>> > @@ -1729,7 +1729,7 @@ static int ath10k_snoc_probe(struct platform_device *pdev)
>> >       ret = ath10k_qmi_init(ar, msa_size);
>> >       if (ret) {
>> >               ath10k_warn(ar, "failed to register wlfw qmi client: %d\n", ret);
>> > -             goto err_core_destroy;
>> > +             goto err_free_irq;
>> >       }
>>
>> From a casual examination of the code this seems like a step in the right
>> direction. But does this error path also need to call ath10k_hw_power_off() ?
>
> It probably should.  I don't see any fatal errors from the step being
> skipped, although it might silence some regulator warnings about being
> left on.  Unlikely to be observed by most folks as I was initing the
> driver pretty early to debug some things.  Looks like Kalle already
> picked up this patch though, so I guess your suggestion would need to
> be a follow up.

Actually it's only in the pending branch, which means that the patch can
be changed or a new version can be submitted:

https://wireless.wiki.kernel.org/en/users/drivers/ath10k/submittingpatches#patch_flow

The easiest way to check the state of a wireless patch is from
patchwork:

https://patchwork.kernel.org/patch/11231325/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#checking_state_of_patches_from_patchwork

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
