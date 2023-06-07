Return-Path: <netdev+bounces-8967-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E8D77266CA
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 19:10:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E6C412812FE
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 17:10:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A06B37323;
	Wed,  7 Jun 2023 17:10:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F029863B5
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 17:10:07 +0000 (UTC)
X-Greylist: delayed 519 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 07 Jun 2023 10:10:05 PDT
Received: from knopi.disroot.org (knopi.disroot.org [178.21.23.139])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FECA1FC2;
	Wed,  7 Jun 2023 10:10:05 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by disroot.org (Postfix) with ESMTP id D3F4A40625;
	Wed,  7 Jun 2023 19:01:18 +0200 (CEST)
X-Virus-Scanned: SPAM Filter at disroot.org
Received: from knopi.disroot.org ([127.0.0.1])
	by localhost (disroot.org [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vliWW6Kk02sA; Wed,  7 Jun 2023 19:01:17 +0200 (CEST)
From: Marco Giorgi <giorgi.marco.96@disroot.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=disroot.org; s=mail;
	t=1686157277; bh=lZZ++WwSaQKCWAG2lUZFQgL5M2d2kWKGbJCXtIUfVJk=;
	h=From:To:Cc:Subject:Date;
	b=d9KmY3FASaiZoDGXQd1dKs9fXRg059+yGpLtgmPeojYEd0yYHAukNa+mG2ThsWeGC
	 M/8b24Ec8QhHeB5jf4d5RjWKW/kwXY+umx6qd/0mJ+nDqjV4nSo8DNyVwrjOb7R6Op
	 sUYCBGE7ABgnlmbukkhixYFPRLP4RmNlD493NSxg4U9IZWcjQhm6p/XDA3gKbHptF1
	 2SwGpFJdTDVZksTQbL6LHGwoU9Rl5V6swX8KovaAoQoQKSnIAlbE6jHeTm+mtwjqEm
	 5YLsW7f12sHtnf0HmKbBtD/FF4bR8kTGcI5ty2t14I7IK2G/v3dWgJZdCeU8Ud19+R
	 rHUqgAqvNuOXA==
To: netdev@vger.kernel.org
Cc: krzysztof.kozlowski@linaro.org,
	u.kleine-koenig@pengutronix.de,
	davem@davemloft.net,
	michael@walle.cc,
	kuba@kernel.org,
	linux-kernel@vger.kernel.org,
	Marco Giorgi <giorgi.marco.96@disroot.org>
Subject: [PATCH RFC net 0/2] nfc: nxp-nci: Fix i2c read on ThinkPad hardware
Date: Wed,  7 Jun 2023 19:00:07 +0200
Message-ID: <20230607170009.9458-1-giorgi.marco.96@disroot.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.9 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

This patch addresses issues with "I2C" read on ThinkPad hardware.

My machine (ThinkPad T590) is equipped with an NXP1001 NFC reader, although
working flawlessly with Lenovo's Windows drivers, on Linux the driver
implementation doesn't work.

My speculation on the error is that the IRQ which is associated with the device
doesn't take into account the device's IRQ GPIO value. This patch addresses
that by exiting from the IRQ if the GPIO is low.

With this, I've been able to read a tag with neard's nfctool.

This is the behavior of the mainline `nxp_nci_i2c` driver:

# nfctool -d nfc0 -1 
Connection timed out
# dmesg -Wtd 
[<   0.000000>] nxp-nci_i2c i2c-NXP1001:00: NFC: Read failed with error -121 
[<   5.142581>] nci: __nci_request: wait_for_completion_interruptible_timeout failed 0 
[<   0.013474>] nxp-nci_i2c i2c-NXP1001:00: NFC: Read failed with error -121 

This is the patched `nxp_nci_i2c` driver:

# nfctool -d nfc0 -1 
nfc0: 
         Tags: [ ] 
         Devices: [ ] 
         Protocols: [ Felica MIFARE Jewel ISO-DEP NFC-DEP ] 
         Powered: Yes 
         RF Mode: None 
         lto: 0 
         rw: 0 
         miux: 0 
 
# nfctool -d nfc0 -p 
Start polling on nfc0 as initiator 
 
Targets found for nfc0 
 Tags: [ tag0 ] 
 Devices: [ ] 


No output from `dmesg`

Marco Giorgi (2):
  nfc: nxp-nci: Fix i2c read on ThinkPad hardware
  nfc: nxp-nci: Fix i2c read on ThinkPad hardware

 drivers/nfc/nxp-nci/i2c.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)


base-commit: 44f8baaf230c655c249467ca415b570deca8df77
-- 
2.41.0


