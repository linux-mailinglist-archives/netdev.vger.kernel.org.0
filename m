Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAF116E8CF8
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 10:40:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234485AbjDTIkG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 04:40:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234522AbjDTIj4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 04:39:56 -0400
Received: from smtpbg153.qq.com (smtpbg153.qq.com [13.245.218.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E54534C21;
        Thu, 20 Apr 2023 01:39:50 -0700 (PDT)
X-QQ-mid: Yeas52t1681979933t404t36488
Received: from 7082A6556EBF4E69829842272A565F7C (jiawenwu@trustnetic.com [183.129.236.74])
X-QQ-SSF: 00400000000000F0FL9000000000000
From:   =?utf-8?b?Smlhd2VuIFd1?= <jiawenwu@trustnetic.com>
X-BIZMAIL-ID: 16123300564657514473
To:     "'Vladimir Oltean'" <olteanv@gmail.com>
Cc:     <netdev@vger.kernel.org>, <linux@armlinux.org.uk>,
        <linux-i2c@vger.kernel.org>, <linux-gpio@vger.kernel.org>,
        <mengyuanlou@net-swift.com>,
        "'Jose Abreu'" <Jose.Abreu@synopsys.com>
References: <20230419082739.295180-1-jiawenwu@trustnetic.com> <20230419082739.295180-1-jiawenwu@trustnetic.com> <20230419082739.295180-7-jiawenwu@trustnetic.com> <20230419082739.295180-7-jiawenwu@trustnetic.com> <20230419131938.3k4kuqucvuuhxcrc@skbuf> <037501d9732b$518048d0$f480da70$@trustnetic.com> <20230420080312.6ai6yrm6gikljeto@skbuf>
In-Reply-To: <20230420080312.6ai6yrm6gikljeto@skbuf>
Subject: RE: [PATCH net-next v3 6/8] net: pcs: Add 10GBASE-R mode for Synopsys Designware XPCS
Date:   Thu, 20 Apr 2023 16:38:48 +0800
Message-ID: <03d301d97363$874123d0$95c36b70$@trustnetic.com>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Content-Language: zh-cn
Thread-Index: AQILBR3gZkFBC9g1wrfKT5ke1rRywwILBR3gATpg8oQBOmDyhAIV2gzYAiVGtNMCC3XXBK56gusA
X-QQ-SENDSIZE: 520
Feedback-ID: Yeas:trustnetic.com:qybglogicsvr:qybglogicsvr5
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,FROM_EXCESS_BASE64,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thursday, April 20, 2023 4:03 PM, Vladimir Oltean wrote:
> On Thu, Apr 20, 2023 at 09:56:26AM +0800, Jiawen Wu wrote:
> > On Wednesday, April 19, 2023 9:20 PM, Vladimir Oltean wrote:
> > > On Wed, Apr 19, 2023 at 04:27:37PM +0800, Jiawen Wu wrote:
> > > > Add basic support for XPCS using 10GBASE-R interface. This mode will
> > > > be extended to use interrupt, so set pcs.poll false. And avoid soft
> > > > reset so that the device using this mode is in the default configuration.
> > >
> > > I'm not clear why the xpcs_soft_reset() call is avoided. Isn't the
> > > out-of-reset configuration the "default" one?
> >
> > Theoretically so, I need to configure 10GBASE-R mode after reset. But this
> > configuration involves board info to configure PMA, etc., I'd like to implement
> > it in the next patch. Now the "default" configuration refers to the mode in
> > which the firmware is configured.
> 
> How much extra complexity are we talking about, to not depend on the
> configuration done by the bootloader?
> 

It needs to implement compat->pma_config, and add a flag in struct dw_xpcs
to indicate board with specific pma configuration. For 10GBASE-R interface, it
relatively simple, but a bit more complicate for 1000BASE-X since there are
logic conflicts in xpcs_do_config(), I haven't resolved yet.

In addition, reconfiguring XPCS will cause some known issues that I need to
workaround in the ethernet driver. So I'd like to add configuration when I
implement rate switching.

There is a piece codes for my test:

+static int xpcs_read_pma(struct dw_xpcs *xpcs, int reg)
+{
+	return xpcs_read(xpcs, MDIO_MMD_PMAPMD, DW_PMA_MMD + reg);
+}
+
+static int xpcs_write_pma(struct dw_xpcs *xpcs, int reg, u16 val)
+{
+	return xpcs_write(xpcs, MDIO_MMD_PMAPMD, DW_PMA_MMD + reg, val);
+}
+
+static int xpcs_poll_power_up(struct dw_xpcs *xpcs)
+{
+	int val, ret;
+
+	/* Wait xpcs power-up good */
+	ret = read_poll_timeout(xpcs_read_vpcs, val,
+				(val & DW_VR_XS_PCS_DIG_STS_PSEQ_ST) ==
+				DW_VR_XS_PCS_DIG_STS_PSEQ_ST_GOOD,
+				10000, 1000000, false,
+				xpcs, DW_VR_XS_PCS_DIG_STS);
+	if (ret < 0)
+		pr_err("%s: xpcs power-up timeout\n", __func__);
+
+	return ret;
+}
+
+static int xpcs_pma_init_done(struct dw_xpcs *xpcs)
+{
+	int val, ret;
+
+	xpcs_write_vpcs(xpcs, DW_VR_XS_PCS_DIG_CTRL1,
+			DW_VR_XS_PCS_DIG_CTRL1_VR_RST |
+			DW_VR_XS_PCS_DIG_CTRL1_EN_VSMMD1);
+
+	/* wait pma initialization done */
+	ret = read_poll_timeout(xpcs_read_vpcs, val,
+				!(val & DW_VR_XS_PCS_DIG_CTRL1_VR_RST),
+				100000, 10000000, false,
+				xpcs, DW_VR_XS_PCS_DIG_CTRL1);
+	if (ret < 0)
+		pr_err("%s: xpcs pma initialization timeout\n", __func__);
+
+	return ret;
+}
+
+static int xpcs_10gbaser_pma_config_wx(struct dw_xpcs *xpcs)
+{
+	int val, ret;
+
+	ret = xpcs_poll_power_up(xpcs);
+	if (ret < 0)
+		return ret;
+
+	xpcs_write(xpcs, MDIO_MMD_PCS, MDIO_CTRL2, MDIO_PCS_CTRL2_10GBR);
+	val = xpcs_read(xpcs, MDIO_MMD_PMAPMD, MDIO_CTRL1);
+	val |= MDIO_CTRL1_SPEED10G;
+	xpcs_write(xpcs, MDIO_MMD_PMAPMD, MDIO_CTRL1, val);
+
+	xpcs_write_pma(xpcs, DW_VR_XS_PMA_MPLLA_CTL0, 0x21);
+	xpcs_write_pma(xpcs, DW_VR_XS_PMA_MPLLA_CTL3, 0);
+	val = xpcs_read_pma(xpcs, DW_VR_XS_PMA_TX_GENCTL1);
+	val = u16_replace_bits(val, 0x5, DW_VR_XS_PMA_TX_GENCTL1_VBOOST_LVL);
+	xpcs_write_pma(xpcs, DW_VR_XS_PMA_TX_GENCTL1, val);
+	xpcs_write_pma(xpcs, DW_VR_XS_PMA_MISC_CTL0, 0xCF00);
+	xpcs_write_pma(xpcs, DW_VR_XS_PMA_VCO_CAL_LD0, 0x549);
+	xpcs_write_pma(xpcs, DW_VR_XS_PMA_VCO_CAL_REF0, 0x29);
+	xpcs_write_pma(xpcs, DW_VR_XS_PMA_TX_RATE_CTL, 0);
+	xpcs_write_pma(xpcs, DW_VR_XS_PMA_RX_RATE_CTL, 0);
+	xpcs_write_pma(xpcs, DW_VR_XS_PMA_TX_GEN_CTL2, 0x300);
+	xpcs_write_pma(xpcs, DW_VR_XS_PMA_RX_GEN_CTL2, 0x300);
+	xpcs_write_pma(xpcs, DW_VR_XS_PMA_MPLLA_CTL2, 0x600);
+
+	xpcs_write_pma(xpcs, DW_VR_XS_PMA_RX_EQ_CTL0, 0x45);
+	val = xpcs_read_pma(xpcs, DW_VR_XS_PMA_RX_EQ_ATTN_CTL);
+	val &= ~DW_VR_XS_PMA_RX_EQ_ATTN_LVL0;
+	xpcs_write_pma(xpcs, DW_VR_XS_PMA_RX_EQ_ATTN_CTL, val);
+	xpcs_write_pma(xpcs, DW_VR_XS_PMA_DFE_TAP_CTL0, 0xBE);
+	val = xpcs_read_pma(xpcs, DW_VR_XS_PMA_AFE_DFE_ENABLE);
+	val &= ~(DW_VR_XS_PMA_DFE_EN_0 | DW_VR_XS_PMA_AFE_EN_0);
+	xpcs_write_pma(xpcs, DW_VR_XS_PMA_AFE_DFE_ENABLE, val);
+	val = xpcs_read_pma(xpcs, DW_VR_XS_PMA_RX_EQ_CTL4);
+	val &= ~DW_VR_XS_PMA_RX_EQ_CTL4_CONT_ADAPT0;
+	xpcs_write_pma(xpcs, DW_VR_XS_PMA_RX_EQ_CTL4, val);
+
+	return xpcs_pma_init_done(xpcs);
+}
+
+static int xpcs_10gbaser_pma_config(struct dw_xpcs *xpcs)
+{
+	if (xpcs->flags & DW_MODEL_WANGXUN_SP)
+		return xpcs_10gbaser_pma_config_wx(xpcs);
+
+	return 0;
+}
+

