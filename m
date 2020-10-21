Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 533D029465B
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 03:51:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439895AbgJUBvd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 21:51:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:36894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439891AbgJUBvd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Oct 2020 21:51:33 -0400
Received: from [10.44.0.192] (unknown [103.48.210.53])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E9E5022409;
        Wed, 21 Oct 2020 01:51:30 +0000 (UTC)
Subject: Re: [PATCH] net: ethernet: fec: Replace interrupt driven MDIO with
 polled IO
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Chris Heally <cphealy@gmail.com>, netdev@vger.kernel.org,
        Fugang Duan <fugang.duan@nxp.com>
References: <c8143134-1df9-d3bc-8ce7-79cb71148d49@linux-m68k.org>
 <20201020024000.GV456889@lunn.ch>
From:   Greg Ungerer <gerg@linux-m68k.org>
Message-ID: <9fa61ea8-11b4-ef3c-c04e-cb124490c9ae@linux-m68k.org>
Date:   Wed, 21 Oct 2020 11:51:38 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201020024000.GV456889@lunn.ch>
Content-Type: multipart/mixed;
 boundary="------------880186BCE0B3D39A7D9E961C"
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a multi-part message in MIME format.
--------------880186BCE0B3D39A7D9E961C
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Andrew,

Thanks for the quick response.


