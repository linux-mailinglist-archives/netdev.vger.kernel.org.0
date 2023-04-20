Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7FF26E87B3
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 03:57:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230217AbjDTB5A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 21:57:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbjDTB47 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 21:56:59 -0400
Received: from smtpbg151.qq.com (smtpbg151.qq.com [18.169.211.239])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E90C91BF0;
        Wed, 19 Apr 2023 18:56:53 -0700 (PDT)
X-QQ-mid: Yeas49t1681955791t631t34113
Received: from 7082A6556EBF4E69829842272A565F7C (jiawenwu@trustnetic.com [183.129.236.74])
X-QQ-SSF: 00400000000000F0FL9000000000000
From:   =?utf-8?b?Smlhd2VuIFd1?= <jiawenwu@trustnetic.com>
X-BIZMAIL-ID: 3731747530147530030
To:     "'Vladimir Oltean'" <olteanv@gmail.com>
Cc:     <netdev@vger.kernel.org>, <linux@armlinux.org.uk>,
        <linux-i2c@vger.kernel.org>, <linux-gpio@vger.kernel.org>,
        <mengyuanlou@net-swift.com>,
        "'Jose Abreu'" <Jose.Abreu@synopsys.com>
References: <20230419082739.295180-1-jiawenwu@trustnetic.com> <20230419082739.295180-1-jiawenwu@trustnetic.com> <20230419082739.295180-7-jiawenwu@trustnetic.com> <20230419082739.295180-7-jiawenwu@trustnetic.com> <20230419131938.3k4kuqucvuuhxcrc@skbuf>
In-Reply-To: <20230419131938.3k4kuqucvuuhxcrc@skbuf>
Subject: RE: [PATCH net-next v3 6/8] net: pcs: Add 10GBASE-R mode for Synopsys Designware XPCS
Date:   Thu, 20 Apr 2023 09:56:26 +0800
Message-ID: <037501d9732b$518048d0$f480da70$@trustnetic.com>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Content-Language: zh-cn
Thread-Index: AQILBR3gZkFBC9g1wrfKT5ke1rRywwILBR3gATpg8oQBOmDyhAIV2gzYrpudPAA=
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

On Wednesday, April 19, 2023 9:20 PM, Vladimir Oltean wrote:
> On Wed, Apr 19, 2023 at 04:27:37PM +0800, Jiawen Wu wrote:
> > Add basic support for XPCS using 10GBASE-R interface. This mode will
> > be extended to use interrupt, so set pcs.poll false. And avoid soft
> > reset so that the device using this mode is in the default configuration.
> 
> I'm not clear why the xpcs_soft_reset() call is avoided. Isn't the
> out-of-reset configuration the "default" one?
> 

Theoretically so, I need to configure 10GBASE-R mode after reset. But this
configuration involves board info to configure PMA, etc., I'd like to implement
it in the next patch. Now the "default" configuration refers to the mode in
which the firmware is configured.

> > +static int xpcs_get_state_10gbaser(struct dw_xpcs *xpcs,
> > +				   struct phylink_link_state *state)
> > +{
> > +	int ret;
> > +
> > +	state->link = false;
> > +
> > +	ret = xpcs_read(xpcs, MDIO_MMD_PCS, MDIO_STAT1);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	if (ret & MDIO_STAT1_LSTATUS)
> > +		state->link = true;
> > +
> > +	if (state->link) {
> 
> It seems pointless to open a new "if" statement when this would have
> sufficed:
> 
> 	if (ret & MDIO_STAT1_LSTATUS) {
> 		state->link = true;
> 		state->pause = MLO_PAUSE_TX | MLO_PAUSE_RX;
> 		...
> 	}
> 
> > +		state->pause = MLO_PAUSE_TX | MLO_PAUSE_RX;
> > +		state->duplex = DUPLEX_FULL;
> > +		state->speed = SPEED_10000;
> > +	}
> > +
> > +	return 0;
> > +}
> 

