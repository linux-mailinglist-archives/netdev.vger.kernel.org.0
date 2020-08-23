Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69B4124EAA3
	for <lists+netdev@lfdr.de>; Sun, 23 Aug 2020 03:00:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726215AbgHWBAi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Aug 2020 21:00:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725767AbgHWBAi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Aug 2020 21:00:38 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04921C061573;
        Sat, 22 Aug 2020 18:00:38 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id g33so2797171pgb.4;
        Sat, 22 Aug 2020 18:00:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5+TanUjx4aTdxJYsMsMUFdiokbTUr43+JM8xsRSY+0I=;
        b=rx6aRGdcfWR0o7pmQXw8pzwtdAHGaRLCgCMimwem4zB0IThITtZDpAl4mr7GQM5ABv
         l1Xav6doj4OTLnwA4WdMcHEbD88JHGA94UnRMXKLOFYYtKEK9V+IYzcoAfzLlFLkkIZY
         c+M50sOOGpNS3D89y06E83Ur0YIMmT1+h/ZfNYjOT8pBg/wWehqtd6D4jkUFAEmJZYKB
         XbAqvmLPMWCwlgh0+4ZmlL2fdeGndIKC6Z3FxKiJGeU60XbTnI596i7sUNUHzyJMpqz1
         E4oshkUJ9vHj2h+CgJqIGlXgpPaoG7gDkPCmf+Y4RJZ8CyPClaU/OCI306cSS4xNrpIK
         1l7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5+TanUjx4aTdxJYsMsMUFdiokbTUr43+JM8xsRSY+0I=;
        b=KpjA+l49Q3eKA/KS6wGZJW9MgonSDMkDMXUQkgZKQ0YvyoJQNnj56nsB+8eP3fbWFp
         sr6QspQVcQKxv2M8TxUJZppyH7qjThA+/xbdfRUIA9USiy7+9dGXE8e30SS5UXXGVYE/
         gxYYn4iRuplnZnmWQ84Rh640XpJMySTi6T7qbod7423j0Ow6kiBn3Jp6NpsvVoUXL0b8
         w4umKO9w83DzosHLCjDh7PQxOsqNJZm3EiKqbO1a/hq4XYLjgz3HAGpzgBRFTIX4bh4+
         D2TyB2rSR2Z+yd+phTrTZotbnVf5tklTcAo85Hf20/HWEozZrUwxTtcKkhudHZpzk1+0
         KSHw==
X-Gm-Message-State: AOAM530AelOY28gXqNfaCwiC51puINcyUJBplQa5fjAyHqFSZrDe674W
        hJh3s3iJokAxDxwlsFJV9w9O10uTEj5d/hA4rMc=
X-Google-Smtp-Source: ABdhPJz1cfAq4nmjDpSF4+magItyeRjS9uG2hW1AoMBR1/nYYEIytOx/aCMpULiCkbyufqWuEEBc5A==
X-Received: by 2002:a65:60ce:: with SMTP id r14mr6742305pgv.85.1598144436460;
        Sat, 22 Aug 2020 18:00:36 -0700 (PDT)
Received: from localhost ([2001:e42:102:1532:160:16:113:140])
        by smtp.gmail.com with ESMTPSA id x15sm6875701pfr.208.2020.08.22.18.00.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Aug 2020 18:00:35 -0700 (PDT)
From:   Coiby Xu <coiby.xu@gmail.com>
To:     linux-bluetooth@vger.kernel.org
Cc:     linux-kernel-mentees@lists.linuxfoundation.org,
        gregkh@linuxfoundation.org, syzkaller-bugs@googlegroups.com,
        syzbot+dd768a260f7358adbaf9@syzkaller.appspotmail.com,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev@vger.kernel.org (open list:NETWORKING [GENERAL]),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] Bluetooth: fix "list_add double add" in hci_conn_complete_evt
Date:   Sun, 23 Aug 2020 09:00:22 +0800
Message-Id: <20200823010022.938532-1-coiby.xu@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <000000000000c57f2d05ac4c5b8e@google.com>
References: <000000000000c57f2d05ac4c5b8e@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When two HCI_EV_CONN_COMPLETE event packets with status=0 of the same
HCI connection are received, device_add would be called twice which
leads to kobject_add being called twice. Thus duplicate
(struct hci_conn *conn)->dev.kobj.entry would be inserted into
(struct hci_conn *conn)->dev.kobj.kset->list.

This issue can be fixed by checking (struct hci_conn *conn)->debugfs.
If it's not NULL, it means the HCI connection has been completed and we
won't duplicate the work as for processing the first
HCI_EV_CONN_COMPLETE event.

Reported-and-tested-by: syzbot+dd768a260f7358adbaf9@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?extid=dd768a260f7358adbaf9
Signed-off-by: Coiby Xu <coiby.xu@gmail.com>
---
 net/bluetooth/hci_event.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 4b7fc430793c..1233739ce760 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -2605,6 +2605,11 @@ static void hci_conn_complete_evt(struct hci_dev *hdev, struct sk_buff *skb)
 	}

 	if (!ev->status) {
+		if (conn->debugfs) {
+			bt_dev_err(hdev, "The connection has been completed");
+			goto unlock;
+		}
+
 		conn->handle = __le16_to_cpu(ev->handle);

 		if (conn->type == ACL_LINK) {
--
2.28.0

