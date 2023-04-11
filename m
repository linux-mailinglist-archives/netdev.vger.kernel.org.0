Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD2AF6DD6D2
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 11:33:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229974AbjDKJdg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 05:33:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229999AbjDKJd0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 05:33:26 -0400
Received: from smtpbgsg1.qq.com (smtpbgsg1.qq.com [54.254.200.92])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56ED31984;
        Tue, 11 Apr 2023 02:32:58 -0700 (PDT)
X-QQ-mid: Yeas48t1681205558t422t54790
Received: from 7082A6556EBF4E69829842272A565F7C (jiawenwu@trustnetic.com [183.129.236.74])
X-QQ-SSF: 00400000000000F0FL9000000000000
From:   =?utf-8?b?Smlhd2VuIFd1?= <jiawenwu@trustnetic.com>
X-BIZMAIL-ID: 4726894801635449641
To:     <netdev@vger.kernel.org>, <linux@armlinux.org.uk>
Cc:     <linux-i2c@vger.kernel.org>, <linux-gpio@vger.kernel.org>,
        <mengyuanlou@net-swift.com>, <jarkko.nikula@linux.intel.com>
References: <20230411092725.104992-1-jiawenwu@trustnetic.com> <20230411092725.104992-3-jiawenwu@trustnetic.com>
In-Reply-To: <20230411092725.104992-3-jiawenwu@trustnetic.com>
Subject: RE: [PATCH net-next v2 2/6] net: txgbe: Implement I2C bus master driver
Date:   Tue, 11 Apr 2023 17:32:36 +0800
Message-ID: <00cf01d96c58$8d3e9130$a7bbb390$@trustnetic.com>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Content-Language: zh-cn
Thread-Index: AQJXy8bYFbRwx/PFgpvJPX7PgyT97wJCMZrbrhcHRuA=
X-QQ-SENDSIZE: 520
Feedback-ID: Yeas:trustnetic.com:qybglogicsvr:qybglogicsvr5
X-Spam-Status: No, score=-0.0 required=5.0 tests=FROM_EXCESS_BASE64,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+Cc: Jarkko Nikula <jarkko.nikula@linux.intel.com>

