Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 845EE4E7FB6
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 08:09:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231745AbiCZHLM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Mar 2022 03:11:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231646AbiCZHLL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Mar 2022 03:11:11 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D9D426D126
        for <netdev@vger.kernel.org>; Sat, 26 Mar 2022 00:09:35 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id t5so8339418pfg.4
        for <netdev@vger.kernel.org>; Sat, 26 Mar 2022 00:09:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aY7Qm3duZzz4/ANMI52LqTxkdMO5YlOW9+CWZKbNUDQ=;
        b=I05Mab032aTpoTeimJ2ZOfF1xo8R9P0uXq5lBgIRm+2ywDCJ7TRBiojiTa2Sl4OyrW
         ENUppUa56EY/52pmYjwVkvLFtLbIrXRiqjns6jQiDFovrx+lkvG4JwIweL0YU8mdQjko
         42818OZdanjVU+H50AQcXJKz2sx+o0LKLoabM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aY7Qm3duZzz4/ANMI52LqTxkdMO5YlOW9+CWZKbNUDQ=;
        b=z/F6w+bCFFRRGE5BfZEbX0y2HXYhf0zq2rrsLzxHN/A8CTr+EK1sD0DaqtAofQ1vrd
         8lUXtqH9DKhPRUPo9Ibi8oQ5C9ztgbH6potSHTeNbR779/5N4BcZXC7EVwtSdnOKshBF
         2BKIocDrClO6c9KpVLocjGM36g65TErinmlOvDCMW8lPD9mFsrLriJROQTCrxOkpO84W
         C/Pmkkie2GhhMZTJ6EamrdobUmGqzilvcq3Kqz5GK8cZ/bMnV9X8dIBZiibY6hKoZP70
         4vBYGir/fL7j2K7FOKk8x01cKrYpvN7E73Em4J9vuRz3uAIqij6J37LN80i7s14LrlAS
         ygYQ==
X-Gm-Message-State: AOAM533dLs3X1Pf0h3GMM3h2FrV3VgRj5aUwlsc3c6dWYZwqfy+I83El
        oriSOFTYQlk0Fjbi4txSNFDOQA==
X-Google-Smtp-Source: ABdhPJxLT1yAk+YxicpfYCc3ehIfT2Bhk4TwGg5YlmuZKXxtcXZhn3FYsvFWkuU6byOwpgW5/SuX6g==
X-Received: by 2002:a05:6a00:815:b0:4fb:e46:511c with SMTP id m21-20020a056a00081500b004fb0e46511cmr7185978pfk.54.1648278574592;
        Sat, 26 Mar 2022 00:09:34 -0700 (PDT)
Received: from localhost (0.223.81.34.bc.googleusercontent.com. [34.81.223.0])
        by smtp.gmail.com with UTF8SMTPSA id j6-20020a17090a588600b001c699d77503sm7565679pji.2.2022.03.26.00.09.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 26 Mar 2022 00:09:33 -0700 (PDT)
From:   Ying Hsu <yinghsu@chromium.org>
To:     marcel@holtmann.org
Cc:     chromeos-bluetooth-upstreaming@chromium.org,
        Ying Hsu <yinghsu@chromium.org>,
        syzbot+2bef95d3ab4daa10155b@syzkaller.appspotmail.com,
        Joseph Hwang <josephsih@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Desmond Cheong Zhi Xi <desmondcheongzx@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v2] Bluetooth: fix dangling sco_conn and use-after-free in sco_sock_timeout
Date:   Sat, 26 Mar 2022 07:09:28 +0000
Message-Id: <20220326070853.v2.1.I67f8ad854ac2f48701902bfb34d6e2070011b779@changeid>
X-Mailer: git-send-email 2.35.1.1021.g381101b075-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Connecting the same socket twice consecutively in sco_sock_connect()
could lead to a race condition where two sco_conn objects are created
but only one is associated with the socket. If the socket is closed
before the SCO connection is established, the timer associated with the
dangling sco_conn object won't be canceled. As the sock object is being
freed, the use-after-free problem happens when the timer callback
function sco_sock_timeout() accesses the socket. Here's the call trace:

dump_stack+0x107/0x163
? refcount_inc+0x1c/
print_address_description.constprop.0+0x1c/0x47e
? refcount_inc+0x1c/0x7b
kasan_report+0x13a/0x173
? refcount_inc+0x1c/0x7b
check_memory_region+0x132/0x139
refcount_inc+0x1c/0x7b
sco_sock_timeout+0xb2/0x1ba
process_one_work+0x739/0xbd1
? cancel_delayed_work+0x13f/0x13f
? __raw_spin_lock_init+0xf0/0xf0
? to_kthread+0x59/0x85
worker_thread+0x593/0x70e
kthread+0x346/0x35a
? drain_workqueue+0x31a/0x31a
? kthread_bind+0x4b/0x4b
ret_from_fork+0x1f/0x30

Link: https://syzkaller.appspot.com/bug?extid=2bef95d3ab4daa10155b
Reported-by: syzbot+2bef95d3ab4daa10155b@syzkaller.appspotmail.com
Fixes: e1dee2c1de2b ("Bluetooth: fix repeated calls to sco_sock_kill")
Signed-off-by: Ying Hsu <yinghsu@chromium.org>
Reviewed-by: Joseph Hwang <josephsih@chromium.org>
---
Tested this commit using a C reproducer on qemu-x86_64 for 8 hours.

Changes in v2:
- Adding Link, Reported-by, and Fixes tags in comment.

 net/bluetooth/sco.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/net/bluetooth/sco.c b/net/bluetooth/sco.c
index 8eabf41b2993..380c63194736 100644
--- a/net/bluetooth/sco.c
+++ b/net/bluetooth/sco.c
@@ -574,19 +574,24 @@ static int sco_sock_connect(struct socket *sock, struct sockaddr *addr, int alen
 	    addr->sa_family != AF_BLUETOOTH)
 		return -EINVAL;
 
-	if (sk->sk_state != BT_OPEN && sk->sk_state != BT_BOUND)
-		return -EBADFD;
+	lock_sock(sk);
+	if (sk->sk_state != BT_OPEN && sk->sk_state != BT_BOUND) {
+		err = -EBADFD;
+		goto done;
+	}
 
-	if (sk->sk_type != SOCK_SEQPACKET)
-		return -EINVAL;
+	if (sk->sk_type != SOCK_SEQPACKET) {
+		err = -EINVAL;
+		goto done;
+	}
 
 	hdev = hci_get_route(&sa->sco_bdaddr, &sco_pi(sk)->src, BDADDR_BREDR);
-	if (!hdev)
-		return -EHOSTUNREACH;
+	if (!hdev) {
+		err = -EHOSTUNREACH;
+		goto done;
+	}
 	hci_dev_lock(hdev);
 
-	lock_sock(sk);
-
 	/* Set destination address and psm */
 	bacpy(&sco_pi(sk)->dst, &sa->sco_bdaddr);
 
-- 
2.35.1.1021.g381101b075-goog

