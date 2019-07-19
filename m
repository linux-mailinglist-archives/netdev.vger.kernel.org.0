Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 856706E29D
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 10:38:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726247AbfGSIh4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jul 2019 04:37:56 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:16954 "EHLO
        hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725794AbfGSIh4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jul 2019 04:37:56 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate14.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5d3181630000>; Fri, 19 Jul 2019 01:37:56 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Fri, 19 Jul 2019 01:37:55 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Fri, 19 Jul 2019 01:37:55 -0700
Received: from [10.26.11.13] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 19 Jul
 2019 08:37:52 +0000
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
        linux-tegra <linux-tegra@vger.kernel.org>
References: <cover.1562149883.git.joabreu@synopsys.com>
 <1b254bb7fc6044c5e6e2fdd9e00088d1d13a808b.1562149883.git.joabreu@synopsys.com>
 <29dcc161-f7c8-026e-c3cc-5adb04df128c@nvidia.com>
 <BN8PR12MB32661E919A8DEBC7095BAA12D3C80@BN8PR12MB3266.namprd12.prod.outlook.com>
 <6a6bac84-1d29-2740-1636-d3adb26b6bcc@nvidia.com>
 <BN8PR12MB3266960A104A7CDBB4E59192D3CB0@BN8PR12MB3266.namprd12.prod.outlook.com>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <bc9ab3c5-b1b9-26d4-7b73-01474328eafa@nvidia.com>
Date:   Fri, 19 Jul 2019 09:37:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <BN8PR12MB3266960A104A7CDBB4E59192D3CB0@BN8PR12MB3266.namprd12.prod.outlook.com>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL104.nvidia.com (172.18.146.11) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1563525476; bh=1RKYbMEPkBkYAvO9fUPJKXbsZ5aFdO+FGd2zGhkjPj4=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=bf64/F0tMPXpg033Cj+uCzeKcnWb+BjHUJJ7UiBLrfB42qlERv9j7sGnt94RfHo7I
         xLt0h459xSXo1xlry7OW/LJjSmKIgWhdNywp6zLUP0XQKA1hCKXDv3xOb0YqGSQWwD
         7qn5PlEGBWBhDFxuAHXXNfrKYlpKaZAurhdI4BNWKtk/cAQ1WGGQ3YlugAvMzBuySL
         GN097jfb6sKEFp+5UaqOXEtHuloX3dInrbqNIUnWvz6l7qMhLomk5Ard0CLdbyCbVv
         fMFMHXntq2wXLJKkHy/3e3KXO0e0CKpYf4305JAz4VyoWBTMMvJt+HnVnRxwtdcd+U
         Biu4jt1VhFB8g==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 19/07/2019 08:51, Jose Abreu wrote:
> From: Jon Hunter <jonathanh@nvidia.com>
> Date: Jul/18/2019, 10:16:20 (UTC+00:00)
> 
>> Have you tried using NFS on a board with this ethernet controller?
> 
> I'm having some issues setting up the NFS server in order to replicate 
> so this may take some time.

If that's the case, we may wish to consider reverting this for now as it
is preventing our board from booting. Appears to revert cleanly on top
of mainline.

> Are you able to add some debug in stmmac_init_rx_buffers() to see what's 
> the buffer address ?

If you have a debug patch you would like me to apply and test with I
can. However, it is best you prepare the patch as maybe I will not dump
the appropriate addresses.

Cheers
Jon

-- 
nvpublic
