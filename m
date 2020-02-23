Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B46B169817
	for <lists+netdev@lfdr.de>; Sun, 23 Feb 2020 15:33:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727072AbgBWOdj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Feb 2020 09:33:39 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:37123 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726490AbgBWOdi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Feb 2020 09:33:38 -0500
Received: by mail-pg1-f195.google.com with SMTP id z12so3634809pgl.4;
        Sun, 23 Feb 2020 06:33:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=69Yk8P/qFbghht4lzUdI2eecmMcH8qqFHN3OCd/EKwg=;
        b=Tzd5nWYAGM+SEbceVpNuxrtzJNBo6OWJtbzTWSSb8B6JOQDE7q1k4sST0MYxVD2+xs
         2iK7yNmaAAJtAzhb1bgTlS1WZ4XjfBFpo3NlirNP4b0eRhFmiCw1NxM4QfbzBmSqlZJk
         Nb0HQa24AlWfm19Z0ZNXNxlXn4yHYtK0VCGI+gDXvCsvN25LlU0CiYt8OawGL8tWGWmT
         M7XkNiOBJMZ2MQ84PWQPVccL31kGSP1XWGwUHPD+wiVQt9FzCkCaujuYVdGiM3r4q0ea
         B9Ywz1Kd2d2Q1ub9oZJDGE2XXcwTXdv5KNtSN+iXmrFEYuY0VFFFLCQU6qGRlaoLSvgE
         4HAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=69Yk8P/qFbghht4lzUdI2eecmMcH8qqFHN3OCd/EKwg=;
        b=S/lSxKBKN4AdSf9gH1zgGt629mnIBGyf7fPu+tyFdPMLpuGLrDJcGz6xfsfyBKxO/L
         LS3FAzdQ2cpPh8jDBej+hyalI4K1/ZeZeX+qg895ptGu3giLS6q/9P95o9V0O2IAbLuD
         prm4PhQK5uUQvkUyApVlWyHgZZDHU4sfJQ4anMc7xXwKUHlwSHYyrm2kk104hMemgbZD
         2QUyfRxwe35HoE0Ax/nU8HGpIr4XUUMA62OuscdUk1ISttKtZaiJsBCleFV4Am26kLwT
         vxaJla8RTfSrNVJPE7pKq4s1sHOI9eufNq1/w30fMN1izwCZjz9dH7vjryvjuX9DWyUT
         7S6w==
X-Gm-Message-State: APjAAAXhRwX9Eta+EG26aCaXHqROEV5mIUImfwmb89NDiJ5cf4k9AJJM
        EdeXJ0FywbyR9x1lNXmIIg==
X-Google-Smtp-Source: APXvYqyuMpfNWCcshVyT4hEGm5SAscjVG1tHFK7wvKEg/Dned1vNx6tuY0HjyvEZJtwbMpUFvuJAVg==
X-Received: by 2002:a62:7945:: with SMTP id u66mr47940144pfc.82.1582468418248;
        Sun, 23 Feb 2020 06:33:38 -0800 (PST)
Received: from madhuparna-HP-Notebook.nitk.ac.in ([2402:3a80:1ee1:fa2c:caf:386d:b081:f71d])
        by smtp.gmail.com with ESMTPSA id y2sm9576879pff.139.2020.02.23.06.33.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Feb 2020 06:33:37 -0800 (PST)
From:   madhuparnabhowmik10@gmail.com
To:     johannes@sipsolutions.net, davem@davemloft.net
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, joel@joelfernandes.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        frextrite@gmail.com,
        Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
Subject: [PATCH] net: mac80211: rx.c: Avoid RCU list traversal under mutex
Date:   Sun, 23 Feb 2020 20:03:02 +0530
Message-Id: <20200223143302.15390-1-madhuparnabhowmik10@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>

local->sta_mtx is held in __ieee80211_check_fast_rx_iface().
No need to use list_for_each_entry_rcu() as it also requires
a cond argument to avoid false lockdep warnings when not used in
RCU read-side section (with CONFIG_PROVE_RCU_LIST).
Therefore use list_for_each_entry();

Signed-off-by: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
---
 net/mac80211/rx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 0e05ff037672..0ba98ad9bc85 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -4114,7 +4114,7 @@ void __ieee80211_check_fast_rx_iface(struct ieee80211_sub_if_data *sdata)
 
 	lockdep_assert_held(&local->sta_mtx);
 
-	list_for_each_entry_rcu(sta, &local->sta_list, list) {
+	list_for_each_entry(sta, &local->sta_list, list) {
 		if (sdata != sta->sdata &&
 		    (!sta->sdata->bss || sta->sdata->bss != sdata->bss))
 			continue;
-- 
2.17.1

