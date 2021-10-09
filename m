Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27442427CBC
	for <lists+netdev@lfdr.de>; Sat,  9 Oct 2021 20:45:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229745AbhJISrb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Oct 2021 14:47:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbhJISr3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Oct 2021 14:47:29 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A764FC061570
        for <netdev@vger.kernel.org>; Sat,  9 Oct 2021 11:45:32 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id v20so1270963plo.7
        for <netdev@vger.kernel.org>; Sat, 09 Oct 2021 11:45:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=n2xJeonrNzJwNbk39d1vJZZUu+mYZbA/KdBQyG7UKOk=;
        b=Whf8ylRK5mdJPakk1l6tEs9lT7rZHZU5z48N//luFzfH8o8Wzmd52UpAgclRKnlVwK
         ydVa6kmbkrwV7sEkOl/V8hw1hj2RjfBWGgPQGWa0nsh7natXL5oRQjwChFN1OhA2QFo7
         319d3MR7Na4qKCssc0RH1khrcBb+hrrnGcou1G26gLMMe9ES1hF/C/5Yvi9zfFCk2v2e
         eH+YvunxOdA1eKhm/zE+o4wuk8bp3FAGEt9Bkuqgub3PsS0NRn9+Z7fIdVbCBA6QIq2Q
         c9rGv3huZ4l1VOqjIZ9lwkEi0lk/6huWAiHVqFeBZZqXiQ9MwC8riX0lnAkakwMQZlSw
         3Rdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=n2xJeonrNzJwNbk39d1vJZZUu+mYZbA/KdBQyG7UKOk=;
        b=48pIuXXE6SIA8+o/F9yfl1G2NGSGJcLHRHhmDvxoZb8qrJVBKSOhTlgFMaeLOt/OO6
         NXc1a5QKmSVIEaloR5I/joEc2mCanVepz1kU1jHvu1v8AqakDaINHWkMmgRX+gCOUal8
         ytsJM9Jf2O9+x3dZvyVs5Ep5lTn19cXYxtjLtYzrCOQKx/yiw3Fl1o//ssAyWvGhVzzY
         tqZ0RAUTZJbewbXgugzcd5tD69f/kW/Vqgzt2sKOwtBjN9DBAyMarbnarvFnGdj6qIGx
         nn907zU/HfzLMx2qAnj+qjNJW3OmzhLJuS0Iq0/vsJ4o9nPoJ+NtYsUKCaRnRXaP1WdW
         E5Aw==
X-Gm-Message-State: AOAM532gdUv0k5dFIOcJwVvFzdoB2jf6vpT3RKLUESgIg5xXej+pN53f
        VEaW0Y9aqJ47u7nd5o1osi9VIg==
X-Google-Smtp-Source: ABdhPJxsokeslVhnKPXXtTKH+imZPwIY8POVv54UfYbh3bLUyUR5pax4w9XdlX0Ak+KM8vn2bHvhiA==
X-Received: by 2002:a17:90b:1106:: with SMTP id gi6mr20095350pjb.144.1633805132224;
        Sat, 09 Oct 2021 11:45:32 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id s30sm3368433pgo.39.2021.10.09.11.45.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Oct 2021 11:45:31 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Cc:     drivers@pensando.io, jtoppins@redhat.com,
        Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 1/9] ionic: add filterlist to debugfs
Date:   Sat,  9 Oct 2021 11:45:15 -0700
Message-Id: <20211009184523.73154-2-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211009184523.73154-1-snelson@pensando.io>
References: <20211009184523.73154-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dump the filter list to debugfs - includes the device-assigned
filter id and the sync'd-to-hardware status.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../ethernet/pensando/ionic/ionic_debugfs.c   | 46 +++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_debugfs.c b/drivers/net/ethernet/pensando/ionic/ionic_debugfs.c
index 86b79430c2ad..c58217027564 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_debugfs.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_debugfs.c
@@ -226,6 +226,50 @@ static int netdev_show(struct seq_file *seq, void *v)
 }
 DEFINE_SHOW_ATTRIBUTE(netdev);
 
+static int lif_filters_show(struct seq_file *seq, void *v)
+{
+	struct ionic_lif *lif = seq->private;
+	struct ionic_rx_filter *f;
+	struct hlist_head *head;
+	struct hlist_node *tmp;
+	unsigned int i;
+
+	seq_puts(seq, "id      flow        state type  filter\n");
+	spin_lock_bh(&lif->rx_filters.lock);
+	for (i = 0; i < IONIC_RX_FILTER_HLISTS; i++) {
+		head = &lif->rx_filters.by_id[i];
+		hlist_for_each_entry_safe(f, tmp, head, by_id) {
+			switch (le16_to_cpu(f->cmd.match)) {
+			case IONIC_RX_FILTER_MATCH_VLAN:
+				seq_printf(seq, "0x%04x  0x%08x  0x%02x  vlan  0x%04x\n",
+					   f->filter_id, f->flow_id, f->state,
+					   le16_to_cpu(f->cmd.vlan.vlan));
+				break;
+			case IONIC_RX_FILTER_MATCH_MAC:
+				seq_printf(seq, "0x%04x  0x%08x  0x%02x  mac   %pM\n",
+					   f->filter_id, f->flow_id, f->state,
+					   f->cmd.mac.addr);
+				break;
+			case IONIC_RX_FILTER_MATCH_MAC_VLAN:
+				seq_printf(seq, "0x%04x  0x%08x  0x%02x  macvl 0x%04x %pM\n",
+					   f->filter_id, f->flow_id, f->state,
+					   le16_to_cpu(f->cmd.vlan.vlan),
+					   f->cmd.mac.addr);
+				break;
+			case IONIC_RX_FILTER_STEER_PKTCLASS:
+				seq_printf(seq, "0x%04x  0x%08x  0x%02x  rxstr 0x%llx\n",
+					   f->filter_id, f->flow_id, f->state,
+					   le64_to_cpu(f->cmd.pkt_class));
+				break;
+			}
+		}
+	}
+	spin_unlock_bh(&lif->rx_filters.lock);
+
+	return 0;
+}
+DEFINE_SHOW_ATTRIBUTE(lif_filters);
+
 void ionic_debugfs_add_lif(struct ionic_lif *lif)
 {
 	struct dentry *lif_dentry;
@@ -237,6 +281,8 @@ void ionic_debugfs_add_lif(struct ionic_lif *lif)
 
 	debugfs_create_file("netdev", 0400, lif->dentry,
 			    lif->netdev, &netdev_fops);
+	debugfs_create_file("filters", 0400, lif->dentry,
+			    lif, &lif_filters_fops);
 }
 
 void ionic_debugfs_del_lif(struct ionic_lif *lif)
-- 
2.17.1

