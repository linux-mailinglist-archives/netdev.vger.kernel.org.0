Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63F2944643E
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 14:38:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232254AbhKENkn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Nov 2021 09:40:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232052AbhKENkm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Nov 2021 09:40:42 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25742C061714;
        Fri,  5 Nov 2021 06:38:03 -0700 (PDT)
Message-ID: <ba543ae4-3a71-13fe-fa82-600ac37eaf5a@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1636119481;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sZQB9w3+9FKZwmi/cO2+1n0La9tvCBuaJ9sTpnPYv4g=;
        b=RDGwff50BUZRF67gegFKaDbSUG2omly1gxVB7XUa7+2giu6sckDggxlWMSEymeNSexidQJ
        n52bGsUc+kvAi+8St8UKVFnhfsUjUndyXpt7/+yE6X5++ygqhUkoId7OMOOd0qtMAUiV0d
        jcbglE6CKlk+IDQGUmaWzoJ8bVZHpGe0nzVDelfL+c5dER0T6aj9wEyS/L8iYm4aHFOfOQ
        4l2O/WShm2GtY+OTnLH3DTIgRsjWhcfdmwOeYVp48Uc8wk/4FBulArFHwyxvrYCRtOBie1
        1JzxcDFgpUfTN5bkCfMx39iZg/C/Eq2Jps6rSON6RDUFrj0B7lUpgQoRImc5QQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1636119481;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sZQB9w3+9FKZwmi/cO2+1n0La9tvCBuaJ9sTpnPYv4g=;
        b=A2Y1ws64rELJfRZc3Z2qFqdyymiBgpjNKzpO0NBUgCEqaSVkfx8E7/0MZgP0tETMJ+Jbn8
        Jxm5+pGQ5gYoVjBw==
Date:   Fri, 5 Nov 2021 14:38:01 +0100
MIME-Version: 1.0
Subject: Re: [PATCH 7/7] net: dsa: b53: Expose PTP timestamping ioctls to
 userspace
Content-Language: de-DE
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <20211104133204.19757-1-martin.kaistra@linutronix.de>
 <20211104133204.19757-8-martin.kaistra@linutronix.de>
 <20211104174251.GB32548@hoboy.vegasvil.org>
From:   Martin Kaistra <martin.kaistra@linutronix.de>
In-Reply-To: <20211104174251.GB32548@hoboy.vegasvil.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 04.11.21 um 18:42 schrieb Richard Cochran:
> On Thu, Nov 04, 2021 at 02:32:01PM +0100, Martin Kaistra wrote:
>> +static int b53_set_hwtstamp_config(struct b53_device *dev, int port,
>> +				   struct hwtstamp_config *config)
>> +{
>> +	struct b53_port_hwtstamp *ps = &dev->ports[port].port_hwtstamp;
>> +	bool tstamp_enable = false;
>> +
>> +	clear_bit_unlock(B53_HWTSTAMP_ENABLED, &ps->state);
>> +
>> +	/* Reserved for future extensions */
>> +	if (config->flags)
>> +		return -EINVAL;
>> +
>> +	switch (config->tx_type) {
>> +	case HWTSTAMP_TX_ON:
>> +		tstamp_enable = true;
>> +		break;
>> +	case HWTSTAMP_TX_OFF:
>> +		tstamp_enable = false;
>> +		break;
>> +	default:
>> +		return -ERANGE;
>> +	}
>> +
>> +	switch (config->rx_filter) {
>> +	case HWTSTAMP_FILTER_NONE:
>> +		tstamp_enable = false;
>> +		break;
>> +	case HWTSTAMP_FILTER_PTP_V2_L2_EVENT:
>> +	case HWTSTAMP_FILTER_PTP_V2_L2_SYNC:
>> +	case HWTSTAMP_FILTER_PTP_V2_L2_DELAY_REQ:
>> +	case HWTSTAMP_FILTER_PTP_V2_EVENT:
>> +	case HWTSTAMP_FILTER_PTP_V2_SYNC:
>> +	case HWTSTAMP_FILTER_PTP_V2_DELAY_REQ:
> 
> This is incorrect.  HWTSTAMP_FILTER_PTP_V2_EVENT includes support for
> UDP/IPv4 and UDP/IPv6.  Driver should return error here.

Ok, then I will remove HWTSTAMP_FILTER_PTP_V2_(EVENT|SYNC|DELAY_REQ) 
from this list, what about HWTSTAMP_FILTER_ALL?

> 
>> +	case HWTSTAMP_FILTER_ALL:
>> +		config->rx_filter = HWTSTAMP_FILTER_PTP_V2_L2_EVENT;
>> +		break;
>> +	default:
>> +		return -ERANGE;
>> +	}
> 
> Thanks,
> Richard
> 


