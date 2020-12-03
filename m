Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EC0E2CD830
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 14:51:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727930AbgLCNu4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 08:50:56 -0500
Received: from fllv0015.ext.ti.com ([198.47.19.141]:55388 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726366AbgLCNu4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 08:50:56 -0500
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 0B3Dnqdr070125;
        Thu, 3 Dec 2020 07:49:52 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1607003393;
        bh=heQpcHf6Hj5/Jowm9lAGLrqIo4IcPttU+vpaQxrvHsY=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=f7Cg6d1tPUtilSaAddetBpqCrhecrHzcoCdFosdrxW1FqVaM0FiOg0g04zUS8lL9t
         WB7Ev3dMp6Vzl/DqhX+M0lT0eAZaKXAtgJeu+eVJmVZuY4A6SsI10fVBmIjeI3uehg
         8Rxa1MD5RiM0Svg4p02XK0TjYjsDZpx+Nc7cO28k=
Received: from DLEE112.ent.ti.com (dlee112.ent.ti.com [157.170.170.23])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 0B3Dnqao114126
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 3 Dec 2020 07:49:52 -0600
Received: from DLEE108.ent.ti.com (157.170.170.38) by DLEE112.ent.ti.com
 (157.170.170.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 3 Dec
 2020 07:49:52 -0600
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE108.ent.ti.com
 (157.170.170.38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 3 Dec 2020 07:49:52 -0600
Received: from [10.250.233.179] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 0B3DnnJI076106;
        Thu, 3 Dec 2020 07:49:49 -0600
Subject: Re: [PATCH 3/4] net: ti: am65-cpsw-nuss: Add switchdev support
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Jonathan Corbet <corbet@lwn.net>, Jiri Pirko <jiri@nvidia.com>,
        <netdev@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Linux ARM Mailing List <linux-arm-kernel@lists.infradead.org>
References: <20201130082046.16292-1-vigneshr@ti.com>
 <20201130082046.16292-4-vigneshr@ti.com> <20201130172034.GF2073444@lunn.ch>
From:   Vignesh Raghavendra <vigneshr@ti.com>
Message-ID: <fc6ddc40-5277-09e5-0a7a-feb1ea4087ef@ti.com>
Date:   Thu, 3 Dec 2020 19:19:48 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201130172034.GF2073444@lunn.ch>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/30/20 10:50 PM, Andrew Lunn wrote:
>> +static int am65_cpsw_port_stp_state_set(struct am65_cpsw_port *port,
>> +					struct switchdev_trans *trans, u8 state)
>> +{
>> +	struct am65_cpsw_common *cpsw = port->common;
>> +	u8 cpsw_state;
>> +	int ret = 0;
>> +
>> +	if (switchdev_trans_ph_prepare(trans))
>> +		return 0;
>> +
>> +	switch (state) {
>> +	case BR_STATE_FORWARDING:
>> +		cpsw_state = ALE_PORT_STATE_FORWARD;
>> +		break;
>> +	case BR_STATE_LEARNING:
>> +		cpsw_state = ALE_PORT_STATE_LEARN;
>> +		break;
>> +	case BR_STATE_DISABLED:
>> +		cpsw_state = ALE_PORT_STATE_DISABLE;
>> +		break;
>> +	case BR_STATE_LISTENING:
>> +	case BR_STATE_BLOCKING:
>> +		cpsw_state = ALE_PORT_STATE_BLOCK;
>> +		break;
>> +	default:
>> +		return -EOPNOTSUPP;
>> +	}
> 
> Strictly speaking, the:
> 
>> +	if (switchdev_trans_ph_prepare(trans))
>> +		return 0;
> 
> should be here. In the prepare phase, you are suppose to validate you
> can do the requested action, and return an error is not. In second
> phase, actually carrying out the action, you then never return an
> error.
> 
> But in this case, you are handling all the bridge states, so it should
> not matter.
> 

Yeah, since driver is interested in all STP states, I preferred to
terminate the function early for prepare phase. Adding switch statement
with just "return 0" for all states during prepare phase looked
redundant to me.

Thanks for the review!

Regards
Vignesh
