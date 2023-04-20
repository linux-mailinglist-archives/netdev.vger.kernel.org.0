Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 041B66E8E1F
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 11:32:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234106AbjDTJcv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 05:32:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234039AbjDTJct (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 05:32:49 -0400
Received: from smtpbg153.qq.com (smtpbg153.qq.com [13.245.218.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AC531702;
        Thu, 20 Apr 2023 02:32:43 -0700 (PDT)
X-QQ-mid: Yeas47t1681983130t003t38627
Received: from 7082A6556EBF4E69829842272A565F7C (jiawenwu@trustnetic.com [183.129.236.74])
X-QQ-SSF: 00400000000000F0FL9000000000000
From:   =?utf-8?b?Smlhd2VuIFd1?= <jiawenwu@trustnetic.com>
X-BIZMAIL-ID: 2844241341821674648
To:     "'Vladimir Oltean'" <olteanv@gmail.com>
Cc:     <netdev@vger.kernel.org>, <linux@armlinux.org.uk>,
        <linux-i2c@vger.kernel.org>, <linux-gpio@vger.kernel.org>,
        <mengyuanlou@net-swift.com>,
        "'Jose Abreu'" <Jose.Abreu@synopsys.com>
References: <20230420080312.6ai6yrm6gikljeto@skbuf> <20230419082739.295180-1-jiawenwu@trustnetic.com> <20230419082739.295180-1-jiawenwu@trustnetic.com> <20230419082739.295180-7-jiawenwu@trustnetic.com> <20230419082739.295180-7-jiawenwu@trustnetic.com> <20230419131938.3k4kuqucvuuhxcrc@skbuf> <037501d9732b$518048d0$f480da70$@trustnetic.com> <20230420080312.6ai6yrm6gikljeto@skbuf> <03d301d97363$874123d0$95c36b70$@trustnetic.com> <03d301d97363$874123d0$95c36b70$@trustnetic.com> <20230420085211.6kt2oj3k5k54mtuf@skbuf>
In-Reply-To: <20230420085211.6kt2oj3k5k54mtuf@skbuf>
Subject: RE: [PATCH net-next v3 6/8] net: pcs: Add 10GBASE-R mode for Synopsys Designware XPCS
Date:   Thu, 20 Apr 2023 17:32:05 +0800
Message-ID: <03d401d9736a$f880d2a0$e98277e0$@trustnetic.com>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Content-Language: zh-cn
Thread-Index: AQILddcEM2VPF5H4GSvZ5UzGHBCY+AILBR3gAgsFHeABOmDyhAE6YPKEAhXaDNgCJUa00wILddcEAbTRLbkBtNEtuQIFposhrj3eybA=
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

On Thursday, April 20, 2023 4:52 PM, Vladimir Oltean wrote:
> On Thu, Apr 20, 2023 at 04:38:48PM +0800, Jiawen Wu wrote:
> > It needs to implement compat->pma_config, and add a flag in struct dw_xpcs
> > to indicate board with specific pma configuration. For 10GBASE-R interface, it
> > relatively simple, but a bit more complicate for 1000BASE-X since there are
> > logic conflicts in xpcs_do_config(), I haven't resolved yet.
> >
> > In addition, reconfiguring XPCS will cause some known issues that I need to
> > workaround in the ethernet driver. So I'd like to add configuration when I
> > implement rate switching.
> >
> > There is a piece codes for my test:
> 
> The PMA initialization procedure looks pretty clean to me (although I'm
> not clear why it depends upon xpcs->flags & DW_MODEL_WANGXUN_SP when the
> registers seem to be present in the common databook), and having it in
> the XPCS driver seems much preferable to depending on an unknown previous
> initialization stage.

The values configured in PMA depend on the board signal quality, Synopsys once
provided the values based on our board information, but we don't know the details
of the computation. So I don't think it's universal.

> 
> Could you detail a bit the known issues and the 1000BASE-X conflicts in
> xpcs_do_config()?
> 

Known issue is that traffic must be totally stopped while the PMA is being configured.
And XPCS should add a judgment that PMA only need to be reconfigured when
interface is changed.

In 1000BASE-X interface, for my current testing, PMA configuration should precede
AN configuration, and need to set PCS_DIG_CTRL1 reg? My test code for AN config:

+static int xpcs_config_aneg_c37_1000basex_wx(struct dw_xpcs *xpcs, unsigned int mode,
+					     const unsigned long *advertising)
+{
+
+	xpcs_write(xpcs, MDIO_MMD_PCS, DW_VR_MII_DIG_CTRL1, 0x3002);
+	xpcs_write(xpcs, MDIO_MMD_VEND2, DW_VR_MII_AN_CTRL, 0x0109);
+	xpcs_write(xpcs, MDIO_MMD_VEND2, DW_VR_MII_DIG_CTRL1, 0x0200);
+	ret = xpcs_read(xpcs, MDIO_MMD_VEND2, MDIO_CTRL1);
+	ret |= BMCR_ANENABLE;
+	xpcs_write(xpcs, MDIO_MMD_VEND2, MDIO_CTRL1, ret);
+}


