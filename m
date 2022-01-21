Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 808CD495C9E
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 10:16:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379695AbiAUJQf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 04:16:35 -0500
Received: from m12-11.163.com ([220.181.12.11]:21394 "EHLO m12-11.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1379693AbiAUJQf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Jan 2022 04:16:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=Message-ID:Date:MIME-Version:From:Subject; bh=AteWn
        C3h4WkXGBWzq718LqhUDvcYoFTFUooY2stq3c4=; b=RCQiBmJvJR5YYsddigBg/
        Iy2X3TzurzMeqsxcSwQnTT4BdMPjCOOTs/ZB2UQrOJset+66/xzkUftnUR7ytGEH
        BfMf1H1rlw+Dp53a/V6NBUd4PdYi7XnNgY+DIYjhugzZaI8vQTKDccq5gX7lJG+i
        peScDGhjgavk5N5xU1IJBA=
Received: from [192.168.16.100] (unknown [110.86.5.94])
        by smtp7 (Coremail) with SMTP id C8CowAA3TUmzeephtUUNBA--.7089S2;
        Fri, 21 Jan 2022 17:15:32 +0800 (CST)
Message-ID: <828e71f6-7366-1455-b1b7-38cfca5a9563@163.com>
Date:   Fri, 21 Jan 2022 17:15:31 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
To:     netdev@vger.kernel.org
Cc:     shemminger@linux-foundation.org, noureddine@arista.com,
        Jakub Kicinski <kuba@kernel.org>
From:   Jianguo Wu <wujianguo106@163.com>
Subject: [PATCH v2] net-procfs: show net devices bound packet types
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: C8CowAA3TUmzeephtUUNBA--.7089S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxCr4kXw18WrW5CFyUZFyUAwb_yoW5GFW8pa
        98ZFy5ArWDGrsxZrs3XFZrXr15urZ7J3Wxu3sFvwsY9asrJr1kX3WfGw17XryrCF4ru3Wq
        gws8Kry5K3y7ZF7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jaFALUUUUU=
X-Originating-IP: [110.86.5.94]
X-CM-SenderInfo: 5zxmxt5qjx0iiqw6il2tof0z/xtbBSRSPkFaEBk3K-QAAss
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jianguo Wu <wujianguo@chinatelecom.cn>

After commit:7866a621043f ("dev: add per net_device packet type chains"),
we can not get packet types that are bound to a specified net device by
/proc/net/ptype, this patch fix the regression.

Run "tcpdump -i ens192 udp -nns0" Before and after apply this patch:

Before:
  [root@localhost ~]# cat /proc/net/ptype
  Type Device      Function
  0800          ip_rcv
  0806          arp_rcv
  86dd          ipv6_rcv

After:
  [root@localhost ~]# cat /proc/net/ptype
  Type Device      Function
  ALL  ens192   tpacket_rcv
  0800          ip_rcv
  0806          arp_rcv
  86dd          ipv6_rcv

v1 -> v2:
  - fix the regression rather than adding new /proc API as
    suggested by Stephen Hemminger.

Fixes: 7866a621043f ("dev: add per net_device packet type chains")
Signed-off-by: Jianguo Wu <wujianguo@chinatelecom.cn>
---
 net/core/net-procfs.c | 35 ++++++++++++++++++++++++++++++++---
 1 file changed, 32 insertions(+), 3 deletions(-)

diff --git a/net/core/net-procfs.c b/net/core/net-procfs.c
index d8b9dbabd4a4..7d2fc6b889f3 100644
--- a/net/core/net-procfs.c
+++ b/net/core/net-procfs.c
@@ -190,12 +190,23 @@ static int softnet_seq_show(struct seq_file *seq, void *v)
 	.show  = softnet_seq_show,
 };

-static void *ptype_get_idx(loff_t pos)
+static void *ptype_get_idx(struct seq_file *seq, loff_t pos)
 {
+	struct list_head *ptype_list = NULL;
 	struct packet_type *pt = NULL;
+	struct net_device *dev;
 	loff_t i = 0;
 	int t;

+	for_each_netdev_rcu(seq_file_net(seq), dev) {
+		ptype_list = &dev->ptype_all;
+		list_for_each_entry_rcu(pt, ptype_list, list) {
+			if (i == pos)
+				return pt;
+			++i;
+		}
+	}
+
 	list_for_each_entry_rcu(pt, &ptype_all, list) {
 		if (i == pos)
 			return pt;
@@ -216,22 +227,40 @@ static void *ptype_seq_start(struct seq_file *seq, loff_t *pos)
 	__acquires(RCU)
 {
 	rcu_read_lock();
-	return *pos ? ptype_get_idx(*pos - 1) : SEQ_START_TOKEN;
+	return *pos ? ptype_get_idx(seq, *pos - 1) : SEQ_START_TOKEN;
 }

 static void *ptype_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 {
+	struct net_device *dev;
 	struct packet_type *pt;
 	struct list_head *nxt;
 	int hash;

 	++*pos;
 	if (v == SEQ_START_TOKEN)
-		return ptype_get_idx(0);
+		return ptype_get_idx(seq, 0);

 	pt = v;
 	nxt = pt->list.next;
+	if (pt->dev) {
+		if (nxt != &pt->dev->ptype_all)
+			goto found;
+
+		dev = pt->dev;
+		for_each_netdev_continue_rcu(seq_file_net(seq), dev) {
+			if (!list_empty(&dev->ptype_all)) {
+				nxt = dev->ptype_all.next;
+				goto found;
+			}
+		}
+
+		nxt = ptype_all.next;
+		goto ptype_all;
+	}
+
 	if (pt->type == htons(ETH_P_ALL)) {
+ptype_all:
 		if (nxt != &ptype_all)
 			goto found;
 		hash = 0;
-- 
1.8.3.1

