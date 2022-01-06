Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2A004864EF
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 14:08:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239349AbiAFNIY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 08:08:24 -0500
Received: from marcansoft.com ([212.63.210.85]:58358 "EHLO mail.marcansoft.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238990AbiAFNIX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jan 2022 08:08:23 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: marcan@marcan.st)
        by mail.marcansoft.com (Postfix) with ESMTPSA id DDDF442165;
        Thu,  6 Jan 2022 13:08:13 +0000 (UTC)
To:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Dmitry Osipenko <digetx@gmail.com>
Cc:     Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Mark Kettenis <kettenis@openbsd.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hans de Goede <hdegoede@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "brian m. carlson" <sandals@crustytoothpaste.net>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com
References: <20220104072658.69756-1-marcan@marcan.st>
 <20220104072658.69756-8-marcan@marcan.st>
 <3dfb1a06-4474-4614-08e5-b09f0977e03c@broadcom.com>
From:   Hector Martin <marcan@marcan.st>
Subject: Re: [PATCH v2 07/35] brcmfmac: pcie: Read Apple OTP information
Message-ID: <7b3e7ae0-5791-f4ad-619a-a3cc3f913a44@marcan.st>
Date:   Thu, 6 Jan 2022 22:08:11 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <3dfb1a06-4474-4614-08e5-b09f0977e03c@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Language: es-ES
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/01/2022 21.37, Arend van Spriel wrote:
> On 1/4/2022 8:26 AM, Hector Martin wrote:
>> +static int brcmf_pcie_read_otp(struct brcmf_pciedev_info *devinfo)
>> +{
>> +	const struct pci_dev *pdev = devinfo->pdev;
>> +	struct brcmf_bus *bus = dev_get_drvdata(&pdev->dev);
>> +	u32 coreid, base, words, idx, sromctl;
>> +	u16 *otp;
>> +	struct brcmf_core *core;
>> +	int ret;
>> +
>> +	switch (devinfo->ci->chip) {
>> +	default:
>> +		/* OTP not supported on this chip */
>> +		return 0;
>> +	}
> 
> Does not seem this code is put to work yet. Will dive into it later on.

The specific OTP ranges and cores are added by the subsequent patches
that add support for individual chips, once all the scaffolding is in place.

> 
>> +	core = brcmf_chip_get_core(devinfo->ci, coreid);
>> +	if (!core) {
>> +		brcmf_err(bus, "No OTP core\n");
>> +		return -ENODEV;
>> +	}
>> +
>> +	if (coreid == BCMA_CORE_CHIPCOMMON) {
>> +		/* Chips with OTP accessed via ChipCommon need additional
>> +		 * handling to access the OTP
>> +		 */
>> +		brcmf_pcie_select_core(devinfo, coreid);
>> +		sromctl = READCC32(devinfo, sromcontrol);
>> +
>> +		if (!(sromctl & BCMA_CC_SROM_CONTROL_OTP_PRESENT)) {
>> +			/* Chip lacks OTP, try without it... */
>> +			brcmf_err(bus,
>> +				  "OTP unavailable, using default firmware\n");
>> +			return 0;
>> +		}
>> +
>> +		/* Map OTP to shadow area */
>> +		WRITECC32(devinfo, sromcontrol,
>> +			  sromctl | BCMA_CC_SROM_CONTROL_OTPSEL);
>> +	}
>> +
>> +	otp = kzalloc(sizeof(u16) * words, GFP_KERNEL);
>> +
>> +	/* Map bus window to SROM/OTP shadow area in core */
>> +	base = brcmf_pcie_buscore_prep_addr(devinfo->pdev, base + core->base);
> 
> I guess this changes the bar window...
> 
>> +	brcmf_dbg(PCIE, "OTP data:\n");
>> +	for (idx = 0; idx < words; idx++) {
>> +		otp[idx] = brcmf_pcie_read_reg16(devinfo, base + 2 * idx);
>> +		brcmf_dbg(PCIE, "[%8x] 0x%04x\n", base + 2 * idx, otp[idx]);
>> +	}
>> +
>> +	if (coreid == BCMA_CORE_CHIPCOMMON) {
>> +		brcmf_pcie_select_core(devinfo, coreid);
> 
> ... which is why you need to reselect the core. Otherwise it makes no 
> sense to me.

Yes; *technically* with the BCMA_CORE_CHIPCOMMON core the OTP is always
within the first 0x1000 and so I wouldn't have to reselect it, since
it'd end up with the same window, but that is not the case with
BCMA_CORE_GCI used on other chips (where the OTP offset is >0x1000),
although those don't hit this code path. So while this line could be
removed without causing any issues, I find it more orthogonal and safer
to keep the pattern where I select the core before accessing
core-relative fixed registers, and treat brcmf_pcie_buscore_prep_addr as
invalidating the BAR window for all intents and purposes.

-- 
Hector Martin (marcan@marcan.st)
Public Key: https://mrcn.st/pub
