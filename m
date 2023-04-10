Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A2306DC3DF
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 09:33:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbjDJHdX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 03:33:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229781AbjDJHdV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 03:33:21 -0400
Received: from smtpbg153.qq.com (smtpbg153.qq.com [13.245.218.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A90C4698
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 00:33:12 -0700 (PDT)
X-QQ-mid: Yeas5t1681111933t855t17530
Received: from 7082A6556EBF4E69829842272A565F7C (jiawenwu@trustnetic.com [183.129.236.74])
X-QQ-SSF: 00400000000000F0FL9000000000000
From:   =?utf-8?b?Smlhd2VuIFd1?= <jiawenwu@trustnetic.com>
X-BIZMAIL-ID: 10513836317384926707
To:     "'Russell King \(Oracle\)'" <linux@armlinux.org.uk>
Cc:     <netdev@vger.kernel.org>, <mengyuanlou@net-swift.com>
References: <20230403064528.343866-1-jiawenwu@trustnetic.com> <20230403064528.343866-6-jiawenwu@trustnetic.com> <ZCrY9Pqn+fID63s3@shell.armlinux.org.uk>
In-Reply-To: <ZCrY9Pqn+fID63s3@shell.armlinux.org.uk>
Subject: RE: [PATCH net-next 5/6] net: txgbe: Implement phylink pcs
Date:   Mon, 10 Apr 2023 15:32:12 +0800
Message-ID: <00a701d96b7e$90edb890$b2c929b0$@trustnetic.com>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Content-Language: zh-cn
Thread-Index: AQKwNRf195lW+I6aexcIjeJmW6Wh1gJHr+azAlWE08CtUaP1IA==
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

> > +				       struct phylink_link_state *state)
> > +{
> > +	int lpa, bmsr;
> > +
> > +	/* For C37 1000BASEX mode */
> > +	if (linkmode_test_bit(ETHTOOL_LINK_MODE_Autoneg_BIT,
> > +			      state->advertising)) {
> > +		/* Reset link state */
> > +		state->link = false;
> > +
> > +		/* Poll for link jitter */
> > +		read_poll_timeout(pcs_read, lpa, lpa,
> > +				  100, 50000, false, txgbe,
> > +				  MDIO_MMD_VEND2, MII_LPA);
> 
> What jitter are you referring to? If the link is down (and thus this
> register reads zero), why do we have to spin here for 50ms each time?
> 

I found that when the last interrupt arrives, the link status is often
still down, but it will become up after a while. It is about 30ms on my
test.
I can't find a good way to solve this problem at the moment, so just
delay some time.


