Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7820E6EC37C
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 03:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbjDXBuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Apr 2023 21:50:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbjDXBuS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Apr 2023 21:50:18 -0400
Received: from smtpbg153.qq.com (smtpbg153.qq.com [13.245.218.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9444E19A;
        Sun, 23 Apr 2023 18:50:14 -0700 (PDT)
X-QQ-mid: Yeas51t1682300979t085t31667
Received: from 7082A6556EBF4E69829842272A565F7C (jiawenwu@trustnetic.com [183.129.236.74])
X-QQ-SSF: 00400000000000F0FM9000000000000
From:   =?utf-8?b?Smlhd2VuIFd1?= <jiawenwu@trustnetic.com>
X-BIZMAIL-ID: 10473020202358225154
To:     "'Simon Horman'" <simon.horman@corigine.com>
Cc:     <netdev@vger.kernel.org>, <andrew@lunn.ch>,
        <linux@armlinux.org.uk>, <jarkko.nikula@linux.intel.com>,
        <olteanv@gmail.com>, <andriy.shevchenko@linux.intel.com>,
        <hkallweit1@gmail.com>, <linux-i2c@vger.kernel.org>,
        <linux-gpio@vger.kernel.org>, <mengyuanlou@net-swift.com>
References: <20230422045621.360918-1-jiawenwu@trustnetic.com> <20230422045621.360918-9-jiawenwu@trustnetic.com> <ZEWNtepnhsZp/HwW@corigine.com>
In-Reply-To: <ZEWNtepnhsZp/HwW@corigine.com>
Subject: RE: [PATCH net-next v4 8/8] net: txgbe: Support phylink MAC layer
Date:   Mon, 24 Apr 2023 09:49:37 +0800
Message-ID: <002901d9764f$073e7d10$15bb7730$@trustnetic.com>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQLYcl6q9PfLE2IPpEOvRSb72esQRAGSvu55Ap8o7ditGil7wA==
Content-Language: zh-cn
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

On Monday, April 24, 2023 3:58 AM, Simon Horman wrote:
> On Sat, Apr 22, 2023 at 12:56:21PM +0800, Jiawen Wu wrote:
> > Add phylink support to Wangxun 10Gb Ethernet controller for the 10GBASE-R
> > interface.
> >
> > Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
> 
> ...
> 
> > +static int txgbe_phylink_init(struct txgbe *txgbe)
> > +{
> > +	struct phylink_config *config;
> > +	struct fwnode_handle *fwnode;
> > +	struct wx *wx = txgbe->wx;
> > +	phy_interface_t phy_mode;
> > +	struct phylink *phylink;
> > +
> > +	config = devm_kzalloc(&wx->pdev->dev, sizeof(*config), GFP_KERNEL);
> > +	if (!config)
> > +		return -ENOMEM;
> > +
> > +	config->dev = &wx->netdev->dev;
> > +	config->type = PHYLINK_NETDEV;
> > +	config->mac_capabilities = MAC_10000FD | MAC_1000FD | MAC_SYM_PAUSE | MAC_ASYM_PAUSE;
> > +	phy_mode = PHY_INTERFACE_MODE_10GBASER;
> > +	__set_bit(PHY_INTERFACE_MODE_10GBASER, config->supported_interfaces);
> > +	fwnode = software_node_fwnode(txgbe->nodes.group[SWNODE_PHYLINK]);
> > +	phylink = phylink_create(config, fwnode, phy_mode, &txgbe_mac_ops);
> > +	if (IS_ERR(phylink))
> > +		return PTR_ERR(phylink);
> > +
> > +	txgbe->phylink = phylink;
> > +
> > +	return 0;
> > +}
> 
> Hi Jiawen,
> 
> txgbe_phylink_init() seems unused.
> Perhaps it needs to be wired-up somewhere?
> 

Oops, I forgot to add it to txgbe_init_phy().


