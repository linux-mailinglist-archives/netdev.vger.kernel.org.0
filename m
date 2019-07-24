Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22CC572E27
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 13:49:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728005AbfGXLtl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 07:49:41 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:51532 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727570AbfGXLtl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 07:49:41 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 4436E6053D; Wed, 24 Jul 2019 11:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1563968980;
        bh=Apr32KU/6B9aTPa2tfZUiPw1kdiISwzr6gcZw8IeftQ=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=Impj17OplB8isAvlFP+/CakfnYAXi2QXZV6Qio9f6okxmSh03RJ3NkrwNPqv96mGv
         wzwAUAZ3aewrIs9r6nDT68F+DVm8DFKi3VwpMj1fkmPJHSvPNXB1gPPXgVRkyMAi3g
         mqwEYpf9qhzg6X/Z1Hp/w6eQ6AYEI6tMU13nWoCU=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,MISSING_DATE,MISSING_MID,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id AF79960214;
        Wed, 24 Jul 2019 11:49:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1563968978;
        bh=Apr32KU/6B9aTPa2tfZUiPw1kdiISwzr6gcZw8IeftQ=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=K4lybffhYJ10/BlwkdUoAzaRQIc6N1THAkohn7DdqgP2PT0ozi2XyuN7rb4rbBnc1
         tt0bbkjG45WVx8xL0gQMJ+EkUqifNWl5Spy7j2VbQ/WkSaMOzTGC4oQvqzIkcFuY7y
         b6twOBEfcEgOWWMX1Tocl+vUUejrgzd8QKZcN5TQ=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org AF79960214
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v4 1/2] rtw88: pci: Rearrange the memory usage for skb in
 RX ISR
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190711052427.5582-1-jian-hong@endlessm.com>
References: <20190711052427.5582-1-jian-hong@endlessm.com>
To:     Jian-Hong Pan <jian-hong@endlessm.com>
Cc:     Yan-Hsuan Chuang <yhchuang@realtek.com>,
        "David S . Miller" <davem@davemloft.net>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        David Laight <David.Laight@aculab.com>,
        Christoph Hellwig <hch@infradead.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@endlessm.com,
        Daniel Drake <drake@endlessm.com>,
        Jian-Hong Pan <jian-hong@endlessm.com>, stable@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190724114940.4436E6053D@smtp.codeaurora.org>
Date:   Wed, 24 Jul 2019 11:49:40 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jian-Hong Pan <jian-hong@endlessm.com> wrote:

> Testing with RTL8822BE hardware, when available memory is low, we
> frequently see a kernel panic and system freeze.
> 
> First, rtw_pci_rx_isr encounters a memory allocation failure (trimmed):
> 
> rx routine starvation
> WARNING: CPU: 7 PID: 9871 at drivers/net/wireless/realtek/rtw88/pci.c:822 rtw_pci_rx_isr.constprop.25+0x35a/0x370 [rtwpci]
> [ 2356.580313] RIP: 0010:rtw_pci_rx_isr.constprop.25+0x35a/0x370 [rtwpci]
> 
> Then we see a variety of different error conditions and kernel panics,
> such as this one (trimmed):
> 
> rtw_pci 0000:02:00.0: pci bus timeout, check dma status
> skbuff: skb_over_panic: text:00000000091b6e66 len:415 put:415 head:00000000d2880c6f data:000000007a02b1ea tail:0x1df end:0xc0 dev:<NULL>
> ------------[ cut here ]------------
> kernel BUG at net/core/skbuff.c:105!
> invalid opcode: 0000 [#1] SMP NOPTI
> RIP: 0010:skb_panic+0x43/0x45
> 
> When skb allocation fails and the "rx routine starvation" is hit, the
> function returns immediately without updating the RX ring. At this
> point, the RX ring may continue referencing an old skb which was already
> handed off to ieee80211_rx_irqsafe(). When it comes to be used again,
> bad things happen.
> 
> This patch allocates a new, data-sized skb first in RX ISR. After
> copying the data in, we pass it to the upper layers. However, if skb
> allocation fails, we effectively drop the frame. In both cases, the
> original, full size ring skb is reused.
> 
> In addition, to fixing the kernel crash, the RX routine should now
> generally behave better under low memory conditions.
> 
> Buglink: https://bugzilla.kernel.org/show_bug.cgi?id=204053
> Signed-off-by: Jian-Hong Pan <jian-hong@endlessm.com>
> Cc: <stable@vger.kernel.org>

2 patches applied to wireless-drivers-next.git, thanks.

ee6db78f5db9 rtw88: pci: Rearrange the memory usage for skb in RX ISR
29b68a920f6a rtw88: pci: Use DMA sync instead of remapping in RX ISR

-- 
https://patchwork.kernel.org/patch/11039275/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

