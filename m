Return-Path: <netdev+bounces-10790-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B69CD730506
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 18:36:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D223F1C20CFF
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 16:36:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7DD92EC07;
	Wed, 14 Jun 2023 16:35:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB6592EC00
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 16:35:58 +0000 (UTC)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BB20212D;
	Wed, 14 Jun 2023 09:35:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=zoOW0ZiNmDtu4Zp3WTG84bXR18T6RnQ3c3NcObSn0t8=; b=Bb3i7EXg2Y5DTbLx+ObL7QLd/D
	jgRwevR8K93fkQzVkpKNWJeuU1DV0SQJyrjUzV0paDYYP4O+no2MUy7XO/bN5wCyeIphi3BxRh+6S
	up0KL9lrh/D405RcUMuTNH6yuU6BLYwY7GbK4L+40EMEikPibJFTVYwnSRuwQFxqMRl1ZoAx9Q+Sg
	W+O9ol0pR8b93ga77s72wLAwkOGU8vdaaLco2KWyGet7IGTIPzFwGJD4/IHT26B4nKvDtAHffUkOM
	jr2D8zvvqd/5T2YRLQKutIEak/K5remDMD3C7Zh2g2mcWUGi/rYxD/T8RCW8Jm1Ghilc093L3aBWy
	48uP04Hg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:41334)
	by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <linux@armlinux.org.uk>)
	id 1q9TT7-0001za-L5; Wed, 14 Jun 2023 17:35:37 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
	(envelope-from <linux@shell.armlinux.org.uk>)
	id 1q9TT0-0000ZE-28; Wed, 14 Jun 2023 17:35:30 +0100
Date: Wed, 14 Jun 2023 17:35:30 +0100
From: "Russell King (Oracle)" <linux@armlinux.org.uk>
To: arinc9.unal@gmail.com
Cc: =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
	Daniel Golle <daniel@makrotopia.org>,
	Landen Chao <Landen.Chao@mediatek.com>,
	DENG Qingfang <dqfext@gmail.com>,
	Sean Wang <sean.wang@mediatek.com>, Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Frank Wunderlich <frank-w@public-files.de>,
	Bartel Eerdekens <bartel.eerdekens@constell8.be>,
	mithat.guner@xeront.com, erkin.bozoglu@xeront.com,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: Re: [PATCH net v4 5/7] net: dsa: mt7530: fix handling of LLDP frames
Message-ID: <ZInsUm5M47p4ReF3@shell.armlinux.org.uk>
References: <20230612075945.16330-1-arinc.unal@arinc9.com>
 <20230612075945.16330-6-arinc.unal@arinc9.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230612075945.16330-6-arinc.unal@arinc9.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 12, 2023 at 10:59:43AM +0300, arinc9.unal@gmail.com wrote:
> diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
> index e4c169843f2e..8388b058fbe4 100644
> --- a/drivers/net/dsa/mt7530.c
> +++ b/drivers/net/dsa/mt7530.c
> @@ -2261,7 +2261,11 @@ mt7530_setup(struct dsa_switch *ds)
>  
>  	/* Trap BPDUs to the CPU port */
>  	mt7530_rmw(priv, MT753X_BPC, MT753X_BPDU_PORT_FW_MASK,
> -		   MT753X_BPDU_CPU_ONLY);
> +		   MT753X_PORT_FW_CPU_ONLY);
> +
> +	/* Trap LLDP frames with :0E MAC DA to the CPU port */
> +	mt7530_rmw(priv, MT753X_RGAC2, MT753X_R0E_PORT_FW_MASK,
> +		   MT753X_R0E_PORT_FW(MT753X_PORT_FW_CPU_ONLY));
>  
>  	/* Enable and reset MIB counters */
>  	mt7530_mib_reset(ds);
> @@ -2364,7 +2368,11 @@ mt7531_setup_common(struct dsa_switch *ds)
>  
>  	/* Trap BPDUs to the CPU port(s) */
>  	mt7530_rmw(priv, MT753X_BPC, MT753X_BPDU_PORT_FW_MASK,
> -		   MT753X_BPDU_CPU_ONLY);
> +		   MT753X_PORT_FW_CPU_ONLY);
> +
> +	/* Trap LLDP frames with :0E MAC DA to the CPU port(s) */
> +	mt7530_rmw(priv, MT753X_RGAC2, MT753X_R0E_PORT_FW_MASK,
> +		   MT753X_R0E_PORT_FW(MT753X_PORT_FW_CPU_ONLY));

Looking at the above two hunks, they look 100% identical. Given that
they are both setting up trapping to the CPU port, maybe they should
be moved into their own common function called from both setup()
functions?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!

