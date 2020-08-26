Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88785252C7F
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 13:33:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729018AbgHZLcO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 07:32:14 -0400
Received: from spam.zju.edu.cn ([61.164.42.155]:45460 "EHLO zju.edu.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728999AbgHZLb6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Aug 2020 07:31:58 -0400
Received: from localhost.localdomain (unknown [210.32.144.184])
        by mail-app3 (Coremail) with SMTP id cC_KCgCnr98JSEZf_ms_Aw--.46227S4;
        Wed, 26 Aug 2020 19:31:24 +0800 (CST)
From:   Dinghao Liu <dinghao.liu@zju.edu.cn>
To:     dinghao.liu@zju.edu.cn, kjlu@umn.edu
Cc:     David Howells <dhowells@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-afs@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] rxrpc: Fix memleak in rxkad_verify_response
Date:   Wed, 26 Aug 2020 19:31:20 +0800
Message-Id: <20200826113120.24297-1-dinghao.liu@zju.edu.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: cC_KCgCnr98JSEZf_ms_Aw--.46227S4
X-Coremail-Antispam: 1UD129KBjvdXoW7GrWktw15JrW5WrWrtF18Krg_yoWDJFc_A3
        yxKayUZ3yYqFy8C3y2g3y5Kw1xurnrArnYgrn3KFsxJ3yUA347C39rJr1fJryF9a1jgryY
        yrnIqryxur1ayjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbIxFc2x0x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3wAFIxvE14AK
        wVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK021l84ACjcxK6xIIjxv20x
        vE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4UJVWxJr1l84ACjcxK6I8E
        87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1le2I262IYc4CY6c
        8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_
        Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwI
        xGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc2xSY4AK67AK6r4kMxAIw28IcxkI7VAKI48J
        MxAIw28IcVCjz48v1sIEY20_GFWkJr1UJwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c
        02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_
        GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7
        CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6rW3Jr0E3s1lIxAIcVC2z280aVAF
        wI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa
        7VUbeT5PUUUUU==
X-CM-SenderInfo: qrrzjiaqtzq6lmxovvfxof0/1tbiAg0EBlZdtPrBDAAIsN
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When kmalloc() on ticket fails, response should be freed
to prevent memleak.

Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
---
 net/rxrpc/rxkad.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/rxrpc/rxkad.c b/net/rxrpc/rxkad.c
index 52a24d4ef5d8..e08130e5746b 100644
--- a/net/rxrpc/rxkad.c
+++ b/net/rxrpc/rxkad.c
@@ -1137,7 +1137,7 @@ static int rxkad_verify_response(struct rxrpc_connection *conn,
 	ret = -ENOMEM;
 	ticket = kmalloc(ticket_len, GFP_NOFS);
 	if (!ticket)
-		goto temporary_error;
+		goto temporary_error_free_resp;
 
 	eproto = tracepoint_string("rxkad_tkt_short");
 	abort_code = RXKADPACKETSHORT;
@@ -1230,6 +1230,7 @@ static int rxkad_verify_response(struct rxrpc_connection *conn,
 
 temporary_error_free_ticket:
 	kfree(ticket);
+temporary_error_free_resp:
 	kfree(response);
 temporary_error:
 	/* Ignore the response packet if we got a temporary error such as
-- 
2.17.1

