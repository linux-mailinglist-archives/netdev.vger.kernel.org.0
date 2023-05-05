Return-Path: <netdev+bounces-609-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BD1966F885E
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 20:05:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B4D6B1C2195C
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 18:05:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F7D7C8CD;
	Fri,  5 May 2023 18:05:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BCCA2F33
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 18:05:49 +0000 (UTC)
X-Greylist: delayed 1584 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 05 May 2023 11:05:47 PDT
Received: from mx.dolansoft.org (s2.dolansoft.org [212.51.146.245])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3330B160B1
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 11:05:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=brun.one;
	s=s1; h=MIME-Version:Message-Id:To:Subject:From:Date:In-Reply-To:References:
	From:To:CC:Subject:Date:Message-ID:Reply-To;
	bh=d5IHyIyxtDU3efblvNQ2dzovcfL520dwiR9VmtOuS3k=; b=F0CFttPRbtk3MwH5pI5JH0p/PX
	9P82sqSQYwqBaYjqRpM24G1tYzraYOV5NuKunIa9YQBUdeTDCtuUTv8y+V7RYqoSbLX4Tmd4wOjjl
	sb992JeB52y1z8rq2CxBpZfiW6O9XKAlQEROx/q3P/cRIXObTtoL12qId3klqUYlsDJvlqLuzqMk7
	u3eOnDMpCHgoHsgDO3pIlBfss4jK1BIxW+9wNZOp0V9CmRP2FYHpIfQ0DgDjzQAAg5pHnUThWBEBn
	BR8K1mRnK+O5gC4sOaggMgskg2aNIuNP+x4pW8UMl0gyvqUXbxSSZbZ0/vaePI8JxyfWrzUOeZ5my
	n2ArCAFw==;
Received: from [212.51.153.89] (helo=[192.168.12.232])
	by mx.dolansoft.org with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <lorenz@dolansoft.org>)
	id 1puzOq-000a4K-2O
	for netdev@vger.kernel.org;
	Fri, 05 May 2023 17:39:20 +0000
Date: Fri, 05 May 2023 19:39:12 +0200
From: Lorenz Brun <lorenz@brun.one>
Subject: Quirks for exotic SFP module
To: netdev@vger.kernel.org
Message-Id: <C157UR.RELZCR5M9XI83@brun.one>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Sender: lorenz@dolansoft.org
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi netdev members,

I have some SFP modules which contain a G.fast modem (Metanoia MT5321). 
In my case I have ones without built-in flash, which means that they 
come up in bootloader mode. Their EEPROM is emulated by the onboard 
CPU/DSP and is pretty much completely incorrect, the claimed checksum 
is 0x00. Luckily there seems to be valid vendor and part number 
information to quirk off of.

I've implemented a detection mechanism analogous to the Cotsworks one, 
which catches my modules. Since the bootloader is in ROM, we sadly 
cannot overwrite the bad data, so I just made it skip the CRC check if 
this is an affected device and the expected CRC is zero.

There is also the issue of the module advertising 1000BASE-T:

 Identifier : 0x03 (SFP)
 Extended identifier : 0x04 (GBIC/SFP defined by 2-wire interface ID)
 Connector : 0x22 (RJ45)
 Transceiver codes : 0x00 0x00 0x00 0x08 0x00 0x00 0x00 0x00 0x00
 Transceiver type : Ethernet: 1000BASE-T
 Encoding : 0x01 (8B/10B)
 BR, Nominal : 0MBd
 Rate identifier : 0x00 (unspecified)
 Length (SMF,km) : 0km
 Length (SMF) : 0m
 Length (50um) : 0m
 Length (62.5um) : 0m
 Length (Copper) : 0m
 Length (OM3) : 0m
 Laser wavelength : 0nm
 Vendor name : METANOIA
 Vendor OUI : 00:00:00
 Vendor PN : MT5321
 Vendor rev : 0001
 Option values : 0x08 0x00
 Option : Retimer or CDR implemented
 BR margin, max : 0%
 BR margin, min : 0%
 Vendor SN :
 Date code : ________

But the module internally has an AR8033 1000BASE-X to RGMII converter 
which is then connected to the modem SoC, so as far as I am aware this 
is incorrect and could cause Linux to do things like autonegotiation 
which definitely does not work here. So this probably needs to be 
quirked away. Anything else I have missed which needs to be changed?

Also, should the quirks and the workaround for the missing checksum be 
separate?

Thanks for your help!
Regards,
Lorenz



