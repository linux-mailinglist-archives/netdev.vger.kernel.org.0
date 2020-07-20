Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C5EE226CF4
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 19:12:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732070AbgGTRLn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 13:11:43 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:47988 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729853AbgGTRLm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Jul 2020 13:11:42 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1595265102; h=Date: Message-Id: Cc: To: References:
 In-Reply-To: From: Subject: Content-Transfer-Encoding: MIME-Version:
 Content-Type: Sender; bh=73j4gslEkdDhJgDflelmYGo9052nEeU1c8WAVbCoH1Q=;
 b=BBRVHxKdC+FXZjhSdOZYUJA9MpY0DAOTCdHMSByl2HpbsArPnNwTHm/9X3v4EbrHyI5Teb9p
 ZZGE9Sy3lzRjw1RTiBCIQbxGlCiAoznSDorqLwWRoJQ1p7oQ+vGhYckBlnK7ITow2W+uH15S
 BBVsrs8apZuN23lGRttxFtAKM6E=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n12.prod.us-west-2.postgun.com with SMTP id
 5f15d00b0cb8533c3b749fa0 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 20 Jul 2020 17:10:35
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 89558C433CB; Mon, 20 Jul 2020 17:10:35 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=2.0 tests=ALL_TRUSTED,MISSING_DATE,
        MISSING_MID,SPF_NONE autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 1A178C433C9;
        Mon, 20 Jul 2020 17:10:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 1A178C433C9
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] net: ath10k: fix OOB: __ath10k_htt_rx_ring_fill_n
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20200623221105.3486-1-bruceshenzk@gmail.com>
References: <20200623221105.3486-1-bruceshenzk@gmail.com>
To:     Zekun Shen <bruceshenzk@gmail.com>
Cc:     unlisted-recipients:; (no To-header on input) security@kernel.org,
        Zekun Shen <bruceshenzk@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Illegal-Object: Syntax error in Cc: address found on vger.kernel.org:
        Cc:     unlisted-recipients:; (no To-header on input)security@kernel.org
                                                                     ^-missing end of address
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.5.2
Message-Id: <20200720171035.89558C433CB@smtp.codeaurora.org>
Date:   Mon, 20 Jul 2020 17:10:35 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Zekun Shen <bruceshenzk@gmail.com> wrote:

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
> 
> Signed-off-by: Zekun Shen <bruceshenzk@gmail.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

bad60b8d1a71 ath10k: check idx validity in __ath10k_htt_rx_ring_fill_n()

-- 
https://patchwork.kernel.org/patch/11621899/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

