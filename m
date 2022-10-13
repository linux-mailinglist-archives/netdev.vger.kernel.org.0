Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 866CE5FDF2A
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 19:42:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbiJMRmC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 13:42:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229652AbiJMRmB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 13:42:01 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DE73DCAC4;
        Thu, 13 Oct 2022 10:41:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
        Resent-Message-ID:In-Reply-To:References;
        bh=x7b71pQCQ6gNjHRAB0+aKfImMlMvzVpRwtk+NdAmaEQ=; t=1665682919; x=1666892519; 
        b=Fxs/VEsGbdqPIF+AcWnoa/+3ZNMdhI/rxpxQfEwqcSQPq7j4TYPDcXgrbn8u77CNbORg2aReVWo
        qWwwUsANqSfHo4V4eAdodmlVy+2DaP4144scv+LdXsZL1A+wtBWY37GaYolWzHpkVxy0Hh/ofWfjt
        Eb22vnKTRxdAxZQb6fISPv0pDZAZVcbsf/A0NHVJdUI6qhTIoEdK13cUP/2rzadPwJmyBA2N3WYtJ
        0d9aJMK5fuQy3eGgUF3K54CPssOUi2Xaat4MLsifrYaq39yRQcoRxBbzRPguXTYAoOrv0+8dMrEj2
        7l4nGmh7sSCMZpOoZ1HzIXg6rnsW1XxCgDRw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1oj2DT-005luD-2c;
        Thu, 13 Oct 2022 19:41:55 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] wifi: cfg80211: silence a sparse RCU warning
Date:   Thu, 13 Oct 2022 19:41:51 +0200
Message-Id: <20221013194149.532913e897bd.I4e49ca6ce4248c0c4a9fa8c78e48ad91ab80c31c@changeid>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

All we're going to do with this pointer is assign it to
another __rcu pointer, but sparse can't see that, so
use rcu_access_pointer() to silence the warning here.

Fixes: c90b93b5b782 ("wifi: cfg80211: update hidden BSSes to avoid WARN_ON")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
Sending it now anyway, just in case you might want to
throw it into the tree before sending a PR to Linus.
---
 net/wireless/scan.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 806a5f1330ff..da752b0cc752 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -1674,7 +1674,9 @@ cfg80211_update_known_bss(struct cfg80211_registered_device *rdev,
 		if (old == rcu_access_pointer(known->pub.ies))
 			rcu_assign_pointer(known->pub.ies, new->pub.beacon_ies);
 
-		cfg80211_update_hidden_bsses(known, new->pub.beacon_ies, old);
+		cfg80211_update_hidden_bsses(known,
+					     rcu_access_pointer(new->pub.beacon_ies),
+					     old);
 
 		if (old)
 			kfree_rcu((struct cfg80211_bss_ies *)old, rcu_head);
-- 
2.37.3

