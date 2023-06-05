Return-Path: <netdev+bounces-7861-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 811A5721DE0
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 08:13:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 013A31C20AAE
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 06:13:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72DA2443E;
	Mon,  5 Jun 2023 06:13:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63CF02104
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 06:13:38 +0000 (UTC)
Received: from relay1-d.mail.gandi.net (relay1-d.mail.gandi.net [217.70.183.193])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49983D3
	for <netdev@vger.kernel.org>; Sun,  4 Jun 2023 23:13:37 -0700 (PDT)
X-GND-Sasl: maxime.chevallier@bootlin.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
	t=1685945615;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mdkvJzyVA1WlXUtMOS1YLVZactouFZmayK8gbUzMHQA=;
	b=Vsuy+ow8Jg52XT0TqzacD6drW7N9jfzAVH6L1EbVXYQJ+elAYEPpb30x/I9pjkPdhwGoc/
	KWQfQQ1YzCB/KAzye0gzSNysAYR8CQOfNCVHAWwDEdZdvx5aHJqoo+BXpUgTKqFyXwsPXZ
	Ah3qERPFE1DMnqUf45/GU1m3t51FE+ZRIsHnlpQpbWuoRpP5SXWdxbzo2INwHag9SCUs2N
	WpqBgphpRFe7oTozEHFHZ24FA8IZQpbA2ud0Hdsvr4TJFP0KFQKd6EFQngsMXWEvYOsF3Y
	XsFNvmZ7ehMsgik5lWwxAPUXl2fgG6g9DO+a0YpU8hGb53ldCtpZCFho21eJlQ==
X-GND-Sasl: maxime.chevallier@bootlin.com
X-GND-Sasl: maxime.chevallier@bootlin.com
Received: by mail.gandi.net (Postfix) with ESMTPSA id 4E69B240006;
	Mon,  5 Jun 2023 06:13:35 +0000 (UTC)
Date: Mon, 5 Jun 2023 08:13:34 +0200
From: Maxime Chevallier <maxime.chevallier@bootlin.com>
To: "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc: Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
Subject: Re: QUSGMII control word
Message-ID: <20230605081334.3258befa@pc-7.home>
In-Reply-To: <ZHnd+6FUO77XFJvQ@shell.armlinux.org.uk>
References: <ZHnd+6FUO77XFJvQ@shell.armlinux.org.uk>
Organization: Bootlin
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.37; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hello Russell,

On Fri, 2 Jun 2023 13:18:03 +0100
"Russell King (Oracle)" <linux@armlinux.org.uk> wrote:

> Hi Maxime,
> 
> Looking at your commit which introduced QUSGMII -
> 5e61fe157a27 ("net: phy: Introduce QUSGMII PHY mode"), are you sure
> your decoding of the control word is correct?
> 
> I've found some information online which suggests that QUSGMII uses a
> slightly different format to the control word from SGMII. Most of the
> bits are the same, but the speed bits occupy the three bits from 11:9,
> and 10M, 100M and 1G are encoded using bits 10:9, whereas in SGMII
> they are bits 11:10. In other words, in QUSGMII they are shifted one
> bit down. In your commit, you used the SGMII decoder for QUSGMII,
> which would mean we'd be picking out the wrong bits for decoding the
> speed.
> 
> QUSGMII also introduces EEE information into bits 8 and 7 whereas
> these are reserved in SGMII.
> 
> Please could you take a look, because I think we need a different
> decoder for the QUSGMII speed bits.

I've taken a look at it, back when I sent that patch I didn't have
access to the full documentation and used a vendor reference
implementation as a basis... I managed to get my hands on the proper
doc and the control word being used looks to be the usxgmii control
word, which matches with the offset you are seeing.

Do you have a patch or should I send a followup ?

Out of curiosity, on which hardware did you find this ?

I still have some patches of PCH extensions around, but didn't get any
room in my schedule to move forward with it. Is it something that you
plan on using ?

Thanks for the report,

Maxime

> Thanks.
> 


