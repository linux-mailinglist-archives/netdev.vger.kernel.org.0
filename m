Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FC125BFEFB
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 15:33:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229530AbiIUNdm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 09:33:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229691AbiIUNdh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 09:33:37 -0400
Received: from m15114.mail.126.com (m15114.mail.126.com [220.181.15.114])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D03E48A7EC
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 06:33:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=yFbag
        /zhtOLwOi/5miF+cOyushQ49gnDwQ+iCvOHS5s=; b=enlojJifX9ZJJDVsSDuak
        3TLNyRcQ3HG9NWWQDR0X9DiIyxkOnwlt7GLC6b2Wtz1ymtZa6/rN2t2jYzLo0XyW
        YynN9/uv4KcyKlCwW8/VX+wCL1+mYd6SUjrqha1pHVDubIlUlxy90HPGagoufN2s
        hVlg9CV5Gj6vkx+VCJwImI=
Received: from localhost.localdomain (unknown [124.16.139.61])
        by smtp7 (Coremail) with SMTP id DsmowAD3_ZWDEitjyDLiBw--.35825S2;
        Wed, 21 Sep 2022 21:32:51 +0800 (CST)
From:   Liang He <windhl@126.com>
To:     tchornyi@marvell.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux@armlinux.org.uk,
        netdev@vger.kernel.org
Cc:     windhl@126.com, yevhen.orlov@plvision.eu,
        taras.chornyi@plvision.eu, oleksandr.mazur@plvision.eu
Subject: [PATCH] net: marvell: Fix refcounting bugs in prestera_port_sfp_bind()
Date:   Wed, 21 Sep 2022 21:32:45 +0800
Message-Id: <20220921133245.4111672-1-windhl@126.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: DsmowAD3_ZWDEitjyDLiBw--.35825S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7tw4fWw4xGFW7AFW5tFy5urg_yoW8GFy8pa
        yjkrWa9r1vqr40v3ykta48ZFWqqa43t3yUKrsrC3WfArWkGrykAryUWFnI9rnxtFWrZFyY
        qr4Ut3W3u3Z8XaUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07Ux73PUUUUU=
X-Originating-IP: [124.16.139.61]
X-CM-SenderInfo: hzlqvxbo6rjloofrz/xtbBGgCDF1-HZ3h4JAACsX
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In prestera_port_sfp_bind(), there are two refcounting bugs:
(1) we should call of_node_get() before of_find_node_by_name() as
it will automaitcally decrease the refcount of 'from' argument;
(2) we should call of_node_put() for the break of the iteration
for_each_child_of_node() as it will automatically increase and
decrease the 'child'.

Fixes: 52323ef75414 ("net: marvell: prestera: add phylink support")
Signed-off-by: Liang He <windhl@126.com>
---
 it will be safe to call of_node_put() at the end of the function as
the of_node_put() can handle NULL.

 drivers/net/ethernet/marvell/prestera/prestera_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_main.c b/drivers/net/ethernet/marvell/prestera/prestera_main.c
index ede3e53b9790..a895862b4821 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_main.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_main.c
@@ -368,6 +368,7 @@ static int prestera_port_sfp_bind(struct prestera_port *port)
 	if (!sw->np)
 		return 0;
 
+	of_node_get(sw->np);
 	ports = of_find_node_by_name(sw->np, "ports");
 
 	for_each_child_of_node(ports, node) {
@@ -417,6 +418,7 @@ static int prestera_port_sfp_bind(struct prestera_port *port)
 	}
 
 out:
+	of_node_put(node);
 	of_node_put(ports);
 	return err;
 }
-- 
2.25.1

