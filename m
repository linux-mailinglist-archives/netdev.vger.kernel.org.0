Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D8B53FDF05
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 17:51:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343840AbhIAPwL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 11:52:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:33802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244935AbhIAPwK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Sep 2021 11:52:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EBA2C61027;
        Wed,  1 Sep 2021 15:51:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630511473;
        bh=3lBDzHMwRFHFzEmJ5m7CdDmivd2al3khol396gFXMyY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fvIGRMsTiSiSONENP3ZgDmxoqbkwAc6KIqfKGMz3d+ei/XaH860hQWNfVYMuHelb0
         YYIrId3XUgflrGPMo1SZ/uZSH3RXhLgxIDWIn6qfXcloKX7Ac0YnX2J1u+9OmyNYiV
         A9pL6c7BhgW3/U2KGWt48/lihL7dJ2lMhhH+fdfJnvK03LGjPBhmVBi/whPR9420Sh
         g8En/1AJYqej3EPhLOHFfNmB0BSaNn5jBCrWPiJ9bz4uaPeHA5aGOmcq5N2awjJNTX
         77nGfF01hYcrD5OHM7F2a7x9yQ1bkKnxAa9XHlvpaRORXQwv76d8WQJeH9x4a1KQv5
         tDyhwQ9PIKO/A==
Received: by pali.im (Postfix)
        id 9E7AEA46; Wed,  1 Sep 2021 17:51:10 +0200 (CEST)
Date:   Wed, 1 Sep 2021 17:51:10 +0200
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Jonas =?utf-8?Q?Dre=C3=9Fler?= <verdre@v0yd.nl>
Cc:     Andy Shevchenko <andy.shevchenko@gmail.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tsuchiya Yuto <kitakar@gmail.com>,
        "open list:TI WILINK WIRELES..." <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH 1/2] mwifiex: Use non-posted PCI register writes
Message-ID: <20210901155110.xgje2qrtq65loawh@pali>
References: <20210830123704.221494-1-verdre@v0yd.nl>
 <20210830123704.221494-2-verdre@v0yd.nl>
 <CAHp75VeAKs=nFw4E20etKc3C_Cszyz9AqN=mLsum7F-BdVK5Rg@mail.gmail.com>
 <7e38931e-2f1c-066e-088e-b27b56c1245c@v0yd.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7e38931e-2f1c-066e-088e-b27b56c1245c@v0yd.nl>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wednesday 01 September 2021 16:01:54 Jonas Dreßler wrote:
> On 8/30/21 2:49 PM, Andy Shevchenko wrote:
> > On Mon, Aug 30, 2021 at 3:38 PM Jonas Dreßler <verdre@v0yd.nl> wrote:
> >>
> >> On the 88W8897 card it's very important the TX ring write pointer is
> >> updated correctly to its new value before setting the TX ready
> >> interrupt, otherwise the firmware appears to crash (probably because
> >> it's trying to DMA-read from the wrong place).
> >>
> >> Since PCI uses "posted writes" when writing to a register, it's not
> >> guaranteed that a write will happen immediately. That means the pointer
> >> might be outdated when setting the TX ready interrupt, leading to
> >> firmware crashes especially when ASPM L1 and L1 substates are enabled
> >> (because of the higher link latency, the write will probably take
> >> longer).
> >>
> >> So fix those firmware crashes by always forcing non-posted writes. We do
> >> that by simply reading back the register after writing it, just as a lot
> >> of other drivers do.
> >>
> >> There are two reproducers that are fixed with this patch:
> >>
> >> 1) During rx/tx traffic and with ASPM L1 substates enabled (the enabled
> >> substates are platform dependent), the firmware crashes and eventually a
> >> command timeout appears in the logs. That crash is fixed by using a
> >> non-posted write in mwifiex_pcie_send_data().
> >>
> >> 2) When sending lots of commands to the card, waking it up from sleep in
> >> very quick intervals, the firmware eventually crashes. That crash
> >> appears to be fixed by some other non-posted write included here.
> >
> > Thanks for all this work!
> >
> > Nevertheless, do we have any commits that may be a good candidate to
> > be in the Fixes tag here?
> >
> 
> I don't think there's any commit we could point to, given that the bug is
> probably somewhere in the firmware code.

Then please add Cc: stable@vger.kernel.org tag into commit message. Such
bugfix is a good candidate for backporting into stable releases.

> >> Signed-off-by: Jonas Dreßler <verdre@v0yd.nl>
