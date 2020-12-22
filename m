Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 951CC2E0F3E
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 21:17:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727700AbgLVUPo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 15:15:44 -0500
Received: from atlmailgw2.ami.com ([63.147.10.42]:46440 "EHLO
        atlmailgw2.ami.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725782AbgLVUPo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Dec 2020 15:15:44 -0500
X-AuditID: ac10606f-231ff70000001934-51-5fe253ca7038
Received: from atlms1.us.megatrends.com (atlms1.us.megatrends.com [172.16.96.144])
        (using TLS with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by atlmailgw2.ami.com (Symantec Messaging Gateway) with SMTP id A2.71.06452.AC352EF5; Tue, 22 Dec 2020 15:15:06 -0500 (EST)
Received: from ami-us-wk.us.megatrends.com (172.16.98.207) by
 atlms1.us.megatrends.com (172.16.96.144) with Microsoft SMTP Server (TLS) id
 14.3.468.0; Tue, 22 Dec 2020 15:15:05 -0500
From:   Hongwei Zhang <hongweiz@ami.com>
To:     <linux-aspeed@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <openbmc@lists.ozlabs.org>, Jakub Kicinski <kuba@kernel.org>,
        David S Miller <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>
CC:     Hongwei Zhang <hongweiz@ami.com>, netdev <netdev@vger.kernel.org>,
        Joel Stanley <joel@jms.id.au>, Andrew Jeffery <andrew@aj.id.au>
Subject: [Aspeed, v2 2/2] net: ftgmac100: Change the order of getting MAC address
Date:   Tue, 22 Dec 2020 15:14:37 -0500
Message-ID: <20201222201437.5588-3-hongweiz@ami.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201221205157.31501-2-hongweiz@ami.com>
References: <20201221205157.31501-2-hongweiz@ami.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.16.98.207]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMLMWRmVeSWpSXmKPExsWyRiBhgu6p4EfxBgenSljsusxhMed8C4vF
        ovczWC1+n//LbHFhWx+rRfPqc8wWl3fNYbM4tkDM4lTLCxYHTo+r7bvYPbasvMnksXPWXXaP
        ix+PMXtsWtXJ5nF+xkJGj8+b5ALYo7hsUlJzMstSi/TtErgy1l28zlrQwFPx7GEfWwPjfs4u
        Rk4OCQETids/7jF3MXJxCAnsYpLYNr2JBcphlHjeeoARpIpNQE1i7+Y5TCAJEYHLjBI3up6A
        tTALdDBKTH3xlR2kSlggUOLpl0VMIDaLgKrEvJ6VYHFeoB0P711igtgnL7F6wwFmEJtTwEzi
        QvcsFhBbSMBUYsXfj8wQ9YISJ2c+AYszC0hIHHzxghmiRlbi1qHHUHMUJR78+s46gVFgFpKW
        WUhaFjAyrWIUSizJyU3MzEkvN9JLzM3US87P3cQICfj8HYwfP5ofYmTiYDzEKMHBrCTCayZ1
        P16INyWxsiq1KD++qDQntfgQozQHi5I47yr3o/FCAumJJanZqakFqUUwWSYOTqkGxltFXUm5
        r/TFMh7FMLO33LzheOeHZDXb7x4dH83nd2KF3XdVsbz8ffynRKkGV6iN6N1ALfmPFtxVHXyv
        Z8ttcXOzPzxlusFae7csXvm1v48Zba4pm33u/X0xxv5AruevmlnyXn/oNW73XG0WsMuF4cXy
        vOWXOk3C/r/52BK1Z8uZ0FkpF3wWKrEUZyQaajEXFScCAJCVVJ5mAgAA
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Reviewer,

Use native MAC address is preferred over other choices, thus change the order
of reading MAC address, try to read it from MAC chip first, if it's not
 availabe, then try to read it from device tree.


Hi Heiner,

> From:	Heiner Kallweit <hkallweit1@gmail.com>
> Sent:	Monday, December 21, 2020 4:37 PM
> > Change the order of reading MAC address, try to read it from MAC chip 
> > first, if it's not availabe, then try to read it from device tree.
> > 
> This commit message leaves a number of questions. It seems the change isn't related at all to the 
> change that it's supposed to fix.
> 
> - What is the issue that you're trying to fix?
> - And what is wrong with the original change?

There is no bug or something wrong with the original code. This patch is for
improving the code. We thought if the native MAC address is available, then
it's preferred over MAC address from dts (assuming both sources are available).

One possible scenario, a MAC address is set in dts and the BMC image is 
compiled and loaded into more than one platform, then the platforms will
have network issue due to the same MAC address they read.

Thanks for your review, I've update the patch to fix the comments.
> 
> > Fixes: 35c54922dc97 ("ARM: dts: tacoma: Add reserved memory for 
> > ramoops")
> > Signed-off-by: Hongwei Zhang <hongweiz@ami.com>
> > ---
> >  drivers/net/ethernet/faraday/ftgmac100.c | 22 +++++++++++++---------
> >  1 file changed, 13 insertions(+), 9 deletions(-)

--Hongwei
