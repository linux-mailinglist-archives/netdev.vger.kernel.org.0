Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C7BE24A2C8
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 17:24:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726792AbgHSPYV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 11:24:21 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:42969 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726187AbgHSPYS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 11:24:18 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from alaa@mellanox.com)
        with SMTP; 19 Aug 2020 18:24:11 +0300
Received: from dev-h-vrt-013.mth.labs.mlnx (dev-h-vrt-013.mth.labs.mlnx [10.194.13.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 07JFOA84024769;
        Wed, 19 Aug 2020 18:24:10 +0300
From:   Alaa Hleihel <alaa@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, xiyou.wangcong@gmail.com,
        marcelo.leitner@gmail.com, Roi Dayan <roid@mellanox.com>
Subject: [PATCH net] net/sched: act_ct: Fix skb double-free in tcf_ct_handle_fragments() error flow
Date:   Wed, 19 Aug 2020 18:24:10 +0300
Message-Id: <20200819152410.1152049-1-alaa@mellanox.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tcf_ct_handle_fragments() shouldn't free the skb when ip_defrag() call
fails. Otherwise, we will cause a double-free bug.
In such cases, just return the error to the caller.

Fixes: b57dc7c13ea9 ("net/sched: Introduce action ct")
Signed-off-by: Alaa Hleihel <alaa@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
---
 net/sched/act_ct.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index e6ad42b11835..2c3619165680 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -704,7 +704,7 @@ static int tcf_ct_handle_fragments(struct net *net, struct sk_buff *skb,
 		err = ip_defrag(net, skb, user);
 		local_bh_enable();
 		if (err && err != -EINPROGRESS)
-			goto out_free;
+			return err;
 
 		if (!err) {
 			*defrag = true;
-- 
1.8.3.1

