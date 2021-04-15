Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2B58360E82
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 17:16:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234615AbhDOPQS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 11:16:18 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:53894 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236550AbhDOPPD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 11:15:03 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 13FFEUCn013190;
        Thu, 15 Apr 2021 10:14:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1618499670;
        bh=+qBC1tnl5YMK3m60rKOq4hj1XFlwy6Q4817612NjXgE=;
        h=Subject:CC:References:From:Date:In-Reply-To;
        b=yfp2Ont4ALWQWjciYZ1YSZtvmOAulxg5cb/16pbUSzbGHThWmXB8x4vP0Um2MAn7N
         x6Qc+dcMcdXltpENliCMx6/3tTikjIlxhhfC8lcSs7JVsGj4p0b3qdVkgcBRTo/ebf
         Rz2L8jKNlffRGiKGr0T6Lk7QvTrGgaxO7Bsf+dok=
Received: from DFLE107.ent.ti.com (dfle107.ent.ti.com [10.64.6.28])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 13FFEUTk017045
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 15 Apr 2021 10:14:30 -0500
Received: from DFLE109.ent.ti.com (10.64.6.30) by DFLE107.ent.ti.com
 (10.64.6.28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Thu, 15
 Apr 2021 10:14:29 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE109.ent.ti.com
 (10.64.6.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2 via
 Frontend Transport; Thu, 15 Apr 2021 10:14:29 -0500
Received: from [172.24.145.148] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 13FFEPBM088778;
        Thu, 15 Apr 2021 10:14:26 -0500
Subject: Re: [PATCH 0/2] MCAN: Add support for implementing transceiver as a
 phy
CC:     <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Rob Herring <robh+dt@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Lokesh Vutla <lokeshvutla@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>
References: <20210415150629.5417-1-a-govindraju@ti.com>
From:   Aswath Govindraju <a-govindraju@ti.com>
Message-ID: <1fc33525-d879-f8b2-60e5-58c64b66b938@ti.com>
Date:   Thu, 15 Apr 2021 20:44:24 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210415150629.5417-1-a-govindraju@ti.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

On 15/04/21 8:36 pm, Aswath Govindraju wrote:
> The following series of patches add support for implementing the
> transceiver as a phy of m_can_platform driver.
> 
> TCAN1042 has a standby signal that needs to be pulled high for
> sending/receiving messages[1]. TCAN1043 has a enable signal along with
> standby signal that needs to be pulled up for sending/receiving
> messages[2], and other combinations of the two lines can be used to put the
> transceiver in different states to reduce power consumption. On boards
> like the AM654-idk and J721e-evm these signals are controlled using gpios.
> 
> These gpios are set in phy driver, and the transceiver can be put in
> different states using phy API. The phy driver is added in the series [3].
> 
> [1] - https://www.ti.com/lit/ds/symlink/tcan1042h.pdf
> [2] - https://www.ti.com/lit/ds/symlink/tcan1043-q1.pdf
> [3] - https://lore.kernel.org/patchwork/project/lkml/list/?series=495365
> 

Please ignore this series. I will post a respin using
devm_phy_get_optional instead of devm_of_phy_get_optional_by_index()
based on the comments below[1]. Sorry for the noise.

[1] - https://lore.kernel.org/patchwork/patch/1413931/

Thanks,
Aswath

> Faiz Abbas (2):
>   dt-bindings: net: can: Document transceiver implementation as phy
>   can: m_can: Add support for transceiver as phy
> 
>  .../devicetree/bindings/net/can/bosch,m_can.yaml    |  3 +++
>  drivers/net/can/m_can/m_can.c                       | 10 ++++++++++
>  drivers/net/can/m_can/m_can.h                       |  2 ++
>  drivers/net/can/m_can/m_can_platform.c              | 13 +++++++++++++
>  4 files changed, 28 insertions(+)
> 

