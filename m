Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A09703D6E9A
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 08:02:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235386AbhG0GC2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 02:02:28 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:61181 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235406AbhG0GC1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 02:02:27 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1627365747; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=LZqKYy1v64NNofFiaZNW6zb9oWb1tmIOWKvk53k8Qt8=; b=kXyl8vc8/Qttc5qFMNESUvBOLx5iI9cYfoiHb6wSfRkVQRai5RngZEMkic/gAZbegg+K9jvT
 6A6irTN9pF8Z6fAm8VJTHuYxMfbqpvxUAOQJBMOo920nm+SXFN20APlVjm3LacAY2kraWDvW
 csAKrq7qPfVo5dkPf7CC96s/HYM=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-west-2.postgun.com with SMTP id
 60ffa1729771b05b24811da4 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 27 Jul 2021 06:02:26
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 446B9C43145; Tue, 27 Jul 2021 06:02:26 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from tykki (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 66387C433F1;
        Tue, 27 Jul 2021 06:02:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 66387C433F1
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Dongliang Mu <mudongliangabcd@gmail.com>
Cc:     ath9k-devel@qca.qualcomm.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Brooke Basile <brookebasile@gmail.com>,
        syzbot+6692c72009680f7c4eb2@syzkaller.appspotmail.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ath9k: hif_usb: fix memory leak in ath9k_hif_usb_firmware_cb
References: <20210709084351.2087311-1-mudongliangabcd@gmail.com>
Date:   Tue, 27 Jul 2021 09:02:21 +0300
In-Reply-To: <20210709084351.2087311-1-mudongliangabcd@gmail.com> (Dongliang
        Mu's message of "Fri, 9 Jul 2021 16:43:51 +0800")
Message-ID: <87r1fkguqa.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dongliang Mu <mudongliangabcd@gmail.com> writes:

> The commit 03fb92a432ea ("ath9k: hif_usb: fix race condition between
> usb_get_urb() and usb_kill_anchored_urbs()") adds three usb_get_urb
> in ath9k_hif_usb_dealloc_tx_urbs and usb_free_urb.
>
> Fix this bug by adding corresponding usb_free_urb in
> ath9k_hif_usb_dealloc_tx_urbs other and hif_usb_stop.
>
> Reported-by: syzbot+6692c72009680f7c4eb2@syzkaller.appspotmail.com
> Fixes: 03fb92a432ea ("ath9k: hif_usb: fix race condition between usb_get_urb() and usb_kill_anchored_urbs()")
> Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>

In the past there have been so many problems with ath9k syzbot fixes
that I have now a hard time trusting them. Can someone review this in
detail, please?

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
