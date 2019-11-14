Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01791FCC35
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 18:54:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727187AbfKNRys (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 12:54:48 -0500
Received: from lelv0143.ext.ti.com ([198.47.23.248]:38968 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726567AbfKNRys (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 12:54:48 -0500
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id xAEHsgMb036508;
        Thu, 14 Nov 2019 11:54:42 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1573754082;
        bh=IzMzCDL6RZPYWjlUNIL9izb7p3Yexr7LZMBJbXVlFJc=;
        h=From:Subject:To:CC:References:Date:In-Reply-To;
        b=FMCHtEyhAIiV8Wy+7be0srBbLGgMCFcdUp7jYQw2842AwBPacUhQSWck+g4/h1Kus
         3Jtirc7hjXrGovaZBFjfmSCQ5M7p0lmSUhdA6K4iLRHJfjmyyM2kisWcs6wTS/0QPR
         oJ48iPcx/SXhyDNGX70N28FvnfmdmeROKyf90+RM=
Received: from DFLE108.ent.ti.com (dfle108.ent.ti.com [10.64.6.29])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id xAEHsgrx046027
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 14 Nov 2019 11:54:42 -0600
Received: from DFLE109.ent.ti.com (10.64.6.30) by DFLE108.ent.ti.com
 (10.64.6.29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Thu, 14
 Nov 2019 11:54:42 -0600
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE109.ent.ti.com
 (10.64.6.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Thu, 14 Nov 2019 11:54:42 -0600
Received: from [10.250.33.226] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id xAEHsgFL030229;
        Thu, 14 Nov 2019 11:54:42 -0600
From:   Dan Murphy <dmurphy@ti.com>
Subject: Re: dp83867: Why does ti,fifo-depth set only TX, and why is it
 mandatory?
To:     Adrian Bunk <bunk@kernel.org>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        <netdev@vger.kernel.org>
References: <20191114162431.GA21979@localhost>
Message-ID: <190bd4d3-4bbd-3684-da31-2335b7c34c2a@ti.com>
Date:   Thu, 14 Nov 2019 11:53:36 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191114162431.GA21979@localhost>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adrian

On 11/14/19 10:24 AM, Adrian Bunk wrote:
> Hi,
>
> looking at the ti,fifo-depth property to set the TX FIFO Depth in the
> dp83867 driver I was wondering:
>
> 1. Why does it set only TX?
> Is there a reason why TX needs setting but RX does not?
> (RX FIFO Depth is SGMII-only, but that's what I am using)

There was no RX fifo depth setting for this device only TX fifo depth 
setting at the original submission.

See 8.6.14 PHY Control Register (PHYCR) only defines tx

> 2. Why is it a mandatory property?
> Perhaps I am missing something obvious, but why can't the driver either
> leave the value untouched or set the maximum when nothing is configured?

When the driver was originally written it was written only for RGMII 
interfaces as that is the MII that the data sheet references and does 
not reference SGMII.  We did not have SGMII samples available at that 
time. According to the HW guys setting the FIFO depth is required for 
RGMII interfaces.  When SGMII support was added in commit 
507ddd5c0d47ad869f361c71d700ffe7f12d1dd6 the rx fifo-depth DT property 
should have been added and both tx and rx should have been made 
optional.  We should probably deprecate the ti,fifo-depth in favor of 
the standard rx-fifo-depth and tx-fifo-depth common properties.

Dan


