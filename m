Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B6B32CDB24
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 17:24:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436793AbgLCQXT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 11:23:19 -0500
Received: from fllv0016.ext.ti.com ([198.47.19.142]:55826 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436766AbgLCQXS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 11:23:18 -0500
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 0B3GM93X012653;
        Thu, 3 Dec 2020 10:22:09 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1607012529;
        bh=S3AFaUzJoub60vRRyYRzulKzsuGYCd0b4YS/6BXU4Dc=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=hwn3l4YL0YRj6YxNfaNfh5x4GsJiSCeWKe3dY0HiyfLmlAnxmzk1vEIsL5lxONW+G
         n95O7cNzNnq37qxWEQb9In92+gOcg0BF6gp0Os6UGEXQcbvHUyJOyh/Fx7v8ZMoKM0
         llqiXQOwNhBzyZFxNySYLG/UGhdB5RsGoE7i1ouA=
Received: from DFLE115.ent.ti.com (dfle115.ent.ti.com [10.64.6.36])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 0B3GM8aR127125
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 3 Dec 2020 10:22:08 -0600
Received: from DFLE104.ent.ti.com (10.64.6.25) by DFLE115.ent.ti.com
 (10.64.6.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 3 Dec
 2020 10:22:07 -0600
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE104.ent.ti.com
 (10.64.6.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 3 Dec 2020 10:22:07 -0600
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 0B3GM5r6078920;
        Thu, 3 Dec 2020 10:22:06 -0600
Subject: Re: [PATCH 1/4] net: ti: am65-cpsw-nuss: Add devlink support
To:     Andrew Lunn <andrew@lunn.ch>, Vignesh Raghavendra <vigneshr@ti.com>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, Jiri Pirko <jiri@nvidia.com>,
        <netdev@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Linux ARM Mailing List <linux-arm-kernel@lists.infradead.org>
References: <20201130082046.16292-1-vigneshr@ti.com>
 <20201130082046.16292-2-vigneshr@ti.com> <20201130155044.GE2073444@lunn.ch>
 <cc7fe740-1002-f1b9-8136-e1ba60cf2541@ti.com>
 <20201203141838.GE2333853@lunn.ch>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <d4ab92c8-8b70-ce26-e47f-d5172c8fd4e7@ti.com>
Date:   Thu, 3 Dec 2020 18:22:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201203141838.GE2333853@lunn.ch>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 03/12/2020 16:18, Andrew Lunn wrote:
>> We don't want to enable HW based switch support unless explicitly
>> asked by user.
> 
> This is the key point. Why? Does individual ports when passed through
> the switch not work properly? Does it add extra latency/jitter?

When switch mode is enabled the forwarding is enabled by default and can't be completely
disabled, while in multi port mode every port and switch tables (ALE) configured so no packet
leaking between ports is happen.
The multi port is the requirement for us to have as default mode no mater to what upper interface
ports are attached to LAG, LRE (HSR/PRP) or bridge.

Switching between modes required significant Port and ALE reconfiguration there for
technical decision made and implemented to use parameter for mode change (by using devlink).

It also allows to keep user interface similar to what was implements for previous generation
of TI CPSW (am3/4/5).

-- 
Best regards,
grygorii
