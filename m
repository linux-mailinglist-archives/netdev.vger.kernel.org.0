Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92EE43AF44C
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 20:06:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234387AbhFUSID (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 14:08:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:46804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234171AbhFUSEy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 14:04:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7D530613BA;
        Mon, 21 Jun 2021 17:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624298170;
        bh=NfLd0CxEmiWCnfSYGMlgS5GtNaM6EQLJ2hNcN4KTWP8=;
        h=From:To:Cc:Subject:Date:From;
        b=LxKASmyOYqzxwUY2RCJD5qM3L/ggKoED709oQpq50FRb1GCJ94lr1V0m/35AU2BZP
         8xhCGiQeJvAQ191igcb4ahOso7hjfSLsnCR2yOfiKtNXJePAKOSmUMulLseMo39vyd
         CdnMI/Z2f9IA0Z2Ysyvk3m64WDON5WL0BnE/fkMIAP/nGCKka00c1tA9m/K4d8EvkX
         xCplinhgV1avrLhVFmQFoMpjvaAUmMVUND4bKQhaQHLB2GkLHEdNbRT8GZIG32++00
         q6kTEAahk6Ja9ahSjmlS2rAYCQbNgcY1w48ZAGnh/wmP9kISi2/ImXCLzEadbyw+69
         zAL4ekcuB3f8Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Du Cheng <ducheng2@gmail.com>,
        syzbot+105896fac213f26056f9@syzkaller.appspotmail.com,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 1/9] cfg80211: call cfg80211_leave_ocb when switching away from OCB
Date:   Mon, 21 Jun 2021 13:55:59 -0400
Message-Id: <20210621175608.736581-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
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
index 915f1fa881e4..73c361fd4a16 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -978,6 +978,9 @@ int cfg80211_change_iface(struct cfg80211_registered_device *rdev,
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

