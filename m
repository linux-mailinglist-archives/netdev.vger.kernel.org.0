Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62A242052C
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 13:44:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728296AbfEPLlm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 07:41:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:50432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728279AbfEPLll (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 May 2019 07:41:41 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B70F52089E;
        Thu, 16 May 2019 11:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558006900;
        bh=8eARBYmvj/PR+Vmhg1+Mrnms2xkYXMN8hkHgcDObopo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lIadVS4mwnMSPf7KYrK2NKYx+sZa3HkwiaZqt165prUzH0oqJFTNES3WkpBax351y
         mTjpo2cjtXWYzntkRxBwEJNiOFfw7fxwOHQco0MzwtzQtlUGfgrZcEtAXKXEdVh+x4
         y3klnUUgdA7M6su1ZAcZDNq+sdifKCrTKPtpzQtY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bhagavathi Perumal S <bperumal@codeaurora.org>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 5/9] mac80211: Fix kernel panic due to use of txq after free
Date:   Thu, 16 May 2019 07:41:29 -0400
Message-Id: <20190516114134.9146-5-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190516114134.9146-1-sashal@kernel.org>
References: <20190516114134.9146-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bhagavathi Perumal S <bperumal@codeaurora.org>

[ Upstream commit f1267cf3c01b12e0f843fb6a7450a7f0b2efab8a ]

The txq of vif is added to active_txqs list for ATF TXQ scheduling
in the function ieee80211_queue_skb(), but it was not properly removed
before freeing the txq object. It was causing use after free of the txq
objects from the active_txqs list, result was kernel panic
due to invalid memory access.

Fix kernel invalid memory access by properly removing txq object
from active_txqs list before free the object.

Signed-off-by: Bhagavathi Perumal S <bperumal@codeaurora.org>
Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/iface.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 5768560cbfc3e..ad03331ee7855 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1937,6 +1937,9 @@ void ieee80211_if_remove(struct ieee80211_sub_if_data *sdata)
 	list_del_rcu(&sdata->list);
 	mutex_unlock(&sdata->local->iflist_mtx);
 
+	if (sdata->vif.txq)
+		ieee80211_txq_purge(sdata->local, to_txq_info(sdata->vif.txq));
+
 	synchronize_rcu();
 
 	if (sdata->dev) {
-- 
2.20.1

