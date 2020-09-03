Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F58225BFEA
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 13:11:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728073AbgICLKH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 07:10:07 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:35580 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726368AbgICLFn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 07:05:43 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 083B5ChD117900;
        Thu, 3 Sep 2020 06:05:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1599131112;
        bh=j7gRaGCJZUJFnrbVSfTAo0ASYxH7elhC7M4m/dECa+M=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=yR6eSeAR5AcQBTSkGgbKjy7k6v6/0wXPhYs8yPe8RWGxq3bgOdloMLuQOf104Cq0R
         Rs3rRyaB8dxW0iR744kb0wsfQsNJ102J+ilKMMzIS6t6Bid+j3ksFgZjk4d+m7xPpA
         aslrQ1NTCG2kWq3YMh59V+aMB1u12SCI5z4sS+E8=
Received: from DLEE112.ent.ti.com (dlee112.ent.ti.com [157.170.170.23])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 083B5CIV126003
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 3 Sep 2020 06:05:12 -0500
Received: from DLEE101.ent.ti.com (157.170.170.31) by DLEE112.ent.ti.com
 (157.170.170.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 3 Sep
 2020 06:05:12 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE101.ent.ti.com
 (157.170.170.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 3 Sep 2020 06:05:12 -0500
Received: from [10.250.38.37] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 083B5BtX011954;
        Thu, 3 Sep 2020 06:05:11 -0500
Subject: Re: [PATCH net-next v2 3/3] net: dp83869: Add speed optimization
 feature
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <andrew@lunn.ch>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20200902203444.29167-1-dmurphy@ti.com>
 <20200902203444.29167-4-dmurphy@ti.com>
 <20200902190650.52c46eb7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Dan Murphy <dmurphy@ti.com>
Message-ID: <e302d45f-c928-e6a3-fe40-da3bce978048@ti.com>
Date:   Thu, 3 Sep 2020 06:05:06 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200902190650.52c46eb7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub

On 9/2/20 9:06 PM, Jakub Kicinski wrote:
> On Wed, 2 Sep 2020 15:34:44 -0500 Dan Murphy wrote:
>> Set the speed optimization bit on the DP83869 PHY.
>>
>> Speed optimization, also known as link downshift, enables fallback to 100M
>> operation after multiple consecutive failed attempts at Gigabit link
>> establishment. Such a case could occur if cabling with only four wires
>> (two twisted pairs) were connected instead of the standard cabling with
>> eight wires (four twisted pairs).
>>
>> The number of failed link attempts before falling back to 100M operation is
>> configurable. By default, four failed link attempts are required before
>> falling back to 100M.
>>
>> Signed-off-by: Dan Murphy <dmurphy@ti.com>
> there seems to be lots of checkpatch warnings here:
>
> ERROR: switch and case should be at the same indent
> #111: FILE: drivers/net/phy/dp83869.c:342:
> +	switch (cnt) {
> +		case DP83869_DOWNSHIFT_1_COUNT:
> [...]
> +		case DP83869_DOWNSHIFT_2_COUNT:
> [...]
> +		case DP83869_DOWNSHIFT_4_COUNT:
> [...]
> +		case DP83869_DOWNSHIFT_8_COUNT:
> [...]
> +		default:
>
> CHECK: Alignment should match open parenthesis
> #139: FILE: drivers/net/phy/dp83869.c:370:
> +static int dp83869_get_tunable(struct phy_device *phydev,
> +				struct ethtool_tunable *tuna, void *data)
>
> CHECK: Alignment should match open parenthesis
> #150: FILE: drivers/net/phy/dp83869.c:381:
> +static int dp83869_set_tunable(struct phy_device *phydev,
> +				struct ethtool_tunable *tuna, const void *data)
>
> WARNING: please, no spaces at the start of a line
> #168: FILE: drivers/net/phy/dp83869.c:669:
> +       ret = phy_modify(phydev, DP83869_CFG2, DP83869_DOWNSHIFT_EN,$
>
> ERROR: code indent should use tabs where possible
> #169: FILE: drivers/net/phy/dp83869.c:670:
> +                        DP83869_DOWNSHIFT_EN);$
>
> WARNING: please, no spaces at the start of a line
> #169: FILE: drivers/net/phy/dp83869.c:670:
> +                        DP83869_DOWNSHIFT_EN);$
>
> WARNING: please, no spaces at the start of a line
> #170: FILE: drivers/net/phy/dp83869.c:671:
> +       if (ret)$
>
> WARNING: suspect code indent for conditional statements (7, 15)
> #170: FILE: drivers/net/phy/dp83869.c:671:
> +       if (ret)
> +               return ret;
>
> ERROR: code indent should use tabs where possible
> #171: FILE: drivers/net/phy/dp83869.c:672:
> +               return ret;$
>
> WARNING: please, no spaces at the start of a line
> #171: FILE: drivers/net/phy/dp83869.c:672:
> +               return ret;$
>
> total: 3 errors, 5 warnings, 2 checks, 152 lines checked

I will fix these.

Dan

