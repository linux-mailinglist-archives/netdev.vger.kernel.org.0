Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB70C35CDC5
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 18:52:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244144AbhDLQih (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 12:38:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:38772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343804AbhDLQgI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 12:36:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DBAF8613E2;
        Mon, 12 Apr 2021 16:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618244839;
        bh=LWniOg1FF4KVU1sA7tBVa/3wIr5uDP1wCzcsfMzVg2Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tllH14zPxB96ouVHWyHrgaKR1tJHmdAwaIIypNA9By0NLouwy2SnhL2k60y5IpU1j
         vu6xYPuM2DpZ074DeDDqltN9kNRYi+0QqSspq0NkjBZfZ9nh6xVTNQi5UskHLqZbKa
         76Ng0bPuzY3Y7TMcV8c8L8sCa0eum32ZJS8FJOv8gOzQkAT+xoVIbLI/6/PIewZPdt
         UfWnha9m+H0EI6zjqSbpfIDXrZQaVpIagI5ueUS1pgH5AZa+SMV3S/PJIJFJoiDYpA
         rn+t/PSk4rLEccUoWxJifzGCEGrudQDapOgxDKT/0UdBoKI8Etga1BXRSgycdH1Ins
         IzbFj6rY6bRIQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Aring <aahringo@redhat.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Sasha Levin <sashal@kernel.org>, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 11/23] net: ieee802154: stop dump llsec devs for monitors
Date:   Mon, 12 Apr 2021 12:26:52 -0400
Message-Id: <20210412162704.315783-11-sashal@kernel.org>
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
index 524819f76858..65d7ca290591 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -1701,6 +1701,11 @@ nl802154_dump_llsec_dev(struct sk_buff *skb, struct netlink_callback *cb)
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

