Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 374D2473F1
	for <lists+netdev@lfdr.de>; Sun, 16 Jun 2019 11:26:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725888AbfFPJYR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Jun 2019 05:24:17 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:43753 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725766AbfFPJYR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Jun 2019 05:24:17 -0400
Received: by mail-pf1-f196.google.com with SMTP id i189so4000456pfg.10
        for <netdev@vger.kernel.org>; Sun, 16 Jun 2019 02:24:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=QIw02wXd+ThSQCSaJvt5xwy2HCbNq0tOfROK68zcA00=;
        b=naC+sKMNw9PAUsBUUfby7TlSCKkllJYXr9Ll2TIt2fO9IviNMrV+/S0uSYAl6Z1oQd
         EG9uzuliWahYJjnjRBVTvyHnEupcNld58uBElFjbJc2GCcBsCfrG9+SR94klCuy8Vlfn
         GoT3UZQznBe8tf5ve5ix9co2K1y7wJs2+S5mQLvl7dfKGvPcAlBznBwjwoSQj7K2nuxM
         DyhZ+JmDra/DWJhk76rFK/bDpXpifYTHUfchbDtwSoXrnkYsG7KW3gCtHiH4zFt1elDE
         8688B2XNR8rIW3WRGUwwNMPuEnOx2Ih+KGqlasde8hRA+tE2yt0rfIhwDA2GvDJz9agW
         SKoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=QIw02wXd+ThSQCSaJvt5xwy2HCbNq0tOfROK68zcA00=;
        b=FR0GOUfZ/7ovxmieuCUTs8crKoJiFJSsrYRXGmirLtgkZq0zN+DsrWjE5EYMZzlzck
         tkplKQtWhY2VbjLg3QTySGKK9/OEpHK/YcmkWduRN6VC2GUzDdj/fz9D+gk/7VnY2KWL
         cwvmx7CKLtA4Uc67nfTOEIMfNZxxAq8bpbBj4RTlcWnq735zapRa39bz9IE9qJbamdLc
         kP2cXLR1Tiwq8AMuiZZ+JFHHo4cQiQW/noGf248pI5Stf0o+rdZE6NMGd6T43NyMu6YG
         Vt+r6nV6JgCQuoEIF3JdLu1lztNHRzFoHtKySUo80zCuj7wO9T6V+rm3oSzjUGUco7Mw
         NDAw==
X-Gm-Message-State: APjAAAUBkE/jxaunYtOqK18TRSbKelfwgeCJPeINFcbV4ijuElSlSkrN
        FDpPG3B6/zg1sspKrW+NlbHwDvIx
X-Google-Smtp-Source: APXvYqy6KB+JyBjKSDuuyZGYgoHVzndzU19StpYZVklNw+y57wsD0TvskWBTLIz2kvLSfGDjwpzCPg==
X-Received: by 2002:aa7:80d9:: with SMTP id a25mr9718632pfn.50.1560677056010;
        Sun, 16 Jun 2019 02:24:16 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id l7sm9564543pfl.9.2019.06.16.02.24.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 16 Jun 2019 02:24:15 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, Jon Maloy <jon.maloy@ericsson.com>,
        Ying Xue <ying.xue@windriver.com>,
        tipc-discussion@lists.sourceforge.net,
        syzkaller-bugs@googlegroups.com
Subject: [PATCH net] tipc: purge deferredq list for each grp member in tipc_group_delete
Date:   Sun, 16 Jun 2019 17:24:07 +0800
Message-Id: <14ff2b79da7b9098fbff2919f0bc5a1afa33fe32.1560677047.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Syzbot reported a memleak caused by grp members' deferredq list not
purged when the grp is be deleted.

The issue occurs when more(msg_grp_bc_seqno(hdr), m->bc_rcv_nxt) in
tipc_group_filter_msg() and the skb will stay in deferredq.

So fix it by calling __skb_queue_purge for each member's deferredq
in tipc_group_delete() when a tipc sk leaves the grp.

Fixes: b87a5ea31c93 ("tipc: guarantee group unicast doesn't bypass group broadcast")
Reported-by: syzbot+78fbe679c8ca8d264a8d@syzkaller.appspotmail.com
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/tipc/group.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/tipc/group.c b/net/tipc/group.c
index 992be61..5f98d38 100644
--- a/net/tipc/group.c
+++ b/net/tipc/group.c
@@ -218,6 +218,7 @@ void tipc_group_delete(struct net *net, struct tipc_group *grp)
 
 	rbtree_postorder_for_each_entry_safe(m, tmp, tree, tree_node) {
 		tipc_group_proto_xmit(grp, m, GRP_LEAVE_MSG, &xmitq);
+		__skb_queue_purge(&m->deferredq);
 		list_del(&m->list);
 		kfree(m);
 	}
-- 
2.1.0

