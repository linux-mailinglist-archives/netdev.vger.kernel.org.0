Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BC4C19A489
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 07:14:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731765AbgDAFN5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 01:13:57 -0400
Received: from guitar.tcltek.co.il ([192.115.133.116]:52444 "EHLO
        mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726811AbgDAFN5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Apr 2020 01:13:57 -0400
X-Greylist: delayed 403 seconds by postgrey-1.27 at vger.kernel.org; Wed, 01 Apr 2020 01:13:56 EDT
Received: from [176.13.116.16] (unknown [176.13.116.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx.tkos.co.il (Postfix) with ESMTPSA id 80CEB44091D;
        Wed,  1 Apr 2020 08:13:55 +0300 (IDT)
Subject: Re: [PATCH] net: phy: marvell10g: add firmware load support
From:   "Shmuel H." <sh@tkos.co.il>
To:     Baruch Siach <baruch@tkos.co.il>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
References: <16e4a15e359012fc485d22c7e413a129029fbd0f.1585676858.git.baruch@tkos.co.il>
 <20200331180346.GS25745@shell.armlinux.org.uk> <874ku3dcki.fsf@tarshish>
 <1ad954a5-5cfc-caa3-5aca-0810223e5ac3@tkos.co.il>
Message-ID: <d2017ccc-c85a-2e6d-4578-eaff530665fe@tkos.co.il>
Date:   Wed, 1 Apr 2020 08:13:54 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <1ad954a5-5cfc-caa3-5aca-0810223e5ac3@tkos.co.il>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Baruch,

On 01/04/2020 08:07, Shmuel H. wrote:
> Hi Baruch,
>
> On 01/04/2020 08:01, Baruch Siach wrote:
>> Hi Russell,
>>
>> On Tue, Mar 31 2020, Russell King - ARM Linux admin wrote:
>>> On Tue, Mar 31, 2020 at 08:47:38PM +0300, Baruch Siach wrote:
>>>> When Marvell 88X3310 and 88E2110 hardware configuration SPI_CONFIG strap
>>>> bit is pulled up, the host must load firmware to the PHY after reset.
>>>> Add support for loading firmware.
>>>>
>>>> Firmware files are available from Marvell under NDA.
>>> As I understand it, the firmware for the different revisions of the
>>> 88x3310 are different, so I think the current derivation of filenames
>>> is not correct.
>> I was not aware of that.
>>
>> Shmuel, have you seen different firmware revisions from Marvell for 88x3310?
> There are many firmware revisions, but I didn't see any mention of one
> being compatible with a specific HW revision on the changelog / datasheets.
Sorry,
Apparently, Marvell do provide multiple firmware versions for the
MVx3310 (REV A1, REV A0, latest).

>
>>> Is this code theoretical, or has it been tested on such a system?  As
>>> far as I'm aware, all the 3310 systems out there so far have been
>>> strapped to boot the firmware from SPI.
>> I tested this code on a system with 88E2110. Shmuel tested similar code
>> with 88X3310. In both cases the hardware designer preferred run-time
>> load of PHY firmware.
>>
>> baruch
>>
>>>> Signed-off-by: Baruch Siach <baruch@tkos.co.il>
>>>> ---
>>>>  drivers/net/phy/marvell10g.c | 114 +++++++++++++++++++++++++++++++++++
>>>>  1 file changed, 114 insertions(+)
>>>>
>>>> diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
>>>> index 64c9f3bba2cd..9572426ba1c6 100644
>>>> --- a/drivers/net/phy/marvell10g.c
>>>> +++ b/drivers/net/phy/marvell10g.c
>>>> @@ -27,13 +27,28 @@
>>>>  #include <linux/marvell_phy.h>
>>>>  #include <linux/phy.h>
>>>>  #include <linux/sfp.h>
>>>> +#include <linux/firmware.h>
>>>> +#include <linux/delay.h>
>>>>
>>>>  #define MV_PHY_ALASKA_NBT_QUIRK_MASK	0xfffffffe
>>>>  #define MV_PHY_ALASKA_NBT_QUIRK_REV	(MARVELL_PHY_ID_88X3310 | 0xa)
>>>>
>>>> +#define MV_FIRMWARE_HEADER_SIZE		32
>>>> +
>>>>  enum {
>>>>  	MV_PMA_BOOT		= 0xc050,
>>>>  	MV_PMA_BOOT_FATAL	= BIT(0),
>>>> +	MV_PMA_BOOT_PROGRESS_MASK = 0x0006,
>>>> +	MV_PMA_BOOT_WAITING	= 0x0002,
>>>> +	MV_PMA_BOOT_FW_LOADED	= BIT(6),
>>>> +
>>>> +	MV_PCS_FW_LOW_WORD	= 0xd0f0,
>>>> +	MV_PCS_FW_HIGH_WORD	= 0xd0f1,
>>>> +	MV_PCS_RAM_DATA		= 0xd0f2,
>>>> +	MV_PCS_RAM_CHECKSUM	= 0xd0f3,
>>>> +
>>>> +	MV_PMA_FW_REV1		= 0xc011,
>>>> +	MV_PMA_FW_REV2		= 0xc012,
>>>>
>>>>  	MV_PCS_BASE_T		= 0x0000,
>>>>  	MV_PCS_BASE_R		= 0x1000,
>>>> @@ -223,6 +238,99 @@ static int mv3310_sfp_insert(void *upstream, const struct sfp_eeprom_id *id)
>>>>  	return 0;
>>>>  }
>>>>
>>>> +static int mv3310_write_firmware(struct phy_device *phydev, const u8 *data,
>>>> +		unsigned int size)
>>>> +{
>>>> +	unsigned int low_byte, high_byte;
>>>> +	u16 checksum = 0, ram_checksum;
>>>> +	unsigned int i = 0;
>>>> +
>>>> +	while (i < size) {
>>>> +		low_byte = data[i++];
>>>> +		high_byte = data[i++];
>>>> +		checksum += low_byte + high_byte;
>>>> +		phy_write_mmd(phydev, MDIO_MMD_PCS, MV_PCS_RAM_DATA,
>>>> +				(high_byte << 8) | low_byte);
>>>> +		cond_resched();
>>>> +	}
>>>> +
>>>> +	ram_checksum = phy_read_mmd(phydev, MDIO_MMD_PCS, MV_PCS_RAM_CHECKSUM);
>>>> +	if (ram_checksum != checksum) {
>>>> +		dev_err(&phydev->mdio.dev, "firmware checksum failed");
>>>> +		return -EIO;
>>>> +	}
>>>> +
>>>> +	return 0;
>>>> +}
>>>> +
>>>> +static void mv3310_report_firmware_rev(struct phy_device *phydev)
>>>> +{
>>>> +	int rev1, rev2;
>>>> +
>>>> +	rev1 = phy_read_mmd(phydev, MDIO_MMD_PMAPMD, MV_PMA_FW_REV1);
>>>> +	rev2 = phy_read_mmd(phydev, MDIO_MMD_PMAPMD, MV_PMA_FW_REV2);
>>>> +	if (rev1 < 0 || rev2 < 0)
>>>> +		return;
>>>> +
>>>> +	dev_info(&phydev->mdio.dev, "Loaded firmware revision %d.%d.%d.%d",
>>>> +			(rev1 & 0xff00) >> 8, rev1 & 0x00ff,
>>>> +			(rev2 & 0xff00) >> 8, rev2 & 0x00ff);
>>>> +}
>>>> +
>>>> +static int mv3310_load_firmware(struct phy_device *phydev)
>>>> +{
>>>> +	const struct firmware *fw_entry;
>>>> +	char *fw_file;
>>>> +	int ret;
>>>> +
>>>> +	switch (phydev->drv->phy_id) {
>>>> +	case MARVELL_PHY_ID_88X3310:
>>>> +		fw_file = "mrvl/x3310fw.hdr";
>>>> +		break;
>>>> +	case MARVELL_PHY_ID_88E2110:
>>>> +		fw_file = "mrvl/e21x0fw.hdr";
>>>> +		break;
>>>> +	default:
>>>> +		dev_warn(&phydev->mdio.dev, "unknown firmware file for %s PHY",
>>>> +				phydev->drv->name);
>>>> +		return -EINVAL;
>>>> +	}
>>>> +
>>>> +	ret = request_firmware(&fw_entry, fw_file, &phydev->mdio.dev);
>>>> +	if (ret < 0)
>>>> +		return ret;
>>>> +
>>>> +	/* Firmware size must be larger than header, and even */
>>>> +	if (fw_entry->size <= MV_FIRMWARE_HEADER_SIZE ||
>>>> +			(fw_entry->size % 2) != 0) {
>>>> +		dev_err(&phydev->mdio.dev, "firmware file invalid");
>>>> +		return -EINVAL;
>>>> +	}
>>>> +
>>>> +	/* Clear checksum register */
>>>> +	phy_read_mmd(phydev, MDIO_MMD_PCS, MV_PCS_RAM_CHECKSUM);
>>>> +
>>>> +	/* Set firmware load address */
>>>> +	phy_write_mmd(phydev, MDIO_MMD_PCS, MV_PCS_FW_LOW_WORD, 0);
>>>> +	phy_write_mmd(phydev, MDIO_MMD_PCS, MV_PCS_FW_HIGH_WORD, 0x0010);
>>>> +
>>>> +	ret = mv3310_write_firmware(phydev,
>>>> +			fw_entry->data + MV_FIRMWARE_HEADER_SIZE,
>>>> +			fw_entry->size - MV_FIRMWARE_HEADER_SIZE);
>>>> +	if (ret < 0)
>>>> +		return ret;
>>>> +
>>>> +	phy_modify_mmd(phydev, MDIO_MMD_PMAPMD, MV_PMA_BOOT,
>>>> +			MV_PMA_BOOT_FW_LOADED, MV_PMA_BOOT_FW_LOADED);
>>>> +
>>>> +	release_firmware(fw_entry);
>>>> +
>>>> +	msleep(100);
>>>> +	mv3310_report_firmware_rev(phydev);
>>>> +
>>>> +	return 0;
>>>> +}
>>>> +
>>>>  static const struct sfp_upstream_ops mv3310_sfp_ops = {
>>>>  	.attach = phy_sfp_attach,
>>>>  	.detach = phy_sfp_detach,
>>>> @@ -249,6 +357,12 @@ static int mv3310_probe(struct phy_device *phydev)
>>>>  		return -ENODEV;
>>>>  	}
>>>>
>>>> +	if ((ret & MV_PMA_BOOT_PROGRESS_MASK) == MV_PMA_BOOT_WAITING) {
>>>> +		ret = mv3310_load_firmware(phydev);
>>>> +		if (ret < 0)
>>>> +			return ret;
>>>> +	}
>>>> +
>>>>  	priv = devm_kzalloc(&phydev->mdio.dev, sizeof(*priv), GFP_KERNEL);
>>>>  	if (!priv)
>>>>  		return -ENOMEM;
>>>> --
>>>> 2.25.1
>>>>
>>>>
>> --
>>      http://baruch.siach.name/blog/                  ~. .~   Tk Open Systems
>> =}------------------------------------------------ooO--U--Ooo------------{=
>>    - baruch@tkos.co.il - tel: +972.52.368.4656, http://www.tkos.co.il -

-- 
- Shmuel Hazan

mailto:sh@tkos.co.il | tel:+972-523-746-435 | http://tkos.co.il

