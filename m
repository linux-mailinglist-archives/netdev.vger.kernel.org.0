Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 345A4163259
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 21:10:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727213AbgBRT56 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 14:57:58 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:35893 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728069AbgBRT5z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 14:57:55 -0500
Received: by mail-pg1-f196.google.com with SMTP id d9so11474644pgu.3;
        Tue, 18 Feb 2020 11:57:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=93cUwvRz5DcbF2nQaz+gagk6IvPBCJp98CU5NTDjQMY=;
        b=UQ+9pXbDMmbdwA6F96Qv1VTxfWIz+JpDgMRfBgEwsI2/DxQA8d1YYv3LhqeSWvFyG3
         KySMupXsPLTKR8WIfSgIj374RP/tpNY6rn9kI85B2bdUZKNIAI4bBtweOJJkv+UufbfL
         OsHJC1WfHbmkTo4aTz0APkZDFAdFavuyyZd6ZXl1OwPo93zeo/bz8FthImtkeCMnvSFS
         vLhtX0zbw3wAuwNmOtJU6nw6SWTGmqPVqAubM0XpVuoS5kogsoQOXzF6YzD7MGj+PfLU
         FaP2WqUchlHEnqt0TtGb4plEPa9QcyJBK/mJcXAwrN+vzxkqCENzHeZu0Lh3Yb+lIkhs
         cIYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=93cUwvRz5DcbF2nQaz+gagk6IvPBCJp98CU5NTDjQMY=;
        b=cYlMuMhrcfgSz2BGEQzzP4rIBh/JWzSMJWAFl2NOwz5cFro5p8S9qevRLJkz4RCloF
         fNkvN+BH2TlZZXNlE6eluVKuhT+9TOflH9vBzMs/4tJi5z1x/ZxAPRuFH0r1SrUzptSu
         DPx04XDFfW2bP2m6TXditXD9K4JbOf+oW3pfNdMweybhWXwyh9rRdoSI1Ki1MO2TpRgd
         mMZSlgpzF0NoxjAq0Ex3qvcIIkE2DYg00MwGFxQb/3JN3KEwWa8Gk5niJDuW14zD9QZ9
         5XYxqLzwWxIPdrzRusJmAdY8kA2tFV4NVPsynM3vGKBzmtVecSFj3/EB44yYtvE8hnKR
         TgOw==
X-Gm-Message-State: APjAAAXcKQwQP8a4ZfLFuQbaTJFZA17la3xeGg/oQycnPzo+BT2V/pGC
        Y1JXOcZ/hFw6r3KmLtplaQ==
X-Google-Smtp-Source: APXvYqzmmai+702KiOlcfbcc3ZFX7jmIWdGXi8fVhYaR8Nc3GJgeHndI1Pldb3SlGbLRf31qGdaxsA==
X-Received: by 2002:a63:4525:: with SMTP id s37mr24073227pga.418.1582055875098;
        Tue, 18 Feb 2020 11:57:55 -0800 (PST)
Received: from madhuparna-HP-Notebook.nitk.ac.in ([2402:3a80:1ee3:ff08:f869:e1e5:121e:cdbf])
        by smtp.gmail.com with ESMTPSA id d4sm4038413pjz.12.2020.02.18.11.57.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Feb 2020 11:57:54 -0800 (PST)
From:   madhuparnabhowmik10@gmail.com
To:     pshelar@ovn.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org, dev@openvswitch.org,
        linux-kernel@vger.kernel.org, joel@joelfernandes.org,
        frextrite@gmail.com,
        linux-kernel-mentees@lists.linuxfoundation.org, paulmck@kernel.org,
        Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
Subject: [PATCH 2/4] vport.c: Use built-in RCU list checking
Date:   Wed, 19 Feb 2020 01:27:42 +0530
Message-Id: <20200218195742.2636-1-madhuparnabhowmik10@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>

hlist_for_each_entry_rcu() has built-in RCU and lock checking.

Pass cond argument to list_for_each_entry_rcu() to silence
false lockdep warning when CONFIG_PROVE_RCU_LIST is enabled
by default.

Signed-off-by: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
---
 net/openvswitch/vport.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/openvswitch/vport.c b/net/openvswitch/vport.c
index 5da9392b03d6..47febb4504f0 100644
--- a/net/openvswitch/vport.c
+++ b/net/openvswitch/vport.c
@@ -96,7 +96,8 @@ struct vport *ovs_vport_locate(const struct net *net, const char *name)
 	struct hlist_head *bucket = hash_bucket(net, name);
 	struct vport *vport;
 
-	hlist_for_each_entry_rcu(vport, bucket, hash_node)
+	hlist_for_each_entry_rcu(vport, bucket, hash_node,
+				lockdep_ovsl_is_held())
 		if (!strcmp(name, ovs_vport_name(vport)) &&
 		    net_eq(ovs_dp_get_net(vport->dp), net))
 			return vport;
-- 
2.17.1

