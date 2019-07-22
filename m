Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6607E6FDBD
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 12:27:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729637AbfGVK1m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 06:27:42 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:13157 "EHLO
        hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726846AbfGVK1m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 06:27:42 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate15.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5d358fa40000>; Mon, 22 Jul 2019 03:27:48 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Mon, 22 Jul 2019 03:27:41 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Mon, 22 Jul 2019 03:27:41 -0700
Received: from [10.21.132.148] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 22 Jul
 2019 10:27:38 +0000
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
 <6a6bac84-1d29-2740-1636-d3adb26b6bcc@nvidia.com>
 <BN8PR12MB3266960A104A7CDBB4E59192D3CB0@BN8PR12MB3266.namprd12.prod.outlook.com>
 <bc9ab3c5-b1b9-26d4-7b73-01474328eafa@nvidia.com>
 <BN8PR12MB3266989D15E017A789E14282D3CB0@BN8PR12MB3266.namprd12.prod.outlook.com>
 <4db855e4-1d59-d30b-154c-e7a2aa1c9047@nvidia.com>
 <BN8PR12MB3266FD9CF18691EDEF05A4B8D3CB0@BN8PR12MB3266.namprd12.prod.outlook.com>
 <64e37224-6661-ddb0-4394-83a16e1ccb61@nvidia.com>
 <BN8PR12MB3266E1FAC5B7874EFA69DD7BD3CB0@BN8PR12MB3266.namprd12.prod.outlook.com>
 <25512348-5b98-aeb7-a6fb-f90376e66a84@nvidia.com>
 <BN8PR12MB32665C1A106D3DCBF89CEA54D3C40@BN8PR12MB3266.namprd12.prod.outlook.com>
 <49efad87-2f74-5804-af4c-33730f865c41@nvidia.com>
 <BN8PR12MB3266362102CCB6B4DDE4BEA0D3C40@BN8PR12MB3266.namprd12.prod.outlook.com>
 <BN8PR12MB326667E86622C3ABD5CDE642D3C40@BN8PR12MB3266.namprd12.prod.outlook.com>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <9bd0de50-cbfa-40ee-52e3-26adc1a59c43@nvidia.com>
Date:   Mon, 22 Jul 2019 11:27:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <BN8PR12MB326667E86622C3ABD5CDE642D3C40@BN8PR12MB3266.namprd12.prod.outlook.com>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1563791268; bh=p3thVhzOYfkF0ilrLvyx7ZdXmJoaxjmMRBaq/ySj/0I=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=Xfcw92Bk1Os81HL717eUaqAlOCD3/2EIGWqpHLZ4xbTXACHxw5w/Slr1xqv+9xZOq
         rIdFNn1b1YHuUhwzwoZ0UUvwD8ovc7OsN8nvLsZ3++jdhs4IdMvK0wWdyGeeV90Jco
         HdExdy7dB/H7lOVS5wh9HxuTSN3uUFXs8TGuNxB7si5EWe11sNZmOjRU1o115iXpkE
         nrXaMRxOXfmKawkklhw4IG1MugC58worRj59YgH3LTYt+0H9QF2Ktb0cLfyoDHm0wW
         HUMnMscWpvz+QDAYse6UAmk+s9ABf/fvpYwoL3QBj/3JBeZCpHU2fgxW0BdMJib233
         y7RlfCm/t3MoA==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 22/07/2019 10:57, Jose Abreu wrote:

...

> Also, please add attached patch. You'll get a compiler warning, just 
> disregard it.

Here you are ...

https://paste.ubuntu.com/p/H9Mvv37vN9/

Cheers
Jon

-- 
nvpublic
