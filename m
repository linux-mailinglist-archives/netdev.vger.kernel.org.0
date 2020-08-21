Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D18F424C9A0
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 03:46:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726946AbgHUBqT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 21:46:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726868AbgHUBqR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 21:46:17 -0400
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB56BC061387
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 18:46:17 -0700 (PDT)
Received: by mail-qv1-xf42.google.com with SMTP id o2so91654qvk.6
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 18:46:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:date:message-id:user-agent:mime-version
         :content-transfer-encoding;
        bh=DyvLbCUvGL9bDmrWcO1tap29+Q0copNEphXJwMJfUmM=;
        b=ibItNJPCRFASoGaCEsVRuAr/AecET8unfSAvJnDmMSe1rXmkMQeMfzT+8WGlBig4bj
         BgNWcIXwlUVRAvDX+KjAjiFEd0ZdbeUX8PeItKDCnmCwJUgR5nzN4nE+QRdzaub5806n
         6OR+Wj/qZSu3GKUeKtMfy1gKp9j26muVNbfDFUbVq252YWn8g2RmKoyMArinM2jc6LT8
         EsxWAzXdzRdFrewjGmZAQ88KTREq7cLcIepBsMIp1FZhaYLfORocS4VTbyukA9FG38oV
         XjpdzSSHKQHoTbLMS2WvKeBtwE2onN8LPJb2t/2ATb+hcKLDBerpoixnQh6fM2Uwja/a
         L3Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=DyvLbCUvGL9bDmrWcO1tap29+Q0copNEphXJwMJfUmM=;
        b=kIYV6Y4Saqwlr2rdBsjhP/6XSQFu79O8+n8MtEasZYMICR2Oih3T8Tr5vvVOrLA3BF
         GdeWm4wYroYOH1oYKyf7BbafSu52h+X+/7QurliUb1PkvnQX66kNUQTU7JTxvDDLfGyR
         Z0HaRnBxhxDt+bFDcPlKFC8o5nSBwi0Yb2QIbIn04Xtm4eJThcwwE549EAtg5PwPq3cz
         TM6Ay/NHxjwKCl5Whdyye96Yq9MkJ8gFS89vBFKRT3/hq6agk3htNhf4qBFrs3v2Mpeh
         IM9bnw7UEEjnBGG/Qk5/pH/MJhs6b4hKo77kBUnNpOu/Bj+oaKAGw0navhj0tk60HmUA
         Ih7g==
X-Gm-Message-State: AOAM530ODbuzTa8iLV0Y7/Vpyu/9ycujVX7mubviydJ7L+Qz8e+I4kCd
        t3ylLFzWDdUOK8C0RiW6uksYz+Aw/aAJaX0=
X-Google-Smtp-Source: ABdhPJyOVPxphVgx4G2XqHy+bhOOLXovVWDzOOaG5IdOspzieM/eTDM67hCWvMvogMj9eP67TkLdmQ==
X-Received: by 2002:a0c:9cc4:: with SMTP id j4mr519547qvf.230.1597974375782;
        Thu, 20 Aug 2020 18:46:15 -0700 (PDT)
Received: from localhost (pool-96-230-24-152.bstnma.fios.verizon.net. [96.230.24.152])
        by smtp.gmail.com with ESMTPSA id d20sm311079qkl.36.2020.08.20.18.46.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Aug 2020 18:46:14 -0700 (PDT)
Subject: [net-next PATCH] netlabel: fix problems with mapping removal
From:   Paul Moore <paul@paul-moore.com>
To:     netdev@vger.kernel.org
Cc:     selinux@vger.kernel.org, linux-security-module@vger.kernel.org,
        Stephen Smalley <stephen.smalley.work@gmail.com>
Date:   Thu, 20 Aug 2020 21:46:14 -0400
Message-ID: <159797437409.20181.15427109610194880479.stgit@sifl>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch fixes two main problems seen when removing NetLabel
mappings: memory leaks and potentially extra audit noise.

The memory leaks are caused by not properly free'ing the mapping's
address selector struct when free'ing the entire entry as well as
not properly cleaning up a temporary mapping entry when adding new
address selectors to an existing entry.  This patch fixes both these
problems such that kmemleak reports no NetLabel associated leaks
after running the SELinux test suite.

The potentially extra audit noise was caused by the auditing code in
netlbl_domhsh_remove_entry() being called regardless of the entry's
validity.  If another thread had already marked the entry as invalid,
but not removed/free'd it from the list of mappings, then it was
possible that an additional mapping removal audit record would be
generated.  This patch fixes this by returning early from the removal
function when the entry was previously marked invalid.  This change
also had the side benefit of improving the code by decreasing the
indentation level of large chunk of code by one (accounting for most
of the diffstat).