On 20/10/20 12:40 pm, Andrew Lunn wrote:
> On Tue, Oct 20, 2020 at 12:14:04PM +1000, Greg Ungerer wrote:
>> Hi Andrew,
>>
>> Commit f166f890c8f0 ("[PATCH] net: ethernet: fec: Replace interrupt driven
>> MDIO with polled IO") breaks the FEC driver on at least one of
>> the ColdFire platforms (the 5208). Maybe others, that is all I have
>> tested on so far.
>>
>> Specifically the driver no longer finds any PHY devices when it probes
>> the MDIO bus at kernel start time.
>>
>> I have pinned the problem down to this one specific change in this commit:
>>
>>> @@ -2143,8 +2142,21 @@ static int fec_enet_mii_init(struct platform_device *pdev)
>>>   	if (suppress_preamble)
>>>   		fep->phy_speed |= BIT(7);
>>> +	/* Clear MMFR to avoid to generate MII event by writing MSCR.
>>> +	 * MII event generation condition:
>>> +	 * - writing MSCR:
>>> +	 *	- mmfr[31:0]_not_zero & mscr[7:0]_is_zero &
>>> +	 *	  mscr_reg_data_in[7:0] != 0
>>> +	 * - writing MMFR:
>>> +	 *	- mscr[7:0]_not_zero
>>> +	 */
>>> +	writel(0, fep->hwp + FEC_MII_DATA);
>>
>> At least by removing this I get the old behavior back and everything works
>> as it did before.
>>
>> With that write of the FEC_MII_DATA register in place it seems that
>> subsequent MDIO operations return immediately (that is FEC_IEVENT is
>> set) - even though it is obvious the MDIO transaction has not completed yet.
>>
>> Any ideas?
> 
> Hi Greg
> 
> This has come up before, but the discussion fizzled out without a
> final patch fixing the issue. NXP suggested this
> 
> writel(0, fep->hwp + FEC_MII_DATA);
> 
> Without it, some other FEC variants break because they do generate an
> interrupt at the wrong time causing all following MDIO transactions to
> fail.
> 
> At the moment, we don't seem to have a clear understanding of the
> different FEC versions, and how their MDIO implementations vary.

Based on Andy and Chris' comments is something like the attached patch
what we need?

Regards
Greg



--------------880186BCE0B3D39A7D9E961C
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-net-fec-fix-MDIO-probing-for-some-FEC-hardware-block.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-net-fec-fix-MDIO-probing-for-some-FEC-hardware-block.pa";
 filename*1="tch"

From 6149e75aca3bd26b158d06e6e6f10dda8fa138de Mon Sep 17 00:00:00 2001
From: Greg Ungerer <gerg@linux-m68k.org>
Date: Wed, 21 Oct 2020 11:35:21 +1000
Subject: [PATCH] net: fec: fix MDIO probing for some FEC hardware blocks

Some (apparently older) versions of the FEC hardware block do not like
the MMFR register being cleared to avoid generation of MII events at
initialization time. The action of clearing this register results in no
future MII events being generated at all on the problem block. This means
the probing of the MDIO bus will find no PHYs.

Create a quirk that can be checked at the FECs MII init time so that
the right thing is done. The quirk is set as appropriate for the FEC
hardware blocks that are known to need this.

Fixes: f166f890c8f0 ("net: ethernet: fec: Replace interrupt driven MDIO with polled IO")
Signed-off-by: Greg Ungerer <gerg@linux-m68k.org>
---
 drivers/net/ethernet/freescale/fec.h      |  6 +++++
 drivers/net/ethernet/freescale/fec_main.c | 27 +++++++++++++----------
 2 files changed, 21 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec.h b/drivers/net/ethernet/freescale/fec.h
index 832a2175636d..c527f4ee1d3a 100644
--- a/drivers/net/ethernet/freescale/fec.h
+++ b/drivers/net/ethernet/freescale/fec.h
@@ -456,6 +456,12 @@ struct bufdesc_ex {
  */
 #define FEC_QUIRK_HAS_FRREG		(1 << 16)
 
+/* Some FEC hardware blocks need the MMFR cleared at setup time to avoid
+ * the generation of an MII event. This must be avoided in the older
+ * FEC blocks where it will stop MII events being generated.
+ */
+#define FEC_QUIRK_CLEAR_SETUP_MII	(1 << 17)
+
 struct bufdesc_prop {
 	int qid;
 	/* Address of Rx and Tx buffers */
diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index fb37816a74db..e67b60de2f8d 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -107,7 +107,7 @@ static const struct fec_devinfo fec_imx6q_info = {
 	.quirks = FEC_QUIRK_ENET_MAC | FEC_QUIRK_HAS_GBIT |
 		  FEC_QUIRK_HAS_BUFDESC_EX | FEC_QUIRK_HAS_CSUM |
 		  FEC_QUIRK_HAS_VLAN | FEC_QUIRK_ERR006358 |
-		  FEC_QUIRK_HAS_RACC,
+		  FEC_QUIRK_HAS_RACC | FEC_QUIRK_CLEAR_SETUP_MII,
 };
 
 static const struct fec_devinfo fec_mvf600_info = {
@@ -119,7 +119,8 @@ static const struct fec_devinfo fec_imx6x_info = {
 		  FEC_QUIRK_HAS_BUFDESC_EX | FEC_QUIRK_HAS_CSUM |
 		  FEC_QUIRK_HAS_VLAN | FEC_QUIRK_HAS_AVB |
 		  FEC_QUIRK_ERR007885 | FEC_QUIRK_BUG_CAPTURE |
-		  FEC_QUIRK_HAS_RACC | FEC_QUIRK_HAS_COALESCE,
+		  FEC_QUIRK_HAS_RACC | FEC_QUIRK_HAS_COALESCE |
+		  FEC_QUIRK_CLEAR_SETUP_MII,
 };
 
 static const struct fec_devinfo fec_imx6ul_info = {
@@ -127,7 +128,7 @@ static const struct fec_devinfo fec_imx6ul_info = {
 		  FEC_QUIRK_HAS_BUFDESC_EX | FEC_QUIRK_HAS_CSUM |
 		  FEC_QUIRK_HAS_VLAN | FEC_QUIRK_ERR007885 |
 		  FEC_QUIRK_BUG_CAPTURE | FEC_QUIRK_HAS_RACC |
-		  FEC_QUIRK_HAS_COALESCE,
+		  FEC_QUIRK_HAS_COALESCE | FEC_QUIRK_CLEAR_SETUP_MII,
 };
 
 static struct platform_device_id fec_devtype[] = {
@@ -2114,15 +2115,17 @@ static int fec_enet_mii_init(struct platform_device *pdev)
 	if (suppress_preamble)
 		fep->phy_speed |= BIT(7);
 
-	/* Clear MMFR to avoid to generate MII event by writing MSCR.
-	 * MII event generation condition:
-	 * - writing MSCR:
-	 *	- mmfr[31:0]_not_zero & mscr[7:0]_is_zero &
-	 *	  mscr_reg_data_in[7:0] != 0
-	 * - writing MMFR:
-	 *	- mscr[7:0]_not_zero
-	 */
-	writel(0, fep->hwp + FEC_MII_DATA);
+	if (fep->quirks & FEC_QUIRK_CLEAR_SETUP_MII) {
+		/* Clear MMFR to avoid to generate MII event by writing MSCR.
+		 * MII event generation condition:
+		 * - writing MSCR:
+		 *	- mmfr[31:0]_not_zero & mscr[7:0]_is_zero &
+		 *	  mscr_reg_data_in[7:0] != 0
+		 * - writing MMFR:
+		 *	- mscr[7:0]_not_zero
+		 */
+		writel(0, fep->hwp + FEC_MII_DATA);
+	}
 
 	writel(fep->phy_speed, fep->hwp + FEC_MII_SPEED);
 
-- 
2.25.1


--------------880186BCE0B3D39A7D9E961C--
