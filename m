Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CE86534CC1
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 11:50:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238744AbiEZJuO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 05:50:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231214AbiEZJuO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 05:50:14 -0400
Received: from mail-m973.mail.163.com (mail-m973.mail.163.com [123.126.97.3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D0846558B;
        Thu, 26 May 2022 02:50:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=Di6y9
        LmpgXQ4/BEcC3oV3UoBlBH0yPqVOabL8M117+A=; b=EZPjLzAPCOi4AlHgX6qbU
        SjQHFuz4h3Y+YZC9aoQz8DWoxh7+OlCSC6l5VK3QLNpphNjFaLFud+l3qCp/vU2z
        XLJRHx4xpuecJEv3OTAU3NsSzWVZdLOJXWmeOYk0qSR23pqQr6lDAf9T6HAyYadE
        Vi0nRvSmQ8Db9OFEV+etis=
Received: from localhost.localdomain (unknown [123.112.69.106])
        by smtp3 (Coremail) with SMTP id G9xpCgDXpnghTY9iJIzYEg--.5546S4;
        Thu, 26 May 2022 17:49:43 +0800 (CST)
From:   Jianglei Nie <niejianglei2021@163.com>
To:     marcel@holtmann.org, johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jianglei Nie <niejianglei2021@163.com>
Subject: [PATCH] Bluetooth: hci_conn: fix potential double free in le_scan_cleanup()
Date:   Thu, 26 May 2022 17:49:18 +0800
Message-Id: <20220526094918.482971-1-niejianglei2021@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: G9xpCgDXpnghTY9iJIzYEg--.5546S4
X-Coremail-Antispam: 1Uf129KBjvdXoWruFWfZFy8tw48AF48AryftFb_yoWfKrcEv3
        sa9F4S9w4DZ395CanIya15A3y8Jwn3ZFykJa12qry5K3s0vFnrGr4xXr1kKryUWw4UZr1f
        Crs8Gr1kZw17tjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7xREsqXtUUUUU==
X-Originating-IP: [123.112.69.106]
X-CM-SenderInfo: xqlhyxxdqjzvrlsqjii6rwjhhfrp/1tbi6xcNjFXl1rDewQAAs0
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When "c == conn" is true, hci_conn_cleanup() is called. The
hci_conn_cleanup() calls hci_dev_put() and hci_conn_put() in
its function implementation. hci_dev_put() and hci_conn_put()
will free the relevant resource if the reference count reaches
zero, which may lead to a double free when hci_dev_put() and
hci_conn_put() are called again.

We should add a return to this function after hci_conn_cleanup()
is called.

Signed-off-by: Jianglei Nie <niejianglei2021@163.com>
---
 net/bluetooth/hci_conn.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index fe803bee419a..7b3e91eb9fa3 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -166,6 +166,7 @@ static void le_scan_cleanup(struct work_struct *work)
 	if (c == conn) {
 		hci_connect_le_scan_cleanup(conn);
 		hci_conn_cleanup(conn);
+		return;
 	}
 
 	hci_dev_unlock(hdev);
-- 
2.25.1

