Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AF6117E5F0
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 18:44:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726115AbgCIRoy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 13:44:54 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:56134 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725904AbgCIRox (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 13:44:53 -0400
Received: by mail-wm1-f68.google.com with SMTP id 6so442915wmi.5
        for <netdev@vger.kernel.org>; Mon, 09 Mar 2020 10:44:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Bk3B15wUtiDLARdP73Erc3+882jZVxE5x6sxzBChR+U=;
        b=cmTIv7tekQb1JLluCtXKE8DF2+ql9jIPi2REpgNG6NWDqzM3kHfiALBGUFipuMqMOI
         n0e72lWgHhEqzDQdkOPt4lkOBNzsPmEMR6UICsuPs0fTnQJb6CXvdQTEJQgAEeyRJSEj
         Dtx8ihkxH1CrjfDZofm6X4O/Q2eIPkOKRbiNB9YMJzx8tyUo2zrXOrPLIJ5Hm6VBzQD8
         961htRtC37eLo4v5F0zKTpjsGtbrQ7Ss8fHhLUnX15nyc9Qes57l0qpk78dZmRJ375NX
         J/4e4IZNiu2+OmKCFiDgyw45MPW5A0sc0WK4tr9Y5WlYhMxqYS8iXtA0aqdVCtGHW0F9
         DLwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Bk3B15wUtiDLARdP73Erc3+882jZVxE5x6sxzBChR+U=;
        b=PogpcgGdlg8odw2q+FV5anhIZOkzeV4yqs/H6VsICPNF32QS091tTInHuHqap3c3C6
         Xcv9zSfTFlgdXebx551BMAu3XnMjl+2/2YRoW9QAAxyQVip0/6Efzux3ZAuc/bvY8edL
         9oCiQcoUasNNGipBKCxLTuO0ZtbqU9nVwPBOkOTm+lfyvw2LJo8AeiGY/Ik6rNIFAWvk
         VFLP6RKVLQnX18brqWszYOlykfcCLrJnwP5iBiYdH7omEBpjYiDL8MIW9bXI15sjMv8U
         jl9W/bM/LzxFNLPzmt3AXo1oDJ9jhroe2VgQKMLIC59iNGmcH/ji8V2IX/pgeo54wVak
         A7hQ==
X-Gm-Message-State: ANhLgQ0MF2CNYIJMtAAMXbbeS4yvmtU4pGfSY+GllvTpOhTvm/25A3nd
        ilMw3wkbK5yOvoUxIEys363jlB2hpJ8=
X-Google-Smtp-Source: ADFU+vua2yKRrpm3s5HODFDpyQDJYCYyRsAZXvdjp0FihHFCc31zZxUGcpBSWkqLpl9gMhmeoOVp3g==
X-Received: by 2002:a1c:6541:: with SMTP id z62mr385681wmb.21.1583775889541;
        Mon, 09 Mar 2020 10:44:49 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id f2sm2414686wrv.48.2020.03.09.10.44.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2020 10:44:48 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pablo@netfilter.org,
        ecree@solarflare.com, mlxsw@mellanox.com
Subject: [patch net-next] flow_offload: use flow_action_for_each in flow_action_mixed_hw_stats_types_check()
Date:   Mon,  9 Mar 2020 18:44:47 +0100
Message-Id: <20200309174447.6352-1-jiri@resnulli.us>
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
 include/net/flow_offload.h | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index 64807aa03cee..7b7bd9215156 100644
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
@@ -267,7 +272,7 @@ flow_action_mixed_hw_stats_types_check(const struct flow_action *action,
 	if (flow_offload_has_one_action(action))
 		return true;
 
-	for (i = 0; i < action->num_entries; i++) {
+	flow_action_for_each(i, action_entry, action) {
 		action_entry = &action->entries[i];
 		if (i && action_entry->hw_stats_type != last_hw_stats_type) {
 			NL_SET_ERR_MSG_MOD(extack, "Mixing HW stats types for actions is not supported");
@@ -316,9 +321,6 @@ flow_action_basic_hw_stats_types_check(const struct flow_action *action,
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

