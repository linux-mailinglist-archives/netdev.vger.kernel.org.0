Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7509C1061D4
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 06:59:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729525AbfKVF5t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 00:57:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:36296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729524AbfKVF5r (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Nov 2019 00:57:47 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A7632072E;
        Fri, 22 Nov 2019 05:57:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574402267;
        bh=fIDkp3nQknwUGs/jEnpCYRRi9+4jX4CW2Ox9ygyMYls=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v3Wa0/wvpsiLSWNor5KI0eKR4ToFTraBRPfcxSom8C3JkthhHTbBZz3kpBIpB2nr2
         0N9PZUwcAwcJ8PR8KeXP+MX2kqxVEHJ7MBpkEqBVF7lyGlmc3DQP9wENweU2Gm/dz7
         DaIsDuxHpupRe/vPP0qkrdTJNzWjOKhksvsLecEs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        linux-decnet-user@lists.sourceforge.net, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 107/127] decnet: fix DN_IFREQ_SIZE
Date:   Fri, 22 Nov 2019 00:55:25 -0500
Message-Id: <20191122055544.3299-106-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122055544.3299-1-sashal@kernel.org>
References: <20191122055544.3299-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 50c2936634bcb1db78a8ca63249236810c11a80f ]

Digging through the ioctls with Al because of the previous
patches, we found that on 64-bit decnet's dn_dev_ioctl()
is wrong, because struct ifreq::ifr_ifru is actually 24
bytes (not 16 as expected from struct sockaddr) due to the
ifru_map and ifru_settings members.

Clearly, decnet expects the ioctl to be called with a struct
like
  struct ifreq_dn {
    char ifr_name[IFNAMSIZ];
    struct sockaddr_dn ifr_addr;
  };

since it does
  struct ifreq *ifr = ...;
  struct sockaddr_dn *sdn = (struct sockaddr_dn *)&ifr->ifr_addr;

This means that DN_IFREQ_SIZE is too big for what it wants on
64-bit, as it is
  sizeof(struct ifreq) - sizeof(struct sockaddr) +
  sizeof(struct sockaddr_dn)

This assumes that sizeof(struct sockaddr) is the size of ifr_ifru
but that isn't true.

Fix this to use offsetof(struct ifreq, ifr_ifru).

This indeed doesn't really matter much - the result is that we
copy in/out 8 bytes more than we should on 64-bit platforms. In
case the "struct ifreq_dn" lands just on the end of a page though
it might lead to faults.

As far as I can tell, it has been like this forever, so it seems
very likely that nobody cares.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/decnet/dn_dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/decnet/dn_dev.c b/net/decnet/dn_dev.c
index df042b6d80b83..22876a197ebec 100644
--- a/net/decnet/dn_dev.c
+++ b/net/decnet/dn_dev.c
@@ -56,7 +56,7 @@
 #include <net/dn_neigh.h>
 #include <net/dn_fib.h>
 
-#define DN_IFREQ_SIZE (sizeof(struct ifreq) - sizeof(struct sockaddr) + sizeof(struct sockaddr_dn))
+#define DN_IFREQ_SIZE (offsetof(struct ifreq, ifr_ifru) + sizeof(struct sockaddr_dn))
 
 static char dn_rt_all_end_mcast[ETH_ALEN] = {0xAB,0x00,0x00,0x04,0x00,0x00};
 static char dn_rt_all_rt_mcast[ETH_ALEN]  = {0xAB,0x00,0x00,0x03,0x00,0x00};
-- 
2.20.1

