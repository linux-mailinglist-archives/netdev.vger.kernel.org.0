Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AE36DAA93
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 12:53:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392977AbfJQKw6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 06:52:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40884 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391322AbfJQKw6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Oct 2019 06:52:58 -0400
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com [209.85.208.198])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 963C2C057F31
        for <netdev@vger.kernel.org>; Thu, 17 Oct 2019 10:52:57 +0000 (UTC)
Received: by mail-lj1-f198.google.com with SMTP id w26so341995ljh.9
        for <netdev@vger.kernel.org>; Thu, 17 Oct 2019 03:52:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=o6NER1hwO3BbGG3lAcp42tgV3B1FMtCN6uX4o8Veflg=;
        b=s18xwuAYhTFEf4os2HhKo3W5Z9ZaDl67wj+O/1cfQM4H31Pe33fG+IMyVE7wEVGFm2
         ukFfaT3iMvRPfxitMdSxsgZjxGH0DaAkQbZidGDqisWrEu53/V8NXCzzAPDAksAO2Z0d
         YYdEuTOExsmTlK1cin0sfY1xm8vRgCFmFw5TJ7yWe+x2by2oIQ9zFNqpvv6kHaYR5/UL
         vVhGoCDlhmHICyrfmlqStfkc3nshcvdV9CNIc+2fjB3bIwS2glT0ZERFO2FQfF2qViGk
         ayUCEHFREbSv4q40ysgmtBJRC5MAErjYfoDbrLpn+d2QBDZlwQ9EQ0NqlZ7RAnwm15e/
         OqiA==
X-Gm-Message-State: APjAAAV9xvZHKTPwuukeZFzSavJhB9JzRsx+6PjOb2BNXHaMMx2stQpk
        YtqUQ/k5l6m6P7ZZUDo3v2VCIB70M+vZCoTRZYk5SWRLrsPlZHUzVD4zZ+CBpF3sNkJ6FnzT8un
        wcjvOrAlQXtyObARm
X-Received: by 2002:a2e:420a:: with SMTP id p10mr2158062lja.16.1571309575964;
        Thu, 17 Oct 2019 03:52:55 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyOvJTW8dENmDsFbHf0/UnRL2nZA9xwsveTcPXV7q45AcwIBMDKEkoPFXOzkc1hfiU97u5mqw==
X-Received: by 2002:a2e:420a:: with SMTP id p10mr2158041lja.16.1571309575790;
        Thu, 17 Oct 2019 03:52:55 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id l7sm831900lji.46.2019.10.17.03.52.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Oct 2019 03:52:55 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 781881804C9; Thu, 17 Oct 2019 12:52:54 +0200 (CEST)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     daniel@iogearbox.net, ast@fb.com
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        bpf@vger.kernel.org, netdev@vger.kernel.org, kafai@fb.com,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: [PATCH bpf v2] xdp: Handle device unregister for devmap_hash map type
Date:   Thu, 17 Oct 2019 12:52:32 +0200
Message-Id: <20191017105232.2806390-1-toke@redhat.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It seems I forgot to add handling of devmap_hash type maps to the device
unregister hook for devmaps. This omission causes devices to not be
properly released, which causes hangs.

Fix this by adding the missing handler.

Fixes: 6f9d451ab1a3 ("xdp: Add devmap_hash map type for looking up devices by hashed index")
Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
v2:
  - Grab the update lock while walking the map and removing entries.

 kernel/bpf/devmap.c | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index d27f3b60ff6d..a0a1153da5ae 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -719,6 +719,38 @@ const struct bpf_map_ops dev_map_hash_ops = {
 	.map_check_btf = map_check_no_btf,
 };
 
+static void dev_map_hash_remove_netdev(struct bpf_dtab *dtab,
+				       struct net_device *netdev)
+{
+	unsigned long flags;
+	int i;
+
+	spin_lock_irqsave(&dtab->index_lock, flags);
+	for (i = 0; i < dtab->n_buckets; i++) {
+		struct bpf_dtab_netdev *dev, *odev;
+		struct hlist_head *head;
+
+		head = dev_map_index_hash(dtab, i);
+		dev = hlist_entry_safe(rcu_dereference_raw(hlist_first_rcu(head)),
+				       struct bpf_dtab_netdev,
+				       index_hlist);
+
+		while (dev) {
+			odev = (netdev == dev->dev) ? dev : NULL;
+			dev = hlist_entry_safe(rcu_dereference_raw(hlist_next_rcu(&dev->index_hlist)),
+					       struct bpf_dtab_netdev,
+					       index_hlist);
+
+			if (odev) {
+				hlist_del_rcu(&odev->index_hlist);
+				call_rcu(&odev->rcu,
+					 __dev_map_entry_free);
+			}
+		}
+	}
+	spin_unlock_irqrestore(&dtab->index_lock, flags);
+}
+
 static int dev_map_notification(struct notifier_block *notifier,
 				ulong event, void *ptr)
 {
@@ -735,6 +767,11 @@ static int dev_map_notification(struct notifier_block *notifier,
 		 */
 		rcu_read_lock();
 		list_for_each_entry_rcu(dtab, &dev_map_list, list) {
+			if (dtab->map.map_type == BPF_MAP_TYPE_DEVMAP_HASH) {
+				dev_map_hash_remove_netdev(dtab, netdev);
+				continue;
+			}
+
 			for (i = 0; i < dtab->map.max_entries; i++) {
 				struct bpf_dtab_netdev *dev, *odev;
 
-- 
2.23.0

