Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 131AA5FD5A2
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 09:41:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229585AbiJMHl2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 03:41:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbiJMHl0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 03:41:26 -0400
Received: from mailgw.kylinos.cn (unknown [124.126.103.232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92C5712C885;
        Thu, 13 Oct 2022 00:41:23 -0700 (PDT)
X-UUID: e60510b4d56e41c4ae64c42a9cb13398-20221013
X-CPASD-INFO: ae7c31ef5cf7477581ead3b6091b9e57@qrVxg2Bjk5Zhg6iDg3qCb1himY2EgqR
        wUGlfkmWFiomMbFJkYl1ZgYFqUWJpX2FZVXp4blJgYGJcWHh4lHKPVGBeYIJUdJOAo59Xk2Fh
X-CLOUD-ID: ae7c31ef5cf7477581ead3b6091b9e57
X-CPASD-SUMMARY: SIP:-1,APTIP:-2.0,KEY:0.0,FROMBLOCK:1,OB:0.0,URL:-5,TVAL:171.
        0,ESV:0.0,ECOM:-5.0,ML:14.0,FD:0.0,CUTS:96.0,IP:-2.0,MAL:-5.0,PHF:-5.0,PHC:-5
        .0,SPF:4.0,EDMS:-5,IPLABEL:4480.0,FROMTO:0,AD:0,FFOB:0.0,CFOB:0.0,SPC:0,SIG:-
        5,AUF:0,DUF:6688,ACD:109,DCD:109,SL:0,EISP:0,AG:0,CFC:0.306,CFSR:0.199,UAT:0,
        RAF:0,IMG:-5.0,DFA:0,DTA:0,IBL:-2.0,ADI:-5,SBL:0,REDM:0,REIP:0,ESB:0,ATTNUM:0
        ,EAF:0,CID:-5.0,VERSION:2.3.17
X-CPASD-ID: e60510b4d56e41c4ae64c42a9cb13398-20221013
X-CPASD-BLOCK: 14
X-CPASD-STAGE: 1
X-UUID: e60510b4d56e41c4ae64c42a9cb13398-20221013
X-User: zhangxiangqian@kylinos.cn
Received: from localhost.localdomain [(111.48.58.12)] by mailgw
        (envelope-from <zhangxiangqian@kylinos.cn>)
        (Generic MTA)
        with ESMTP id 122811894; Thu, 13 Oct 2022 15:42:21 +0800
From:   zhangxiangqian <zhangxiangqian@kylinos.cn>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: macvlan: change schedule system_wq to system_unbound_wq
Date:   Thu, 13 Oct 2022 15:41:12 +0800
Message-Id: <1665646872-20954-1-git-send-email-zhangxiangqian@kylinos.cn>
X-Mailer: git-send-email 2.7.4
X-Spam-Status: No, score=0.5 required=5.0 tests=BAYES_00,KHOP_HELO_FCRDNS,
        MAY_BE_FORGED,PDS_RDNS_DYNAMIC_FP,RDNS_DYNAMIC,SPF_HELO_NONE,
        T_SPF_PERMERROR,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For FT2000+/64 devices,
when four virtual machines share the same physical network interface,
DROP will occur due to the single core CPU performance problem.

ip_check_defrag and macvlan_process_broadcast is on the same CPU.
When the MACVLAN PORT increases, the CPU usage reaches more than 90%.
bc_queue > bc_queue_len_used (default 1000), causing DROP.

Signed-off-by: zhangxiangqian <zhangxiangqian@kylinos.cn>
---
 drivers/net/macvlan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index 1080d6e..dd3f35e 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -361,7 +361,7 @@ static void macvlan_broadcast_enqueue(struct macvlan_port *port,
 	}
 	spin_unlock(&port->bc_queue.lock);
 
-	schedule_work(&port->bc_work);
+	queue_work(system_unbound_wq, &port->bc_work);
 
 	if (err)
 		goto free_nskb;
-- 
2.7.4

