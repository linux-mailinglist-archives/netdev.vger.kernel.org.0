Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D5BA124660
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 13:02:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726922AbfLRMC1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 07:02:27 -0500
Received: from mail25.static.mailgun.info ([104.130.122.25]:63482 "EHLO
        mail25.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726591AbfLRMC1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 07:02:27 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1576670546; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=B4/RlwWd+D6Up8aRuxBevuGNVTwp4B7x7EDttVNYIiA=; b=JzmkTD4gJHSur/m0zYaxnSqfCHiu13B1y00q04C1xuTJNO6Kwy6jbQqBxJOvn2SmFqqcAZ9J
 wLT0s1CLr8PkBiQT+1AaI5SI9XMG489N/T7PvjwY5GcvgnCDuiHuGi/9N1055XSuAdvIsmv4
 QMw8KvUxTRIApx+6lA0UdSfCt50=
X-Mailgun-Sending-Ip: 104.130.122.25
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5dfa1551.7fd173ba7420-smtp-out-n02;
 Wed, 18 Dec 2019 12:02:25 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 76B02C4479F; Wed, 18 Dec 2019 12:02:24 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 2EA18C43383;
        Wed, 18 Dec 2019 12:02:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 2EA18C43383
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Jia-Ju Bai <baijiaju1990@gmail.com>
Cc:     ath9k-devel@qca.qualcomm.com, davem@davemloft.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ath9k: fix possible sleep-in-atomic-context bugs in hif_usb_send_regout()
References: <20191218114533.9268-1-baijiaju1990@gmail.com>
Date:   Wed, 18 Dec 2019 14:02:19 +0200
In-Reply-To: <20191218114533.9268-1-baijiaju1990@gmail.com> (Jia-Ju Bai's
        message of "Wed, 18 Dec 2019 19:45:33 +0800")
Message-ID: <87h81xc050.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jia-Ju Bai <baijiaju1990@gmail.com> writes:

> The driver may sleep while holding a spinlock.
> The function call path (from bottom to top) in Linux 4.19 is:
>
> drivers/net/wireless/ath/ath9k/hif_usb.c, 108: 
> 	usb_alloc_urb(GFP_KERNEL) in hif_usb_send_regout
> drivers/net/wireless/ath/ath9k/hif_usb.c, 470: 
> 	hif_usb_send_regout in hif_usb_send
> drivers/net/wireless/ath/ath9k/htc_hst.c, 34: 
> 	(FUNC_PTR)hif_usb_send in htc_issue_send
> drivers/net/wireless/ath/ath9k/htc_hst.c, 295: 
> 	htc_issue_send in htc_send
> drivers/net/wireless/ath/ath9k/htc_drv_beacon.c, 250: 
> 	htc_send in ath9k_htc_send_beacon
> drivers/net/wireless/ath/ath9k/htc_drv_beacon.c, 207: 
> 	spin_lock_bh in ath9k_htc_send_beacon
>
> drivers/net/wireless/ath/ath9k/hif_usb.c, 112: 
> 	kzalloc(GFP_KERNEL) in hif_usb_send_regout
> drivers/net/wireless/ath/ath9k/hif_usb.c, 470: 
> 	hif_usb_send_regout in hif_usb_send
> drivers/net/wireless/ath/ath9k/htc_hst.c, 34: 
> 	(FUNC_PTR)hif_usb_send in htc_issue_send
> drivers/net/wireless/ath/ath9k/htc_hst.c, 295: 
> 	htc_issue_send in htc_send
> drivers/net/wireless/ath/ath9k/htc_drv_beacon.c, 250: 
> 	htc_send in ath9k_htc_send_beacon
> drivers/net/wireless/ath/ath9k/htc_drv_beacon.c, 207: 
> 	spin_lock_bh in ath9k_htc_send_beacon
>
> drivers/net/wireless/ath/ath9k/hif_usb.c, 127: 
> 	usb_submit_urb(GFP_KERNEL) in hif_usb_send_regout
> drivers/net/wireless/ath/ath9k/hif_usb.c, 470: 
> 	hif_usb_send_regout in hif_usb_send
> drivers/net/wireless/ath/ath9k/htc_hst.c, 34: 
> 	(FUNC_PTR)hif_usb_send in htc_issue_send
> drivers/net/wireless/ath/ath9k/htc_hst.c, 295: 
> 	htc_issue_send in htc_send
> drivers/net/wireless/ath/ath9k/htc_drv_beacon.c, 250: 
> 	htc_send in ath9k_htc_send_beacon
> drivers/net/wireless/ath/ath9k/htc_drv_beacon.c, 207: 
> 	spin_lock_bh in ath9k_htc_send_beacon
>
> (FUNC_PTR) means a function pointer is called.
>
> To fix these bugs, GFP_KERNEL is replaced with GFP_ATOMIC.
>
> These bugs are found by a static analysis tool STCheck written by myself.
>
> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>

Can someone else verify this and provide Reviewed-by?

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
