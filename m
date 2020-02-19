Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D352164149
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 11:17:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726622AbgBSKRF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 05:17:05 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:46409 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726210AbgBSKRF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 05:17:05 -0500
Received: by mail-pg1-f193.google.com with SMTP id y30so855916pga.13;
        Wed, 19 Feb 2020 02:17:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wx3cl/ju+y18z95mSB4X4cdRQQ7rCw0DISRZpgvl858=;
        b=mN10sBd/GXiQoJR3Ywfsm0PgOHnA0dVmNF3IgQ8Ktyp7fHFx4uXm9z6AnSYjILHEIV
         BAZuo/Qzdzixq8W+e9q65H8A0nw4EeI4VW8DpBfebiI8ju0TWNS5j6aH+EUlou6AYQnO
         QowgF8dWYECxBSGNFRbDdqgiNPb4ggGYLCHRw6x4N1s+H7Y8VoinygwuqrYU9UI08Mkn
         1jdpPlct9uT3eS4Hyp281UiuPQ8R9RCNUENIsaUMvOdmPRsrzEPB6R3V2VvWEQzELr9T
         dXuxcP4YxroyUstNofwTQhh6Yk+wv4ttKWd+yjJf0swaUFO3aBClYJpFbl4F8ctGX/Bf
         ZVdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wx3cl/ju+y18z95mSB4X4cdRQQ7rCw0DISRZpgvl858=;
        b=R+uQYR//jDMLz6rW5FgeVsvM6NUNgcDU1EpL38UnDCrGyT/D/mBn06c4KF4ZTdsprJ
         Kko+OMVZ4muJ87CV7lV3o0RUR+ee7Gk3GsKD0JB+hIXLl048gr2bPJP8MiESSsFjtRgZ
         K1mxcE+BiEyS93bb45w8aSo/H+Yz6LT2LZt2HnDZM8iYAQbum2M/KZlXrUSRwoVPo1Ih
         7oGZONIKAtOcNJfo1vN+36f0vD8Hku3MQl619Db7KAdT96irQFsG+6Op68H0PCbr6z8C
         qYdY60HCpzuPaPoGAMhoFFVJvqw0+5rFv5Ya8OQUPOCuF2pM84vHPEx1QCkyz2I1i2uG
         H4YQ==
X-Gm-Message-State: APjAAAXECzoHvUUIDoqxUyOVTLYR9Of/LoL7ZoHSmkLDQkvmaMN45Ws/
        /6W1VdEw77kdUvivlwLkrKM=
X-Google-Smtp-Source: APXvYqy6NiIl+ebEVWdcRWivE8SiuoiFsCnaSaA8epCJyhv6rxlKttT+lXy/ebF12zJfvlcSy/d+Bw==
X-Received: by 2002:a63:6d0b:: with SMTP id i11mr26437592pgc.266.1582107424607;
        Wed, 19 Feb 2020 02:17:04 -0800 (PST)
Received: from localhost.localdomain ([146.196.37.220])
        by smtp.googlemail.com with ESMTPSA id a2sm2400885pfi.30.2020.02.19.02.16.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Feb 2020 02:17:04 -0800 (PST)
From:   Amol Grover <frextrite@gmail.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S . Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Joel Fernandes <joel@joelfernandes.org>,
        Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, Amol Grover <frextrite@gmail.com>
Subject: [PATCH] netfilter: ipt_CLUSTERIP: Pass lockdep expression to RCU lists
Date:   Wed, 19 Feb 2020 15:46:27 +0530
Message-Id: <20200219101626.31943-1-frextrite@gmail.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

cn->configs is traversed using list_for_each_entry_rcu
outside an RCU read-side critical section but under the protection
of cn->lock.

Hence, add corresponding lockdep expression to silence false-positive
warnings, and harden RCU lists.

Signed-off-by: Amol Grover <frextrite@gmail.com>
---
 net/ipv4/netfilter/ipt_CLUSTERIP.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
index 6bdb1ab8af61..df856ff835b7 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -139,7 +139,8 @@ __clusterip_config_find(struct net *net, __be32 clusterip)
 	struct clusterip_config *c;
 	struct clusterip_net *cn = clusterip_pernet(net);
 
-	list_for_each_entry_rcu(c, &cn->configs, list) {
+	list_for_each_entry_rcu(c, &cn->configs, list,
+				lockdep_is_held(&cn->lock)) {
 		if (c->clusterip == clusterip)
 			return c;
 	}
@@ -194,7 +195,8 @@ clusterip_netdev_event(struct notifier_block *this, unsigned long event,
 	struct clusterip_config *c;
 
 	spin_lock_bh(&cn->lock);
-	list_for_each_entry_rcu(c, &cn->configs, list) {
+	list_for_each_entry_rcu(c, &cn->configs, list,
+				lockdep_is_held(&cn->lock)) {
 		switch (event) {
 		case NETDEV_REGISTER:
 			if (!strcmp(dev->name, c->ifname)) {
-- 
2.24.1

