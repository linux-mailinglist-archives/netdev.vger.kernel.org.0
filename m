Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B32AA5C18
	for <lists+netdev@lfdr.de>; Mon,  2 Sep 2019 20:10:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726771AbfIBSKI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Sep 2019 14:10:08 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:53750 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726506AbfIBSKH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Sep 2019 14:10:07 -0400
Received: by mail-wm1-f65.google.com with SMTP id q19so6665373wmc.3
        for <netdev@vger.kernel.org>; Mon, 02 Sep 2019 11:10:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LKt2qX2lKxAy9En6DM3x9jZuRetXtcW/fLf4cxZ+m0I=;
        b=s3Xvh2TYWWPm2cjAKDbtrMm81XMIqgwVaj3C5LDL9Yj7aiV/O5BmhP1qXQS0+c7fn2
         EHCRoLqYs8heYv7ShErBmEP2YqWGzl+ak2PFlqQ6yzKBvzCrAaXrgGFlng/EzVeOdpUQ
         nqvyW1nrqshLe6j+QLhiTjivCF8zfidb1x6v6sKj/T51VZr11DFX9SG+Cex+7PVx4QH0
         9AnGHqYw28JbE2vpTkytOzSIOteooJOjkvTkcUFPWy/vuGfrwowglEqQj3KDnPZnstrl
         9qQjVXA2OfnZMyxNfZbrw4xcgFABfMfU7+/7eMcS7OB3eVPWpvk24rDl09Hdel5WciXv
         Bfsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=LKt2qX2lKxAy9En6DM3x9jZuRetXtcW/fLf4cxZ+m0I=;
        b=kbxWHqlKlwL7/TFmdAxlGQ36uxjfmGDU1zSj07pPFkOUqHCIOWEKU+RBSDlJ7HXvHs
         xVas3LZH6km/UofjusgexkZDUVDn5ACX+6zYP4nbLCjr0BkObJYDFmCvrwOiLTzvASUz
         UeY2tPFVXFlckepdMdI1k/khmfoQj7JIDxIqMjR868dLJNmISQKL37D7/K4CLsHTRcrl
         +0yeSjFzeXeaaVBnUVQpbTEbxqzny6r53Snt+m4ISYCG1Ufu6CchpfNDjntPygXviQbc
         bGvwtehzKjHz9f2VPYHjSM0ZUdHSn27M7vRYIV+XxJe+ZZZ/AmZN5vR+bJZ78lDbdLnF
         KnMQ==
X-Gm-Message-State: APjAAAW4YMZIgLcc3iDSS7NyiRraEZTeg8RjydxLkAg2qYdu1RUxGuqp
        XAud4YVYtmcWzyn1jbzmVv2XKPhsri0=
X-Google-Smtp-Source: APXvYqwrV23Bi4Ch878f+eBoMbe3UBq01ZiJL3ljHtG/W8X86YtwkSbiB6JYjCxleFimcOO/1QE4NA==
X-Received: by 2002:a1c:a713:: with SMTP id q19mr1275068wme.127.1567447804785;
        Mon, 02 Sep 2019 11:10:04 -0700 (PDT)
Received: from tycho.fritz.box (ipbcc09208.dynamic.kabel-deutschland.de. [188.192.146.8])
        by smtp.gmail.com with ESMTPSA id o9sm6628050wrh.46.2019.09.02.11.10.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Sep 2019 11:10:04 -0700 (PDT)
From:   Zahari Doychev <zahari.doychev@linux.com>
To:     netdev@vger.kernel.org
Cc:     bridge@lists.linux-foundation.org, nikolay@cumulusnetworks.com,
        roopa@cumulusnetworks.com, jhs@mojatatu.com, dsahern@gmail.com,
        simon.horman@netronome.com, makita.toshiaki@lab.ntt.co.jp,
        xiyou.wangcong@gmail.com, jiri@resnulli.us,
        alexei.starovoitov@gmail.com, johannes@sipsolutions.net,
        Zahari Doychev <zahari.doychev@linux.com>
Subject: [PATCH v3 1/2] net: bridge: use mac_len in bridge forwarding
Date:   Mon,  2 Sep 2019 20:09:59 +0200
Message-Id: <20190902181000.25638-1-zahari.doychev@linux.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The bridge code cannot forward packets from various paths that set up the
SKBs in different ways. Some of these packets get corrupted during the
forwarding as not always is just ETH_HLEN pulled at the front.

