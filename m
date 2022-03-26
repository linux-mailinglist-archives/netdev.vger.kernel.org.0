Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D71684E7F9F
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 07:42:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231592AbiCZGoK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Mar 2022 02:44:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231611AbiCZGoH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Mar 2022 02:44:07 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD86417FD1A
        for <netdev@vger.kernel.org>; Fri, 25 Mar 2022 23:42:29 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id z128so8155762pgz.2
        for <netdev@vger.kernel.org>; Fri, 25 Mar 2022 23:42:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DzmW1EwXib0HEBL5ioOFxuUKPvj/IW7QJoaVVg8+xH0=;
        b=k94K+4orcgP8kDrhyw/hF4hSopr8E4xGvyHDrqmV3/AETXXKBicOS4bD6VEdw0a1rk
         fhuEs9Biymqy6AHdhF5pzSmXa5ciGqejQRnrQLgx+SNgTm/KSr+Q2OPuHqp9haPiNsxN
         wWrIRxjQUk6PDVquYpGEneQwQulpcj2oVxdyE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DzmW1EwXib0HEBL5ioOFxuUKPvj/IW7QJoaVVg8+xH0=;
        b=7Fhp8CmStUlHAhuvFJA1dQU+axeIGWY5EHWlMaWhZyNyr94Le9ODkhyamQsM1xezBc
         fZO92bqruFYnOwS7knpCdsAR4bHogAD5Q1LROyosFA+VCE+2BUQMtdxlgylSIc7vqJXU
         uQ2eMgztVwhshKav5TR7D0qThq0NhCmDL90JpChwH0BP+p91Fvy9rzQiB1atMalrveMV
         d6zvC+v3qYXbBtxArFyTDESlFyZOZGdjgNPo5MQz1nn9RAO8U6yj8MMjLocEU2I1zK7j
         bfPmtoaJBdpSLZkjgDbMr8KsPXwrYL1jTT98wLNSrrKy/zASQ90qu0BfKhDXhtS7FOx1
         SC+w==
X-Gm-Message-State: AOAM531+wgS9dYTEpKhLWhpgk1q5XKGXAJbA6ieSYQehu7t5jetNLjSA
        DVhS81DVpOLZsLaQgOMdhRsBfA==
X-Google-Smtp-Source: ABdhPJwXINhn4isrhWwq6UFZEvwUcMk+1i2H2+Yb705ZRLHFhy/5zUzg6kvPyFIyPtyDuoEF4KjUNQ==
X-Received: by 2002:a05:6a00:98e:b0:4fb:1162:b2a5 with SMTP id u14-20020a056a00098e00b004fb1162b2a5mr6604055pfg.12.1648276949326;
        Fri, 25 Mar 2022 23:42:29 -0700 (PDT)
Received: from localhost (0.223.81.34.bc.googleusercontent.com. [34.81.223.0])
        by smtp.gmail.com with UTF8SMTPSA id d80-20020a621d53000000b004fae1119955sm8960061pfd.213.2022.03.25.23.42.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Mar 2022 23:42:29 -0700 (PDT)
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
Subject: [PATCH] Bluetooth: fix dangling sco_conn and use-after-free in sco_sock_timeout
Date:   Sat, 26 Mar 2022 06:35:17 +0000
Message-Id: <20220326063415.1.I67f8ad854ac2f48701902bfb34d6e2070011b779@changeid>
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

