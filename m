Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98ACB23EEB4
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 16:08:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726656AbgHGOIk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Aug 2020 10:08:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726250AbgHGOAI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Aug 2020 10:00:08 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AB80C061575;
        Fri,  7 Aug 2020 06:59:26 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id u128so1042121pfb.6;
        Fri, 07 Aug 2020 06:59:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KkgC/IfZgfpRrHJateeuAuB7TNckjX9ScGM6wvRUKgI=;
        b=gDMavG5S3kcl1rHlmaIoh4h3AYKDs61EYZN8cDWB74dcRQJBQd0+pzoVYEOzovxZ6h
         eJWijr6Xw5aNrN6uqIKECi/C3CMLum49xD4ayGZU5SCqKI5EIhok9ewLtPGgHhEd19uT
         /EYlh//DysbcBPh9myNWMQzxHPisMLRScDsNeoOsup5vA4gWdGhGu8be8vzbdTD8VZaS
         TVS6/qccykmKkXJN8moBVApR9dpm8+L+Ifu5XZwHri5sFP3sqGK5xxLy+2p6JmvH7M+9
         0IBgfEunDLgdwJAg64hXWLJ3rTkUD542IaGzrBdHgqq/MtvSXsQAdXcgy5CbwBggVq2/
         FgMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KkgC/IfZgfpRrHJateeuAuB7TNckjX9ScGM6wvRUKgI=;
        b=OsPnzlh2Y5QffI1aJDF3jvTqAqErGnS3arYXuqTSYhEhrhieykS7544+GjusuVO0ZG
         J0bt7bXrBW1jaG9m2r392qjWcFH/7ZdbajlXUqGMtct9SpgBeqGb25XcRy/2mc0vz1OV
         OXo/udPbhZiHU3sYbaCTxU2XdqqD1YDtC5VKgXrycsNLn+NjyWYh28qxEEwccm0oauJH
         H2GAOdu1MMJuahDM4cmzMssXGXTDRy2g5JLp1XjNg5N36S4sRXq3QVyw632AoB4Mv8mZ
         TPBjreU4XIjlQBGpGvqRI31H3tDmTkxn31JV3VPcub03Y5NSt0RBRvJrJRhMPTf2bQ/6
         8hgA==
X-Gm-Message-State: AOAM5316x3pKKHeQkf8jueZfTIkw2Zu7vqSZ19VgMzIoimen3CRO9iSg
        MFsyXnHEPSxgh3KIZHUM4H3Er3WTtuBjLg==
X-Google-Smtp-Source: ABdhPJz4Wsqd8oawH81Y8HKewsfkWQhSxRPY2Ov5elBmaChRBM6h41G4JBnG2tm9eAT+qNWOK3v2Lw==
X-Received: by 2002:aa7:8a4d:: with SMTP id n13mr14406135pfa.143.1596808765226;
        Fri, 07 Aug 2020 06:59:25 -0700 (PDT)
Received: from localhost ([2001:e42:102:1532:160:16:113:140])
        by smtp.gmail.com with ESMTPSA id u15sm11212157pju.42.2020.08.07.06.59.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2020 06:59:24 -0700 (PDT)
From:   Coiby Xu <coiby.xu@gmail.com>
To:     linux-bluetooth@vger.kernel.org
Cc:     linux-kernel-mentees@lists.linuxfoundation.org,
        syzkaller-bugs@googlegroups.com,
        syzbot+305a91e025a73e4fd6ce@syzkaller.appspotmail.com,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev@vger.kernel.org (open list:NETWORKING [GENERAL]),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] Bluetooth: Delete both L2CAP connction and HCI channel when completing destroying logical link in AMP
Date:   Fri,  7 Aug 2020 21:59:17 +0800
Message-Id: <20200807135918.1177869-1-coiby.xu@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When destroying a logical link (HCI_EV_DISCONN_LOGICAL_LINK_COMPLETE) in
AMP, L2CAP connection (struct l2cap_conn) should be deleted together with
HCI channel (struct hci_chan). Otherwise HCI channel will be deleted twice
when unregistering a HCI device.

`static void l2cap_conn_del(struct hci_conn *hcon, int err)` could
achieve this purpose. Make it a public function.

Reported-and-tested-by: syzbot+305a91e025a73e4fd6ce@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?extid=305a91e025a73e4fd6ce
Signed-off-by: Coiby Xu <coiby.xu@gmail.com>
---
 include/net/bluetooth/l2cap.h | 1 +
 net/bluetooth/amp.c           | 2 +-
 net/bluetooth/l2cap_core.c    | 2 +-
 3 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/net/bluetooth/l2cap.h b/include/net/bluetooth/l2cap.h
index 8f1e6a7a2df8..8508a433d6ac 100644
--- a/include/net/bluetooth/l2cap.h
+++ b/include/net/bluetooth/l2cap.h
@@ -988,6 +988,7 @@ void __l2cap_chan_add(struct l2cap_conn *conn, struct l2cap_chan *chan);
 typedef void (*l2cap_chan_func_t)(struct l2cap_chan *chan, void *data);
 void l2cap_chan_list(struct l2cap_conn *conn, l2cap_chan_func_t func,
 		     void *data);
+void l2cap_conn_del(struct hci_conn *hcon, int err);
 void l2cap_chan_del(struct l2cap_chan *chan, int err);
 void l2cap_send_conn_req(struct l2cap_chan *chan);
 void l2cap_move_start(struct l2cap_chan *chan);
diff --git a/net/bluetooth/amp.c b/net/bluetooth/amp.c
index 9c711f0dfae3..cee02f009cef 100644
--- a/net/bluetooth/amp.c
+++ b/net/bluetooth/amp.c
@@ -584,5 +584,5 @@ void amp_destroy_logical_link(struct hci_chan *hchan, u8 reason)
 {
 	BT_DBG("hchan %p", hchan);

-	hci_chan_del(hchan);
+	l2cap_conn_del(hchan->conn, bt_to_errno(reason));
 }
diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index fe913a5c754a..38f60fb9b515 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -1851,7 +1851,7 @@ static void l2cap_unregister_all_users(struct l2cap_conn *conn)
 	}
 }

-static void l2cap_conn_del(struct hci_conn *hcon, int err)
+void l2cap_conn_del(struct hci_conn *hcon, int err)
 {
 	struct l2cap_conn *conn = hcon->l2cap_data;
 	struct l2cap_chan *chan, *l;
--
2.27.0

