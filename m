Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 312323E26BD
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 11:06:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244076AbhHFJGu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 05:06:50 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:46574 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231559AbhHFJGs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Aug 2021 05:06:48 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1628240793; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=eGRB1c7R3wNbeGgi5/cgrfgmx0N/n1KWYXBimiwCgjs=; b=FcT1PcGs0A09vD8110JWzOu64HuXU7AsAO1tu2n7g3SJC5MVw4+L7J8EEMa2zG/GMWiAUh/x
 k45iO2k/wSaQ/yTm1V6MwvdaRPPSeioMP266ifrBXWtaxXxUZNphau9lD0F8zgJdQMi/hAuW
 m6WBKvvgp8lAL9SCelQ7EKmiPFo=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-east-1.postgun.com with SMTP id
 610cfb94ad1af63949db21ab (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 06 Aug 2021 09:06:28
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 13CDBC4323A; Fri,  6 Aug 2021 09:06:28 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from tykki (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 54EA7C433F1;
        Fri,  6 Aug 2021 09:06:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 54EA7C433F1
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     ath9k-devel@qca.qualcomm.com, davem@davemloft.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        syzbot+03110230a11411024147@syzkaller.appspotmail.com
Subject: Re: [PATCH] net: ath9k: fix use-after-free in ath9k_hif_usb_rx_cb
References: <20210804194841.14544-1-paskripkin@gmail.com>
Date:   Fri, 06 Aug 2021 12:06:17 +0300
In-Reply-To: <20210804194841.14544-1-paskripkin@gmail.com> (Pavel Skripkin's
        message of "Wed, 4 Aug 2021 22:48:41 +0300")
Message-ID: <87sfznaqnq.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pavel Skripkin <paskripkin@gmail.com> writes:

> Syzbot reported use-after-free Read in ath9k_hif_usb_rx_cb(). The
> problem was in incorrect htc_handle->drv_priv initialization.
>
> Probable call trace which can trigger use-after-free:
>
> ath9k_htc_probe_device()
>   /* htc_handle->drv_priv = priv; */
>   ath9k_htc_wait_for_target()      <--- Failed
>   ieee80211_free_hw()		   <--- priv pointer is freed
>
> <IRQ>
> ...
> ath9k_hif_usb_rx_cb()
>   ath9k_hif_usb_rx_stream()
>    RX_STAT_INC()		<--- htc_handle->drv_priv access
>
> In order to not add fancy protection for drv_priv we can move
> htc_handle->drv_priv initialization at the end of the
> ath9k_htc_probe_device() and add helper macro to make
> all *_STAT_* macros NULL save.
>
> Also, I made whitespaces clean ups in *_STAT_* macros definitions
> to make checkpatch.pl happy.

Separate patch for cleanups, please.

> Fixes: fb9987d0f748 ("ath9k_htc: Support for AR9271 chipset.")
> Reported-and-tested-by: syzbot+03110230a11411024147@syzkaller.appspotmail.com
> Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
> ---
>
> Hi, ath9k maintainer/developers!
>
> I know, that you do not like changes, that wasn't tested on real
> hardware. I really don't access to this one, so I'd like you to test it on
> real hardware piece, if you have one. At least, this patch was tested by
> syzbot [1]
>
> [1] https://syzkaller.appspot.com/bug?id=6ead44e37afb6866ac0c7dd121b4ce07cb665f60

syzbot does not equal testing on real hardware. Can someone test or
review this, please?

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
