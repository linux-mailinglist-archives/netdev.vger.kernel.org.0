Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E243264B9C
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 19:40:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727116AbgIJRkn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 13:40:43 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:52758 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726844AbgIJRem (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 13:34:42 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 08AHYZd6070090;
        Thu, 10 Sep 2020 12:34:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1599759275;
        bh=HNcXE24gLodGk/pYnEjtALKDPSSo1riHaJjB1RV+ZCw=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=TalcK8c1fG7RnK2xc+mbsJks00QLpOoGxnT47DmAJp3XSQZCXa9HD5q2FUrXBMKds
         eUylw3V/mYfdFbE6yjoNYEqQ/bTaqrGx8NiXfus1PdyJdVLYd7L3wBDpruu9dq4fTF
         gARNSoQWP80FbGd74iW7MbXgF5T2bw0TTUzxCr7c=
Received: from DLEE115.ent.ti.com (dlee115.ent.ti.com [157.170.170.26])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 08AHYZNc121733
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 10 Sep 2020 12:34:35 -0500
Received: from DLEE107.ent.ti.com (157.170.170.37) by DLEE115.ent.ti.com
 (157.170.170.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 10
 Sep 2020 12:34:35 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE107.ent.ti.com
 (157.170.170.37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 10 Sep 2020 12:34:35 -0500
Received: from [10.250.38.37] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 08AHYYxE007690;
        Thu, 10 Sep 2020 12:34:34 -0500
Subject: Re: [PATCH net-next v3 3/3] net: dp83869: Add speed optimization
 feature
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <andrew@lunn.ch>, <f.fainelli@gmail.com>,
        <hkallweit1@gmail.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20200903114259.14013-1-dmurphy@ti.com>
 <20200903114259.14013-4-dmurphy@ti.com>
 <20200905113818.7962b6d4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <9848c3ee-51c2-2e06-a51b-3aacc1384557@ti.com>
 <20200908104719.0b8aced3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Dan Murphy <dmurphy@ti.com>
Message-ID: <9d5c56ab-fe37-f132-8891-f20f2bfddb9f@ti.com>
Date:   Thu, 10 Sep 2020 12:34:34 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200908104719.0b8aced3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub

On 9/8/20 12:47 PM, Jakub Kicinski wrote:
> On Tue, 8 Sep 2020 09:07:22 -0500 Dan Murphy wrote:
>> On 9/5/20 1:38 PM, Jakub Kicinski wrote:
>>> On Thu, 3 Sep 2020 06:42:59 -0500 Dan Murphy wrote:
>>>> +static int dp83869_set_downshift(struct phy_device *phydev, u8 cnt)
>>>> +{
>>>> +	int val, count;
>>>> +
>>>> +	if (cnt > DP83869_DOWNSHIFT_8_COUNT)
>>>> +		return -E2BIG;
>>> ERANGE
>> This is not checking a range but making sure it is not bigger then 8.
>>
>> IMO I would use ERANGE if the check was a boundary check for upper and
>> lower bounds.
> Yeah, ERANGE is not perfect, but the strerror for E2BIG is
> "Argument list too long" - IDK if users seeing that will know that it
> means the value is too large. Perhaps we should stick to EINVAL?

EINVAL works for me to.

Dan

