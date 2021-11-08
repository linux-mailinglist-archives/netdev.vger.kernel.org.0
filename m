Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D225644A30D
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 02:23:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242534AbhKIBZs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 20:25:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:40814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243348AbhKIBPa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Nov 2021 20:15:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 359056128B;
        Tue,  9 Nov 2021 01:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636419989;
        bh=K15zpbvGvoOyEAgc1q267wln0cn4CGaE1QidG057S7k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZOvelYmW+3jrSuHFHcfc8ArGGZkKlE4wtrt8owdqvGab0KIOkmu5Xz2F2GpjD3hyM
         qmJUIVcK6LoALhscXq8LvHFSSgJu7q5kT6AZSaN9qA2MJB9h2XWH45dcVm2u6TiJaM
         g5CdXAAeTm/qOSUT44CcbgGXEISq0aNNhFAGHZ0TY+iyrqLCDU82k3bjOPPmy1m9Xn
         0zYKjMsGqTdjvzbaIe1TB+tBAQKnC45CBauu+i4P7WYDCCmDqwFaEUcSkTahoXwEC8
         lTU86qX6YFzmCLT7ZCATAXap1VEs9xO1Xlj7cxsjIEEa68eLpioPU4hMfzOqmViIHc
         GxQTzQWO1+w7g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stephen Suryaputra <ssuryaextr@gmail.com>,
        Antonio Quartulli <a@unstable.cc>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 39/47] gre/sit: Don't generate link-local addr if addr_gen_mode is IN6_ADDR_GEN_MODE_NONE
Date:   Mon,  8 Nov 2021 12:50:23 -0500
Message-Id: <20211108175031.1190422-39-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211108175031.1190422-1-sashal@kernel.org>
References: <20211108175031.1190422-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stephen Suryaputra <ssuryaextr@gmail.com>

[ Upstream commit 61e18ce7348bfefb5688a8bcd4b4d6b37c0f9b2a ]

When addr_gen_mode is set to IN6_ADDR_GEN_MODE_NONE, the link-local addr
should not be generated. But it isn't the case for GRE (as well as GRE6)
and SIT tunnels. Make it so that tunnels consider the addr_gen_mode,
especially for IN6_ADDR_GEN_MODE_NONE.

Do this in add_v4_addrs() to cover both GRE and SIT only if the addr
scope is link.

Signed-off-by: Stephen Suryaputra <ssuryaextr@gmail.com>
Acked-by: Antonio Quartulli <a@unstable.cc>
Link: https://lore.kernel.org/r/20211020200618.467342-1-ssuryaextr@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/addrconf.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 76c097552ea74..9d8b791f63efc 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -3054,6 +3054,9 @@ static void sit_add_v4_addrs(struct inet6_dev *idev)
 	memcpy(&addr.s6_addr32[3], idev->dev->dev_addr, 4);
 
 	if (idev->dev->flags&IFF_POINTOPOINT) {
+		if (idev->cnf.addr_gen_mode == IN6_ADDR_GEN_MODE_NONE)
+			return;
+
 		addr.s6_addr32[0] = htonl(0xfe800000);
 		scope = IFA_LINK;
 		plen = 64;
-- 
2.33.0

