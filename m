Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C4653FDD95
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 16:02:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244795AbhIAODB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 10:03:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240837AbhIAODA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 10:03:00 -0400
Received: from mout-p-102.mailbox.org (mout-p-102.mailbox.org [IPv6:2001:67c:2050::465:102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 278AEC061575;
        Wed,  1 Sep 2021 07:02:03 -0700 (PDT)
Received: from smtp102.mailbox.org (smtp102.mailbox.org [80.241.60.233])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4H05Ms116kzQkF0;
        Wed,  1 Sep 2021 16:02:01 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Subject: Re: [PATCH 1/2] mwifiex: Use non-posted PCI register writes
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
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
        Bjorn Helgaas <bhelgaas@google.com>,
        =?UTF-8?Q?Pali_Roh=c3=a1r?= <pali@kernel.org>
References: <20210830123704.221494-1-verdre@v0yd.nl>
 <20210830123704.221494-2-verdre@v0yd.nl>
 <CAHp75VeAKs=nFw4E20etKc3C_Cszyz9AqN=mLsum7F-BdVK5Rg@mail.gmail.com>
From:   =?UTF-8?Q?Jonas_Dre=c3=9fler?= <verdre@v0yd.nl>
Message-ID: <7e38931e-2f1c-066e-088e-b27b56c1245c@v0yd.nl>
Date:   Wed, 1 Sep 2021 16:01:54 +0200
MIME-Version: 1.0
In-Reply-To: <CAHp75VeAKs=nFw4E20etKc3C_Cszyz9AqN=mLsum7F-BdVK5Rg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: CEE9126D
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/30/21 2:49 PM, Andy Shevchenko wrote:
 > On Mon, Aug 30, 2021 at 3:38 PM Jonas Dreßler <verdre@v0yd.nl> wrote:
 >>
 >> On the 88W8897 card it's very important the TX ring write pointer is
 >> updated correctly to its new value before setting the TX ready
 >> interrupt, otherwise the firmware appears to crash (probably because
 >> it's trying to DMA-read from the wrong place).
 >>
 >> Since PCI uses "posted writes" when writing to a register, it's not
 >> guaranteed that a write will happen immediately. That means the pointer
 >> might be outdated when setting the TX ready interrupt, leading to
 >> firmware crashes especially when ASPM L1 and L1 substates are enabled
 >> (because of the higher link latency, the write will probably take
 >> longer).
 >>
 >> So fix those firmware crashes by always forcing non-posted writes. We do
 >> that by simply reading back the register after writing it, just as a lot
 >> of other drivers do.
 >>
 >> There are two reproducers that are fixed with this patch:
 >>
 >> 1) During rx/tx traffic and with ASPM L1 substates enabled (the enabled
 >> substates are platform dependent), the firmware crashes and eventually a
 >> command timeout appears in the logs. That crash is fixed by using a
 >> non-posted write in mwifiex_pcie_send_data().
 >>
 >> 2) When sending lots of commands to the card, waking it up from sleep in
 >> very quick intervals, the firmware eventually crashes. That crash
 >> appears to be fixed by some other non-posted write included here.
 >
 > Thanks for all this work!
 >
 > Nevertheless, do we have any commits that may be a good candidate to
 > be in the Fixes tag here?
 >

I don't think there's any commit we could point to, given that the bug 
is probably somewhere in the firmware code.

 >> Signed-off-by: Jonas Dreßler <verdre@v0yd.nl>
 >> ---
 >>   drivers/net/wireless/marvell/mwifiex/pcie.c | 6 ++++++
 >>   1 file changed, 6 insertions(+)
 >>
 >> diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c 
b/drivers/net/wireless/marvell/mwifiex/pcie.c
 >> index c6ccce426b49..bfd6e135ed99 100644
 >> --- a/drivers/net/wireless/marvell/mwifiex/pcie.c
 >> +++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
 >> @@ -237,6 +237,12 @@ static int mwifiex_write_reg(struct 
mwifiex_adapter *adapter, int reg, u32 data)
 >>
 >>          iowrite32(data, card->pci_mmap1 + reg);
 >>
 >> +       /* Do a read-back, which makes the write non-posted, 
ensuring the
 >> +        * completion before returning.
 >
 >> +        * The firmware of the 88W8897 card is buggy and this avoids 
crashes.
 >
 > Any firmware version reference? Would be nice to have just for the
 > sake of record.
 >

Pretty sure the crash is present in every firmware that has been 
released, I've tried most of them. FTR, the current firmware version is 
15.68.19.p21.

 >> +        */
 >> +       ioread32(card->pci_mmap1 + reg);
 >> +
 >>          return 0;
 >>   }
 >
 >
