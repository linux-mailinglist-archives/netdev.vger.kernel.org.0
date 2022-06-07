Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2450540270
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 17:31:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344104AbiFGPby (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 11:31:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245305AbiFGPbw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 11:31:52 -0400
Received: from m12-11.163.com (m12-11.163.com [220.181.12.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4B0B6F45DE;
        Tue,  7 Jun 2022 08:31:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=uNPsyShOFiuwQGXJNt
        ++4+eFtCC9VoD+9K2/mAYK9QI=; b=ILXys8kBZMpjoIDZoqm9tHve4Jy6dqU3Ul
        1RWqpQVQHZWue1xgMBwJ4QzgfLM6RZerSdeMo9k3woQ1aZp/NEJaQogIoGa51mdG
        Z2tbEJ8boPcW5VrGSwTg77NCLeYpwvMJEx6+JYJ3yrkcyVVe1qVKhud9GB4l7iKc
        xM+e5xo+Y=
Received: from localhost.localdomain (unknown [202.112.113.212])
        by smtp7 (Coremail) with SMTP id C8CowADncKANb59i1gX+Gg--.1343S4;
        Tue, 07 Jun 2022 23:30:26 +0800 (CST)
From:   Xiaohui Zhang <ruc_zhangxiaohui@163.com>
To:     Xiaohui Zhang <ruc_zhangxiaohui@163.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Xiaohui Zhang <xiaohuizhang@ruc.edu.cn>
Subject: [PATCH 1/1] Bluetooth: use memset avoid memory leaks
Date:   Tue,  7 Jun 2022 23:30:20 +0800
Message-Id: <20220607153020.29430-1-ruc_zhangxiaohui@163.com>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: C8CowADncKANb59i1gX+Gg--.1343S4
X-Coremail-Antispam: 1Uf129KBjvdXoWrtw18JFy3Xw48AFW5WF4xtFb_yoWfWFX_uw
        4ruayfZa1rJ34Iya12yF48u3W2yan5ZrZ5GrnaqrWUX34UGw47Krs2gFnxWrn7K39ruFy3
        ArZ8JryrAw48JjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7sRMvtCDUUUUU==
X-Originating-IP: [202.112.113.212]
X-CM-SenderInfo: puxfs6pkdqw5xldrx3rl6rljoofrz/1tbiThIZMFUDPaLqywAAsd
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xiaohui Zhang <xiaohuizhang@ruc.edu.cn>

Similar to the handling of l2cap_ecred_connect in commit d3715b2333e9
("Bluetooth: use memset avoid memory leaks"), we thought a patch
might be needed here as well.

Use memset to initialize structs to prevent memory leaks
in l2cap_le_connect

Signed-off-by: Xiaohui Zhang <xiaohuizhang@ruc.edu.cn>
---
 net/bluetooth/l2cap_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index ae78490ecd3d..09ecaf556de5 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -1369,6 +1369,7 @@ static void l2cap_le_connect(struct l2cap_chan *chan)
 
 	l2cap_le_flowctl_init(chan, 0);
 
+	memset(&req, 0, sizeof(req));
 	req.psm     = chan->psm;
 	req.scid    = cpu_to_le16(chan->scid);
 	req.mtu     = cpu_to_le16(chan->imtu);
-- 
2.17.1

