Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A52116E7CE1
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 16:36:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232841AbjDSOgw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 10:36:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231779AbjDSOgv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 10:36:51 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86653C5;
        Wed, 19 Apr 2023 07:36:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681915010; x=1713451010;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=cJddK4E628OwUVOAwqpQ1+1q5y0xq6cFMslrEnMg2ks=;
  b=RNHZ2a5UTh/QFs0wuLqV/egye5Sl+CE7PJWyjOYv1gEaf8IVpWdWMR8h
   D5Q+uLHP8oyt0oURVMRw0moloeLee7ZqsY+oVk3mOaccZ0HL+ZBfsbhZK
   XAZJyUSBaXSAmO5Hkzupq8jPpfTjwaCT+FcAlVQLrIEBctTR6MWeW2IsD
   Yg6LeCGJ08n8nqANnP53+0urQa/Bz8Q07gvCcb7nzyhGmx040aZ5lZdIo
   eKSz60M9byQeILlIxjM4IITPbwf0ZD44cNrMFcNW8HcmfV+4ozlhKqUD6
   qtC4e+6UuuichwxFtN3eE6hrn0iI7/eBcid+F88SAfICUbKSFLwMi4V6J
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10685"; a="373346334"
X-IronPort-AV: E=Sophos;i="5.99,208,1677571200"; 
   d="scan'208";a="373346334"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2023 07:36:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10685"; a="802934539"
X-IronPort-AV: E=Sophos;i="5.99,208,1677571200"; 
   d="scan'208";a="802934539"
Received: from mylly.fi.intel.com (HELO [10.237.72.175]) ([10.237.72.175])
  by fmsmga002.fm.intel.com with ESMTP; 19 Apr 2023 07:36:46 -0700
Message-ID: <fd5652bd-5b85-0f7d-3690-21eb1a0010b3@linux.intel.com>
Date:   Wed, 19 Apr 2023 17:36:45 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.9.0
Subject: Re: [PATCH net-next v3 2/8] i2c: designware: Add driver support for
 Wangxun 10Gb NIC
To:     Jiawen Wu <jiawenwu@trustnetic.com>, netdev@vger.kernel.org,
        linux@armlinux.org.uk
Cc:     linux-i2c@vger.kernel.org, linux-gpio@vger.kernel.org,
        olteanv@gmail.com, mengyuanlou@net-swift.com
References: <20230419082739.295180-1-jiawenwu@trustnetic.com>
 <20230419082739.295180-3-jiawenwu@trustnetic.com>
Content-Language: en-US
From:   Jarkko Nikula <jarkko.nikula@linux.intel.com>
In-Reply-To: <20230419082739.295180-3-jiawenwu@trustnetic.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi

On 4/19/23 11:27, Jiawen Wu wrote:
> Wangxun 10Gb ethernet chip is connected to Designware I2C, to communicate
> with SFP.
> 
> Add platform data to pass IOMEM base address, board flag and other
> parameters, since resource address was mapped on ethernet driver.
> 
> The exists IP limitations are dealt as workarounds:
> - IP does not support interrupt mode, it works on polling mode.
> - I2C cannot read continuously, only one byte can at a time.
> - Additionally set FIFO depth address the chip issue.
> 
> Cc: Jarkko Nikula <jarkko.nikula@linux.intel.com>
> 
> Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
> ---
>   drivers/i2c/busses/i2c-designware-common.c  |  4 +
>   drivers/i2c/busses/i2c-designware-core.h    |  1 +
>   drivers/i2c/busses/i2c-designware-master.c  | 91 ++++++++++++++++++++-
>   drivers/i2c/busses/i2c-designware-platdrv.c | 36 +++++++-
>   include/linux/platform_data/i2c-dw.h        | 15 ++++
>   5 files changed, 143 insertions(+), 4 deletions(-)
>   create mode 100644 include/linux/platform_data/i2c-dw.h
> 
> diff --git a/drivers/i2c/busses/i2c-designware-common.c b/drivers/i2c/busses/i2c-designware-common.c
> index 0dc6b1ce663f..e4faab4655cb 100644
> --- a/drivers/i2c/busses/i2c-designware-common.c
> +++ b/drivers/i2c/busses/i2c-designware-common.c
> @@ -588,6 +588,10 @@ int i2c_dw_set_fifo_size(struct dw_i2c_dev *dev)
>   	if (ret)
>   		return ret;
>   
> +	/* workaround for IP hardware issue */
> +	if ((dev->flags & MODEL_MASK) == MODEL_WANGXUN_SP)
> +		param |= 0x80800;
> +
What is the issue here? Is register DW_IC_COMP_PARAM_1 implemented? If 
not then I think safer is not to even read it lines before this added test.

