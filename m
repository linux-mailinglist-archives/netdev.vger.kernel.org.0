Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75F9B2210E2
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 17:28:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726890AbgGOP1Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 11:27:16 -0400
Received: from mail29.static.mailgun.info ([104.130.122.29]:23355 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725792AbgGOP1P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 11:27:15 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1594826835; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=OS9jfqCnxLfBYtRX/l34nJHSA0Qibt4senv0rOAx718=; b=RCbJcu1qj3ZqZZImlhDi/8sVe4EChlTyI6bSky/Nweqs5lZ/YTbNfKoeBoj+ftQOoIqMxSIf
 IQtiItQ2i7KHJ1Tfbb43VGKvJHMz+uF6x1+CvtpaMX/2HKcwzH85EGSVDDVT5wTqpurHRj0p
 w+e8uezY5G7glhVFKsT4BndPItE=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-east-1.postgun.com with SMTP id
 5f0f2046f9ca681bd0a4dd9e (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 15 Jul 2020 15:27:02
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id B13B4C43391; Wed, 15 Jul 2020 15:27:01 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 080D3C433C9;
        Wed, 15 Jul 2020 15:26:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 080D3C433C9
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Zekun Shen <bruceshenzk@gmail.com>
Cc:     security@kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        ath10k@lists.infradead.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] net: ath10k: fix OOB: __ath10k_htt_rx_ring_fill_n
References: <20200623221105.3486-1-bruceshenzk@gmail.com>
Date:   Wed, 15 Jul 2020 18:26:56 +0300
In-Reply-To: <20200623221105.3486-1-bruceshenzk@gmail.com> (Zekun Shen's
        message of "Tue, 23 Jun 2020 18:11:05 -0400")
Message-ID: <87mu4094u7.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Zekun Shen <bruceshenzk@gmail.com> writes:

> The idx in __ath10k_htt_rx_ring_fill_n function lives in
> consistent dma region writable by the device. Malfunctional
> or malicious device could manipulate such idx to have a OOB
> write. Either by
>     htt->rx_ring.netbufs_ring[idx] = skb;
> or by
>     ath10k_htt_set_paddrs_ring(htt, paddr, idx);
>
> The idx can also be negative as it's signed, giving a large
> memory space to write to.
>
> It's possibly exploitable by corruptting a legit pointer with
> a skb pointer. And then fill skb with payload as rougue object.
>
> Signed-off-by: Zekun Shen <bruceshenzk@gmail.com>
> ---
> Part of the log here. Sometimes it appears as UAF when writing 
> to a freed memory by chance.
>
>  [   15.594376] BUG: unable to handle page fault for address: ffff887f5c1804f0
>  [   15.595483] #PF: supervisor write access in kernel mode
>  [   15.596250] #PF: error_code(0x0002) - not-present page
>  [   15.597013] PGD 0 P4D 0
>  [   15.597395] Oops: 0002 [#1] SMP KASAN PTI
>  [   15.597967] CPU: 0 PID: 82 Comm: kworker/u2:2 Not tainted 5.6.0 #69
>  [   15.598843] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), 
>  BIOS rel-1.12.1-0-ga5cab58e9a3f-prebuilt.qemu.org 04/01/2014
>  [   15.600438] Workqueue: ath10k_wq ath10k_core_register_work [ath10k_core]
>  [   15.601389] RIP: 0010:__ath10k_htt_rx_ring_fill_n 
>  (linux/drivers/net/wireless/ath/ath10k/htt_rx.c:173) ath10k_core

I added the log to the commit log as it looks useful.

Also I made minor changes to the title and to the error message.

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
