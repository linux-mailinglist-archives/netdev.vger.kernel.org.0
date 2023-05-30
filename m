Return-Path: <netdev+bounces-6403-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 119D17162B1
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 15:54:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A72B61C20BCB
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 13:54:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C3C2209BC;
	Tue, 30 May 2023 13:54:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C74CE1993C
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 13:54:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E846C4339B;
	Tue, 30 May 2023 13:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685454849;
	bh=rgf+HEj4ZYtwLLR/R3w1YhWAX1e+gNFkFUVeEzu18m4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=vONDWZ9ntDzM4PRohaxB3E7voG+FpjkPs0BpVBGHFOKVhlX2Kl72iKbh/wpEnXwvA
	 MvG0cw8/1qnoW8ChO9yzMc+3hZ0J+6qXtiGDgv6RRipTF32ADW0zrbg9o8IncJwTGC
	 ClSiazKVVW5IPAZZJ3JSUNrpRApjfrpe7c9Yu+wCtd3IAS16v9UVIw60dyiQ/P3llo
	 gNuZvk3pVoK5Vc1HjbEPs0Q/CYAVfTi3gCwE2VKqY1wrMy/XnXh8IFVmsT0M18cD/d
	 JcxPZRVTIpOdtadlJvMQYnKMgF/ADW0uqnl7otCADjFbJNKJZd4Q9eV/HA/uyftboK
	 oHDoDEvDIPg7A==
Date: Tue, 30 May 2023 15:54:01 +0200
From: Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To: Michal Smulski <michal.smulski@ooma.com>
Cc: Andrew Lunn <andrew@lunn.ch>, "f.fainelli@gmail.com"
 <f.fainelli@gmail.com>, "olteanv@gmail.com" <olteanv@gmail.com>,
 "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v2] net: dsa: mv88e6xxx: implement USXGMII mode
 for mv88e6393x
Message-ID: <20230530155401.706eb6b2@dellmb>
In-Reply-To: <BYAPR14MB291865D8A5763CFA9552774FE34A9@BYAPR14MB2918.namprd14.prod.outlook.com>
References: <20230527172024.9154-1-michal.smulski@ooma.com>
	<20230528092522.47enrnrslgflovmx@kandell>
	<512cef84-b7f0-4532-86a3-6972d05ca25d@lunn.ch>
	<BYAPR14MB291865D8A5763CFA9552774FE34A9@BYAPR14MB2918.namprd14.prod.outlook.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.37; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 29 May 2023 17:23:12 +0000
Michal Smulski <michal.smulski@ooma.com> wrote:

> If I understand this correctly, you are asking to create a function for USXGMII similar to:
> 
> static int mv88e6390_serdes_pcs_get_state_sgmii(struct mv88e6xxx_chip *chip,
> 	int port, int lane, struct phylink_link_state *state)
> 
> However, the datasheet for 88e6393x chips does not document any registers for USXGMII interface (as it does for SGMII). You can only see that 10G link is valid by looking at MV88E6390_10G_STAT1 & MDIO_STAT1_LSTATUS which has already been implemented in:
> static int mv88e6390_serdes_pcs_get_state_10g(struct mv88e6xxx_chip *chip,
> 	int port, int lane, struct phylink_link_state *state)
> The datasheet states that in USXGMII mode the link is always set to 10GBASE-R coding for all data rates.
> 
> From the logs, I see that that the link is configured using in-band information. However, there is no register access in MV88E6393x that would allow to either control or get status information (speed, duplex, flow control, auto-negotiation, etc). Most of "useful" registers are already defined in mv88e6xxx/serdes.h file.
> 
> [   50.624175] mv88e6085 0x0000000008b96000:02: configuring for inband/usxgmii link mode
> ...
> [  387.116463] fsl_dpaa2_eth dpni.3 eth1: configuring for inband/usxgmii link mode
> [  387.132554] fsl_dpaa2_eth dpni.3 eth1: Link is Up - 10Gbps/Full - flow control off
> 
> If I misunderstood what is requested, please give me a bit more information what I should be adding for this patch to be accepted.

I know that 6393x does not document the USXGMII registers, but I bet
there are there. Similar to how 88X3540 supports USXGMII but the
registers are not documented.

Do you have func spec for 88X3310 / 88X3340 ? Those two document some
USXGMII registers, and the bits are the same as in this microsemi
document
  https://www.microsemi.com/document-portal/doc_view/1245324-coreusxgmii-hb

I don't acutally have access to Cisco's USXGMII specification, but I
bet these register bits are same between vendors. Could you at least
try to investigate this?

Marek

