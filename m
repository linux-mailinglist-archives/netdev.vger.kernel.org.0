Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20CE4441C44
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 15:09:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232174AbhKAOMY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 10:12:24 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:49111 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229826AbhKAOMY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 10:12:24 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1635775790; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=CvtnDpKjW8pQbenyBtfylZcE3DM2k5AZjm8hFYUwq1E=; b=airuP4O6s3lRpEqx3UhkBBIBEmNHgSgWkCKVy/f1tsvZ5Wu/InhFdgn4wG9JxQJdYX4GjshR
 9vzlohqS0+qHf9lxJR7VlE9ekvkyGdj+DauCZnmIuc7xeN52TD7VTrJwQMoDaUuiOdJfjF5T
 3wgJtlBXkr/M0li7kU47oupxzvU=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-west-2.postgun.com with SMTP id
 617ff4aeaeb23905560c9fba (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 01 Nov 2021 14:07:42
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 9C808C43617; Mon,  1 Nov 2021 14:07:42 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from tykki (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id EBF4BC4360D;
        Mon,  1 Nov 2021 14:07:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org EBF4BC4360D
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Zekun Shen <bruceshenzk@gmail.com>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Siva Rebbagondla <siva8118@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, brendandg@nyu.edu
Subject: Re: [PATCH] rsi_usb: Fix out-of-bounds read in rsi_read_pkt
References: <YXxXS4wgu2OsmlVv@10-18-43-117.dynapool.wireless.nyu.edu>
Date:   Mon, 01 Nov 2021 16:07:37 +0200
In-Reply-To: <YXxXS4wgu2OsmlVv@10-18-43-117.dynapool.wireless.nyu.edu> (Zekun
        Shen's message of "Fri, 29 Oct 2021 16:19:23 -0400")
Message-ID: <87tugw0y1i.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Zekun Shen <bruceshenzk@gmail.com> writes:

> rsi_get_* functions rely on an offset variable from usb
> input. The size of usb input is RSI_MAX_RX_USB_PKT_SIZE(3000),
> while 2-byte offset can be up to 0xFFFF. Thus a large offset
> can cause out-of-bounds read.
>
> The patch adds a bound checking condition when rcv_pkt_len is 0,
> indicating it's USB. It's unclear whether this is triggerable
> from other type of bus. The following check might help in that case.
> offset > rcv_pkt_len - FRAME_DESC_SZ
>
> The bug is trigerrable with conpromised/malfunctioning USB devices.
> I tested the patch with the crashing input and got no more bug report.
>
> Attached is the KASAN report from fuzzing.
>
> BUG: KASAN: slab-out-of-bounds in rsi_read_pkt+0x42e/0x500 [rsi_91x]
> Read of size 2 at addr ffff888019439fdb by task RX-Thread/227
>
> CPU: 0 PID: 227 Comm: RX-Thread Not tainted 5.6.0 #66
> Call Trace:
>  dump_stack+0x76/0xa0
>  print_address_description.constprop.0+0x16/0x200
>  ? rsi_read_pkt+0x42e/0x500 [rsi_91x]
>  ? rsi_read_pkt+0x42e/0x500 [rsi_91x]
>  __kasan_report.cold+0x37/0x7c
>  ? rsi_read_pkt+0x42e/0x500 [rsi_91x]
>  kasan_report+0xe/0x20
>  rsi_read_pkt+0x42e/0x500 [rsi_91x]
>  rsi_usb_rx_thread+0x1b1/0x2fc [rsi_usb]
>  ? rsi_probe+0x16a0/0x16a0 [rsi_usb]
>  ? _raw_spin_lock_irqsave+0x7b/0xd0
>  ? _raw_spin_trylock_bh+0x120/0x120
>  ? __wake_up_common+0x10b/0x520
>  ? rsi_probe+0x16a0/0x16a0 [rsi_usb]
>  kthread+0x2b5/0x3b0
>  ? kthread_create_on_node+0xd0/0xd0
>  ret_from_fork+0x22/0x40
>
> Reported-by: Zekun Shen <bruceshenzk@gmail.com>

You are the author, no need to have your name in Reported-by.


-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
