Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 851AEB9776
	for <lists+netdev@lfdr.de>; Fri, 20 Sep 2019 20:59:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406631AbfITS7N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Sep 2019 14:59:13 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:43931 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406402AbfITS7N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Sep 2019 14:59:13 -0400
Received: by mail-ot1-f65.google.com with SMTP id b2so7041861otq.10;
        Fri, 20 Sep 2019 11:59:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id;
        bh=J4vx9PYCckXSIkTAbdPAoy6ZQMTL3tsqc04FyxnbD98=;
        b=NYbvempqSC6ct3jEQl32QlA0KvhKKkwMbnMwWmPFQOADK6qE/mClS572zIVdVzyS9x
         Ur+w5wjoIde9sdkeF0Apk/onxx/6dPfBqk5JgRer1eAJkfRsNoGtdmqJT45ag9hsUB4b
         +wOl4TuaLfkkIcDOjnepjrimn7RAWRY9QbOMD7WI1GG+wk5beMMOjmY2DCfKRMU9FG8T
         8ZSoMemThFgPSIEoNpHqGkxEd0YYeEtyyuWcbA8A9nX47yJXppN1LsGS/O93px5vbm5/
         q2fX4jFyzuNgCPCin//l4P8YtL9shptUQMU1FRHab6JXzh1zQqLkUNkV83Sno+9z0fiB
         oCow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=J4vx9PYCckXSIkTAbdPAoy6ZQMTL3tsqc04FyxnbD98=;
        b=HXWqi+0R3Jq2UFt/WeFWASZUOfyeGgFBcuTddYJoTeUJ0gpGjUr9GVOa4wW+SORtM6
         uV1ZVpZ+bLRh7dtriMGMMmE1roaJtWiFJ48/ldwqlq58axDJ30isiMTXi+zg8dg0sW7s
         C8F7A9/spQLE/YjQhIYgMoIl/5JO6tFgxKSms01IXv6d8rROixwPr3TM0z06U1gcdXJf
         m1BYzZXs1HYuz0WsSOd3GiyQqdoNabCQ4PgafFp6HRTG32z25m6BKvRKIgg6hPOfzcAi
         sR39z9b/6CPXCc4GNrfP4Qu2mAzdj43IP8oOXwqLjd+2R3FINGHXP4JCyy1fr7YxdUsM
         kmdg==
X-Gm-Message-State: APjAAAVr3UjWvuUf+Y1eziTF/W+89JoLNXpKNoR6sY+vG9LjA9vj31Nq
        MXkv0dt6v3igAkw4WaNUPas=
X-Google-Smtp-Source: APXvYqy60VomBZgY1DfqMYb6nHbpCnQzp3RdIplihOP3add6tpSTYndbFek5dxwpqRJVlAgygDu2SA==
X-Received: by 2002:a9d:4711:: with SMTP id a17mr7663392otf.90.1569005952199;
        Fri, 20 Sep 2019 11:59:12 -0700 (PDT)
Received: from localhost.localdomain (ip24-56-44-135.ph.ph.cox.net. [24.56.44.135])
        by smtp.gmail.com with ESMTPSA id i5sm843490otk.10.2019.09.20.11.59.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 20 Sep 2019 11:59:11 -0700 (PDT)
From:   Matthew Cover <werekraken@gmail.com>
X-Google-Original-From: Matthew Cover <matthew.cover@stackpath.com>
To:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        jasowang@redhat.com, edumazet@google.com, sdf@google.com,
        mst@redhat.com, matthew.cover@stackpath.com, mail@timurcelik.de,
        pabeni@redhat.com, nicolas.dichtel@6wind.com, wangli39@baidu.com,
        lifei.shirley@bytedance.com, tglx@linutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH net-next] tuntap: Fallback to automq on TUNSETSTEERINGEBPF prog negative return
Date:   Fri, 20 Sep 2019 11:58:43 -0700
Message-Id: <20190920185843.4096-1-matthew.cover@stackpath.com>
X-Mailer: git-send-email 2.15.2 (Apple Git-101.1)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Treat a negative return from a TUNSETSTEERINGEBPF bpf prog as a signal
to fallback to tun_automq_select_queue() for tx queue selection.

Compilation of this exact patch was tested.

For functional testing 3 additional printk()s were added.

Functional testing results (on 2 txq tap device):

  [Fri Sep 20 18:33:27 2019] ========== tun no prog ==========
  [Fri Sep 20 18:33:27 2019] tuntap: tun_ebpf_select_queue() returned '-1'
  [Fri Sep 20 18:33:27 2019] tuntap: tun_automq_select_queue() ran
  [Fri Sep 20 18:33:27 2019] ========== tun prog -1 ==========
  [Fri Sep 20 18:33:27 2019] tuntap: bpf_prog_run_clear_cb() returned '-1'
  [Fri Sep 20 18:33:27 2019] tuntap: tun_ebpf_select_queue() returned '-1'
  [Fri Sep 20 18:33:27 2019] tuntap: tun_automq_select_queue() ran
  [Fri Sep 20 18:33:27 2019] ========== tun prog 0 ==========
  [Fri Sep 20 18:33:27 2019] tuntap: bpf_prog_run_clear_cb() returned '0'
  [Fri Sep 20 18:33:27 2019] tuntap: tun_ebpf_select_queue() returned '0'
  [Fri Sep 20 18:33:27 2019] ========== tun prog 1 ==========
  [Fri Sep 20 18:33:27 2019] tuntap: bpf_prog_run_clear_cb() returned '1'
  [Fri Sep 20 18:33:27 2019] tuntap: tun_ebpf_select_queue() returned '1'
  [Fri Sep 20 18:33:27 2019] ========== tun prog 2 ==========
  [Fri Sep 20 18:33:27 2019] tuntap: bpf_prog_run_clear_cb() returned '2'
  [Fri Sep 20 18:33:27 2019] tuntap: tun_ebpf_select_queue() returned '0'

Signed-off-by: Matthew Cover <matthew.cover@stackpath.com>
---
 drivers/net/tun.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index aab0be4..173d159 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -583,35 +583,37 @@ static u16 tun_automq_select_queue(struct tun_struct *tun, struct sk_buff *skb)
 	return txq;
 }
 
-static u16 tun_ebpf_select_queue(struct tun_struct *tun, struct sk_buff *skb)
+static int tun_ebpf_select_queue(struct tun_struct *tun, struct sk_buff *skb)
 {
 	struct tun_prog *prog;
 	u32 numqueues;
-	u16 ret = 0;
+	int ret = -1;
 
 	numqueues = READ_ONCE(tun->numqueues);
 	if (!numqueues)
 		return 0;
 
+	rcu_read_lock();
 	prog = rcu_dereference(tun->steering_prog);
 	if (prog)
 		ret = bpf_prog_run_clear_cb(prog->prog, skb);
+	rcu_read_unlock();
 
-	return ret % numqueues;
+	if (ret >= 0)
+		ret %= numqueues;
+
+	return ret;
 }
 
 static u16 tun_select_queue(struct net_device *dev, struct sk_buff *skb,
 			    struct net_device *sb_dev)
 {
 	struct tun_struct *tun = netdev_priv(dev);
-	u16 ret;
+	int ret;
 
-	rcu_read_lock();
-	if (rcu_dereference(tun->steering_prog))
-		ret = tun_ebpf_select_queue(tun, skb);
-	else
+	ret = tun_ebpf_select_queue(tun, skb);
+	if (ret < 0)
 		ret = tun_automq_select_queue(tun, skb);
-	rcu_read_unlock();
 
 	return ret;
 }
-- 
1.8.3.1

