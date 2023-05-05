Return-Path: <netdev+bounces-617-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 59C076F8914
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 20:54:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 15C0D28108B
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 18:54:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E7C0C8C7;
	Fri,  5 May 2023 18:54:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 042EEC2ED
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 18:54:06 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 574322154C
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 11:53:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=NuyxHYXEknFwv8vExztcKKv2LirgXSIW8C3XghqFCKE=; b=3fZv4prMUS6NgLSPH74mhvaADq
	OGMWrXci+fxJYEJbwoCmvsJbFJvCHjchnOgzJv5nh0TxzWXNNPid99skJrLR53jBnHwIo28rzoWt8
	B0hdrXHKBvlyCATD3HtIQmwOtXrSO9LxkDRZgaMYCA2o6OpB/IdLvwshlOGp0R7zGh6o=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1pv0Yp-00C1Nb-1F; Fri, 05 May 2023 20:53:43 +0200
Date: Fri, 5 May 2023 20:53:43 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Lorenz Brun <lorenz@brun.one>
Cc: netdev@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>
Subject: Re: Quirks for exotic SFP module
Message-ID: <7ed07d2e-ef0e-4e27-9ac6-96d60ae0e630@lunn.ch>
References: <C157UR.RELZCR5M9XI83@brun.one>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C157UR.RELZCR5M9XI83@brun.one>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 05, 2023 at 07:39:12PM +0200, Lorenz Brun wrote:
> Hi netdev members,

For SFP matters, please Cc: SFP maintainer, and the PHY
maintainers. See the MAINTAINERS file.

> I have some SFP modules which contain a G.fast modem (Metanoia MT5321). In
> my case I have ones without built-in flash, which means that they come up in
> bootloader mode. Their EEPROM is emulated by the onboard CPU/DSP and is
> pretty much completely incorrect, the claimed checksum is 0x00. Luckily
> there seems to be valid vendor and part number information to quirk off of.

It is amazing how many SFP manufactures cannot get the simple things
like CRC right. 

> I've implemented a detection mechanism analogous to the Cotsworks one, which
> catches my modules. Since the bootloader is in ROM, we sadly cannot
> overwrite the bad data, so I just made it skip the CRC check if this is an
> affected device and the expected CRC is zero.

Sounds sensible. Probably pointless, because SFP manufactures don't
seem to care about quality, but please do print an warning that the
bad checksum is being ignored.

> There is also the issue of the module advertising 1000BASE-T:

Probably something for Russell, but what should be advertised?
1000Base-X? 

> But the module internally has an AR8033 1000BASE-X to RGMII converter which
> is then connected to the modem SoC, so as far as I am aware this is
> incorrect and could cause Linux to do things like autonegotiation which
> definitely does not work here.

Is there anything useful to be gained by talking to the PHY? Since it
appears to be just a media converter, i guess the PHY having link is
not useful. Does the LOS GPIO tell you about the G.Fast modem status?

    Andrew

