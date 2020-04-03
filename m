Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABAD119DDA1
	for <lists+netdev@lfdr.de>; Fri,  3 Apr 2020 20:09:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404509AbgDCSJO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Apr 2020 14:09:14 -0400
Received: from mx.0dd.nl ([5.2.79.48]:46238 "EHLO mx.0dd.nl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728368AbgDCSJN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Apr 2020 14:09:13 -0400
Received: from mail.vdorst.com (mail.vdorst.com [IPv6:fd01::250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mx.0dd.nl (Postfix) with ESMTPS id 1E45F5FADE;
        Fri,  3 Apr 2020 20:09:12 +0200 (CEST)
Authentication-Results: mx.0dd.nl;
        dkim=pass (2048-bit key; secure) header.d=vdorst.com header.i=@vdorst.com header.b="KtO3uizp";
        dkim-atps=neutral
Received: from www (www.vdorst.com [192.168.2.222])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.vdorst.com (Postfix) with ESMTPSA id AC18627C0E5;
        Fri,  3 Apr 2020 20:09:11 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.vdorst.com AC18627C0E5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vdorst.com;
        s=default; t=1585937351;
        bh=xBdua0z2R0JdSBRmoYYNQnHi6mI3NA5tona4JmFQPrw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=KtO3uizphLuDc4K+36n4GW9eKfV1czQNFNwwSjsRupOFX6zh+lc1ZJofOUnx7mw74
         ACD1d+pMmh1u+BWLL2DRtM8RDSHlfTV77qXfsqj61/DTTdEmbhf1dCe2suosyIC57j
         WuhmNA9fKpJhZGgaNCkjiW6JJDS5V+rNLePUZNBPmIxBrwl9UM++ZXeKCFEiY5+qqS
         N+sY8VvZG2cq76ciatzusD9V0JFxMnk1xfOQZ/gCf1lRy13iHL7/9/Uabty7dg+ejo
         hhAzL/LXSHOM0CT4gaowSGGLe+VF0PkOoQ01NEDcWhJQrh4yTErQtmfvk/Pjq2MEtH
         5XOrEeek0MH/w==
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1]) by
 www.vdorst.com (Horde Framework) with HTTPS; Fri, 03 Apr 2020 18:09:11 +0000
Date:   Fri, 03 Apr 2020 18:09:11 +0000
Message-ID: <20200403180911.Horde.9xqnJvjcRDe-ttshlJbG6WE@www.vdorst.com>
From:   =?utf-8?b?UmVuw6k=?= van Dorst <opensource@vdorst.com>
To:     Chuanhong Guo <gch981213@gmail.com>
Cc:     netdev@vger.kernel.org, stable@vger.kernel.org,
        Sean Wang <sean.wang@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: dsa: mt7530: fix null pointer dereferencing in
 port5 setup
In-Reply-To: <20200403112830.505720-1-gch981213@gmail.com>
User-Agent: Horde Application Framework 5
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quoting Chuanhong Guo <gch981213@gmail.com>:

Hi Chuanhong,

> The 2nd gmac of mediatek soc ethernet may not be connected to a PHY
> and a phy-handle isn't always available.
> Unfortunately, mt7530 dsa driver assumes that the 2nd gmac is always
> connected to switch port 5 and setup mt7530 according to phy address
> of 2nd gmac node, causing null pointer dereferencing when phy-handle
> isn't defined in dts.

MT7530 tries to detect if 2nd GMAC is using a phy with phy-address 0 or 4.
If so, switch port 5 needs to be setup so that PHY 0 or 4 is available
via port 5 of the switch. Any MAC can talk to PHY 0/4 directly via port 5.
This is also explained in the kernel docs mt7530.txt.

May be there are better way to detect that any node is using phy 0/4 of
the switch.

Funny that I never tested this case that 2nd gmac node exits and is disabled
without using port 5.

Thanks for the fix.

Tested-by: René van Dorst <opensource@vdorst.com>

Greats,

René

> This commit fix this setup code by checking return value of
> of_parse_phandle before using it.
>
> Fixes: 38f790a80560 ("net: dsa: mt7530: Add support for port 5")
> Signed-off-by: Chuanhong Guo <gch981213@gmail.com>
> Cc: stable@vger.kernel.org
> ---
>
> mt7530 is available as a standalone chip and we should not make it
> tightly coupled with a specific type of ethernet dt binding in the
> first place.
> A proper fix is to replace this port detection logic with a dt
> property under mt7530 node, but that's too much for linux-stable.
>
>  drivers/net/dsa/mt7530.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
> index 6e91fe2f4b9a..1d53a4ebcd5a 100644
> --- a/drivers/net/dsa/mt7530.c
> +++ b/drivers/net/dsa/mt7530.c
> @@ -1414,6 +1414,9 @@ mt7530_setup(struct dsa_switch *ds)
>  				continue;
>
>  			phy_node = of_parse_phandle(mac_np, "phy-handle", 0);
> +			if (!phy_node)
> +				continue;
> +
>  			if (phy_node->parent == priv->dev->of_node->parent) {
>  				ret = of_get_phy_mode(mac_np, &interface);
>  				if (ret && ret != -ENODEV)
> --
> 2.25.1



