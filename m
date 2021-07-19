Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86B803CD671
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 16:18:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241034AbhGSNhV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 09:37:21 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:42774 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239393AbhGSNhU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 09:37:20 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 16JEHhrr065969;
        Mon, 19 Jul 2021 09:17:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1626704263;
        bh=CpcBmeRcDZIm1A+uFJxjzBz0ASRFRo855v0wJBlfQ5M=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=q6XV22eGAENwhwuWelD7Uev62RNFacZJMHt6hRzHKhGVbs42d07Zp8W+UGy17RMVu
         ASWjlvysk9i701FVrSsCcnFpIbiBeY2XuY+xKbbB/lXvT+TjH98DeLEh/9EkUQkOzM
         k9qYpzTai4Vh8ioAt01sou6d7RDI+UZrgTqTaLFQ=
Received: from DLEE104.ent.ti.com (dlee104.ent.ti.com [157.170.170.34])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 16JEHhO2097307
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 19 Jul 2021 09:17:43 -0500
Received: from DLEE111.ent.ti.com (157.170.170.22) by DLEE104.ent.ti.com
 (157.170.170.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Mon, 19
 Jul 2021 09:17:41 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE111.ent.ti.com
 (157.170.170.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2 via
 Frontend Transport; Mon, 19 Jul 2021 09:17:40 -0500
Received: from [10.250.235.117] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 16JEHYmU043982;
        Mon, 19 Jul 2021 09:17:35 -0500
Subject: Re: [PATCH v4 0/2] MCAN: Add support for implementing transceiver as
 a phy
To:     Marc Kleine-Budde <mkl@pengutronix.de>
CC:     Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, <linux-can@vger.kernel.org>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Lokesh Vutla <lokeshvutla@ti.com>,
        Kishon Vijay Abraham I <kishon@ti.com>
References: <20210510052541.14168-1-a-govindraju@ti.com>
 <2c5b76f7-8899-ab84-736b-790482764384@ti.com>
 <20210616091709.n7x62wmvafz4rzs7@pengutronix.de>
From:   Aswath Govindraju <a-govindraju@ti.com>
Message-ID: <218d6825-82c0-38f5-19ab-235f8e6f74a0@ti.com>
Date:   Mon, 19 Jul 2021 19:47:33 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210616091709.n7x62wmvafz4rzs7@pengutronix.de>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marc,

On 16/06/21 2:47 pm, Marc Kleine-Budde wrote:
> On 14.06.2021 18:02:53, Aswath Govindraju wrote:
>> Hi Marc,
>>
>> On 10/05/21 10:55 am, Aswath Govindraju wrote:
>>> The following series of patches add support for implementing the
>>> transceiver as a phy of m_can_platform driver.
>>>
>>> TCAN1042 has a standby signal that needs to be pulled high for
>>> sending/receiving messages[1]. TCAN1043 has a enable signal along with
>>> standby signal that needs to be pulled up for sending/receiving
>>> messages[2], and other combinations of the two lines can be used to put the
>>> transceiver in different states to reduce power consumption. On boards
>>> like the AM654-idk and J721e-evm these signals are controlled using gpios.
>>>
>>> These gpios are set in phy driver, and the transceiver can be put in
>>> different states using phy API. The phy driver is added in the series [3].
>>>
>>> This patch series is dependent on [4].
>>>
>>
>> [4] is now part of linux-next
>>
>>> [4] - https://lore.kernel.org/patchwork/patch/1413286/
>>
>> May I know if this series is okay to be picked up ?
> 
> As soon as this hits net-next/master I can pick up this series.
> 

Thank you for reply.

I am planning on posting device tree patches to arm64 tree and
Nishanth(maintainer of the tree) requested for an immutable tag if the
dependent patches are not in master. So, after applying this patch
series, can you please provide an immutable tag ?

Thanks,
Aswath

> Marc
> 

