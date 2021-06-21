Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E25553AF262
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 19:52:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231837AbhFURy1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 13:54:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:38456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230330AbhFURyY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 13:54:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2571F611C1;
        Mon, 21 Jun 2021 17:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624297930;
        bh=EKWFR62OC53Ool/73TihiUZRikghbx9/5caVVvFCek4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fWqCbK+4qSkJh6e5DrAzi/s6SKkLwgq+89HBcDLLhpkq55xGpCxZJR1ddtaVIgKNg
         Oj9yRnPA0hLpEw8zXYcUwnmTRNJBK98WQ48UM8+cuPwzsAuCzKZv1Pn9nVnUsCbjRn
         TkZrHhSuLHm79WD6MpMy1acXsqvHfn0bZp8QQiQERr7389gKqfEloTDUz0XGwcdb+q
         fZ7tkzN3ZNfsnQwYIvaE6plZ6Nal1vvb4XYhMXJiF3BVG2T3/+bi8AaR1oENSLx6N6
         mFl8v7Vr1g80eaDhFSh52uxRUopDYA+MIaWMHKYK/8UsipiXPwuBv3WyWihg9G7Txn
         dTdMudwf5YCyw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Du Cheng <ducheng2@gmail.com>,
        syzbot+105896fac213f26056f9@syzkaller.appspotmail.com,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 07/39] cfg80211: call cfg80211_leave_ocb when switching away from OCB
Date:   Mon, 21 Jun 2021 13:51:23 -0400
Message-Id: <20210621175156.735062-7-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210621175156.735062-1-sashal@kernel.org>
References: <20210621175156.735062-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Du Cheng <ducheng2@gmail.com>

[ Upstream commit a64b6a25dd9f984ed05fade603a00e2eae787d2f ]

If the userland switches back-and-forth between NL80211_IFTYPE_OCB and
NL80211_IFTYPE_ADHOC via send_msg(NL80211_CMD_SET_INTERFACE), there is a
chance where the cleanup cfg80211_leave_ocb() is not called. This leads
to initialization of in-use memory (e.g. init u.ibss while in-use by
u.ocb) due to a shared struct/union within ieee80211_sub_if_data:

struct ieee80211_sub_if_data {
    ...
    union {
        struct ieee80211_if_ap ap;
        struct ieee80211_if_vlan vlan;
        struct ieee80211_if_managed mgd;
        struct ieee80211_if_ibss ibss; // <- shares address
        struct ieee80211_if_mesh mesh;
        struct ieee80211_if_ocb ocb; // <- shares address
        struct ieee80211_if_mntr mntr;
        struct ieee80211_if_nan nan;
    } u;
    ...
}

Therefore add handling of otype == NL80211_IFTYPE_OCB, during
cfg80211_change_iface() to perform cleanup when leaving OCB mode.

link to syzkaller bug:
https://syzkaller.appspot.com/bug?id=0612dbfa595bf4b9b680ff7b4948257b8e3732d5

Reported-by: syzbot+105896fac213f26056f9@syzkaller.appspotmail.com
Signed-off-by: Du Cheng <ducheng2@gmail.com>
Link: https://lore.kernel.org/r/20210428063941.105161-1-ducheng2@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/util.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/wireless/util.c b/net/wireless/util.c
index f342b6147675..726e7d2342bd 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1059,6 +1059,9 @@ int cfg80211_change_iface(struct cfg80211_registered_device *rdev,
 		case NL80211_IFTYPE_MESH_POINT:
 			/* mesh should be handled? */
 			break;
+		case NL80211_IFTYPE_OCB:
+			cfg80211_leave_ocb(rdev, dev);
+			break;
 		default:
 			break;
 		}
-- 
2.30.2