> +static int txgbe_i2c_dw_xfer_quirk(struct i2c_adapter *adap, struct i2c_msg *msgs,
> +				   int num_msgs)
> +{
> +	struct dw_i2c_dev *dev = i2c_get_adapdata(adap);
> +	int msg_idx, buf_len, data_idx, ret;
> +	unsigned int val;
> +	u8 dev_addr;
> +	u8 *buf;
> +
> +	dev->msgs = msgs;
> +	dev->msgs_num = num_msgs;
> +	i2c_dw_xfer_init(dev);
> +	regmap_write(dev->map, DW_IC_INTR_MASK, 0);
> +
> +	dev_addr = msgs[0].buf[0];
> +
> +	for (msg_idx = 0; msg_idx < num_msgs; msg_idx++) {
> +		buf = msgs[msg_idx].buf;
> +		buf_len = msgs[msg_idx].len;
> +
> +		for (data_idx = 0; data_idx < buf_len; data_idx++) {
> +			if (msgs[msg_idx].flags & I2C_M_RD) {
> +				ret = i2c_dw_poll_tx_empty(dev);
> +				if (ret)
> +					return ret;
> +
> +				regmap_write(dev->map, DW_IC_DATA_CMD,
> +					     (dev_addr + data_idx) | BIT(9));
> +				regmap_write(dev->map, DW_IC_DATA_CMD, 0x100 | BIT(9));
> +

Am I wrong but this looks tailored to the use-case rather than generic 
implementation? I don't understand what is this write command with data 
(dev_addr + data_idx) + STOP followed by read command with STOP.

DW_IC_DATA_CMD upper bits have following meaning:

BIT(8) == 0x100: 1 = read, 0 = write
BIT(9): Stop issued after this byte
BIT(10): RESTART is issued before the byte is sent or received

> +			} else {
> +				ret = i2c_dw_poll_tx_empty(dev);
> +				if (ret)
> +					return ret;
> +
> +				regmap_write(dev->map, DW_IC_DATA_CMD, buf[data_idx]);
> +				if (data_idx == (buf_len - 1))
> +					regmap_write(dev->map, DW_IC_DATA_CMD, BIT(9));

I think these separate writes must be combined if I'm not wrong? I 
believe this cause needless extra zero byte + STOP transferred on the 
bus instead of last buffer byte + STOP?

> --- a/drivers/i2c/busses/i2c-designware-platdrv.c
> +++ b/drivers/i2c/busses/i2c-designware-platdrv.c

> +static void dw_i2c_get_plat_data(struct dw_i2c_dev *dev)
> +{
> +	struct platform_device *pdev = to_platform_device(dev->dev);
> +	struct dw_i2c_platform_data *pdata;
> +
> +	pdata = dev_get_platdata(&pdev->dev);
> +	if (!pdata)
> +		return;
> +
> +	dev->flags |= pdata->flags;
> +	dev->base = pdata->base;
> +
> +	if (pdata->ss_hcnt && pdata->ss_lcnt) {
> +		dev->ss_hcnt = pdata->ss_hcnt;
> +		dev->ss_lcnt = pdata->ss_lcnt;
> +	} else {
> +		dev->ss_hcnt = 6;
> +		dev->ss_lcnt = 8;
> +	}
> +
> +	if (pdata->fs_hcnt && pdata->fs_lcnt) {
> +		dev->fs_hcnt = pdata->fs_hcnt;
> +		dev->fs_lcnt = pdata->fs_lcnt;
> +	} else {
> +		dev->fs_hcnt = 6;
> +		dev->fs_lcnt = 8;
> +	}
> +}
> +
>   static const struct dmi_system_id dw_i2c_hwmon_class_dmi[] = {
>   	{
>   		.ident = "Qtechnology QT5222",
> @@ -282,6 +314,8 @@ static int dw_i2c_plat_probe(struct platform_device *pdev)
>   	dev->irq = irq;
>   	platform_set_drvdata(pdev, dev);
>   
> +	dw_i2c_get_plat_data(dev);
> +
Instead of this added code would it be possible to use generic timing 
parameters which can come either from firmware or code? Those are 
handled already here by the call to i2c_parse_fw_timings().

Then drivers/i2c/busses/i2c-designware-master.c: 
i2c_dw_set_timings_master() takes care of calculating Designware 
specific hcnt/lcnt timing parameters from those generic values.
