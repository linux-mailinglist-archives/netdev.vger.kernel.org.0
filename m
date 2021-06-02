Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E7EE39841D
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 10:29:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232627AbhFBIak (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 04:30:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232583AbhFBIa3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 04:30:29 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B403EC061756;
        Wed,  2 Jun 2021 01:28:46 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1loMF2-000xxd-R9; Wed, 02 Jun 2021 10:28:44 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     m.chetan.kumar@intel.com, loic.poulain@linaro.org,
        Johannes Berg <johannes.berg@intel.com>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>
Subject: [RFC v2 3/5] rtnetlink: add IFLA_PARENT_DEV_NAME
Date:   Wed,  2 Jun 2021 10:28:38 +0200
Message-Id: <20210602102653.9d5c4789824f.Ia98e333bba58bc6a0b1c8fa28ad0964fb9c918d6@changeid>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210602082840.85828-1-johannes@sipsolutions.net>
References: <20210602082840.85828-1-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

In some cases, for example in the upcoming WWAN framework
changes, there's no natural "parent netdev", so sometimes
dummy netdevs are created or similar. IFLA_PARENT_DEV_NAME
is a new attribute intended to contain a device (sysfs,
struct device) name that can be used instead when creating
a new netdev, if the rtnetlink family implements it.

Suggested-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
v2:
 * new patch
---
 include/uapi/linux/if_link.h | 6 ++++++
 net/core/rtnetlink.c         | 1 +
 2 files changed, 7 insertions(+)

diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index f7c3beebb074..3455780193a4 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -341,6 +341,12 @@ enum {
 	IFLA_ALT_IFNAME, /* Alternative ifname */
 	IFLA_PERM_ADDRESS,
 	IFLA_PROTO_DOWN_REASON,
+
+	/* device (sysfs) name as parent, used instead
+	 * of IFLA_LINK where there's no parent netdev
+	 */
+	IFLA_PARENT_DEV_NAME,
+
 	__IFLA_MAX
 };
 
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 4975dd91407d..49a27bf6e4a7 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1878,6 +1878,7 @@ static const struct nla_policy ifla_policy[IFLA_MAX+1] = {
 	[IFLA_PERM_ADDRESS]	= { .type = NLA_REJECT },
 	[IFLA_PROTO_DOWN_REASON] = { .type = NLA_NESTED },
 	[IFLA_NEW_IFINDEX]	= NLA_POLICY_MIN(NLA_S32, 1),
+	[IFLA_PARENT_DEV_NAME]	= { .type = NLA_NUL_STRING },
 };
 
 static const struct nla_policy ifla_info_policy[IFLA_INFO_MAX+1] = {
-- 
2.31.1

