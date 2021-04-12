Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B6E135CCBD
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 18:33:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244791AbhDLQbE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 12:31:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:57004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244773AbhDLQ2d (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 12:28:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3932D61391;
        Mon, 12 Apr 2021 16:25:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618244728;
        bh=JzaEgVeMcDRSlnHmJZCFh0NcD0YpT7T03OgNiJxA6U0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kcC6HS54cJVmz2D8OP03jsOJntU39fSKe8zbj/GpmY475YtjcLlUGC3dz5TGwGpy+
         FfPjDKwmkd83pL8D8s5yg50Tqyn582lEuxDd+cFVVq+LJGHa5HO8jYgzddyTagMn0s
         0CbF4UZefOUB7vEgowo5JjayzxxowUSHd75B4qJZHgAzODncuGRdYSmoqU6Fy7dIS/
         Z57Dfx1sR9CENR0R5ZB6P0wRS2je8RvsCEMHRz1WaQJ1gG+vMJ2EByjn7auWwYYOBy
         DxweWL9nF2dJMI5Gs7QAPf9dL0QcgMp2IgX5bOQ/CWLZpMuR813nyXZCcfFLwW5+mS
         /P4LXfGjax8BA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Aring <aahringo@redhat.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 20/39] net: ieee802154: stop dump llsec keys for monitors
Date:   Mon, 12 Apr 2021 12:24:42 -0400
Message-Id: <20210412162502.314854-20-sashal@kernel.org>
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
index 748e0aac0b78..323d92177521 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -1509,6 +1509,11 @@ nl802154_dump_llsec_key(struct sk_buff *skb, struct netlink_callback *cb)
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

