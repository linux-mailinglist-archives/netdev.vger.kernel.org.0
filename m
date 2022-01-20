Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE81A4947CA
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 08:05:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237946AbiATHFg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 02:05:36 -0500
Received: from m12-15.163.com ([220.181.12.15]:14924 "EHLO m12-15.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232999AbiATHFf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Jan 2022 02:05:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=Message-ID:Date:MIME-Version:From:Subject; bh=gUuxI
        np6kIAi1Ks8ru5WQHcZS8rqBOsJ2rSgr1rJwg4=; b=XfLYk3PR6mRJFQykVgMfD
        Zk7bdcDEwIuFQX8UXvvIR2H5wkWOudXBmBi8Pn6Dc34nf12g7q3qNvxysGMJv4eY
        3/kd0EPt/0wcf1UzktWQCP4HvOIGzwUXYFbCt+lFe6SglX9dFBk5Jg6W6gL6Lcco
        ZLLHNBRKyEFIUAz5+jw2KY=
Received: from [192.168.16.100] (unknown [110.86.5.94])
        by smtp11 (Coremail) with SMTP id D8CowACXOciZCelhCoZtAQ--.15S2;
        Thu, 20 Jan 2022 15:05:16 +0800 (CST)
Message-ID: <04a03a41-6d44-645e-4935-613de20afb2d@163.com>
Date:   Thu, 20 Jan 2022 15:04:58 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
To:     netdev@vger.kernel.org
Cc:     shemminger@linux-foundation.org, noureddine@arista.com,
        Jakub Kicinski <kuba@kernel.org>
From:   Jianguo Wu <wujianguo106@163.com>
Subject: [PATCH] net-procfs: show net devices bound packet types
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: D8CowACXOciZCelhCoZtAQ--.15S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxCr4DKw17WFWxArWfZrWfGrg_yoW5WF4rpa
        95ZFW5Jry8Gw43tr4fXFZFqryfXF4rG34fC3sF9wnak34Dtr1vqF1rKrW2vr15CF4rJas8
        Ja10gFy5C347uaUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UEsj8UUUUU=
X-Originating-IP: [110.86.5.94]
X-CM-SenderInfo: 5zxmxt5qjx0iiqw6il2tof0z/xtbBLQyOkFziaMS0uAAAsh
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wujianguo <wujianguo@chinatelecom.cn>

After commit:7866a621043f ("dev: add per net_device packet type chains"),
we can not get packet types that are bound to a specified net device.

So and a new net procfs(/proc/net/dev_ptype) to show packet types
that are bound to a specified net device.

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
  0800          ip_rcv
  0806          arp_rcv
  86dd          ipv6_rcv
  [root@localhost ~]# cat /proc/net/dev_ptype
  Type Device      Function
  ALL  ens192   tpacket_rcv

Signed-off-by: Jianguo Wu <wujianguo@chinatelecom.cn>
---
 net/core/net-procfs.c | 40 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 39 insertions(+), 1 deletion(-)

diff --git a/net/core/net-procfs.c b/net/core/net-procfs.c
index d8b9dbabd4a4..9589e4faa51c 100644
--- a/net/core/net-procfs.c
+++ b/net/core/net-procfs.c
@@ -280,6 +280,37 @@ static int ptype_seq_show(struct seq_file *seq, void *v)
 	.show  = ptype_seq_show,
 };

+static int dev_ptype_seq_show(struct seq_file *seq, void *v)
+{
+	struct net_device *dev = v;
+	struct packet_type *pt = NULL;
+	struct list_head *ptype_list = NULL;
+
+	if (v == SEQ_START_TOKEN) {
+		seq_puts(seq, "Type Device      Function\n");
+	} else {
+		ptype_list = &dev->ptype_all;
+		list_for_each_entry_rcu(pt, ptype_list, list) {
+			if (pt->type == htons(ETH_P_ALL))
+				seq_puts(seq, "ALL ");
+			else
+				seq_printf(seq, "%04x", ntohs(pt->type));
+
+			seq_printf(seq, " %-8s %ps\n",
+				   pt->dev ? pt->dev->name : "", pt->func);
+		}
+	}
+
+	return 0;
+}
+
+static const struct seq_operations dev_ptype_seq_ops = {
+	.start = dev_seq_start,
+	.next  = dev_seq_next,
+	.stop  = dev_seq_stop,
+	.show  = dev_ptype_seq_show,
+};
+
 static int __net_init dev_proc_net_init(struct net *net)
 {
 	int rc = -ENOMEM;
@@ -294,11 +325,17 @@ static int __net_init dev_proc_net_init(struct net *net)
 			sizeof(struct seq_net_private)))
 		goto out_softnet;

-	if (wext_proc_init(net))
+	if (!proc_create_net("dev_ptype", 0444, net->proc_net, &dev_ptype_seq_ops,
+			     sizeof(struct seq_net_private)))
 		goto out_ptype;
+
+	if (wext_proc_init(net))
+		goto out_dev_ptype;
 	rc = 0;
 out:
 	return rc;
+out_dev_ptype:
+	remove_proc_entry("dev_ptype", net->proc_net);
 out_ptype:
 	remove_proc_entry("ptype", net->proc_net);
 out_softnet:
@@ -312,6 +349,7 @@ static void __net_exit dev_proc_net_exit(struct net *net)
 {
 	wext_proc_exit(net);

+	remove_proc_entry("dev_ptype", net->proc_net);
 	remove_proc_entry("ptype", net->proc_net);
 	remove_proc_entry("softnet_stat", net->proc_net);
 	remove_proc_entry("dev", net->proc_net);
-- 
1.8.3.1

