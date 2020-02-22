Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 870D2168E26
	for <lists+netdev@lfdr.de>; Sat, 22 Feb 2020 11:22:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727115AbgBVKVi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Feb 2020 05:21:38 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:44537 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726763AbgBVKVi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Feb 2020 05:21:38 -0500
Received: by mail-pf1-f196.google.com with SMTP id y5so2636994pfb.11;
        Sat, 22 Feb 2020 02:21:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=EvDiT7bfIhipTWPuk+o95uS98pfW7H0yCdQ9Sfbo/Ig=;
        b=E1/3ABOeJQH0wnuX05IolVmIzSvEmtPAQMAKISZRE2fJdP4fBRe0LzXpHBx0nbm2Yg
         lbQgRPmdPW2NVHfTSiMcq2H1nq9eZJCEm3LI6QpEmGESMe7eryC9V6t5CQEe+2qUExb6
         t4+djDOoQcjMF7AnYmD1vYKdIqS61aN0vSirk9KlUFq6vWvGAOX11edipD39TDR57tv9
         itNEOpo9JNzTejTF9m0WNGX3It/h0umtzpGcidkTTyq63GBC1N2cQgdl8QuAv+zpr2mn
         45ZsKYRnx9mGvpeqUnb2vIRZfhfLM5cw5ncI4t21CVsOvUgiUPMtLgTJM4yvANTIoKoo
         Dksw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=EvDiT7bfIhipTWPuk+o95uS98pfW7H0yCdQ9Sfbo/Ig=;
        b=KlTOl63PT+uwcAugbpn1D4VK65/OLIj5vH6oviUT+U6fLSIfbPXljaV+FJSKjgDc7j
         vsV0UY29hjx7I4NVO2uqe2MhrrMOojbPNbgNokiGaju/MZIdBbSgQErYp1Q6R9EHz4hI
         f9KhwQst1Onrez6Et74zbDLFVGwjH5PEOJ0NYbgGvgDflyBK3ceOXy5pDtpXwqz2mXcS
         mGoBo8MRMn1wkl8DUQ07mpRlMfHkZAr6tTwR+Mygm4GAq4/L2Ul/4CxDZNs/hnsemgxq
         QbxQAbGzSnd9YcJ/dQwtxZdwPlnqyRjjvQpM2S/gbsM2D5dYqnnvObVxqlYEWDQxXfcu
         HU0Q==
X-Gm-Message-State: APjAAAVGU4KtZBlEmdqNtqAcd2PsbvfXIz0bP44mLEGJMRUG+j+3SVTg
        CNOqJp5nZeF0FHQ97Ci2eg==
X-Google-Smtp-Source: APXvYqxkjfb1mnSYTDk9CIGFnAcTYxjBa2sZc0qY+qzvciaOoKV49y+B/rTlCXGag1kwqiL1Eb3YpA==
X-Received: by 2002:a63:d003:: with SMTP id z3mr41300183pgf.448.1582366897473;
        Sat, 22 Feb 2020 02:21:37 -0800 (PST)
Received: from madhuparna-HP-Notebook.nitk.ac.in ([112.79.49.48])
        by smtp.gmail.com with ESMTPSA id w6sm6237352pfq.99.2020.02.22.02.21.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Feb 2020 02:21:36 -0800 (PST)
From:   madhuparnabhowmik10@gmail.com
To:     johannes@sipsolutions.net, davem@davemloft.net
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, joel@joelfernandes.org,
        frextrite@gmail.com,
        linux-kernel-mentees@lists.linuxfoundation.org, paulmck@kernel.org,
        Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
Subject: [PATCH] net: mac80211: rx.c: Use built-in RCU list checking
Date:   Sat, 22 Feb 2020 15:48:31 +0530
Message-Id: <20200222101831.8001-1-madhuparnabhowmik10@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>

list_for_each_entry_rcu() has built-in RCU and lock checking.

Pass cond argument to list_for_each_entry_rcu() to silence
false lockdep warning when CONFIG_PROVE_RCU_LIST is enabled
by default.

Signed-off-by: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
---
 net/mac80211/rx.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 0e05ff037672..0967bdc75938 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -3547,7 +3547,8 @@ static void ieee80211_rx_cooked_monitor(struct ieee80211_rx_data *rx,
 	skb->pkt_type = PACKET_OTHERHOST;
 	skb->protocol = htons(ETH_P_802_2);
 
-	list_for_each_entry_rcu(sdata, &local->interfaces, list) {
+	list_for_each_entry_rcu(sdata, &local->interfaces, list,
+				lockdep_is_held(&rx->local->rx_path_lock)) {
 		if (!ieee80211_sdata_running(sdata))
 			continue;
 
@@ -4114,7 +4115,8 @@ void __ieee80211_check_fast_rx_iface(struct ieee80211_sub_if_data *sdata)
 
 	lockdep_assert_held(&local->sta_mtx);
 
-	list_for_each_entry_rcu(sta, &local->sta_list, list) {
+	list_for_each_entry_rcu(sta, &local->sta_list, list,
+				lockdep_is_held(&local->sta_mtx)) {
 		if (sdata != sta->sdata &&
 		    (!sta->sdata->bss || sta->sdata->bss != sdata->bss))
 			continue;
-- 
2.17.1

