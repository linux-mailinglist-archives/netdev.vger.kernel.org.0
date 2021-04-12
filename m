Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D1ED35CDC2
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 18:52:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245715AbhDLQi1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 12:38:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:38912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343763AbhDLQgA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 12:36:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 98B91613E1;
        Mon, 12 Apr 2021 16:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618244838;
        bh=FcsUkKioZA4Od5n/OACK5XQmTWA2WD4p0Bi2hPfzReE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IcBY4hRY6LH+ObeHmndseh7FLB8Cn5g5exv8gAJdLeIBLK0EktpkYm4dxAt3HQZsW
         QkIV/9O8pGpB4WHO8go1Cp/54hTPOuY9MwPfEnfMLhjIOtj2YZmszgFdan0wS0qJKK
         poxVROVLnJmwrcVklC/c7WScCuHx7sBRpMiaZDB76pCFXvGr/B2kxfKBSVaa4GxyEU
         XFa/5GeS3uhifSV6XOI9DnIOT0W0ffuPefvy4dUoWpfPclni9gPdxof2XZ2yok/T8Q
         6Du8VaiUyAj17lNIrS2EV42FQ8lzlxywVhp9M2taejUijfTlCiMIGqgeoj59pwnvRn
         nkanxujnIOvVA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Aring <aahringo@redhat.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 10/23] net: ieee802154: stop dump llsec keys for monitors
Date:   Mon, 12 Apr 2021 12:26:51 -0400
Message-Id: <20210412162704.315783-10-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210412162704.315783-1-sashal@kernel.org>
References: <20210412162704.315783-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Aring <aahringo@redhat.com>

[ Upstream commit fb3c5cdf88cd504ef11d59e8d656f4bc896c6922 ]

This patch stops dumping llsec keys for monitors which we don't support
yet. Otherwise we will access llsec mib which isn't initialized for
monitors.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
Link: https://lore.kernel.org/r/20210405003054.256017-4-aahringo@redhat.com
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ieee802154/nl802154.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
index 249db5ea02b9..524819f76858 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -1526,6 +1526,11 @@ nl802154_dump_llsec_key(struct sk_buff *skb, struct netlink_callback *cb)
 	if (err)
 		return err;
 
+	if (wpan_dev->iftype == NL802154_IFTYPE_MONITOR) {
+		err = skb->len;
+		goto out_err;
+	}
+
 	if (!wpan_dev->netdev) {
 		err = -EINVAL;
 		goto out_err;
-- 
2.30.2

