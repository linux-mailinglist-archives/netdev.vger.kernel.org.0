Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B87986EFC
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 02:55:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405162AbfHIAy6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 20:54:58 -0400
Received: from gate2.alliedtelesis.co.nz ([202.36.163.20]:59147 "EHLO
        gate2.alliedtelesis.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404676AbfHIAy5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 20:54:57 -0400
Received: from mmarshal3.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 71110806B6;
        Fri,  9 Aug 2019 12:54:54 +1200 (NZST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1565312094;
        bh=P49ozH2DAvwt8y1J8WbUcyJoXFazE5b714yGTC0YJrQ=;
        h=From:To:Cc:Subject:Date;
        b=pfmt09bcvfeV2lGKii2doOv/3SuyBMQLDbrTxaW1TajRJ2c1kBEOF2it4qOMRayek
         dqN8LPQcQoGmigoD1VeRxJ1nd8/qm7QhOLFTbn08AO6DfTvd7pZPiSjTBxoIAvthbN
         AmMPbQuX2K+7eyxmmVlNBdFxk7GD0pP4FilsbxCqgDZjXV+m9Nsva1c6KGralqgIGj
         tGYtPeTkM4fC4uLBJhXu216LbGnjmX4qHmsI8rsJmyOqO1rtNNNF6vogmcPxBP1rYg
         m+5FoVhsThf3+xdBsoQzc3qeGeawf3OcznvRFjdNeEyPzgP8tia6Ng56t2Lr1cMuJz
         jlZrTau35L44w==
Received: from smtp (Not Verified[10.32.16.33]) by mmarshal3.atlnz.lc with Trustwave SEG (v7,5,8,10121)
        id <B5d4cc45d0000>; Fri, 09 Aug 2019 12:54:53 +1200
Received: from chrisp-dl.ws.atlnz.lc (chrisp-dl.ws.atlnz.lc [10.33.22.30])
        by smtp (Postfix) with ESMTP id 9DA9013EEDE;
        Fri,  9 Aug 2019 12:54:56 +1200 (NZST)
Received: by chrisp-dl.ws.atlnz.lc (Postfix, from userid 1030)
        id 305D71E0508; Fri,  9 Aug 2019 12:54:54 +1200 (NZST)
From:   Chris Packham <chris.packham@alliedtelesis.co.nz>
To:     jon.maloy@ericsson.com, ying.xue@windriver.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net,
        linux-kernel@vger.kernel.org,
        Chris Packham <chris.packham@alliedtelesis.co.nz>
Subject: [PATCH v2] tipc: initialise addr_trail_end when setting node addresses
Date:   Fri,  9 Aug 2019 12:54:51 +1200
Message-Id: <20190809005451.18881-1-chris.packham@alliedtelesis.co.nz>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
x-atlnz-ls: pat
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ensure addr_trail_end is set to jiffies when configuring the node
address. This ensures that we don't treat the initial value of 0 as
being a wrapped. This isn't a problem when using auto-generated node
addresses because the addr_trail_end is updated for the duplicate
address detection phase.

Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
---
Changes in v2:
- move setting to tipc_set_node_addr() as suggested
- reword commit message

 net/tipc/addr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/tipc/addr.c b/net/tipc/addr.c
index b88d48d00913..0f1eaed1bd1b 100644
--- a/net/tipc/addr.c
+++ b/net/tipc/addr.c
@@ -75,6 +75,7 @@ void tipc_set_node_addr(struct net *net, u32 addr)
 		tipc_set_node_id(net, node_id);
 	}
 	tn->trial_addr =3D addr;
+	tn->addr_trial_end =3D jiffies;
 	pr_info("32-bit node address hash set to %x\n", addr);
 }
=20
--=20
2.22.0

