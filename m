Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9A90D92BA
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 15:41:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389848AbfJPNlQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 09:41:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57820 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728234AbfJPNlQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Oct 2019 09:41:16 -0400
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com [209.85.167.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2ABD2C05686D
        for <netdev@vger.kernel.org>; Wed, 16 Oct 2019 13:41:15 +0000 (UTC)
Received: by mail-lf1-f70.google.com with SMTP id w4so4813131lfl.17
        for <netdev@vger.kernel.org>; Wed, 16 Oct 2019 06:41:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5/PWc4h2KyVD4/ITY1USp/LB2s4kx+If4TaEOrfoSTs=;
        b=sASzUpwDjgiT+HI7jOiltmQBVaUlDN40gfk1wp90Fu3zxhM6ib2BVaLD3U0AdvwllK
         7gNVxYQk60uuBN1zbHGbIs3ak80mLo8+66dEkkDCdsMAguyuhOCeEf3wvur0PgrGlDqu
         bhhl2EjAs6S/3CKqbWRHhFmQ7dzZKBZurQCUEaDR6MOvWbIGea8rhaDZBtF75wA8JU3F
         T7uPCbDhNLp5lZzCpIEQb80k/g16Yz9GFXH7hU5xWpSqCOhpDZwVz5+e2MqTqdDPLKwS
         xv/JjUd9wdrXrWO7vwIQnS0mf5XEkxYnkvpgXXFKUc2GRrxoM+9IL2a9A8G+i0qWmxP/
         xi0Q==
X-Gm-Message-State: APjAAAXAtgGPSAk2aEfw5VfZLST7XVonmBmpR5RJwk3QqgZdBDSE4UA7
        HFV6yAyyLhGCQOEV1zehxQi4sFCRe0uoEJWKelBffG4J1jsBPfk2CDdU/vDadlRWA9y8PVwHuL8
        cudBpMS3MeCtx7Up/
X-Received: by 2002:ac2:4196:: with SMTP id z22mr24761738lfh.171.1571233273691;
        Wed, 16 Oct 2019 06:41:13 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwg64ZdxcESSu4q+rfKJD+H8qEfCZE76av68koSbdgDMfPiI3vPRroBhmpVM96PF1PHvjzguQ==
X-Received: by 2002:ac2:4196:: with SMTP id z22mr24761720lfh.171.1571233273426;
        Wed, 16 Oct 2019 06:41:13 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id e21sm6556772lfj.10.2019.10.16.06.41.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Oct 2019 06:41:12 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id CB3541800F4; Wed, 16 Oct 2019 15:41:11 +0200 (CEST)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     daniel@iogearbox.net, ast@fb.com
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: [PATCH bpf] xdp: Handle device unregister for devmap_hash map type
Date:   Wed, 16 Oct 2019 15:28:02 +0200
Message-Id: <20191016132802.2760149-1-toke@redhat.com>
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
 kernel/bpf/devmap.c | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index d27f3b60ff6d..deb9416341e9 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -719,6 +719,35 @@ const struct bpf_map_ops dev_map_hash_ops = {
 	.map_check_btf = map_check_no_btf,
 };
 
+static void dev_map_hash_remove_netdev(struct bpf_dtab *dtab,
+				       struct net_device *netdev)
+{
+	int i;
+
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
+}
+
 static int dev_map_notification(struct notifier_block *notifier,
 				ulong event, void *ptr)
 {
@@ -735,6 +764,11 @@ static int dev_map_notification(struct notifier_block *notifier,
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

