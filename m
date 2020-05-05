Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F8EB1C5901
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 16:21:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730569AbgEEOVC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 10:21:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730559AbgEEOU7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 10:20:59 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EC57C061A0F;
        Tue,  5 May 2020 07:20:59 -0700 (PDT)
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 4345523E80;
        Tue,  5 May 2020 16:20:57 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1588688457;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hN9heAe9nvYzjYtNDE8SqD4yGSnkgCfLMAsBpUZiufs=;
        b=MlVY1pqCRINZzT3UE7EK05+wlTCqLm5hLyXTOO7pvnWZEFyJ1Hjw6ZViHh/C6qOFZW/c1e
        ij0zOdNDDPAsMcw+63PcWcYuDXYuXlijC8S0BEiNDJbBhOk9Xpz4douoc05xQn/BYNxc/1
        5hCUs+spNQgxlPqVZecpaZYfq04dtTk=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 05 May 2020 16:20:57 +0200
From:   Michael Walle <michael@walle.cc>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [RFC net-next] net: phy: at803x: add cable diagnostics support
In-Reply-To: <20200505130741.GD208718@lunn.ch>
References: <20200503181517.4538-1-michael@walle.cc>
 <20200505130741.GD208718@lunn.ch>
User-Agent: Roundcube Webmail/1.4.4
Message-ID: <7dcb92b092057d50b8f079fa8bf0bfeb@walle.cc>
X-Sender: michael@walle.cc
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2020-05-05 15:07, schrieb Andrew Lunn:
>> +static int at803x_cable_test_get_status(struct phy_device *phydev,
>> +					bool *finished)
>> +{
>> +	struct at803x_priv *priv = phydev->priv;
>> +	static const int ethtool_pair[] = {
>> +		ETHTOOL_A_CABLE_PAIR_0, ETHTOOL_A_CABLE_PAIR_1,
>> +		ETHTOOL_A_CABLE_PAIR_2, ETHTOOL_A_CABLE_PAIR_3};
> 
> If you put one per line, you will keep the reverse christmas tree, and
> David will be happy.
> 
>> +	int pair, val, ret;
>> +	unsigned int delay_ms;
> 
> Well, David will be happy if you move this as well.

Damn, this should really be a checkpatch.pl check ;) It was "int 
delay_ms;"
before, then it was changed to "unsigned int delay_ms;"..

> 
>> +	*finished = false;
>> +
>> +	if (priv->cdt_start) {
>> +		delay_ms = AT803X_CDT_DELAY_MS;
>> +		delay_ms -= jiffies_delta_to_msecs(jiffies - priv->cdt_start);
>> +		if (delay_ms > 0)
>> +			msleep(delay_ms);
>> +	}
>> +
>> +	for (pair = 0; pair < 4; pair++) {
>> +		ret = at803x_cdt_start(phydev, pair);
>> +		if (ret)
>> +			return ret;
>> +
>> +		ret = at803x_cdt_wait_for_completion(phydev);
>> +		if (ret)
>> +			return ret;
>> +
>> +		val = phy_read(phydev, AT803X_CDT_STATUS);
>> +		if (val < 0)
>> +			return val;
>> +
>> +		ethnl_cable_test_result(phydev, ethtool_pair[pair],
>> +					at803x_cdt_test_result(val));
>> +
>> +		if (at803x_cdt_fault_length_valid(val))
>> +			continue;
> 
> The name is not very intuitive. It return false if it is valid?

Mhh, this is actually wrong, it returns true if the length is
valid. I need to double check that. what about
at803x_cdt_fault_length_is_valid()

> Otherwise, this looks good.

I'll wait for your v3 and then I'll rebase on that.

-michael
