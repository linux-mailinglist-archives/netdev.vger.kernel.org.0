Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F01103DCB3E
	for <lists+netdev@lfdr.de>; Sun,  1 Aug 2021 12:42:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231670AbhHAKnE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Aug 2021 06:43:04 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:20052 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231473AbhHAKnE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 1 Aug 2021 06:43:04 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1627814576; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=2FG8QOpXnwfsbiJCBm93zOuOMBxth1HO6MjmY+P4JDM=; b=xS7RA+CSA0TKQM5XIehBjgRtS9GVmSMtti3Ww4dVRWhtZYHZl+iPNDCQnvXeUFPsDepIAMym
 U/jeZdeCRT/EJi61qvFPYFR0mZRMbdTspCYaVSfnDuQhUH5eqku5jJ9VSsjiVZ7H2jYgG7Q1
 t1YXKgieqCI358xnUwfIFsTtj14=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-west-2.postgun.com with SMTP id
 61067a96e31d882d18c2e679 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sun, 01 Aug 2021 10:42:30
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 78BA0C4338A; Sun,  1 Aug 2021 10:42:30 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from tykki (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 73176C433F1;
        Sun,  1 Aug 2021 10:42:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 73176C433F1
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     chris.chiu@canonical.com
Cc:     Jes.Sorensen@gmail.com, davem@davemloft.net, kuba@kernel.org,
        code@reto-schneider.ch, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rtl8xxxu: Fix the handling of TX A-MPDU aggregation
References: <20210630160151.28227-1-chris.chiu@canonical.com>
Date:   Sun, 01 Aug 2021 13:42:23 +0300
In-Reply-To: <20210630160151.28227-1-chris.chiu@canonical.com> (chris chiu's
        message of "Thu, 1 Jul 2021 00:01:51 +0800")
Message-ID: <87k0l5e99s.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

chris.chiu@canonical.com writes:

> From: Chris Chiu <chris.chiu@canonical.com>
>
> The TX A-MPDU aggregation is not handled in the driver since the
> ieee80211_start_tx_ba_session has never been started properly.
> Start and stop the TX BA session by tracking the TX aggregation
> status of each TID. Fix the ampdu_action and the tx descriptor
> accordingly with the given TID.
>
> Signed-off-by: Chris Chiu <chris.chiu@canonical.com>
> ---
>  .../net/wireless/realtek/rtl8xxxu/rtl8xxxu.h  |  2 ++
>  .../wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 33 ++++++++++++++-----
>  2 files changed, 26 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
> index d1a566cc0c9e..3f7ff84f2056 100644
> --- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
> +++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
> @@ -1383,6 +1383,8 @@ struct rtl8xxxu_priv {
>  	u8 no_pape:1;
>  	u8 int_buf[USB_INTR_CONTENT_LENGTH];
>  	u8 rssi_level;
> +	bool tx_aggr_started[IEEE80211_NUM_TIDS];

Why do you use bool of arrays? That looks racy to me. Wouldn't
DECLARE_BITMAP() be safer, like tid_bitmap uses?

> +	DECLARE_BITMAP(tid_bitmap, IEEE80211_NUM_TIDS);

I would rename this to a more descriptive name, like tid_tx_operational.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
