Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD18E3FE0EB
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 19:08:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345550AbhIARJQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 13:09:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232491AbhIARJP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 13:09:15 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10E4FC061575;
        Wed,  1 Sep 2021 10:08:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=/eEATaSgxKUQuEI/VyWcCLd2zs8bwbYE3icsNkYYsmw=;
        t=1630516098; x=1631725698; b=RtAtVXaduob7xiT7IHVqDf4yVm7hZDPfHF61IRzyCKEwmJX
        mSK8vDdF7RHjaN0vmn/QjTZnro8PJfs3ruUBvowAJZ5Vo4AC4CQWoITgxNG1Gu45dSv5x1n/B6s5b
        wnEa1PGC2XikPYykvpU1K79Z0UAeRNA5BIM8KuTxP8mgPn5YOar0Q+3bNG62yZOMF8uFvNSxL2Qe6
        xTgYsnDsI9IKwEMoasdU1/l6SxvAdyZ5oh3Xckr9PXuhDvUEDt+WcjfHU9HkcluFjti2Q/C8sZokH
        QRKOw4aWovo4GQmc1HNP3Y/LaU3OOtWD4jJsv2QpmrDMOjgLA01Bj0Fq/lv/0blA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1mLTiS-001Fyv-Ur; Wed, 01 Sep 2021 19:08:01 +0200
Message-ID: <f293c619399ba8bd60240879a20ee34db1248255.camel@sipsolutions.net>
Subject: Re: [PATCH 1/2] mwifiex: Use non-posted PCI register writes
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Pali =?ISO-8859-1?Q?Roh=E1r?= <pali@kernel.org>,
        Jonas =?ISO-8859-1?Q?Dre=DFler?= <verdre@v0yd.nl>
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
Date:   Wed, 01 Sep 2021 19:07:58 +0200
In-Reply-To: <985049b8-bad7-6f18-c94f-368059dd6f95@gmail.com>
References: <20210830123704.221494-1-verdre@v0yd.nl>
         <20210830123704.221494-2-verdre@v0yd.nl>
         <CAHp75VeAKs=nFw4E20etKc3C_Cszyz9AqN=mLsum7F-BdVK5Rg@mail.gmail.com>
         <7e38931e-2f1c-066e-088e-b27b56c1245c@v0yd.nl>
         <20210901155110.xgje2qrtq65loawh@pali>
         <985049b8-bad7-6f18-c94f-368059dd6f95@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2021-09-01 at 18:51 +0200, Heiner Kallweit wrote:
> On 01.09.2021 17:51, Pali Rohár wrote:
> > On Wednesday 01 September 2021 16:01:54 Jonas Dreßler wrote:
> > > On 8/30/21 2:49 PM, Andy Shevchenko wrote:
> > > > On Mon, Aug 30, 2021 at 3:38 PM Jonas Dreßler <verdre@v0yd.nl> wrote:
> > > > > 
> > > > > On the 88W8897 card it's very important the TX ring write pointer is
> > > > > updated correctly to its new value before setting the TX ready
> > > > > interrupt, otherwise the firmware appears to crash (probably because
> > > > > it's trying to DMA-read from the wrong place).
> > > > > 
> 
> This sounds somehow like the typical case where you write DMA descriptors
> and then ring the doorbell. This normally requires a dma_wmb().
> Maybe something like that is missing here?

But it looks like this "TX ring write pointer" is actually the register?

However, I would agree that doing it in mwifiex_write_reg() is possibly
too big a hammer - could be done only for reg->tx_wrptr, not all the
registers?

Actually, can two writes actually cross on PCI?

johannes

