Return-Path: <netdev+bounces-1464-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D0446FDD58
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 14:00:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 063372813DD
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 12:00:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01BD912B67;
	Wed, 10 May 2023 12:00:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA6028C1C
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 12:00:35 +0000 (UTC)
Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::223])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B9547ABF
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 05:00:26 -0700 (PDT)
Received: (Authenticated sender: thomas.petazzoni@bootlin.com)
	by mail.gandi.net (Postfix) with ESMTPSA id 665CA60010;
	Wed, 10 May 2023 12:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
	t=1683720024;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TppqhAQBU5f329Qyr84VrX2a1Pt5tkHupSTS+6i/nLU=;
	b=Hdd/GGR1GxE3BuniPdnXz/3itRr/j1tW9nzNX13vRsJugsgDO7+ZPpsmUz06eckv7oYuBI
	LLJmEcFdajyMKIAFiPzAN/HcvFMTKruKJsfNNAdLk1Dr9XpyVY+mfAPmG8GBtiClcs1mmi
	PFLVaAY/1tqIXQPtkCzK2YsOJERMYFpjiB6iWoi6lAevCKO0KsNFLo/gfB52N+eRqSyzCD
	fKivvCJmO1Ed8n+YkV40z8xy0divAqeNtNiplLoY6ISMKVUqLPF+1jJVJRT/uPfJmFup7V
	TvOBftMBTvZ/vVd+ya45niIHhyNw5C+VsyanYlay9VRpAD75rvw8cDpudlZGaQ==
Date: Wed, 10 May 2023 14:00:22 +0200
From: Thomas Petazzoni <thomas.petazzoni@bootlin.com>
To: "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc: Eric Dumazet <edumazet@google.com>, Marek =?UTF-8?B?QmVow7pu?=
 <kabel@kernel.org>, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski
 <kuba@kernel.org>, netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
 =?UTF-8?B?R3LDqWdvcnk=?= Clement <gregory.clement@bootlin.com>, Maxime
 Chevallier <maxime.chevallier@bootlin.com>
Subject: Re: [PATCH net-next 5/5] net: mvneta: allocate TSO header DMA
 memory in chunks
Message-ID: <20230510140022.6e170eec@windsurf>
In-Reply-To: <ZFuEphwApIDwJSxb@shell.armlinux.org.uk>
References: <ZFtuhJOC03qpASt2@shell.armlinux.org.uk>
	<E1pwgrb-001XEA-HB@rmk-PC.armlinux.org.uk>
	<CANn89iKrhFWgbqxDU2RY62PmCrhfV+OpvGUAy9uDCJ8KGw9qZw@mail.gmail.com>
	<ZFuEphwApIDwJSxb@shell.armlinux.org.uk>
Organization: Bootlin
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hello Russell,

On Wed, 10 May 2023 12:48:54 +0100
"Russell King (Oracle)" <linux@armlinux.org.uk> wrote:

> On the hardware I have, that is correct. Maybe others with mvneta on
> different SoCs can comment? Thomas probably has an idea, but as he
> hasn't worked on Marvell hardware for some time, may have forgotten
> everything about Marvell hardware.

As far as I'm aware, none of the HW platforms that have the mvneta IP
as Ethernet MAC have an IOMMU/SMMU or similar. The more recent Marvell
platforms are using the mvpp2 IP instead.

> On that point, I'm wondering whether there's much value keeping
> Thomas' maintainer's entries for Marvell stuff - any comment Thomas?

Clearly, I am no longer actively working on Marvell platforms, and it
would certainly be fine to see other people step up to maintain the
mvneta driver and drop my entry.

Best regards,

Thomas
-- 
Thomas Petazzoni, co-owner and CEO, Bootlin
Embedded Linux and Kernel engineering and training
https://bootlin.com

