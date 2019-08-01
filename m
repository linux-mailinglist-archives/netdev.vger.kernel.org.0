Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF14C7E0FA
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 19:22:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731067AbfHARWq convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 1 Aug 2019 13:22:46 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:57644 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726017AbfHARWq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Aug 2019 13:22:46 -0400
Received: from localhost (c-24-22-75-21.hsd1.or.comcast.net [24.22.75.21])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 065E0153F53E0;
        Thu,  1 Aug 2019 10:22:44 -0700 (PDT)
Date:   Thu, 01 Aug 2019 13:22:44 -0400 (EDT)
Message-Id: <20190801.132244.614118963896811192.davem@davemloft.net>
To:     opensource@vdorst.com
Cc:     netdev@vger.kernel.org, frank-w@public-files.de,
        sean.wang@mediatek.com, f.fainelli@gmail.com,
        matthias.bgg@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        john@phrozen.org, linux-mediatek@lists.infradead.org,
        linux-mips@vger.kernel.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org, linux@armlinux.org.uk
Subject: Re: [PATCH net-next 1/3] net: dsa: mt7530: Convert to PHYLINK API
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190801172104.Horde.Cuwt4jywUX_mcO9-n8QpWTN@www.vdorst.com>
References: <20190724192549.24615-2-opensource@vdorst.com>
        <20190727184828.GT1330@shell.armlinux.org.uk>
        <20190801172104.Horde.Cuwt4jywUX_mcO9-n8QpWTN@www.vdorst.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 01 Aug 2019 10:22:45 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: René van Dorst <opensource@vdorst.com>
Date: Thu, 01 Aug 2019 17:21:04 +0000

> Quoting Russell King - ARM Linux admin <linux@armlinux.org.uk>:
> 
>> Hi,
>>
>> Just a couple of minor points.
>>
>> On Wed, Jul 24, 2019 at 09:25:47PM +0200, René van Dorst wrote:
> 
> <snip>
> 
>>> +
>>> +static void mt7530_phylink_validate(struct dsa_switch *ds, int port,
>>> +				    unsigned long *supported,
>>> +				    struct phylink_link_state *state)
>>> +{
>>> +	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
>>> +
>>> +	switch (port) {
>>> +	case 0: /* Internal phy */
>>> +	case 1:
>>> +	case 2:
>>> +	case 3:
>>> +	case 4:
>>> +		if (state->interface != PHY_INTERFACE_MODE_NA &&
>>> +		    state->interface != PHY_INTERFACE_MODE_GMII)
>>> +			goto unsupported;
>>> +		break;
>>> +	/* case 5: Port 5 not supported! */
>>> +	case 6: /* 1st cpu port */
>>> +		if (state->interface != PHY_INTERFACE_MODE_NA &&
>>> +		    state->interface != PHY_INTERFACE_MODE_RGMII &&
>>> +		    state->interface != PHY_INTERFACE_MODE_TRGMII)
>>> +			goto unsupported;
>>> +		break;
>>> +	default:
>>> +		linkmode_zero(supported);
>>> + dev_err(ds->dev, "%s: unsupported port: %i\n", __func__, port);
>>
>> You could reorder this as:
>>
>> 	default:
>> 		dev_err(ds->dev, "%s: unsupported port: %i\n", __func__, port);
>> 	unsupported:
>> 		linkmode_zero(supported);
>>
> 
> Hi David,
> 
>> and save having the "unsupported" at the end of the function.  Not
>> sure
>> what DaveM would think of it though.
> 
> Can you give your option about this?
> So I know what to do with it and make a new series.

Russell's suggestion is fine.
