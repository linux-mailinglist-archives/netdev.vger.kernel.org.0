Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5038438FBAA
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 09:28:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231637AbhEYH3b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 03:29:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231263AbhEYH33 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 May 2021 03:29:29 -0400
Received: from plekste.mt.lv (bute.mt.lv [IPv6:2a02:610:7501:2000::195])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2FFAC061574;
        Tue, 25 May 2021 00:28:00 -0700 (PDT)
Received: from localhost ([127.0.0.1] helo=bute.mt.lv)
        by plekste.mt.lv with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <gatis@mikrotik.com>)
        id 1llRTk-0006jO-7Y; Tue, 25 May 2021 10:27:52 +0300
MIME-Version: 1.0
Date:   Tue, 25 May 2021 10:27:52 +0300
From:   Gatis Peisenieks <gatis@mikrotik.com>
To:     Chris Snook <chris.snook@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        jesse.brandeburg@intel.com, dchickles@marvell.com,
        tully@mikrotik.com, Eric Dumazet <eric.dumazet@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] atl1c: add 4 RX/TX queue support for Mikrotik
 10/25G NIC
In-Reply-To: <CAMXMK6vhcOUTdMihyo0Umss7T9cvxf_4R8iH4weCJ2Apr6d6OA@mail.gmail.com>
References: <20210524191115.2760178-1-gatis@mikrotik.com>
 <CAMXMK6vhcOUTdMihyo0Umss7T9cvxf_4R8iH4weCJ2Apr6d6OA@mail.gmail.com>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <1b5e9b39d1d0b55c6557e7fb0f571e62@mikrotik.com>
X-Sender: gatis@mikrotik.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Chris, thank you for taking a look at this!

In my experience L4 hashing (adding TCP/UDP ports to the hash to
determine rx queue) can cause problems with fragmented packets when
packet parser ignores the "More Fragments" and/or "Fragment Offset"
fields of the IPv4 header. Only the first fragment contains the ports,
so if parser blindly assumes ports to be at start of L4 offset, then
packets belonging to same connection get scattered among the rx queues
which is not good for performance.

Mikrotik 10/25G NIC RX parser stops at L3 if it sees any of those set.
Essentially it falls back to L2/L3 hashing for fragmented packets.
So it is ok in that regard.


On 2021-05-24 22:52, Chris Snook wrote:
> Is the L4 part of that hash configurable? That sort of thing tends to
> cause performance problems for fragmenting workloads, such as NFS over
> UDP.
> 
> - Chris
> 
