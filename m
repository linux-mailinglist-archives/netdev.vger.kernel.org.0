Return-Path: <netdev+bounces-1338-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C696D6FD765
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 08:50:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BAA901C20CF1
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 06:50:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B2D65691;
	Wed, 10 May 2023 06:50:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D0137F
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 06:50:02 +0000 (UTC)
Received: from smtpbg153.qq.com (smtpbg153.qq.com [13.245.218.24])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B99F270B
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 23:49:59 -0700 (PDT)
X-QQ-mid:Yeas54t1683701271t870t28039
Received: from 3DB253DBDE8942B29385B9DFB0B7E889 (jiawenwu@trustnetic.com [125.119.253.217])
X-QQ-SSF:00400000000000F0FNF000000000000
From: =?utf-8?b?Smlhd2VuIFd1?= <jiawenwu@trustnetic.com>
X-BIZMAIL-ID: 306390345786609964
To: "'Simon Horman'" <simon.horman@corigine.com>
Cc: <netdev@vger.kernel.org>,
	<jarkko.nikula@linux.intel.com>,
	<andriy.shevchenko@linux.intel.com>,
	<mika.westerberg@linux.intel.com>,
	<jsd@semihalf.com>,
	<Jose.Abreu@synopsys.com>,
	<andrew@lunn.ch>,
	<hkallweit1@gmail.com>,
	<linux@armlinux.org.uk>,
	<linux-i2c@vger.kernel.org>,
	<linux-gpio@vger.kernel.org>,
	<mengyuanlou@net-swift.com>
References: <20230509022734.148970-1-jiawenwu@trustnetic.com> <20230509022734.148970-4-jiawenwu@trustnetic.com> <ZFpnfNy2NSYNwUyI@corigine.com>
In-Reply-To: <ZFpnfNy2NSYNwUyI@corigine.com>
Subject: RE: [PATCH net-next v7 3/9] net: txgbe: Register fixed rate clock
Date: Wed, 10 May 2023 14:47:50 +0800
Message-ID: <009e01d9830b$56f1daf0$04d590d0$@trustnetic.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQJdw4zS3rpHMobUlf9gBLGLbLpYXQIKQeubAeFNPY+uKzJMoA==
Content-Language: zh-cn
X-QQ-SENDSIZE: 520
Feedback-ID: Yeas:trustnetic.com:qybglogicsvrgz:qybglogicsvrgz5a-1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,FROM_EXCESS_BASE64,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tuesday, May 9, 2023 11:32 PM, Simon Horman wrote:
> On Tue, May 09, 2023 at 10:27:28AM +0800, Jiawen Wu wrote:
> > In order for I2C to be able to work in standard mode, register a fixed
> > rate clock for each I2C device.
> >
> > Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
> 
> ...
> 
> > @@ -70,6 +72,32 @@ static int txgbe_swnodes_register(struct txgbe *txgbe)
> >  	return software_node_register_node_group(nodes->group);
> >  }
> >
> > +static int txgbe_clock_register(struct txgbe *txgbe) {
> > +	struct pci_dev *pdev = txgbe->wx->pdev;
> > +	struct clk_lookup *clock;
> > +	char clk_name[32];
> > +	struct clk *clk;
> > +
> > +	snprintf(clk_name, sizeof(clk_name), "i2c_designware.%d",
> > +		 (pdev->bus->number << 8) | pdev->devfn);
> > +
> > +	clk = clk_register_fixed_rate(NULL, clk_name, NULL, 0, 156250000);
> > +	if (IS_ERR(clk))
> > +		return PTR_ERR(clk);
> > +
> > +	clock = clkdev_create(clk, NULL, clk_name);
> > +	if (!clock) {
> > +		clk_unregister(clk);
> > +		return PTR_ERR(clock);
> 
> Hi Jiawen,
> 
> Sorry for missing this earlier, but the above error handling doesn't seem right.
> 
>    * This error condition is met if clock == NULL
>    * So the above is returning PTR_ERR(NULL), which is a yellow flag to me.
>      In any case, PTR_ERR(NULL) => 0 is returned on error.
>    * The caller treats a 0 return value as success.
> 
>    Perhaps this should be: return -ENOMEM?

No problem, I will fix it in patch v8.

> 
> > +	}
> > +
> > +	txgbe->clk = clk;
> > +	txgbe->clock = clock;
> > +
> > +	return 0;
> > +}
> > +
> >  int txgbe_init_phy(struct txgbe *txgbe)  {
> >  	int ret;
> > @@ -80,10 +108,23 @@ int txgbe_init_phy(struct txgbe *txgbe)
> >  		return ret;
> >  	}
> >
> > +	ret = txgbe_clock_register(txgbe);
> > +	if (ret) {
> > +		wx_err(txgbe->wx, "failed to register clock: %d\n", ret);
> > +		goto err_unregister_swnode;
> > +	}
> > +
> >  	return 0;
> 
> ...
> 


