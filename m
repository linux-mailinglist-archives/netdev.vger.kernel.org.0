Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C395838C803
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 15:28:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234393AbhEUN3g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 09:29:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:48267 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235021AbhEUN3e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 May 2021 09:29:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621603691;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=E3f8qlzbFBDKEGYYa2YZ9L5S9+3TxhT6OOSrMEDma1I=;
        b=TrDKS3aNS6KS7RxKdmoN7Fv8wB8VsMfpAl8IE7gVkBt/dMXcdgl0vxzsyIgF6EOulrphUm
        nFx1xjYoBugN21ezxVeSBJ3nS8AIzSud/S/Tkll5QjppRIwswf5oEw8JcUw0ExVzCsDwm0
        1fpiqUe/KOqiVb7Bt+WjvAEpVzINkyQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-74-K5CU7H3SMs6y7TIjWyPi4w-1; Fri, 21 May 2021 09:28:09 -0400
X-MC-Unique: K5CU7H3SMs6y7TIjWyPi4w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 85B4D801B16;
        Fri, 21 May 2021 13:28:08 +0000 (UTC)
Received: from f33vm.wilsonet.com.wilsonet.com (dhcp-17-185.bos.redhat.com [10.18.17.185])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E134210AFEB0;
        Fri, 21 May 2021 13:28:06 +0000 (UTC)
From:   Jarod Wilson <jarod@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Jarod Wilson <jarod@redhat.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Davis <tadavis@lbl.gov>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        netdev@vger.kernel.org
Subject: [PATCH net-next v2 1/4] bonding: add pure source-mac-based tx hashing option
Date:   Fri, 21 May 2021 09:27:53 -0400
Message-Id: <20210521132756.1811620-2-jarod@redhat.com>
In-Reply-To: <20210521132756.1811620-1-jarod@redhat.com>
References: <20210518210849.1673577-1-jarod@redhat.com>
 <20210521132756.1811620-1-jarod@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As it turns out, a pure source-mac only tx hash has a place for some VM
setups. The previously added vlan+srcmac hash doesn't work as well for a
VM with a single MAC and multiple vlans -- these types of setups path
traffic more efficiently if the load is split by source mac alone. Enable
this by way of an extra module parameter, rather than adding yet another
hashing method in the tx fast path.

Cc: Jay Vosburgh <j.vosburgh@gmail.com>
Cc: Veaceslav Falico <vfalico@gmail.com>
Cc: Andy Gospodarek <andy@greyhouse.net>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Thomas Davis <tadavis@lbl.gov>
Cc: Nikolay Aleksandrov <nikolay@nvidia.com>
Cc: netdev@vger.kernel.org
Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 Documentation/networking/bonding.rst | 13 +++++++++++++
 drivers/net/bonding/bond_main.c      | 18 ++++++++++++------
 2 files changed, 25 insertions(+), 6 deletions(-)

diff --git a/Documentation/networking/bonding.rst b/Documentation/networking/bonding.rst
index 62f2aab8eaec..767dbb49018b 100644
--- a/Documentation/networking/bonding.rst
+++ b/Documentation/networking/bonding.rst
@@ -707,6 +707,13 @@ mode
 		swapped with the new curr_active_slave that was
 		chosen.
 
+novlan_srcmac
+
+	When using the vlan+srcmac xmit_hash_policy, there may be cases where
+	omitting the vlan from the hash is beneficial. This can be done with
+	an extra module parameter here. The default value is 0 to include
+	vlan ID in the transmit hash.
+
 num_grat_arp,
 num_unsol_na
 
@@ -964,6 +971,12 @@ xmit_hash_policy
 
 		hash = (vlan ID) XOR (source MAC vendor) XOR (source MAC dev)
 
+		Optionally, if the module parameter novlan_srcmac=1 is set,
+		the vlan ID is omitted from the hash and only the source MAC
+		address is used, reducing the hash to
+
+		hash = (source MAC vendor) XOR (source MAC dev)
+
 	The default value is layer2.  This option was added in bonding
 	version 2.6.3.  In earlier versions of bonding, this parameter
 	does not exist, and the layer2 policy is the only policy.  The
diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 20bbda1b36e1..32785e9d0295 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -107,6 +107,7 @@ static char *lacp_rate;
 static int min_links;
 static char *ad_select;
 static char *xmit_hash_policy;
+static int novlan_srcmac;
 static int arp_interval;
 static char *arp_ip_target[BOND_MAX_ARP_TARGETS];
 static char *arp_validate;
@@ -168,6 +169,9 @@ MODULE_PARM_DESC(xmit_hash_policy, "balance-alb, balance-tlb, balance-xor, 802.3
 				   "0 for layer 2 (default), 1 for layer 3+4, "
 				   "2 for layer 2+3, 3 for encap layer 2+3, "
 				   "4 for encap layer 3+4, 5 for vlan+srcmac");
+module_param(novlan_srcmac, int, 0);
+MODULE_PARM_DESC(novlan_srcmac, "include vlan ID in vlan+srcmac xmit_hash_policy or not; "
+			      "0 to include it (default), 1 to exclude it");
 module_param(arp_interval, int, 0);
 MODULE_PARM_DESC(arp_interval, "arp interval in milliseconds");
 module_param_array(arp_ip_target, charp, NULL, 0);
@@ -3523,9 +3527,9 @@ static bool bond_flow_ip(struct sk_buff *skb, struct flow_keys *fk,
 
 static u32 bond_vlan_srcmac_hash(struct sk_buff *skb)
 {
-	struct ethhdr *mac_hdr = (struct ethhdr *)skb_mac_header(skb);
+	struct ethhdr *mac_hdr = eth_hdr(skb);
 	u32 srcmac_vendor = 0, srcmac_dev = 0;
-	u16 vlan;
+	u32 hash;
 	int i;
 
 	for (i = 0; i < 3; i++)
@@ -3534,12 +3538,14 @@ static u32 bond_vlan_srcmac_hash(struct sk_buff *skb)
 	for (i = 3; i < ETH_ALEN; i++)
 		srcmac_dev = (srcmac_dev << 8) | mac_hdr->h_source[i];
 
-	if (!skb_vlan_tag_present(skb))
-		return srcmac_vendor ^ srcmac_dev;
+	hash = srcmac_vendor ^ srcmac_dev;
+
+	if (novlan_srcmac || !skb_vlan_tag_present(skb))
+		return hash;
 
-	vlan = skb_vlan_tag_get(skb);
+	hash ^= skb_vlan_tag_get(skb);
 
-	return vlan ^ srcmac_vendor ^ srcmac_dev;
+	return hash;
 }
 
 /* Extract the appropriate headers based on bond's xmit policy */
-- 
2.30.2

