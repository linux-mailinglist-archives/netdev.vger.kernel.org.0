Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8EB635CCA6
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 18:33:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244616AbhDLQa4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 12:30:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:56430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244613AbhDLQ2x (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 12:28:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C30086136A;
        Mon, 12 Apr 2021 16:25:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618244731;
        bh=pELHQ16BipNWV/9uSZSu6kkQI6TqpmtP85DPY8kiGHQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XemumQi/V/orWSpAT3SIVA/JOYP/IUUlBH8I6MwcglxMCPG1yfjI8ti3OLCDuJM1i
         RNRC5dkijFF2t6rzHAu8uYv7vH5x8pdyl5yQqfVMNMyeAc/Px69B7CGL+grMzxfPMX
         6TQ2nZuMXk85RPgi3FcpUrpaELlh6akGg/bael525mDBZuqVFDZLhfd8ZXS1Rezp8P
         TrcIZrKJBq1YrdRzBWgCrXXtVQT4osbbVwi9cEPe3mtknjkyPadUGh1r5c4JtmGiCG
         ayaNDmI/NdNhuzEr8vPpLRjT/EjGmmEMJ9KnsNOWY/9CGA9UoOGDxoj9hzc9ifQJKX
         9RL+lUxW2wgig==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Aring <aahringo@redhat.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 23/39] net: ieee802154: stop dump llsec devs for monitors
Date:   Mon, 12 Apr 2021 12:24:45 -0400
Message-Id: <20210412162502.314854-23-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210412162502.314854-1-sashal@kernel.org>
References: <20210412162502.314854-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Aring <aahringo@redhat.com>

[ Upstream commit 5582d641e6740839c9b83efd1fbf9bcd00b6f5fc ]

This patch stops dumping llsec devs for monitors which we don't support
yet. Otherwise we will access llsec mib which isn't initialized for
monitors.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
Link: https://lore.kernel.org/r/20210405003054.256017-7-aahringo@redhat.com
Signed-off-by: Stefan Schmidt <stefan@datenfreihafen.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ieee802154/nl802154.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
index 2eaf29d15baa..8e996ed8b3db 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -1688,6 +1688,11 @@ nl802154_dump_llsec_dev(struct sk_buff *skb, struct netlink_callback *cb)
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

