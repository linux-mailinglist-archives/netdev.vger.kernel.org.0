Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F63C5FDC4D
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 16:20:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbiJMOU2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 10:20:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230011AbiJMOU0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 10:20:26 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ED686279
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 07:20:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=xPazVOf+JIyGrlgsKcU5eWYA5huFnC8aPrhbNP5ZPv8=; b=y/qixORELxshsq9200zsgcRL3P
        dAK+YwMOSYDN6a4AGnpelLTMKNRLjxjRxHGW1X2pMkv6ALFK8rFDIpCz7OfDcl5VymvIqwJdYPoBf
        ieDxtEjgLPKotQNz11+ujVfurDvb6FW2G4ScHJTzkvnCpVq5vHf3hNyjslVfHmiAgqE0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oiz4H-001tU2-Mu; Thu, 13 Oct 2022 16:20:13 +0200
Date:   Thu, 13 Oct 2022 16:20:13 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Arankal, Nagaraj" <nagaraj.p.arankal@hpe.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: socket leaks observed in Linux kernel's passive close path
Message-ID: <Y0genWOLGfy2kQ/M@lunn.ch>
References: <SJ0PR84MB1847204B80E86F8449DE1AAAB2259@SJ0PR84MB1847.NAMPRD84.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SJ0PR84MB1847204B80E86F8449DE1AAAB2259@SJ0PR84MB1847.NAMPRD84.PROD.OUTLOOK.COM>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 13, 2022 at 06:47:56AM +0000, Arankal, Nagaraj wrote:
> Description:
> We have observed a strange race condition , where sockets are not freed in kernel in the following condition.
> We have a kernel module , which monitors the TCP connection state changes , as part of the functionality it replaces the default sk_destruct function of all TCP sockets with our module specific routine.  Looks like sk_destruct() is not invoked in following condition and hence the sockets are leaked despite receiving RESET from the remote.
> 
> 1.	Establish a TCP connection between Host A and Host B.
> 2.	Make the client at B to initiate the CLOSE() immediately after 3-way handshake.
> 3.	Server end sends huge amount of data to client and does close on FD.
> 4.	FIN from the client is not ACKED, and server is busy sending the data.
> 5.	RESET is received from the remote client.
> 6.	Sk_destruct() is not invoked due to non-null sk_refcnt or sk_wmem_alloc count.
> 
> Kernel version: Debian Linux 4.19.y(238,247)

Is this reproducible with a modern kernel? v6.0? If this is already
fixed, we need to identify what change fixed it, and get it back
ported. If it is broken in v6.0, and net-next, it first needs fixing
in net-next, and then back porting to the different LTS kernels.

   Andrew
