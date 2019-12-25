Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DC2F12A6D5
	for <lists+netdev@lfdr.de>; Wed, 25 Dec 2019 09:51:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726289AbfLYIvS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Dec 2019 03:51:18 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:39070 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726025AbfLYIvS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Dec 2019 03:51:18 -0500
Received: by mail-wm1-f65.google.com with SMTP id 20so3994061wmj.4
        for <netdev@vger.kernel.org>; Wed, 25 Dec 2019 00:51:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=metanetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=09lvqk71kX2nSZPes3xfEklU5p2EQhZUgUY6AUmwaKk=;
        b=R+0201xBMON8gZ4ryjz7gnIKkSH7Kn3v3k0fk2iETClA2XAYV/4J425vXf9zk0+xpX
         X3xGYJ5W3bCeI+h/HQsGz9lUvIsOVoIUYI5fvXWwtqn7s6sLD0xNCNFwDltYKPjiHJt6
         38KEMLtqa5a+OlkxRaG7mFt4QtOeCHCpouWZ8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=09lvqk71kX2nSZPes3xfEklU5p2EQhZUgUY6AUmwaKk=;
        b=rHdWeXBmWwyHwkc7Jgkn86Y9+oCH6vrzYiG8el6pyE73e6URWXcTOcABJq/+KV3W3L
         lq7sO/8npITg3whCqSSQEM/inO5edoZLVL/1MiOqwlGa4BYJtsW+/KstfmGzZ9UPWhyd
         8flHW2SauG6z+vms0LqtuSq2uSr9Tce5cOdw9qZnL9LmUWGYBjJ1FvlVRnP+DA59ZV0Z
         1b9kbkmUFCnwQP6YKAMI53lffqKj4MM05W3DROy/VrvhR3b8S8Z+52U6Ny0u/VWALWDC
         0wLcyq/5Swrb5dr5LSlK8uKiXH1mUNoat7Angf0LNJIbDtS14StxMnnvpK/sAnA5JaRQ
         ooPw==
X-Gm-Message-State: APjAAAXUGinm5qw6QBTaDqzRNYzhJRVYVloQ3pW+sqcOnsXX3VSgMb1O
        Nxa8m781W94CyjxCC9kWDqMLIQ==
X-Google-Smtp-Source: APXvYqyrVWi+wmDx66Kk+2qzRppbbA6dOCOWP4l1pyhYRb9y4DDWzzYOBAEAuQ6LyGd5TiUqIsRVig==
X-Received: by 2002:a1c:e289:: with SMTP id z131mr7933658wmg.18.1577263876271;
        Wed, 25 Dec 2019 00:51:16 -0800 (PST)
Received: from localhost.localdomain ([141.226.11.88])
        by smtp.gmail.com with ESMTPSA id q15sm27916549wrr.11.2019.12.25.00.51.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Dec 2019 00:51:15 -0800 (PST)
From:   shmulik@metanetworks.com
X-Google-Original-From: sladkani@proofpoint.com
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        shmulik.ladkani@gmail.com,
        Shmulik Ladkani <sladkani@proofpoint.com>
Subject: [PATCH net] net/sched: act_mirred: Pull mac prior redir to non mac_header_xmit device
Date:   Wed, 25 Dec 2019 10:51:01 +0200
Message-Id: <20191225085101.19696-1-sladkani@proofpoint.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shmulik Ladkani <sladkani@proofpoint.com>

There's no skb_pull performed when a mirred action is set at egress of a
mac device, with a target device/action that expects skb->data to point
at the network header.

As a result, either the target device is errornously given an skb with
data pointing to the mac (egress case), or the net stack receives the
skb with data pointing to the mac (ingress case).

E.g:
 # tc qdisc add dev eth9 root handle 1: prio
 # tc filter add dev eth9 parent 1: prio 9 protocol ip handle 9 basic \
   action mirred egress redirect dev tun0

 (tun0 is a tun device. result: tun0 errornously gets the eth header
  instead of the iph)

Revise the push/pull logic of tcf_mirred_act() to not rely on the
skb_at_tc_ingress() vs tcf_mirred_act_wants_ingress() comparison, as it
does not cover all "pull" cases.

Instead, calculate whether the required action on the target device
requires the data to point at the network header, and compare this to
whether skb->data points to network header - and make the push/pull
adjustments as necessary.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Shmulik Ladkani <sladkani@proofpoint.com>
Tested-by: Jamal Hadi Salim <jhs@mojatatu.com>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
---
 net/sched/act_mirred.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/net/sched/act_mirred.c b/net/sched/act_mirred.c
index 1e3eb3a97532..1ad300e6dbc0 100644
--- a/net/sched/act_mirred.c
+++ b/net/sched/act_mirred.c
@@ -219,8 +219,10 @@ static int tcf_mirred_act(struct sk_buff *skb, const struct tc_action *a,
 	bool use_reinsert;
 	bool want_ingress;
 	bool is_redirect;
+	bool expects_nh;
 	int m_eaction;
 	int mac_len;
+	bool at_nh;
 
 	rec_level = __this_cpu_inc_return(mirred_rec_level);
 	if (unlikely(rec_level > MIRRED_RECURSION_LIMIT)) {
@@ -261,19 +263,19 @@ static int tcf_mirred_act(struct sk_buff *skb, const struct tc_action *a,
 			goto out;
 	}
 
-	/* If action's target direction differs than filter's direction,
-	 * and devices expect a mac header on xmit, then mac push/pull is
-	 * needed.
-	 */
 	want_ingress = tcf_mirred_act_wants_ingress(m_eaction);
-	if (skb_at_tc_ingress(skb) != want_ingress && m_mac_header_xmit) {
-		if (!skb_at_tc_ingress(skb)) {
-			/* caught at egress, act ingress: pull mac */
-			mac_len = skb_network_header(skb) - skb_mac_header(skb);
+
+	expects_nh = want_ingress || !m_mac_header_xmit;
+	at_nh = skb->data == skb_network_header(skb);
+	if (at_nh != expects_nh) {
+		mac_len = skb_at_tc_ingress(skb) ? skb->mac_len :
+			  skb_network_header(skb) - skb_mac_header(skb);
+		if (expects_nh) {
+			/* target device/action expect data at nh */
 			skb_pull_rcsum(skb2, mac_len);
 		} else {
-			/* caught at ingress, act egress: push mac */
-			skb_push_rcsum(skb2, skb->mac_len);
+			/* target device/action expect data at mac */
+			skb_push_rcsum(skb2, mac_len);
 		}
 	}
 
-- 
2.24.1

