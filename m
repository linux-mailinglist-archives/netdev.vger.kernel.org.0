Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C4FA2AA4A1
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 12:23:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727901AbgKGLXi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 06:23:38 -0500
Received: from z5.mailgun.us ([104.130.96.5]:42467 "EHLO z5.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726242AbgKGLXh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 7 Nov 2020 06:23:37 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1604748216; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=zS6LvfRtNdiUkeSXeykO/m6acIjMHUD9ACoUZ1OClsU=; b=DU8TSiReszkfEJeff5XNbTvC0YHCWuwFz07EJE1W6QhcKy/f7fTlsPQHKO1bpvaSahUGpBps
 2pP9XS78Y4QO4/vkFYMFbgaMENm9zDeBvihKE0s+EkKGzctp2x1tCHUq+rICwGLuxd5eB7lp
 bFZL33KbEvGzJdNEoUAdckNJtQs=
X-Mailgun-Sending-Ip: 104.130.96.5
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-west-2.postgun.com with SMTP id
 5fa683b861a7f890a693db06 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sat, 07 Nov 2020 11:23:36
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id D53BAC433F0; Sat,  7 Nov 2020 11:23:35 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 2A814C433C6;
        Sat,  7 Nov 2020 11:23:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 2A814C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Alex Dewar <alex.dewar90@gmail.com>
Cc:     netdev@vger.kernel.org, Carl Huang <cjhuang@codeaurora.org>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        ath11k@lists.infradead.org, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH 2/2] ath11k: Handle errors if peer creation fails
References: <20201004100218.311653-1-alex.dewar90@gmail.com>
        <87blhfbysb.fsf@codeaurora.org>
        <20201006081321.e2tf5xrdhnk4j3nq@medion>
Date:   Sat, 07 Nov 2020 13:23:30 +0200
In-Reply-To: <20201006081321.e2tf5xrdhnk4j3nq@medion> (Alex Dewar's message of
        "Tue, 6 Oct 2020 09:13:21 +0100")
Message-ID: <87pn4pfm19.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alex Dewar <alex.dewar90@gmail.com> writes:

> On Tue, Oct 06, 2020 at 10:26:28AM +0300, Kalle Valo wrote:
>> Alex Dewar <alex.dewar90@gmail.com> writes:
>> 
>> > ath11k_peer_create() is called without its return value being checked,
>> > meaning errors will be unhandled. Add missing check and, as the mutex is
>> > unconditionally unlocked on leaving this function, simplify the exit
>> > path.
>> >
>> > Addresses-Coverity-ID: 1497531 ("Code maintainability issues")
>> > Fixes: 701e48a43e15 ("ath11k: add packet log support for QCA6390")
>> > Signed-off-by: Alex Dewar <alex.dewar90@gmail.com>
>> > ---
>> >  drivers/net/wireless/ath/ath11k/mac.c | 21 +++++++++------------
>> >  1 file changed, 9 insertions(+), 12 deletions(-)
>> >
>> > diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
>> > index 7f8dd47d2333..58db1b57b941 100644
>> > --- a/drivers/net/wireless/ath/ath11k/mac.c
>> > +++ b/drivers/net/wireless/ath/ath11k/mac.c
>> > @@ -5211,7 +5211,7 @@ ath11k_mac_op_assign_vif_chanctx(struct ieee80211_hw *hw,
>> >  	struct ath11k *ar = hw->priv;
>> >  	struct ath11k_base *ab = ar->ab;
>> >  	struct ath11k_vif *arvif = (void *)vif->drv_priv;
>> > -	int ret;
>> > +	int ret = 0;
>> 
>> I prefer not to initialise the ret variable.
>> 
>> >  	arvif->is_started = true;
>> >  
>> >  	/* TODO: Setup ps and cts/rts protection */
>> >  
>> > -	mutex_unlock(&ar->conf_mutex);
>> > -
>> > -	return 0;
>> > -
>> > -err:
>> > +unlock:
>> >  	mutex_unlock(&ar->conf_mutex);
>> >  
>> >  	return ret;
>> 
>> So in the pending branch I changed this to:
>> 
>> 	ret = 0;
>> 
>> out:
>> 	mutex_unlock(&ar->conf_mutex);
>> 
>> 	return ret;
>> 
>> Please check.
>
> I'm afraid you've introduced a bug ;). The body of the first if-statement
> in the function doesn't set ret because no error has occurred. So now
> it'll jump to the label and the function will return ret uninitialized.

Ouch, so I did. Good catch! I would have hoped that GCC warns about that
but it didn't.

I fixed the bug and added also a warning messages if peer_create()
fails:

https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/commit/?h=pending&id=e3e7b8072fa6bb0928b9066cf76e19e6bd2ec663

Does this look better now? :)

> With the gcc extension, ret will be initialised to zero anyway, so we're
> not saving anything by explicitly assigning to ret later in the
> function.

I prefer not to initialise ret in the beginning of the function and I
try to maintain that style in ath11k. I think it's more readable that
the error value is assigned just before the goto.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