This happens e.g. when VLAN tags are pushed by using tc act_vlan on
ingress. Example configuration is provided below. The test setup consists
of two netdevs connected to external hosts. There is act_vlan on one of
them adding two vlan tags on ingress and removing the tags on egress.
The configuration is done using the following commands:

ip link add name br0 type bridge vlan_filtering 1
ip link set dev br0 up

ip link set dev net0 up
ip link set dev net0 master br0

ip link set dev net1 up
ip link set dev net1 master br0

bridge vlan add dev net0 vid 100 master
bridge vlan add dev br0 vid 100 self
bridge vlan add dev net1 vid 100 master

tc qdisc add dev net0 handle ffff: clsact
tc qdisc add dev net1 handle ffff: clsact

tc filter add dev net0 ingress pref 1 protocol all flower \
		  action vlan push id 10 pipe action vlan push id 100

tc filter add dev net0 egress pref 1 protocol 802.1q flower \
		  vlan_id 100 vlan_ethtype 802.1q cvlan_id 10 \
		  action vlan pop pipe action vlan pop

When using the setup above the packets coming on net0 get double tagged but
the MAC headers gets corrupted when the packets go out of net1.
The skb->data is pushed only by the ETH_HLEN length instead of mac_len in
br_dev_queue_push_xmit. This later causes the function validate_xmit_vlan
to insert the outer vlan tag behind the inner vlan tag as the skb->data
does not point to the start of packet.

The problem is fixed by using skb->mac_len instead of ETH_HLEN, which makes
sure that the skb headers are correctly restored. This usually does not
change anything, execpt the local bridge transmits which now need to set
the skb->mac_len correctly in br_dev_xmit, as well as the broken case noted
above.

Signed-off-by: Zahari Doychev <zahari.doychev@linux.com>

---
v2->v3:
 - move cover letter description to commit message
---
 net/bridge/br_device.c  | 3 ++-
 net/bridge/br_forward.c | 4 ++--
 net/bridge/br_vlan.c    | 3 ++-
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
index 681b72862c16..aeb77ff60311 100644
--- a/net/bridge/br_device.c
+++ b/net/bridge/br_device.c
@@ -55,8 +55,9 @@ netdev_tx_t br_dev_xmit(struct sk_buff *skb, struct net_device *dev)
 	BR_INPUT_SKB_CB(skb)->frag_max_size = 0;
 
 	skb_reset_mac_header(skb);
+	skb_reset_mac_len(skb);
 	eth = eth_hdr(skb);
-	skb_pull(skb, ETH_HLEN);
+	skb_pull(skb, skb->mac_len);
 
 	if (!br_allowed_ingress(br, br_vlan_group_rcu(br), skb, &vid))
 		goto out;
diff --git a/net/bridge/br_forward.c b/net/bridge/br_forward.c
index 86637000f275..edb4f3533f05 100644
--- a/net/bridge/br_forward.c
+++ b/net/bridge/br_forward.c
@@ -32,7 +32,7 @@ static inline int should_deliver(const struct net_bridge_port *p,
 
 int br_dev_queue_push_xmit(struct net *net, struct sock *sk, struct sk_buff *skb)
 {
-	skb_push(skb, ETH_HLEN);
+	skb_push(skb, skb->mac_len);
 	if (!is_skb_forwardable(skb->dev, skb))
 		goto drop;
 
@@ -94,7 +94,7 @@ static void __br_forward(const struct net_bridge_port *to,
 		net = dev_net(indev);
 	} else {
 		if (unlikely(netpoll_tx_running(to->br->dev))) {
-			skb_push(skb, ETH_HLEN);
+			skb_push(skb, skb->mac_len);
 			if (!is_skb_forwardable(skb->dev, skb))
 				kfree_skb(skb);
 			else
diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index bb98984cd27d..419067b314d7 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -466,13 +466,14 @@ static bool __allowed_ingress(const struct net_bridge *br,
 		/* Tagged frame */
 		if (skb->vlan_proto != br->vlan_proto) {
 			/* Protocol-mismatch, empty out vlan_tci for new tag */
-			skb_push(skb, ETH_HLEN);
+			skb_push(skb, skb->mac_len);
 			skb = vlan_insert_tag_set_proto(skb, skb->vlan_proto,
 							skb_vlan_tag_get(skb));
 			if (unlikely(!skb))
 				return false;
 
 			skb_pull(skb, ETH_HLEN);
+			skb_reset_network_header(skb);
 			skb_reset_mac_len(skb);
 			*vid = 0;
 			tagged = false;
-- 
2.22.0

