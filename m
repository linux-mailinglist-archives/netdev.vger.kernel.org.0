Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2394817F49C
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 11:12:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726265AbgCJKMC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 06:12:02 -0400
Received: from mail-wm1-f45.google.com ([209.85.128.45]:52066 "EHLO
        mail-wm1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726199AbgCJKMB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 06:12:01 -0400
Received: by mail-wm1-f45.google.com with SMTP id a132so655078wme.1
        for <netdev@vger.kernel.org>; Tue, 10 Mar 2020 03:12:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pAfQ4UVd0+5VHSGW77/C5/h58FpuNIAJHdUMfrOs0hM=;
        b=fyaSNWROVwT6YVxexr1Uou1XnCooQkooR7twrhMriP7BDNEM0bhFTN3gzidr9Elrak
         4hmhsTWOJszISVFc0+7mfxHy+MnnemvzvSVEK44T4/dbGD6kOAJIsE92deLH544ES7pJ
         P0nHvmEiHPnuFEgArGZJJJMHgHxUt0I4tguo+7OW1pB12s6zBi06tAS4ks2BBKZOTorN
         92r6sRVuHXOkKZk24cQilOB1exv37bh3Xp6cFImUKyZ6FYbKrhECJVxlZDfhLB+Ab2IU
         2wrbyGv+6jbHE46rjPYohheZstDwCSl+Z5tBEcPp/yfbCS5fY6me6hObm5BJ3LH0coBD
         gtIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pAfQ4UVd0+5VHSGW77/C5/h58FpuNIAJHdUMfrOs0hM=;
        b=EBUionc3iVxMw1yWiwGj9rQABMcdSPu65Poeme8gkVqANkSGTPDVZGfgtVFGA+Ny2g
         aaB71Bzw9XBdfrIK26gK8LOWQ/aDKkdWn49eT6Req0iTMo65zMZUgWR17JPv/fHoYeG5
         fgvPtA3Yifjwd1vPrXV2wPhc1zo/92kwdOfUo2tLCW/YK/MbbRTOjNjbvJGZruyWyS9i
         Nmt0Mr6Ll6ODaqCzd3ZRZabPJeQUon6273HDf1qV1MWx4Q74XiLi79U6syNuQyXWLTWv
         znfg59aJU08v8IpVRE/Pra2NN1DGGiWsQlw5WTXlZgdJVgdhHKllfqhjo/w1lHlj1Edh
         Zxeg==
X-Gm-Message-State: ANhLgQ03uInQ7J+XtlClF9y3LYM4jeAHC1B7R9gYF60QVspga4dn0Pya
        K8Lp5v0sPEvV00TDqNAZwR/T2A5SvQc=
X-Google-Smtp-Source: ADFU+vso59wP2NRB4aN496pSOUl3ONDuww7rl/5ls7Sjx4I5gCC2imq70pH+0AgVt/BYhDXCh52AuQ==
X-Received: by 2002:a1c:7dc8:: with SMTP id y191mr1322437wmc.167.1583835119066;
        Tue, 10 Mar 2020 03:11:59 -0700 (PDT)
Received: from localhost (mail.chocen-mesto.cz. [85.163.43.2])
        by smtp.gmail.com with ESMTPSA id g129sm3665254wmg.12.2020.03.10.03.11.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2020 03:11:58 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pablo@netfilter.org,
        ecree@solarflare.com, mlxsw@mellanox.com
Subject: [patch net-next v2] flow_offload: use flow_action_for_each in flow_action_mixed_hw_stats_types_check()
Date:   Tue, 10 Mar 2020 11:11:57 +0100
Message-Id: <20200310101157.5567-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of manually iterating over entries, use flow_action_for_each
helper. Move the helper and wrap it to fit to 80 cols on the way.

Signed-off-by: Jiri Pirko <jiri@resnulli.us>
---
v1->v2:
- removed action_entry init in loop
---
 include/net/flow_offload.h | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index 64807aa03cee..891e15055708 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -256,6 +256,11 @@ static inline bool flow_offload_has_one_action(const struct flow_action *action)
 	return action->num_entries == 1;
 }
 
+#define flow_action_for_each(__i, __act, __actions)			\
+        for (__i = 0, __act = &(__actions)->entries[0];			\
+	     __i < (__actions)->num_entries;				\
+	     __act = &(__actions)->entries[++__i])
+
 static inline bool
 flow_action_mixed_hw_stats_types_check(const struct flow_action *action,
 				       struct netlink_ext_ack *extack)
@@ -267,8 +272,7 @@ flow_action_mixed_hw_stats_types_check(const struct flow_action *action,
 	if (flow_offload_has_one_action(action))
 		return true;
 
-	for (i = 0; i < action->num_entries; i++) {
-		action_entry = &action->entries[i];
+	flow_action_for_each(i, action_entry, action) {
 		if (i && action_entry->hw_stats_type != last_hw_stats_type) {
 			NL_SET_ERR_MSG_MOD(extack, "Mixing HW stats types for actions is not supported");
 			return false;
@@ -316,9 +320,6 @@ flow_action_basic_hw_stats_types_check(const struct flow_action *action,
 	return flow_action_hw_stats_types_check(action, extack, 0);
 }
 
-#define flow_action_for_each(__i, __act, __actions)			\
-        for (__i = 0, __act = &(__actions)->entries[0]; __i < (__actions)->num_entries; __act = &(__actions)->entries[++__i])
-
 struct flow_rule {
 	struct flow_match	match;
 	struct flow_action	action;
-- 
2.21.1

