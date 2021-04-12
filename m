Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E2F535CDA3
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 18:37:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245350AbhDLQhg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 12:37:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:35668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243784AbhDLQd7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 12:33:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5650E613CA;
        Mon, 12 Apr 2021 16:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618244809;
        bh=KlcYCbh/aOwdIZJA/TMT/dsRi9umog+EcNG2foDfu7U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qo7wJrEdLmJ34uAW6gA/EuAhTGhqhW4RV9Jn2u3UtgpRj8qV1Or1JCOzFLCCf+xLr
         P9745VjKxhYcPe1Yu1OTY9HAzkkd4Q+JwIVJF961ZSCdftO/RczLW3Tr8I8KCf6k/N
         ORLVosGIjuqIvOKMUDlquBsVi1XWY+beEaOvtd7ayWQhIPLezEd14ybQLlypZPTeqX
         p7/vQyS+jkhcqz6Pu7+PtD4SeAW6C0Lkxbx5C7ZgGP9eFoeDlLBCOalvqi/vhYtTHU
         ZHDlTdLCJ4eVDQVzA+7XFVFoTLJaSIa67CuVzwbT3ssueALQj7aPbLHkyXV8ND8Rsw
         CE+nYb/pBwdYg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Aring <aahringo@redhat.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 14/25] net: ieee802154: stop dump llsec devkeys for monitors
Date:   Mon, 12 Apr 2021 12:26:19 -0400
Message-Id: <20210412162630.315526-14-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210412162630.315526-1-sashal@kernel.org>
References: <20210412162630.315526-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Aring <aahringo@redhat.com>

[ Upstream commit 080d1a57a94d93e70f84b7a360baa351388c574f ]

This patch stops dumping llsec devkeys for monitors which we don't support
yet. Otherwise we will access llsec mib which isn't initialized for
monitors.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
Link: https://lore.kernel.org/r/20210405003054.256017-10-aahringo@redhat.com
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ieee802154/nl802154.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
index 10858c31cb47..b770837b3379 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -1866,6 +1866,11 @@ nl802154_dump_llsec_devkey(struct sk_buff *skb, struct netlink_callback *cb)
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