> -----Original Message-----
> From: Jiawen Wu <jiawenwu@trustnetic.com>
> Sent: Tuesday, April 11, 2023 5:27 PM
> To: netdev@vger.kernel.org; linux@armlinux.org.uk
> Cc: linux-i2c@vger.kernel.org; linux-gpio@vger.kernel.org;
> mengyuanlou@net-swift.com; Jiawen Wu <jiawenwu@trustnetic.com>
> Subject: [PATCH net-next v2 2/6] net: txgbe: Implement I2C bus master
> driver
> 
> Implement I2C bus driver to send and receive I2C messages.
> 
> This I2C license the IP of Synopsys Designware, but without interrupt
> support on the hardware design. It seems that polling mode needs to be
> added in Synopsys Designware I2C driver. But currently it can only be
> driven by this I2C bus master driver.
> 
> Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
> ---
>  drivers/net/ethernet/wangxun/Kconfig          |   1 +
>  .../net/ethernet/wangxun/txgbe/txgbe_phy.c    | 153
> ++++++++++++++++++
>  .../net/ethernet/wangxun/txgbe/txgbe_type.h   |  23 +++
>  3 files changed, 177 insertions(+)
> 
> diff --git a/drivers/net/ethernet/wangxun/Kconfig
> b/drivers/net/ethernet/wangxun/Kconfig
> index c9d88673d306..8cbf0dd48a2c 100644
> --- a/drivers/net/ethernet/wangxun/Kconfig
> +++ b/drivers/net/ethernet/wangxun/Kconfig
> @@ -41,6 +41,7 @@ config TXGBE
>  	tristate "Wangxun(R) 10GbE PCI Express adapters support"
>  	depends on PCI
>  	select LIBWX
> +	select I2C
>  	help
>  	  This driver supports Wangxun(R) 10GbE PCI Express family of
>  	  adapters.
> diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
> b/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
> index 86d5e0647d5e..2721da1625e0 100644
> --- a/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
> +++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
> @@ -2,9 +2,12 @@
>  /* Copyright (c) 2015 - 2023 Beijing WangXun Technology Co., Ltd. */
> 
>  #include <linux/gpio/property.h>
> +#include <linux/iopoll.h>
> +#include <linux/i2c.h>
>  #include <linux/pci.h>
> 
>  #include "../libwx/wx_type.h"
> +#include "../libwx/wx_hw.h"
>  #include "txgbe_type.h"
>  #include "txgbe_phy.h"
> 
> @@ -67,6 +70,142 @@ static int txgbe_swnodes_register(struct txgbe
> *txgbe)
>  	return software_node_register_node_group(nodes->group);
>  }
> 
> +static void txgbe_i2c_start(struct wx *wx, u16 dev_addr)
> +{
> +	wr32(wx, TXGBE_I2C_ENABLE, 0);
> +
> +	wr32(wx, TXGBE_I2C_CON,
> +	     (TXGBE_I2C_CON_MASTER_MODE |
> +	      TXGBE_I2C_CON_SPEED(1) |
> +	      TXGBE_I2C_CON_RESTART_EN |
> +	      TXGBE_I2C_CON_SLAVE_DISABLE));
> +	wr32(wx, TXGBE_I2C_TAR, dev_addr);
> +	wr32(wx, TXGBE_I2C_SS_SCL_HCNT, 600);
> +	wr32(wx, TXGBE_I2C_SS_SCL_LCNT, 600);
> +	wr32(wx, TXGBE_I2C_RX_TL, 0); /* 1byte for rx full signal */
> +	wr32(wx, TXGBE_I2C_TX_TL, 4);
> +	wr32(wx, TXGBE_I2C_SCL_STUCK_TIMEOUT, 0xFFFFFF);
> +	wr32(wx, TXGBE_I2C_SDA_STUCK_TIMEOUT, 0xFFFFFF);
> +
> +	wr32(wx, TXGBE_I2C_INTR_MASK, 0);
> +	wr32(wx, TXGBE_I2C_ENABLE, 1);
> +}
> +
> +static int txgbe_i2c_poll_intr(struct wx *wx, u16 intr)
> +{
> +	u16 val;
> +
> +	return read_poll_timeout(rd32, val, (val & intr) == intr,
> +				 100, 1000, false, wx,
> +				 TXGBE_I2C_RAW_INTR_STAT);
> +}
> +
> +static int txgbe_read_i2c_bytes(struct wx *wx, u8 dev_addr, struct
> i2c_msg *msg)
> +{
> +	int err, i;
> +
> +	txgbe_i2c_start(wx, msg->addr);
> +
> +	for (i = 0; i < msg->len; i++) {
> +		/* wait tx empty */
> +		err = txgbe_i2c_poll_intr(wx, TXGBE_I2C_INTR_STAT_TEMP);
> +		if (err)
> +			return err;
> +
> +		/* read data */
> +		wr32(wx, TXGBE_I2C_DATA_CMD,
> +		     (dev_addr + i) | TXGBE_I2C_DATA_CMD_STOP);
> +		wr32(wx, TXGBE_I2C_DATA_CMD,
> +		     TXGBE_I2C_DATA_CMD_READ |
> TXGBE_I2C_DATA_CMD_STOP);
> +
> +		/* wait for read complete */
> +		err = txgbe_i2c_poll_intr(wx, TXGBE_I2C_INTR_STAT_RFUL);
> +		if (err)
> +			return err;
> +
> +		msg->buf[i] = 0xFF & rd32(wx, TXGBE_I2C_DATA_CMD);
> +	}
> +
> +	return 0;
> +}
> +
> +static int txgbe_write_i2c_bytes(struct wx *wx, struct i2c_msg *msg)
> +{
> +	int err, i;
> +
> +	txgbe_i2c_start(wx, msg->addr);
> +
> +	for (i = 0; i < msg->len; i++) {
> +		/* wait tx empty */
> +		err = txgbe_i2c_poll_intr(wx, TXGBE_I2C_INTR_STAT_TEMP);
> +		if (err)
> +			return err;
> +
> +		/* write data */
> +		wr32(wx, TXGBE_I2C_DATA_CMD, msg->buf[i]);
> +		if (i == (msg->len - 1))
> +			wr32(wx, TXGBE_I2C_DATA_CMD,
> TXGBE_I2C_DATA_CMD_STOP);
> +	}
> +
> +	return 0;
> +}
> +
> +static int txgbe_i2c_xfer(struct i2c_adapter *i2c_adap,
> +			  struct i2c_msg *msg, int num_msgs)
> +{
> +	struct wx *wx = i2c_get_adapdata(i2c_adap);
> +	u8 dev_addr = msg[0].buf[0];
> +	int i, ret;
> +
> +	for (i = 0; i < num_msgs; i++) {
> +		if (msg[i].flags & I2C_M_RD)
> +			ret = txgbe_read_i2c_bytes(wx, dev_addr,
&msg[i]);
> +		else
> +			ret = txgbe_write_i2c_bytes(wx, &msg[i]);
> +
> +		if (ret)
> +			return ret;
> +	}
> +
> +	return num_msgs;
> +}
> +
> +static u32 txgbe_i2c_func(struct i2c_adapter *adap)
> +{
> +	return I2C_FUNC_I2C;
> +}
> +
> +static const struct i2c_algorithm txgbe_i2c_algo = {
> +	.master_xfer = txgbe_i2c_xfer,
> +	.functionality = txgbe_i2c_func,
> +};
> +
> +static int txgbe_i2c_adapter_add(struct txgbe *txgbe)
> +{
> +	struct pci_dev *pdev = txgbe->wx->pdev;
> +	struct i2c_adapter *i2c_adap;
> +	int ret;
> +
> +	i2c_adap = devm_kzalloc(&pdev->dev, sizeof(*i2c_adap),
> GFP_KERNEL);
> +	if (!i2c_adap)
> +		return -ENOMEM;
> +
> +	i2c_adap->owner = THIS_MODULE;
> +	i2c_adap->algo = &txgbe_i2c_algo;
> +	i2c_adap->dev.parent = &pdev->dev;
> +	i2c_adap->dev.fwnode =
> software_node_fwnode(txgbe->nodes.group[SWNODE_I2C]);
> +	strscpy(i2c_adap->name, "txgbe_i2c", sizeof(i2c_adap->name));
> +
> +	i2c_set_adapdata(i2c_adap, txgbe->wx);
> +	ret = i2c_add_adapter(i2c_adap);
> +	if (ret)
> +		return ret;
> +
> +	txgbe->i2c_adap = i2c_adap;
> +
> +	return 0;
> +}
> +
>  int txgbe_init_phy(struct txgbe *txgbe)
>  {
>  	int ret;
> @@ -77,10 +216,24 @@ int txgbe_init_phy(struct txgbe *txgbe)
>  		return ret;
>  	}
> 
> +	ret = txgbe_i2c_adapter_add(txgbe);
> +	if (ret) {
> +		wx_err(txgbe->wx, "failed to init i2c interface: %d\n",
ret);
> +		goto err;
> +	}
> +
>  	return 0;
> +
> +err:
> +	txgbe_remove_phy(txgbe);
> +
> +	return ret;
>  }
> 
>  void txgbe_remove_phy(struct txgbe *txgbe)
>  {
> +	if (txgbe->i2c_adap)
> +		i2c_del_adapter(txgbe->i2c_adap);
> +
>  	software_node_unregister_node_group(txgbe->nodes.group);
>  }
> diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
> b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
> index d30684378f4e..6c02af196157 100644
> --- a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
> +++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
> @@ -55,6 +55,28 @@
>  #define TXGBE_TS_CTL                            0x10300
>  #define TXGBE_TS_CTL_EVAL_MD                    BIT(31)
> 
> +/* I2C registers */
> +#define TXGBE_I2C_CON                           0x14900 /* I2C
> Control */
> +#define TXGBE_I2C_CON_SLAVE_DISABLE             BIT(6)
> +#define TXGBE_I2C_CON_RESTART_EN                BIT(5)
> +#define TXGBE_I2C_CON_SPEED(_v)
> FIELD_PREP(GENMASK(2, 1), _v)
> +#define TXGBE_I2C_CON_MASTER_MODE               BIT(0)
> +#define TXGBE_I2C_TAR                           0x14904 /* I2C
> Target Address */
> +#define TXGBE_I2C_DATA_CMD                      0x14910 /*
> I2C Rx/Tx Data Buf and Cmd */
> +#define TXGBE_I2C_DATA_CMD_STOP                 BIT(9)
> +#define TXGBE_I2C_DATA_CMD_READ                 BIT(8)
> +#define TXGBE_I2C_SS_SCL_HCNT                   0x14914
> +#define TXGBE_I2C_SS_SCL_LCNT                   0x14918
> +#define TXGBE_I2C_INTR_MASK                     0x14930 /* I2C
> Interrupt Mask */
> +#define TXGBE_I2C_RAW_INTR_STAT                 0x14934 /*
> I2C Raw Interrupt Status */
> +#define TXGBE_I2C_INTR_STAT_RFUL                BIT(2)
> +#define TXGBE_I2C_INTR_STAT_TEMP                BIT(4)
> +#define TXGBE_I2C_RX_TL                         0x14938 /* I2C
> Receive FIFO Threshold */
> +#define TXGBE_I2C_TX_TL                         0x1493C /* I2C
> TX FIFO Threshold */
> +#define TXGBE_I2C_ENABLE                        0x1496C /* I2C
> Enable */
> +#define TXGBE_I2C_SCL_STUCK_TIMEOUT             0x149AC
> +#define TXGBE_I2C_SDA_STUCK_TIMEOUT             0x149B0
> +
>  /* Part Number String Length */
>  #define TXGBE_PBANUM_LENGTH                     32
> 
> @@ -139,6 +161,7 @@ struct txgbe_nodes {
>  struct txgbe {
>  	struct wx *wx;
>  	struct txgbe_nodes nodes;
> +	struct i2c_adapter *i2c_adap;
>  };
> 
>  #endif /* _TXGBE_TYPE_H_ */
> --
> 2.27.0
> 

