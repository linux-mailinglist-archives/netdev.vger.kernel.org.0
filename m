Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A40E6E5B8
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 14:30:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728213AbfGSMaS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jul 2019 08:30:18 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:8306 "EHLO
        hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727649AbfGSMaR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jul 2019 08:30:17 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate16.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5d31b7d60000>; Fri, 19 Jul 2019 05:30:14 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Fri, 19 Jul 2019 05:30:16 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Fri, 19 Jul 2019 05:30:16 -0700
Received: from [10.26.11.13] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 19 Jul
 2019 12:30:12 +0000
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
 <bc9ab3c5-b1b9-26d4-7b73-01474328eafa@nvidia.com>
 <BN8PR12MB3266989D15E017A789E14282D3CB0@BN8PR12MB3266.namprd12.prod.outlook.com>
 <4db855e4-1d59-d30b-154c-e7a2aa1c9047@nvidia.com>
 <BN8PR12MB3266FD9CF18691EDEF05A4B8D3CB0@BN8PR12MB3266.namprd12.prod.outlook.com>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <64e37224-6661-ddb0-4394-83a16e1ccb61@nvidia.com>
Date:   Fri, 19 Jul 2019 13:30:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <BN8PR12MB3266FD9CF18691EDEF05A4B8D3CB0@BN8PR12MB3266.namprd12.prod.outlook.com>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL104.nvidia.com (172.18.146.11) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1563539415; bh=rXBG0gCP1VhyH9WcfrSYQsJS54xGCOqnpCluiiWVfAY=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=KJPHyGo324KngvEcJ+QS/r+yGkUcmAk79HVpkwqViXUNgzCsoNRMlDqCX7s8ayEsu
         rmmZpHA/FPBqDUNLNsKkv/ky6tZmZ8EonhOlq8Bn1YeLNQRB0rhV+4qVzJr/36d1Yj
         HoSeo7o/FfTFVQ0N6x6y4CBvIaCti7pR3S8hEFKBfPxys8M7Pfek8i8PdKhS/ZW5O3
         Y9juNEfArHWH3O+Xhz8HAPYhahww/UXyHwg0fj7ucGsblPzqHh3IB4ysqyUwe7jM2N
         sKps43ebG07KbBzYyJUnNDs3HNnaU645qR8zHAhKCNh03C6xd9dusT5ahZ/d5BlG3a
         ObETXwuwIU3Xg==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 19/07/2019 11:25, Jose Abreu wrote:

...

> Thanks. Can you add attached patch and check if WARN is triggered ? And 
> it would be good to know whether this is boot specific crash or just 
> doesn't work at all, i.e. not using NFS to mount rootfs and instead 
> manually configure interface and send/receive packets.

With this patch applied I did not see the WARN trigger.

I booted the board without using NFS and then started used dhclient to
bring up the network interface and it appears to be working fine. I can
even mount the NFS share fine. So it does appear to be particular to
using NFS to mount the rootfs.

Cheers
Jon

-- 
nvpublic
