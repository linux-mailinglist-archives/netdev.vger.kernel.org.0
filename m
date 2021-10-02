Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1EB341FC1B
	for <lists+netdev@lfdr.de>; Sat,  2 Oct 2021 15:11:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233281AbhJBNNX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Oct 2021 09:13:23 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:19027 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233255AbhJBNNS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 2 Oct 2021 09:13:18 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1633180292; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=U56aPpP9fNQficQEnaop9Sqfh0G91mtG/y8HvE9u/Sg=; b=XzfL5+m6+mIaNhMW2rSaikP+dEzren9cgnIfn6T996OtJfMkz/UdrYO7mkW5lBJvqSoxWwWA
 Ji7vvUGlLO93apMHCVSGH9U6dhGDYb0Ao/A6zRvSBnFf2qT1BSjxosZ5uJ+u9QLMpeSlnTud
 /OMvq0bhf4JMWa9LE7ZKOsRDsMk=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-west-2.postgun.com with SMTP id
 61585a7d47d64efb6dea8e54 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sat, 02 Oct 2021 13:11:25
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 521A7C4361B; Sat,  2 Oct 2021 13:11:25 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from tykki (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 5381EC4338F;
        Sat,  2 Oct 2021 13:11:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 5381EC4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     ath9k-devel@qca.qualcomm.com, davem@davemloft.net, kuba@kernel.org,
        Sujith.Manoharan@atheros.com, linville@tuxdriver.com,
        vasanth@atheros.com, senthilkumar@atheros.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+03110230a11411024147@syzkaller.appspotmail.com,
        syzbot+c6dde1f690b60e0b9fbe@syzkaller.appspotmail.com
Subject: Re: [PATCH RESEND] net: ath9k: fix use-after-free in ath9k_hif_usb_rx_cb
References: <4e1374b1-74e4-22ea-d5e0-7cf592a0b65b@gmail.com>
        <20210922164204.32680-1-paskripkin@gmail.com>
        <9bbf1f36-2878-69d1-f262-614d3cb66328@gmail.com>
Date:   Sat, 02 Oct 2021 16:11:18 +0300
In-Reply-To: <9bbf1f36-2878-69d1-f262-614d3cb66328@gmail.com> (Pavel
        Skripkin's message of "Sat, 2 Oct 2021 16:05:47 +0300")
Message-ID: <87pmsnh8qx.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pavel Skripkin <paskripkin@gmail.com> writes:

> On 9/22/21 19:42, Pavel Skripkin wrote:
>> Syzbot reported use-after-free Read in ath9k_hif_usb_rx_cb(). The
>> problem was in incorrect htc_handle->drv_priv initialization.
>>
>> Probable call trace which can trigger use-after-free:
>>
>> ath9k_htc_probe_device()
>>    /* htc_handle->drv_priv = priv; */
>>    ath9k_htc_wait_for_target()      <--- Failed
>>    ieee80211_free_hw()		   <--- priv pointer is freed
>>
>> <IRQ>
>> ...
>> ath9k_hif_usb_rx_cb()
>>    ath9k_hif_usb_rx_stream()
>>     RX_STAT_INC()		<--- htc_handle->drv_priv access
>>
>> In order to not add fancy protection for drv_priv we can move
>> htc_handle->drv_priv initialization at the end of the
>> ath9k_htc_probe_device() and add helper macro to make
>> all *_STAT_* macros NULL save.
>>
>> Fixes: fb9987d0f748 ("ath9k_htc: Support for AR9271 chipset.")
>> Reported-and-tested-by: syzbot+03110230a11411024147@syzkaller.appspotmail.com
>> Reported-and-tested-by: syzbot+c6dde1f690b60e0b9fbe@syzkaller.appspotmail.com
>> Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
>> ---
>>
>> Why resend?
>> 	No activity on this patch since 8/6/21, Kalle Valo has asked around,
>> 	for review and no one claimed it.
>>
>> Resend changes:
>> 	1. Rebased on top of v5.15-rc2
>> 	2. Removed clean ups for macros
>> 	3. Added 1 more syzbot tag, since this patch has passed 2 syzbot
>> 	tests
>>
>
> Hi, ath9k maintainers!
>
> Does this patch need any further work? I can't see any comments on it
> since 8/6/21 and I can't see it on wireless patchwork.
>
> If this bug is already fixed and I've overlooked a fix commit, please,
> let me know. As I see syzbot hits this bug really often [1]

See my other mail I just sent about ath9k syzbot patches:

https://lore.kernel.org/linux-wireless/87tuhzhdyq.fsf@codeaurora.org/

In summary: please wait patiently once I'm able to test the syzbot
patches on a real device.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
