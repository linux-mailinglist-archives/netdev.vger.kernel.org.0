Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B7D53160FA
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 09:28:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231354AbhBJI1i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 03:27:38 -0500
Received: from mail29.static.mailgun.info ([104.130.122.29]:33010 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230118AbhBJI0c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 03:26:32 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1612945572; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=9EoJ98RLCOjfNGA9m9IWMD0BBEcL08tR1uiW4fkuRXk=; b=FL9knDF+/FuCTnXp3ItWpaSFXJ1xuYx+To1aAOZObVcBeLYLPRNZ5YJ64H5oAAIujMzXe/zA
 Z/aP0R5sbjFcY0FNGF2t9/NQ7c7YnAmRCX/XaY+mlR3LcuLkuRCt+8LIHhVhxop0ZeX7MCxy
 k3FtpsEk+G3fJ5RH9TyyxAVSKgQ=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-west-2.postgun.com with SMTP id
 6023988434db06ef79edb787 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 10 Feb 2021 08:25:40
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 035F8C433ED; Wed, 10 Feb 2021 08:25:39 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 4F74CC433ED;
        Wed, 10 Feb 2021 08:25:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 4F74CC433ED
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        ath10k@lists.infradead.org
Subject: Re: [PATCH 4/5] ath10k: detect conf_mutex held ath10k_drain_tx() calls
References: <cover.1612915444.git.skhan@linuxfoundation.org>
        <a980abfb143f5240375f3f1046f0f26971c695e6.1612915444.git.skhan@linuxfoundation.org>
Date:   Wed, 10 Feb 2021 10:25:35 +0200
In-Reply-To: <a980abfb143f5240375f3f1046f0f26971c695e6.1612915444.git.skhan@linuxfoundation.org>
        (Shuah Khan's message of "Tue, 9 Feb 2021 17:42:25 -0700")
Message-ID: <87lfbwtjls.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Shuah Khan <skhan@linuxfoundation.org> writes:

> ath10k_drain_tx() must not be called with conf_mutex held as workers can
> use that also. Add check to detect conf_mutex held calls.
>
> Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>

The commit log does not answer to "Why?". How did you find this? What
actual problem are you trying to solve?

> ---
>  drivers/net/wireless/ath/ath10k/mac.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
> index 53f92945006f..3545ce7dce0a 100644
> --- a/drivers/net/wireless/ath/ath10k/mac.c
> +++ b/drivers/net/wireless/ath/ath10k/mac.c
> @@ -4566,6 +4566,7 @@ static void ath10k_mac_op_wake_tx_queue(struct ieee80211_hw *hw,
>  /* Must not be called with conf_mutex held as workers can use that also. */
>  void ath10k_drain_tx(struct ath10k *ar)
>  {
> +	WARN_ON(lockdep_is_held(&ar->conf_mutex));

Empty line after WARN_ON().

Shouldn't this check debug_locks similarly lockdep_assert_held() does?

#define lockdep_assert_held(l)	do {				\
		WARN_ON(debug_locks && !lockdep_is_held(l));	\
	} while (0)

And I suspect you need #ifdef CONFIG_LOCKDEP which should fix the kbuild
bot error.

But honestly I would prefer to have lockdep_assert_not_held() in
include/linux/lockdep.h, much cleaner that way. Also
i915_gem_object_lookup_rcu() could then use the same macro.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
