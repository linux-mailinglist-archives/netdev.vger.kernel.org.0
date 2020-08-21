Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC1FC24E226
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 22:35:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726760AbgHUUe5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 16:34:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726750AbgHUUez (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 16:34:55 -0400
Received: from mail-qv1-xf41.google.com (mail-qv1-xf41.google.com [IPv6:2607:f8b0:4864:20::f41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35E70C061575
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 13:34:55 -0700 (PDT)
Received: by mail-qv1-xf41.google.com with SMTP id o2so1211603qvk.6
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 13:34:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:date:message-id:user-agent:mime-version
         :content-transfer-encoding;
        bh=gtYkus8ZVVc5pmWJLu8BIzUlBoq3dgwoix4MDLg9CP8=;
        b=NhZ9BlLwXuB+GFtl7cKffYH0zhfkWL/WSkQtfHgqgfDHRf5pL5PPk1dZVv9acUrgeW
         BE413GiRIotoOjZwD6VeTM2HLzyqxWxDKxIAtQkaPG4uNkREAmp+G9oV0IrcpXynP46t
         8VizZ4qQn2NbP0d1s9ez5FHu/QYS2HdRkGgc02r15zn3wkfjrFmqwdj1bF+QlZA8a1/g
         0NUV9wPeIseYV79MxRR5zEhMm0OWXCpUSMOkc+4wFZRxRaj1DA8gErM1GTC9wGkCssqw
         DnVAPGFkTNYZCxTSniValX1oejiDpHcKvomdCBMAJN6PZ1VNW+LdlMnnNI7c5pN3NesQ
         PJTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=gtYkus8ZVVc5pmWJLu8BIzUlBoq3dgwoix4MDLg9CP8=;
        b=bamHZpruapr0BJu5WbmT8Mk5sK5zcXdOrWR/5oc4ZUc78qkrt+HqHGO9mXdVeF+Fa+
         NWSkRFZArTjM8WRVx4ijFlXXbjLBnWTm5F3bB3uZBVtfCUjrcDPO3e+XHj0JMfPmX5sK
         QOP988ewvlDGdCuyE5jJUfSUUpe2WW+NC/C2hR4BdoRFlAr6ivqxwI3//tXQt/DLX06a
         UKBxFcy4fQ2xgF2ztaF/CqveKbQ96rjipF60ylOcBlfUw5l1sSh7+m0wDxM+XCbfN+oN
         OnOaEvnMpxv1Q9DrM6fKb6aLnPQPSNLscaW2m/KQWIFPEEOSnJpcPRlRV7VtnrI9d/MI
         RJYQ==
X-Gm-Message-State: AOAM533Zts9+UaRlbWFlE5aIJEXvrx4CanoCPDG3NPWS8GKUj8ppHxGo
        XoTCEXMhZYd3GEbDH7v326LnafRUKdDIF4w=
X-Google-Smtp-Source: ABdhPJz8j+1pCA53E3Grk45ESNsN0PVvN11X7njTJ3Ea12itZgwJb9nO1rLFL84r1uLmlvhcUWyxPw==
X-Received: by 2002:a05:6214:1108:: with SMTP id e8mr4020105qvs.237.1598042093697;
        Fri, 21 Aug 2020 13:34:53 -0700 (PDT)
Received: from localhost (pool-96-230-24-152.bstnma.fios.verizon.net. [96.230.24.152])
        by smtp.gmail.com with ESMTPSA id k1sm2675427qkf.12.2020.08.21.13.34.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2020 13:34:52 -0700 (PDT)
Subject: [net PATCH] netlabel: fix problems with mapping removal
From:   Paul Moore <paul@paul-moore.com>
To:     netdev@vger.kernel.org
Cc:     linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        Stephen Smalley <stephen.smalley.work@gmail.com>
Date:   Fri, 21 Aug 2020 16:34:52 -0400
Message-ID: <159804209207.16190.14955035148979265114.stgit@sifl>
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

Fixes: 63c416887437 ("netlabel: Add network address selectors to the NetLabel/LSM domain mapping")
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

