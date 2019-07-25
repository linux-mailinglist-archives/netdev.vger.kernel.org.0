Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA09C75106
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 16:26:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388197AbfGYO0G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 10:26:06 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:14345 "EHLO
        hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727937AbfGYO0E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 10:26:04 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqemgate16.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5d39bbf90000>; Thu, 25 Jul 2019 07:26:01 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Thu, 25 Jul 2019 07:26:03 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Thu, 25 Jul 2019 07:26:03 -0700
Received: from [10.21.132.148] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 25 Jul
 2019 14:26:00 +0000
Subject: Re: [PATCH net-next 3/3] net: stmmac: Introducing support for Page
 Pool
To:     Jose Abreu <Jose.Abreu@synopsys.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
CC:     Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Robin Murphy <robin.murphy@arm.com>,
        linux-tegra <linux-tegra@vger.kernel.org>
References: <cover.1562149883.git.joabreu@synopsys.com>
 <1b254bb7fc6044c5e6e2fdd9e00088d1d13a808b.1562149883.git.joabreu@synopsys.com>
 <7a79be5d-7ba2-c457-36d3-1ccef6572181@nvidia.com>
 <BYAPR12MB3269927AB1F67D46E150ED6BD3C10@BYAPR12MB3269.namprd12.prod.outlook.com>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <9e695f33-fd9f-a910-0891-2b63bd75e082@nvidia.com>
Date:   Thu, 25 Jul 2019 15:25:59 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <BYAPR12MB3269927AB1F67D46E150ED6BD3C10@BYAPR12MB3269.namprd12.prod.outlook.com>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1564064761; bh=02CCi2dURDoTdTOLsKxT1oBFwomdLIlg5QDDNMYzFOQ=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=DXknfBB+azI5uGhCeC7AuX2u46+p182Ai+AfpMw9eJdl5incUApMGK/H63FgwohOJ
         mOUAzFzHdP350C1HF/3gtjxX6c4geXco8PF/HfsaqzEnI3ih2794mUrwW23auOUuBm
         5Cewh8XPlfrMPZKmCLvmdyHzCaS5yFP/F5d4E308ASTgwXIzMgkBqjvo6UPmBlqnm9
         8YnIa+OSuqAaHE0uF91Zcqy5z+cyNUlRrRlJlNBPS0ugoFzxjmt0bYkSg7rqwLe2BF
         EtyjQS7ifAkRCJUhEvLf8SqNxDh3xXejjKZIm4RSNdwGaxWAexRTeKGxaGfdvlEqWF
         Atza3kh8wxz2g==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 25/07/2019 14:26, Jose Abreu wrote:

...

> Well, I wasn't expecting that :/
> 
> Per documentation of barriers I think we should set descriptor fields 
> and then barrier and finally ownership to HW so that remaining fields 
> are coherent before owner is set.
> 
> Anyway, can you also add a dma_rmb() after the call to 
> stmmac_rx_status() ?

Yes. I removed the debug print added the barrier, but that did not help.

Jon

-- 
nvpublic
