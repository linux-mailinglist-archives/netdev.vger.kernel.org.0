Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83C9F4F7D3E
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 12:48:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244540AbiDGKt5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 06:49:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244542AbiDGKt4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 06:49:56 -0400
Received: from phobos.denx.de (phobos.denx.de [85.214.62.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F065A1CA138
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 03:47:56 -0700 (PDT)
Received: from [127.0.0.1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: marex@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 944828205B;
        Thu,  7 Apr 2022 12:47:54 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1649328475;
        bh=PGzyioWsm/hHxgsvbP5tAswm3oEFGlanrHAxXuQ18MI=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=C8s3nu5mFTxtiLc1330LxeqE3bxV3RGPBzVN4nJGFFLXc1xy5cm9dp6Oox2QVci6M
         KHw7HeI1IsUUxlzRFn0LYCU+1PiBuzDlQvgB7hF8sJrMgEFDElqUQHqfhm4RnRnH7e
         /jc7TqHSfD/0hrqFrWotdF7fkbtv6m8wC2ozdXX8E+x/cPsGTTHd7MgK52Zw5QD6H9
         VjPZCokpFY49AEbId53763MgzpjdTqFr6LkXtRkcUMBTBH4kuKfOyL0BhtniXnauvS
         UXhri0UnvRQtVFAy9J54hzHMr/gcjmnp9B/MWahN0EjBzQwge5w7CmGt+oAB8TyrI2
         eyjL9HRZzbc4w==
Message-ID: <a6234484-e327-3a31-a5df-b5964ef3e0e5@denx.de>
Date:   Thu, 7 Apr 2022 12:47:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v2] net: phy: micrel: ksz9031/ksz9131: add cabletest
 support
Content-Language: en-US
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Paolo Abeni <pabeni@redhat.com>, kernel@pengutronix.de
References: <20220407020812.1095295-1-marex@denx.de>
 <20220407050605.GA21228@pengutronix.de>
From:   Marek Vasut <marex@denx.de>
In-Reply-To: <20220407050605.GA21228@pengutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.103.5 at phobos.denx.de
X-Virus-Status: Clean
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/7/22 07:06, Oleksij Rempel wrote:
> On Thu, Apr 07, 2022 at 04:08:12AM +0200, Marek Vasut wrote:
> ...
> 
>> +static int ksz9x31_cable_test_result_trans(u16 status)
>> +{
>> +	switch (FIELD_GET(KSZ9x31_LMD_VCT_ST_MASK, status)) {
>> +	case KSZ9x31_LMD_VCT_ST_NORMAL:
>> +		return ETHTOOL_A_CABLE_RESULT_CODE_OK;
>> +	case KSZ9x31_LMD_VCT_ST_OPEN:
>> +		return ETHTOOL_A_CABLE_RESULT_CODE_SAME_SHORT;
>> +	case KSZ9x31_LMD_VCT_ST_SHORT:
>> +		return ETHTOOL_A_CABLE_RESULT_CODE_OPEN;
> 
> This conversation looks twisted:
> VCT_ST_OPEN -> CODE_SAME_SHORT
> VCT_ST_SHORT -> CODE_OPEN

Doh ... fixed

>> +	case KSZ9x31_LMD_VCT_ST_FAIL:
>> +		fallthrough;
>> +	default:
>> +		return ETHTOOL_A_CABLE_RESULT_CODE_UNSPEC;
>> +	}
>> +}
>> +
> ...
>> +static int ksz9x31_cable_test_get_status(struct phy_device *phydev,
>> +					 bool *finished)
>> +{
>> +	struct kszphy_priv *priv = phydev->priv;
>> +	unsigned long pair_mask = 0xf;
>> +	int retries = 20;
>> +	int pair, ret, rv;
>> +
>> +	*finished = false;
>> +
>> +	/* Try harder if link partner is active */
>> +	while (pair_mask && retries--) {
>> +		for_each_set_bit(pair, &pair_mask, 4) {
>> +			ret = ksz9x31_cable_test_one_pair(phydev, pair);
>> +			if (ret == -EAGAIN)
>> +				continue;
>> +			if (ret < 0)
>> +				return ret;
>> +			clear_bit(pair, &pair_mask);
>> +		}
>> +		/* If link partner is in autonegotiation mode it will send 2ms
>> +		 * of FLPs with at least 6ms of silence.
>> +		 * Add 2ms sleep to have better chances to hit this silence.
>> +		 */
>> +		if (pair_mask)
>> +			usleep_range(2000, 3000);
> 
> Not a blocker, just some ideas:
> In my experience, active link partner may affect test result in way,
> that the PHY wont report it as failed test. Especially, if the cable is
> on the edge of specification (for example too long cable).
> At same time 6ms of silence is PHY specific implementation. For example
> KSZ PHYs tend to send burst of FLPs and the switch to other MDI-X pair
> (if auto MDI-X is enabled). Some RTL PHYs tend to send random firework of pulses
> on different pairs.
> 
> May be we should not fight against autoneg and misuse it a bit? For
> example:
> 0. force MDI configuration
> 1. limit autoneg to 10mbit

We can't do that in this case, can we ?

KSZ9131RNX, DS00002841B-page 38, 4.14 LinkMD (R) Cable Diagnostic
"
Prior to running the cable diagnostics, Auto-negotiation should
be disabled, full duplex set and the link speed set to 1000Mbps
via the Basic Control Register.
"

> 2. allow the link
> 3. switch to test and run on unused pair
> 4. force MDI-X configuration and goto 1.
> 
> Other options can be:
> - implement autoneg next page tx/rx and pass linux-vendor specific
>    information over it (some thing like, please stop autoneg for X amount
>    of sec)
> - advertise remote fault

Wouldn't that only work if the link partner is also up to date linux 
machine ?
