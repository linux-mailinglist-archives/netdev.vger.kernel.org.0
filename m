Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B04991A30E0
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 10:29:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726706AbgDII3S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 04:29:18 -0400
Received: from mail-pj1-f68.google.com ([209.85.216.68]:38508 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726574AbgDII3S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Apr 2020 04:29:18 -0400
Received: by mail-pj1-f68.google.com with SMTP id t40so983874pjb.3;
        Thu, 09 Apr 2020 01:29:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=thmb2MaUkAYwWEknYChKiLfRBjC26khbulpjo27xBxY=;
        b=IP2q/UImPra//LmWIBAZ+IhOWsM8OCnVf+xQw5pG52z6SrmJwJZiaotOEUZ8mKGafH
         uzuNLilzjhYGUngIrdbMtEFbnAMI5dzle15sBBfWVQLPnlZn8ICMi0nGPtxcgryAU75K
         oJKLxnMkTlRRsSxqbN3DvJTcobEuHgJ240erVvAm5BiwUBXWPy11Z0O2woJ48cNcEcta
         NaACUYq+4l4lmMcNDkrNCL6HCUdEFSfdNktjmi67pZVW4zegjXoF9saAgQONuQ4suwk0
         4ZbpKYRFCQ1M0gznRBve4tjKLwuAN9ht2kvRhNe5qrERFD+o+R/VPYm+qFLnaDGPvmY9
         tZCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=thmb2MaUkAYwWEknYChKiLfRBjC26khbulpjo27xBxY=;
        b=UTgBrWQRfxSdDWfqFXl2F+hpmnZX9jkpgIwNnrmxsftIOjfk6mTdlK5XgXxvbF/96B
         XpFtXodhDxcctrpkoYrpfgY39AxUHDx45TAYd1A0WjDBcmo+JTdSdd8gsJZPMWG7H2rO
         tMqF/sFZdgr6rAIh9RVVNDqKupxJUc9M4PVMjCtljmOO3I8o7Gq3D9TRYgOhSpePu+p7
         E3GsWNDrwJp9W+k6OSrTs+BF+fr1cTSJDlo//nZg+IzlahaA0nT/LYAoEzCcUWQlIxlQ
         sJtsbZeltTGxKyDzhK0wWdFMfN3rAIMqUItrA61mTktBR/jk1pvBinIZIn/mTxwFYOLZ
         ok7A==
X-Gm-Message-State: AGi0PuasciH3m3o6jy5/I5Giw/SGUHY5aYgF7KRyWubixEZQfR5NeBnc
        2ZSR7mf/aZ4UJjJtTq3hXA==
X-Google-Smtp-Source: APiQypL1Nj1lCDjuCVFwMYpqxk0cEfBJHr8sL+RJosyfsPsRH8j2Im1XHq+VTTkIBFpCE2s7AqCWKQ==
X-Received: by 2002:a17:902:aa84:: with SMTP id d4mr11298193plr.158.1586420957884;
        Thu, 09 Apr 2020 01:29:17 -0700 (PDT)
Received: from localhost.localdomain ([2402:3a80:13be:8fdf:25a2:66e2:761f:9d4c])
        by smtp.gmail.com with ESMTPSA id o128sm18390653pfb.58.2020.04.09.01.29.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Apr 2020 01:29:17 -0700 (PDT)
From:   madhuparnabhowmik10@gmail.com
To:     johannes@sipsolutions.net, davem@davemloft.net, kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, frextrite@gmail.com,
        joel@joelfernandes.org, paulmck@kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
Subject: [PATCH 3/4] net: mac80211: sta_info.c: Add lockdep condition for RCU list usage
Date:   Thu,  9 Apr 2020 13:59:06 +0530
Message-Id: <20200409082906.27427-1-madhuparnabhowmik10@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>

The function sta_info_get_by_idx() uses RCU list primitive.
It is called with  local->sta_mtx held from mac80211/cfg.c.
Add lockdep expression to avoid any false positive RCU list warnings.

Signed-off-by: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
---
 net/mac80211/sta_info.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index f8d5c2515829..cd8487bc6fc2 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -231,7 +231,8 @@ struct sta_info *sta_info_get_by_idx(struct ieee80211_sub_if_data *sdata,
 	struct sta_info *sta;
 	int i = 0;
 
-	list_for_each_entry_rcu(sta, &local->sta_list, list) {
+	list_for_each_entry_rcu(sta, &local->sta_list, list,
+				lockdep_is_held(&local->sta_mtx)) {
 		if (sdata != sta->sdata)
 			continue;
 		if (i < idx) {
-- 
2.17.1

