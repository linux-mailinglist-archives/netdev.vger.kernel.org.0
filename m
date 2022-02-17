Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 318A54B9BE9
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 10:22:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238596AbiBQJWd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 04:22:33 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238413AbiBQJWc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 04:22:32 -0500
Received: from codeconstruct.com.au (pi.codeconstruct.com.au [203.29.241.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE0706409;
        Thu, 17 Feb 2022 01:22:16 -0800 (PST)
Received: from [192.168.12.102] (unknown [159.196.94.94])
        by mail.codeconstruct.com.au (Postfix) with ESMTPSA id 41BA82039E;
        Thu, 17 Feb 2022 17:22:14 +0800 (AWST)
Message-ID: <5c2673ed11ad764764998e1244a59f0c8c1cb2da.camel@codeconstruct.com.au>
Subject: Re: [PATCH net-next v5 2/2] mctp i2c: MCTP I2C binding driver
From:   Matt Johnston <matt@codeconstruct.com.au>
To:     Wolfram Sang <wsa@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jeremy Kerr <jk@codeconstruct.com.au>,
        linux-i2c@vger.kernel.org, netdev@vger.kernel.org,
        Zev Weiss <zev@bewilderbeest.net>
Date:   Thu, 17 Feb 2022 17:22:13 +0800
In-Reply-To: <Yg4N1SYeCdSPDR+V@ninjato>
References: <20220210063651.798007-1-matt@codeconstruct.com.au>
         <20220210063651.798007-3-matt@codeconstruct.com.au>
         <Yg0jMkt56EhrBybc@ninjato>
         <eaee265147f14982c89d400f80e4482a029cdf98.camel@codeconstruct.com.au>
         <Yg4N1SYeCdSPDR+V@ninjato>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4-1ubuntu2 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,KHOP_HELO_FCRDNS,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2022-02-17 at 09:58 +0100, Wolfram Sang wrote:
> > I think 'slave' might be a bit unclear - the driver's acting as an I2C master
> > too.
> 
> Right. Yet, AFAIU only when sending responses to other nodes, or? It
> does not drive this one remote device with address 0xNN but acts itself
> as device 0xMM.

The Linux mctp-i2c endpoint (0xMM) can send MCTP messages to any I2C node
(0xNN), as a block write master->slave. The MCTP I2C transport is
bidirectional - either side can send the first message, all messages are
block writes. (Hopefully I've understood your question)

Most higher level protocols on top of MCTP are request/response style, though
it isn't inherent. The mctp-i2c driver is mostly stateless, but it in order
to deal with i2c muxes the MCTP stack has a concept of "flows" so that it
will keep a bus locked for replies after sending out a request (with timeout)
- that matches how higher level protocols expect to work.

> Oh, and one other question I have meanwhile: do you really need
> "mctp_current_mux" as a device attribute or is it mere debug and could
> go away when upstream?

Yes, it's really only useful for debugging since it could be outdated by the
time it is read. I'll remove it, we could add something more robust if people
had a need.

Cheers,
Matt

