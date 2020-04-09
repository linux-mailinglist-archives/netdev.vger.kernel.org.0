Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0DF71A30E6
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 10:29:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726752AbgDII3g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 04:29:36 -0400
Received: from mail-pj1-f66.google.com ([209.85.216.66]:50689 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725987AbgDII3g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Apr 2020 04:29:36 -0400
Received: by mail-pj1-f66.google.com with SMTP id b7so1010658pju.0;
        Thu, 09 Apr 2020 01:29:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=F8gyLVop1Ch0gKbGVHgodmcnCvN85X6SPXoRalm/4uY=;
        b=UeBYraYaZuRxL0liXfpT3eVN66/M7EoV5rBCI8IzWjSmRtb+2fS8VCoKQMRNiiNNPI
         GQtwO3Bb29klU3jizxQRTERoAEXMyuzs1GZ8SHeaPbBLrD4BxH76imlRAO696yJeT/r2
         qBIrWD7A+ldxeRNDjELWGTGbyz2IHckScRapPjH+TRr2QELy92KzJehjWMqTb4aTYhtu
         6onqsCgA3u6/XIdsuxQIbr6F331I1soaJ+j5c4fo43C9LhUUj+dNReGxEjJfbh6LKXa4
         3cGcDbF00vMoIY6Givp1/PKfafreL5o5/vA6obHT0zDpScse921LkE8zqJb/dXCvp59B
         Osyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=F8gyLVop1Ch0gKbGVHgodmcnCvN85X6SPXoRalm/4uY=;
        b=k17Lh734EagITwH2O1h0HwNIvTKwyC4IDOPoItgtq6/LC3tKWetqM3mERr3kHBNUIP
         Lb6sNN0+wNJF80lOnTeRK/J+CGnZEMl4+TGgHNmcwzRFIzLmlnCqLHg1oYEady3e/muJ
         KFZxuXHqzSABSXB/j+3l1qxc/bMX3Xt3UuOd9/WPZ24wKeF0JrqcO3qwmnAGc/nfV7y4
         pIkNeshxTEFwUu73SPZDsxHm1/rRFZx2XnhXoiN0nJMH6+AuQ4ooWq2599wJT6Sx5RgF
         8V3utfuloprOuF3l0d3v19NJTqRacXcGzOC5Vb77b29ZVLoa3UKBFM562jT5b927Jmm6
         SJZQ==
X-Gm-Message-State: AGi0Pub/xSeM6tE5n8vNNK0pN5rASRyr29rNZi3qhlxog96WsdgUlItY
        rPDj40s8/4jshS5GAdnchw==
X-Google-Smtp-Source: APiQypJOJq7j0sm89Vt3qi8RrEHe8B14IxsT3T/FfEhZcmU+VsnMmS2Hw8QCmcgk7K/Ke/8ZAy4FBQ==
X-Received: by 2002:a17:90b:24f:: with SMTP id fz15mr9986110pjb.138.1586420975683;
        Thu, 09 Apr 2020 01:29:35 -0700 (PDT)
Received: from localhost.localdomain ([2402:3a80:13be:8fdf:25a2:66e2:761f:9d4c])
        by smtp.gmail.com with ESMTPSA id y19sm19170866pfe.9.2020.04.09.01.29.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Apr 2020 01:29:34 -0700 (PDT)
From:   madhuparnabhowmik10@gmail.com
To:     johannes@sipsolutions.net, davem@davemloft.net, kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, frextrite@gmail.com,
        joel@joelfernandes.org, paulmck@kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
Subject: [PATCH 4/4] net: mac80211: mlme.c: Add lockdep condition for RCU list usage
Date:   Thu,  9 Apr 2020 13:59:25 +0530
Message-Id: <20200409082925.27481-1-madhuparnabhowmik10@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>

ieee80211_add_vht_ie() is called with sdata->wdev.mtx held from
ieee80211_send_assoc(). Add lockdep condition to avoid false positive
warnings.

Signed-off-by: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
---
 net/mac80211/mlme.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 16d75da0996a..ef64b3e91ce6 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -590,7 +590,8 @@ static void ieee80211_add_vht_ie(struct ieee80211_sub_if_data *sdata,
 		bool disable_mu_mimo = false;
 		struct ieee80211_sub_if_data *other;
 
-		list_for_each_entry_rcu(other, &local->interfaces, list) {
+		list_for_each_entry_rcu(other, &local->interfaces, list,
+					lockdep_is_held(&sdata->wdev.mtx)) {
 			if (other->vif.mu_mimo_owner) {
 				disable_mu_mimo = true;
 				break;
-- 
2.17.1

