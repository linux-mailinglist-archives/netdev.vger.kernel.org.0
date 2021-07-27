Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ACEF3D7509
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 14:27:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236528AbhG0M0y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 08:26:54 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:18083 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231981AbhG0M0x (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Jul 2021 08:26:53 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1627388813; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=Q6hAM6vysUdsneiXBqcVC/h93AYOHGPjOJpOhDCKNt0=; b=pCxrMPpV+aaGvpvbw1apMeYgyS7lI2y0DOhNjdVtDwSvPo887QAZ5i2KcsDJyWzGKsMDT680
 dZXtqyMRfiA0PGZTWjXDtE8Z7hAx0cYbCxeF/8iBPRUrL+wjjh8gJOrKvaQaN1CGw+vut/Af
 KaVvV/ebtRSV+hWlhyEb1dY4zrg=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-east-1.postgun.com with SMTP id
 60fffb6e1dd16c87888e8e96 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 27 Jul 2021 12:26:22
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 34AC4C433F1; Tue, 27 Jul 2021 12:26:21 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from tykki (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id ECF58C433F1;
        Tue, 27 Jul 2021 12:26:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org ECF58C433F1
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Julian Calaby <julian.calaby@gmail.com>
Cc:     Dongliang Mu <mudongliangabcd@gmail.com>,
        QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Brooke Basile <brookebasile@gmail.com>,
        syzbot+6692c72009680f7c4eb2@syzkaller.appspotmail.com,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ath9k: hif_usb: fix memory leak in ath9k_hif_usb_firmware_cb
References: <20210709084351.2087311-1-mudongliangabcd@gmail.com>
        <CAGRGNgUNnf=62xnFE4zUiVJ+n6NyGjFUmdR2JChbRkhsDSy0Yw@mail.gmail.com>
Date:   Tue, 27 Jul 2021 15:26:14 +0300
In-Reply-To: <CAGRGNgUNnf=62xnFE4zUiVJ+n6NyGjFUmdR2JChbRkhsDSy0Yw@mail.gmail.com>
        (Julian Calaby's message of "Tue, 27 Jul 2021 17:24:44 +1000")
Message-ID: <877dhcgcyh.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Julian Calaby <julian.calaby@gmail.com> writes:

> Hi Dongliang,
>
> (Drive-by review, I know almost nothing about the code in question)
>
> On Fri, Jul 9, 2021 at 6:47 PM Dongliang Mu <mudongliangabcd@gmail.com> wrote:
>>
>> The commit 03fb92a432ea ("ath9k: hif_usb: fix race condition between
>> usb_get_urb() and usb_kill_anchored_urbs()") adds three usb_get_urb
>> in ath9k_hif_usb_dealloc_tx_urbs and usb_free_urb.
>>
>> Fix this bug by adding corresponding usb_free_urb in
>> ath9k_hif_usb_dealloc_tx_urbs other and hif_usb_stop.
>>
>> Reported-by: syzbot+6692c72009680f7c4eb2@syzkaller.appspotmail.com
>> Fixes: 03fb92a432ea ("ath9k: hif_usb: fix race condition between usb_get_urb() and usb_kill_anchored_urbs()")
>> Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
>> ---
>>  drivers/net/wireless/ath/ath9k/hif_usb.c | 3 +++
>>  1 file changed, 3 insertions(+)
>>
>> diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
>> index 860da13bfb6a..bda91ff3289b 100644
>> --- a/drivers/net/wireless/ath/ath9k/hif_usb.c
>> +++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
>> @@ -457,6 +457,7 @@ static void hif_usb_stop(void *hif_handle)
>>                 usb_kill_urb(tx_buf->urb);
>>                 list_del(&tx_buf->list);
>>                 usb_free_urb(tx_buf->urb);
>> +               usb_free_urb(tx_buf->urb);
>
> Ok, so if I'm reading this correctly, before the first usb_free_urb()
> call, we have two references to the urb at tx_buf->urb.
>
> Why?
>
> Isn't the better fix here to detangle why there's more than one
> reference to it and resolve it that way? This looks like a hack to fix
> something much more fundamentally broken.

Yeah, this looks very suspicious.

One more thing: also the patch should be tested with real hardware. I'm
worried that people are just trying to fix a syzbot warning and not
really considering how it works in real life. That's why I'm extra
careful with syzbot patches for wireless drivers.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
