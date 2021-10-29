Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAA4043F522
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 05:02:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231599AbhJ2DEb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 23:04:31 -0400
Received: from pi.codeconstruct.com.au ([203.29.241.158]:43074 "EHLO
        codeconstruct.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231593AbhJ2DEa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 23:04:30 -0400
Received: by codeconstruct.com.au (Postfix, from userid 10000)
        id 14FE52022E; Fri, 29 Oct 2021 11:01:53 +0800 (AWST)
From:   Jeremy Kerr <jk@codeconstruct.com.au>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matt Johnston <matt@codeconstruct.com.au>,
        Andrew Jeffery <andrew@aj.id.au>
Subject: [PATCH net-next v2 0/3] MCTP flow support
Date:   Fri, 29 Oct 2021 11:01:42 +0800
Message-Id: <20211029030145.633626-1-jk@codeconstruct.com.au>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For certain MCTP transport bindings, the binding driver will need to be
aware of request/response pairing. For example, the i2c binding may need
to set multiplexer configuration when expecting a response from a device
behind a mux.

This series implements a mechanism for informing the driver about these
flows, so it can implement transport-specific behaviour when a flow is
in progress (ie, a response is expected, and/or we time-out on that
expectation). We use a skb extension to notify the driver about the
presence of a flow, and a new dev->ops callback to notify about a flow's
destruction.

Cheers,


Jeremy

---
v2:
 - add cover letter
 - fix CONFIG combinations when MCTP_FLOWS=n

Jeremy Kerr (3):
  mctp: Return new key from mctp_alloc_local_tag
  mctp: Add flow extension to skb
  mctp: Pass flow data & flow release events to drivers

 include/linux/skbuff.h   |  3 ++
 include/net/mctp.h       | 13 +++++++
 include/net/mctpdevice.h | 16 ++++++++
 net/core/skbuff.c        | 19 +++++++++
 net/mctp/Kconfig         |  7 +++-
 net/mctp/device.c        | 51 ++++++++++++++++++++++++
 net/mctp/route.c         | 83 +++++++++++++++++++++++++++++++++-------
 7 files changed, 177 insertions(+), 15 deletions(-)

-- 
2.33.0

