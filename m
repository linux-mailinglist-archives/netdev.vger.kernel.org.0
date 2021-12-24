Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D86A47EAC0
	for <lists+netdev@lfdr.de>; Fri, 24 Dec 2021 04:09:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351089AbhLXDJO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 22:09:14 -0500
Received: from mail-m965.mail.126.com ([123.126.96.5]:48346 "EHLO
        mail-m965.mail.126.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351076AbhLXDJO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 22:09:14 -0500
X-Greylist: delayed 1868 seconds by postgrey-1.27 at vger.kernel.org; Thu, 23 Dec 2021 22:09:12 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=KoDSO7RRSOeNU3vg8r
        6/Hs8GY7UKm0pUledHd5dTthw=; b=Bu6XMGk13KFmg9Ht5ph/waHAXJuIUNaM5b
        oNk2AGSoMyRT0D1gbKcgnx+2l3E62vgzt1so5PWWJ4nNKBhqEveC4L8KP+aNoPiW
        iFtxZaHHfi36NAea9WFEaqEwS/vPUwPiFQafp739yUoVjK6lBcAKSVx5T0wEpzLF
        3a2m1iHqA=
Received: from localhost.localdomain (unknown [61.149.132.128])
        by smtp10 (Coremail) with SMTP id NuRpCgBnbFRqMsVhMvm4Aw--.46407S4;
        Fri, 24 Dec 2021 10:37:32 +0800 (CST)
From:   zhang kai <zhangkaiheb@126.com>
To:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        davem@davemloft.net, kuba@kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     zhang kai <zhangkaiheb@126.com>
Subject: [PATCH] netfilter: seqadj: check seq offset before update
Date:   Fri, 24 Dec 2021 10:37:13 +0800
Message-Id: <20211224023713.9260-1-zhangkaiheb@126.com>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: NuRpCgBnbFRqMsVhMvm4Aw--.46407S4
X-Coremail-Antispam: 1Uf129KBjvJXoW7tFW8XF4xCr18ZFy3Cw1DGFg_yoW8GF1rpa
        9Ykryayr17XryIya1xWryvy3Wavws3Gr4UWF9xZayfZ39FqF48KF43tryjgF1rXrs5AF13
        KF4aqFsFgFn5A3DanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0zRW5lnUUUUU=
X-Originating-IP: [61.149.132.128]
X-CM-SenderInfo: x2kd0wxndlxvbe6rjloofrz/1tbi5BNz-lpECeFWtwABss
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

if seq/ack offset is zero, don't update

Signed-off-by: zhang kai <zhangkaiheb@126.com>
---
 net/netfilter/nf_conntrack_seqadj.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nf_conntrack_seqadj.c b/net/netfilter/nf_conntrack_seqadj.c
index 3066449f8bd8..d35e272a2e36 100644
--- a/net/netfilter/nf_conntrack_seqadj.c
+++ b/net/netfilter/nf_conntrack_seqadj.c
@@ -186,11 +186,13 @@ int nf_ct_seq_adjust(struct sk_buff *skb,
 	else
 		seqoff = this_way->offset_before;
 
-	newseq = htonl(ntohl(tcph->seq) + seqoff);
-	inet_proto_csum_replace4(&tcph->check, skb, tcph->seq, newseq, false);
-	pr_debug("Adjusting sequence number from %u->%u\n",
-		 ntohl(tcph->seq), ntohl(newseq));
-	tcph->seq = newseq;
+	if (seqoff) {
+		newseq = htonl(ntohl(tcph->seq) + seqoff);
+		inet_proto_csum_replace4(&tcph->check, skb, tcph->seq, newseq, false);
+		pr_debug("Adjusting sequence number from %u->%u\n",
+			 ntohl(tcph->seq), ntohl(newseq));
+		tcph->seq = newseq;
+	}
 
 	if (!tcph->ack)
 		goto out;
@@ -201,6 +203,9 @@ int nf_ct_seq_adjust(struct sk_buff *skb,
 	else
 		ackoff = other_way->offset_before;
 
+	if (!ackoff)
+		goto out;
+
 	newack = htonl(ntohl(tcph->ack_seq) - ackoff);
 	inet_proto_csum_replace4(&tcph->check, skb, tcph->ack_seq, newack,
 				 false);
-- 
2.17.1

