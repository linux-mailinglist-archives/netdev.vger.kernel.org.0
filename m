Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60F8C16411F
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 11:01:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726652AbgBSKBf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 05:01:35 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:47093 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726450AbgBSKBf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 05:01:35 -0500
Received: by mail-pg1-f196.google.com with SMTP id y30so835430pga.13;
        Wed, 19 Feb 2020 02:01:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1EXylD9M9pyp6RCZrxC0U5DPcWHq62ndaaHnByK73qg=;
        b=h1LWdc/XtVhfk8KjtHhg4fU8weGskZPlQRBh5/dxOKJooTKO6sqSyQcabvn/E5pfPB
         qHxDiS5im9Rv2NXhglKKTBJTlmdcA0rbXMb047X51M63ZYkgcvE0TkwB8AjRTrc7NY56
         oMd4FQer5pztQ+WEc5OGCV7FqpisfkCYzn38geyLlsWd3JCFiZ0abJEuKkhqrEVSlEpd
         q8oxbcP8n7mp0YPGJwVfWvhylm2poJO0QdF06EbcTHUcgZ7PsxE9ZCrwPEDysmzvq5vt
         sfkfnoppF867VfHRaOASJ+AF7D5p1VcnWpGqyfHIAZkq+YQ3fu/HlP6yIXQ/IPet6sY2
         8Ftw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1EXylD9M9pyp6RCZrxC0U5DPcWHq62ndaaHnByK73qg=;
        b=Kb/aseEtxL/DiKoWClPtk829VR+v0+EJ7QSrG+7dR5u2OOXGyuhBzdAmtQdXrgIVE/
         LOiCqQzz2i5KtkvITmEaa6TYlMoZq4opNhr8pMn7nRu9klpexiv8j4pVIiItrNiGBnBM
         h96Tl987rafVAhJWoB0g/PXIyUuGu83kahb0HNJp7HmQwU/U5Fsq3N6Vt8LSVVYcM+N3
         VnWTASb/vKaivKq6qd1mv+wWNAO4aQ8peJ02tRCggdhJ5Ggex5iSQu5m50gLGn3EhQDE
         DulomWlEZuHRZyDHTAYR1jzFiwT8lCV4tV/MzknISECtA8DEjN3KYlosbYQkWJOab4Kf
         Kumg==
X-Gm-Message-State: APjAAAWFHkK8BrAFibsfejh/7OmcXSFyIaAwBPjSba6sgGFa6sCnAlUo
        DoZfGP4lSQb4br03nRfIyJY=
X-Google-Smtp-Source: APXvYqxUF3j/7VaJSopwF5M/zdTNKYwnecAFNAI6SMP/6B46CpsqGYOYKoKBjr2bnTQZ6Mht9Uj5Nw==
X-Received: by 2002:a62:ac03:: with SMTP id v3mr25792332pfe.17.1582106494797;
        Wed, 19 Feb 2020 02:01:34 -0800 (PST)
Received: from localhost.localdomain ([146.196.37.220])
        by smtp.googlemail.com with ESMTPSA id q17sm2040779pgn.94.2020.02.19.02.01.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Feb 2020 02:01:34 -0800 (PST)
From:   Amol Grover <frextrite@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Joel Fernandes <joel@joelfernandes.org>,
        Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Amol Grover <frextrite@gmail.com>
Subject: [PATCH RESEND] net: hsr: Pass lockdep expression to RCU lists
Date:   Wed, 19 Feb 2020 15:30:11 +0530
Message-Id: <20200219100010.23264-1-frextrite@gmail.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

node_db is traversed using list_for_each_entry_rcu
outside an RCU read-side critical section but under the protection
of hsr->list_lock.

Hence, add corresponding lockdep expression to silence false-positive
warnings, and harden RCU lists.

Signed-off-by: Amol Grover <frextrite@gmail.com>
---
Resend:
- Remove failed delivery recipients

 net/hsr/hsr_framereg.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/hsr/hsr_framereg.c b/net/hsr/hsr_framereg.c
index 27dc65d7de67..cc8fcfd3918d 100644
--- a/net/hsr/hsr_framereg.c
+++ b/net/hsr/hsr_framereg.c
@@ -156,7 +156,8 @@ static struct hsr_node *hsr_add_node(struct hsr_priv *hsr,
 		new_node->seq_out[i] = seq_out;
 
 	spin_lock_bh(&hsr->list_lock);
-	list_for_each_entry_rcu(node, node_db, mac_list) {
+	list_for_each_entry_rcu(node, node_db, mac_list,
+				lockdep_is_held(&hsr->list_lock)) {
 		if (ether_addr_equal(node->macaddress_A, addr))
 			goto out;
 		if (ether_addr_equal(node->macaddress_B, addr))
-- 
2.24.1

