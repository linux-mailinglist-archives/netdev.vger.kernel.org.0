Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FF6B7E0F3
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 19:21:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731035AbfHARVH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 13:21:07 -0400
Received: from mx.0dd.nl ([5.2.79.48]:51400 "EHLO mx.0dd.nl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726017AbfHARVH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Aug 2019 13:21:07 -0400
Received: from mail.vdorst.com (mail.vdorst.com [IPv6:fd01::250])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.0dd.nl (Postfix) with ESMTPS id D3FAF5FAF1;
        Thu,  1 Aug 2019 19:21:04 +0200 (CEST)
Authentication-Results: mx.0dd.nl;
        dkim=pass (2048-bit key; secure) header.d=vdorst.com header.i=@vdorst.com header.b="SRQ1xsxp";
        dkim-atps=neutral
Received: from www (www.vdorst.com [192.168.2.222])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.vdorst.com (Postfix) with ESMTPSA id 863BE1D41C1A;
        Thu,  1 Aug 2019 19:21:04 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.vdorst.com 863BE1D41C1A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vdorst.com;
        s=default; t=1564680064;
        bh=qXhetRaPsrRE45vvWYJmuhc7HV2WP+u9zx31XLRxyyQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SRQ1xsxpkO0zQvFXPsBIjpU8Zewx/BoF1vudjXCLvkpvg1pOCQ77OtXy9XvZp2uiZ
         XRlnYM6t2X2BP53Fyd//MtlrNg/WiJ2xK9OPy9Lx8jNn5w0No2ermaOalvg/P1vtp7
         nRE2EVaMqiMlqAdckg44rF0BmqrQNrnnEJ/abispHn+uduExpWCaJ87XsPbYPCp81c
         Kv1jz4zIYWLBVhWJMax1v2INmDB4m2zyHAs3K7MfyMWa4jFzCLJvyEZt5no8g/kMEv
         tgUhPKsTzzDf7texObmElR7S8Vh/XjvPgjZaOJLDYNXQTyS+2VK+ZpRX/40oqDxQQo
         hoJzMg4EQfLUw==
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1]) by
 www.vdorst.com (Horde Framework) with HTTPS; Thu, 01 Aug 2019 17:21:04 +0000
Date:   Thu, 01 Aug 2019 17:21:04 +0000
Message-ID: <20190801172104.Horde.Cuwt4jywUX_mcO9-n8QpWTN@www.vdorst.com>
From:   =?utf-8?b?UmVuw6k=?= van Dorst <opensource@vdorst.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, frank-w@public-files.de,
        sean.wang@mediatek.com, f.fainelli@gmail.com,
        matthias.bgg@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        john@phrozen.org, linux-mediatek@lists.infradead.org,
        linux-mips@vger.kernel.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>
Subject: Re: [PATCH net-next 1/3] net: dsa: mt7530: Convert to PHYLINK API
References: <20190724192549.24615-1-opensource@vdorst.com>
 <20190724192549.24615-2-opensource@vdorst.com>
 <20190727184828.GT1330@shell.armlinux.org.uk>
In-Reply-To: <20190727184828.GT1330@shell.armlinux.org.uk>
User-Agent: Horde Application Framework 5
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quoting Russell King - ARM Linux admin <linux@armlinux.org.uk>:

> Hi,
>
> Just a couple of minor points.
>
> On Wed, Jul 24, 2019 at 09:25:47PM +0200, René van Dorst wrote:

<snip>

>> +
>> +static void mt7530_phylink_validate(struct dsa_switch *ds, int port,
>> +				    unsigned long *supported,
>> +				    struct phylink_link_state *state)
>> +{
>> +	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
>> +
>> +	switch (port) {
>> +	case 0: /* Internal phy */
>> +	case 1:
>> +	case 2:
>> +	case 3:
>> +	case 4:
>> +		if (state->interface != PHY_INTERFACE_MODE_NA &&
>> +		    state->interface != PHY_INTERFACE_MODE_GMII)
>> +			goto unsupported;
>> +		break;
>> +	/* case 5: Port 5 not supported! */
>> +	case 6: /* 1st cpu port */
>> +		if (state->interface != PHY_INTERFACE_MODE_NA &&
>> +		    state->interface != PHY_INTERFACE_MODE_RGMII &&
>> +		    state->interface != PHY_INTERFACE_MODE_TRGMII)
>> +			goto unsupported;
>> +		break;
>> +	default:
>> +		linkmode_zero(supported);
>> +		dev_err(ds->dev, "%s: unsupported port: %i\n", __func__, port);
>
> You could reorder this as:
>
> 	default:
> 		dev_err(ds->dev, "%s: unsupported port: %i\n", __func__, port);
> 	unsupported:
> 		linkmode_zero(supported);
>

Hi David,

> and save having the "unsupported" at the end of the function.  Not sure
> what DaveM would think of it though.

Can you give your option about this?
So I know what to do with it and make a new series.

Greats,

René

>
>
> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
> According to speedtest.net: 11.9Mbps down 500kbps up



