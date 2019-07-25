Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C3E774A2F
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 11:45:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390744AbfGYJpw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 05:45:52 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:15831 "EHLO
        hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725808AbfGYJpw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 05:45:52 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate14.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5d397a500000>; Thu, 25 Jul 2019 02:45:52 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Thu, 25 Jul 2019 02:45:51 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Thu, 25 Jul 2019 02:45:51 -0700
Received: from [10.21.132.148] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 25 Jul
 2019 09:45:48 +0000
Subject: Re: [PATCH net-next 3/3] net: stmmac: Introducing support for Page
 Pool
To:     Jose Abreu <Jose.Abreu@synopsys.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
CC:     David Miller <davem@davemloft.net>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "lists@bofh.nu" <lists@bofh.nu>,
        "Joao.Pinto@synopsys.com" <Joao.Pinto@synopsys.com>,
        "alexandre.torgue@st.com" <alexandre.torgue@st.com>,
        "maxime.ripard@bootlin.com" <maxime.ripard@bootlin.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "wens@csie.org" <wens@csie.org>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
References: <BYAPR12MB32692AF2BA127C5DA5B74804D3C70@BYAPR12MB3269.namprd12.prod.outlook.com>
 <6c769226-bdd9-6fe0-b96b-5a0d800fed24@arm.com>
 <8756d681-e167-fe4a-c6f0-47ae2dcbb100@nvidia.com>
 <20190723.115112.1824255524103179323.davem@davemloft.net>
 <20190724085427.GA10736@apalos>
 <BYAPR12MB3269AA9955844E317B62A239D3C60@BYAPR12MB3269.namprd12.prod.outlook.com>
 <20190724095310.GA12991@apalos>
 <BYAPR12MB3269C5766F553438ECFF2C9BD3C60@BYAPR12MB3269.namprd12.prod.outlook.com>
 <33de62bf-2f8a-bf00-9260-418b12bed24c@nvidia.com>
 <BYAPR12MB32696F0A2BFDF69F31C4311CD3C60@BYAPR12MB3269.namprd12.prod.outlook.com>
 <a07c3480-af03-a61b-4e9c-d9ceb29ce622@nvidia.com>
 <BYAPR12MB3269F4E62B64484B08F90998D3C10@BYAPR12MB3269.namprd12.prod.outlook.com>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <d2658b7d-1f24-70f7-fafe-b60a0fd7d240@nvidia.com>
Date:   Thu, 25 Jul 2019 10:45:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <BYAPR12MB3269F4E62B64484B08F90998D3C10@BYAPR12MB3269.namprd12.prod.outlook.com>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1564047952; bh=5isgglopm7SeJ86vy3+jPoE2tjL+r8qlKxtTv2QKBHM=;
        h=X-PGP-Universal:Subject:To:CC:References:From:Message-ID:Date:
         User-Agent:MIME-Version:In-Reply-To:X-Originating-IP:
         X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=UOPEEsvkrrYBFIWOd177XUvGoLoWRcDIklaeRlE6HdJ86bODEuxFdAKOnXSsl7TQj
         C1BlC2kjEQ0OhI0uEKzvHK9P8cFLhTi9bOecyjyqn+yeZ5oJTX4F0fA21jvxkmoMGW
         TNukEvfcPf42Mg3iQLiGz6vTTPRGJWuSlRF4vZIshHT3rYR/wZStZWNFVVkYAUtTdd
         e5axWio9Qs/BMnGYpAWXNM8SBrmW/SE92TcRbIn7zHU7j0fR3D8FXMdI5wfJW2vgh6
         LWbcupZd1chBOxvamcdQX84cb/usJkiRoWPgbFY/h+z97ZHmL8OzwA12q1uekPsgVZ
         PMCZNteWQgGFg==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 25/07/2019 08:44, Jose Abreu wrote:

...

> OK. Can you please test what Ilias mentioned ?
> 
> Basically you can hard-code the order to 0 in 
> alloc_dma_rx_desc_resources():
> - pp_params.order = DIV_ROUND_UP(priv->dma_buf_sz, PAGE_SIZE);
> + pp_params.order = 0;
> 
> Unless you use a MTU > PAGE_SIZE.

I made the change but unfortunately the issue persists.

Jon

-- 
nvpublic
