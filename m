Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0E69339395
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 17:38:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232675AbhCLQhx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 11:37:53 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:38996 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232283AbhCLQh2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 11:37:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615567047;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=FnVUzFvzsl3Bp0QFRDBlIHeV43tl8slTgFSG/RNrL70=;
        b=NGaY7GgPaYyHMDgiCO+jFe+7BkYPJjVJ0EI2VWUJ7SZqVBiljmQk8M/DgmMr1wOMeH3GSI
        5hFi3fTN+dsjLfV8dzDRRZ7m+A7hQuhPyCKWlplMiHHaYg/g2MwWduvxU7jVXeROYLmXM2
        mQIiGWECdd0bYtwsnhXa2+mUfjSA+04=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-540-kF_I14VGMT-R9-CJQ8RLzQ-1; Fri, 12 Mar 2021 11:37:23 -0500
X-MC-Unique: kF_I14VGMT-R9-CJQ8RLzQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4FF9E192D786;
        Fri, 12 Mar 2021 16:37:22 +0000 (UTC)
Received: from f33vm.wilsonet.com.wilsonet.com (dhcp-17-185.bos.redhat.com [10.18.17.185])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 077E8610A8;
        Fri, 12 Mar 2021 16:37:15 +0000 (UTC)
From:   Jarod Wilson <jarod@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Jarod Wilson <jarod@redhat.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net] wireless/nl80211: fix wdev_id may be used uninitialized
Date:   Fri, 12 Mar 2021 11:36:51 -0500
Message-Id: <20210312163651.1398207-1-jarod@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Build currently fails with -Werror=maybe-uninitialized set:

net/wireless/nl80211.c: In function '__cfg80211_wdev_from_attrs':
net/wireless/nl80211.c:124:44: error: 'wdev_id' may be used
uninitialized in this function [-Werror=maybe-uninitialized]

Easy fix is to just initialize wdev_id to 0, since it's value doesn't
otherwise matter unless have_wdev_id is true.

Fixes: a05829a7222e ("cfg80211: avoid holding the RTNL when calling the driver")
CC: Johannes Berg <johannes@sipsolutions.net>
CC: "David S. Miller" <davem@davemloft.net>
CC: Jakub Kicinski <kuba@kernel.org>
CC: linux-wireless@vger.kernel.org
CC: netdev@vger.kernel.org
Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 net/wireless/nl80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 521d36bb0803..a157783760c7 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -70,7 +70,7 @@ __cfg80211_wdev_from_attrs(struct cfg80211_registered_device *rdev,
 	struct wireless_dev *result = NULL;
 	bool have_ifidx = attrs[NL80211_ATTR_IFINDEX];
 	bool have_wdev_id = attrs[NL80211_ATTR_WDEV];
-	u64 wdev_id;
+	u64 wdev_id = 0;
 	int wiphy_idx = -1;
 	int ifidx = -1;
 
-- 
2.29.2

