Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4BD84B99F2
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 08:39:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236424AbiBQHkA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 02:40:00 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236370AbiBQHj7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 02:39:59 -0500
Received: from codeconstruct.com.au (pi.codeconstruct.com.au [203.29.241.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12EA62A39C7;
        Wed, 16 Feb 2022 23:39:43 -0800 (PST)
Received: from [192.168.12.102] (unknown [159.196.94.94])
        by mail.codeconstruct.com.au (Postfix) with ESMTPSA id 105532039E;
        Thu, 17 Feb 2022 15:39:37 +0800 (AWST)
Message-ID: <eaee265147f14982c89d400f80e4482a029cdf98.camel@codeconstruct.com.au>
Subject: Re: [PATCH net-next v5 2/2] mctp i2c: MCTP I2C binding driver
From:   Matt Johnston <matt@codeconstruct.com.au>
To:     Wolfram Sang <wsa@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jeremy Kerr <jk@codeconstruct.com.au>,
        linux-i2c@vger.kernel.org, netdev@vger.kernel.org,
        Zev Weiss <zev@bewilderbeest.net>
Date:   Thu, 17 Feb 2022 15:39:37 +0800
In-Reply-To: <Yg0jMkt56EhrBybc@ninjato>
References: <20220210063651.798007-1-matt@codeconstruct.com.au>
         <20220210063651.798007-3-matt@codeconstruct.com.au>
         <Yg0jMkt56EhrBybc@ninjato>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4-1ubuntu2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,KHOP_HELO_FCRDNS,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Wolfram,

On Wed, 2022-02-16 at 17:15 +0100, Wolfram Sang wrote:
> So, I did a high level review regardings the I2C stuff. I did not check
> locking, device lifetime, etc. My biggest general remark is the mixture
> of multi-comment styles, like C++ style or no empty "/*" at the
> beginning as per Kernel coding style. Some functions have nice
> explanations in the header but not proper kdoc formatting. And also on
> the nitbit side, I don't think '__func__' helps here on the error
> messages. But that's me, I'll leave it to the netdev maintainers.

I'll tidy up the comments. A filled /* first line is part of the netdev
style.
> 
> Now for the I2C part. It looks good. I have only one remark:
> 
> > +static const struct i2c_device_id mctp_i2c_id[] = {
> > +	{ "mctp-i2c", 0 },
> > +	{},
> > +};
> > +MODULE_DEVICE_TABLE(i2c, mctp_i2c_id);
> 
> ...
> 
> > +static struct i2c_driver mctp_i2c_driver = {
> > +	.driver = {
> > +		.name = "mctp-i2c",
> > +		.of_match_table = mctp_i2c_of_match,
> > +	},
> > +	.probe_new = mctp_i2c_probe,
> > +	.remove = mctp_i2c_remove,
> > +	.id_table = mctp_i2c_id,
> > +};
> 
> I'd suggest to add 'slave' to the 'mctp-i2c' string somewhere to make it
> easily visible that this driver does not manage a remote device but
> processes requests to its own address.

I think 'slave' might be a bit unclear - the driver's acting as an I2C master
too. It also is more baggage moving to inclusive naming. Maybe mctp-i2c-
transport or mctp-i2c-interface would suit?

Cheers,
Matt