Reported-by: Stephen Smalley <stephen.smalley.work@gmail.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
---
 net/netlabel/netlabel_domainhash.c |   59 ++++++++++++++++++------------------
 1 file changed, 30 insertions(+), 29 deletions(-)

diff --git a/net/netlabel/netlabel_domainhash.c b/net/netlabel/netlabel_domainhash.c
index d07de2c0fbc7..f73a8382c275 100644
--- a/net/netlabel/netlabel_domainhash.c
+++ b/net/netlabel/netlabel_domainhash.c
@@ -85,6 +85,7 @@ static void netlbl_domhsh_free_entry(struct rcu_head *entry)
 			kfree(netlbl_domhsh_addr6_entry(iter6));
 		}
 #endif /* IPv6 */
+		kfree(ptr->def.addrsel);
 	}
 	kfree(ptr->domain);
 	kfree(ptr);
@@ -537,6 +538,8 @@ int netlbl_domhsh_add(struct netlbl_dom_map *entry,
 				goto add_return;
 		}
 #endif /* IPv6 */
+		/* cleanup the new entry since we've moved everything over */
+		netlbl_domhsh_free_entry(&entry->rcu);
 	} else
 		ret_val = -EINVAL;
 
@@ -580,6 +583,12 @@ int netlbl_domhsh_remove_entry(struct netlbl_dom_map *entry,
 {
 	int ret_val = 0;
 	struct audit_buffer *audit_buf;
+	struct netlbl_af4list *iter4;
+	struct netlbl_domaddr4_map *map4;
+#if IS_ENABLED(CONFIG_IPV6)
+	struct netlbl_af6list *iter6;
+	struct netlbl_domaddr6_map *map6;
+#endif /* IPv6 */
 
 	if (entry == NULL)
 		return -ENOENT;
@@ -597,6 +606,9 @@ int netlbl_domhsh_remove_entry(struct netlbl_dom_map *entry,
 		ret_val = -ENOENT;
 	spin_unlock(&netlbl_domhsh_lock);
 
+	if (ret_val)
+		return ret_val;
+
 	audit_buf = netlbl_audit_start_common(AUDIT_MAC_MAP_DEL, audit_info);
 	if (audit_buf != NULL) {
 		audit_log_format(audit_buf,
@@ -606,40 +618,29 @@ int netlbl_domhsh_remove_entry(struct netlbl_dom_map *entry,
 		audit_log_end(audit_buf);
 	}
 
-	if (ret_val == 0) {
-		struct netlbl_af4list *iter4;
-		struct netlbl_domaddr4_map *map4;
-#if IS_ENABLED(CONFIG_IPV6)
-		struct netlbl_af6list *iter6;
-		struct netlbl_domaddr6_map *map6;
-#endif /* IPv6 */
-
-		switch (entry->def.type) {
-		case NETLBL_NLTYPE_ADDRSELECT:
-			netlbl_af4list_foreach_rcu(iter4,
-					     &entry->def.addrsel->list4) {
-				map4 = netlbl_domhsh_addr4_entry(iter4);
-				cipso_v4_doi_putdef(map4->def.cipso);
-			}
+	switch (entry->def.type) {
+	case NETLBL_NLTYPE_ADDRSELECT:
+		netlbl_af4list_foreach_rcu(iter4, &entry->def.addrsel->list4) {
+			map4 = netlbl_domhsh_addr4_entry(iter4);
+			cipso_v4_doi_putdef(map4->def.cipso);
+		}
 #if IS_ENABLED(CONFIG_IPV6)
-			netlbl_af6list_foreach_rcu(iter6,
-					     &entry->def.addrsel->list6) {
-				map6 = netlbl_domhsh_addr6_entry(iter6);
-				calipso_doi_putdef(map6->def.calipso);
-			}
+		netlbl_af6list_foreach_rcu(iter6, &entry->def.addrsel->list6) {
+			map6 = netlbl_domhsh_addr6_entry(iter6);
+			calipso_doi_putdef(map6->def.calipso);
+		}
 #endif /* IPv6 */
-			break;
-		case NETLBL_NLTYPE_CIPSOV4:
-			cipso_v4_doi_putdef(entry->def.cipso);
-			break;
+		break;
+	case NETLBL_NLTYPE_CIPSOV4:
+		cipso_v4_doi_putdef(entry->def.cipso);
+		break;
 #if IS_ENABLED(CONFIG_IPV6)
-		case NETLBL_NLTYPE_CALIPSO:
-			calipso_doi_putdef(entry->def.calipso);
-			break;
+	case NETLBL_NLTYPE_CALIPSO:
+		calipso_doi_putdef(entry->def.calipso);
+		break;
 #endif /* IPv6 */
-		}
-		call_rcu(&entry->rcu, netlbl_domhsh_free_entry);
 	}
+	call_rcu(&entry->rcu, netlbl_domhsh_free_entry);
 
 	return ret_val;
 }

