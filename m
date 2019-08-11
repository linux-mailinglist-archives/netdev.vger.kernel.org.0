Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F78A89392
	for <lists+netdev@lfdr.de>; Sun, 11 Aug 2019 22:18:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726484AbfHKUSb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Aug 2019 16:18:31 -0400
Received: from gate2.alliedtelesis.co.nz ([202.36.163.20]:60977 "EHLO
        gate2.alliedtelesis.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725870AbfHKUSb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Aug 2019 16:18:31 -0400
Received: from mmarshal3.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 2CDA7806AC;
        Mon, 12 Aug 2019 08:18:28 +1200 (NZST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1565554708;
        bh=KbEn6R22gp+fzANJwM1Iwq1ow4g7T1cFqyGR5ntWCRA=;
        h=From:To:Cc:Subject:Date;
        b=Xe+LiSnEiE5W2jpgbzUmgEfNCbN/cahGB1/jNSFGsKewwXfj/cjj0JHs3/zjxMzN7
         GU9BOmRts0Ne4quigGWFzn5nYN8kVOGS6XJKVw8/1DmoXLfe4k0we8EWblPOGqK6Im
         qohgmKlbbsc7d1WLFnatWn8R811hl7kLsLYORjvObBcu7dlnBMibzSrlcPE6e20mNZ
         KVbZwTW1dACu/bnAlfuFE2iH8YbDYCkN837TEtMtgUA9+WqaaOyNIjdEgFpvdXE+I1
         MtH1pzMcbAWICpMM5Bw+WdpjV6ImpQFGGfAgWV9vMdlwfgxXQVZRZD0O4VIgBiIZpO
         Um/CVdpfnBRkQ==
Received: from smtp (Not Verified[10.32.16.33]) by mmarshal3.atlnz.lc with Trustwave SEG (v7,5,8,10121)
        id <B5d5078130000>; Mon, 12 Aug 2019 08:18:27 +1200
Received: from chrisp-dl.ws.atlnz.lc (chrisp-dl.ws.atlnz.lc [10.33.22.30])
        by smtp (Postfix) with ESMTP id 63CD813EC73;
        Mon, 12 Aug 2019 08:18:30 +1200 (NZST)
Received: by chrisp-dl.ws.atlnz.lc (Postfix, from userid 1030)
        id D1DF41E0508; Mon, 12 Aug 2019 08:18:27 +1200 (NZST)
From:   Chris Packham <chris.packham@alliedtelesis.co.nz>
To:     jon.maloy@ericsson.com, ying.xue@windriver.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net,
        linux-kernel@vger.kernel.org,
        Chris Packham <chris.packham@alliedtelesis.co.nz>
Subject: [PATCH v3] tipc: initialise addr_trail_end when setting node addresses
Date:   Mon, 12 Aug 2019 08:18:25 +1200
Message-Id: <20190811201825.13876-1-chris.packham@alliedtelesis.co.nz>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
x-atlnz-ls: pat
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We set the field 'addr_trial_end' to 'jiffies', instead of the current
value 0, at the moment the node address is initialized. This guarantees
we don't inadvertently enter an address trial period when the node
address is explicitly set by the user.

Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
Acked-by: Jon Maloy <jon.maloy@ericsson.com>
---

Notes:
    Changes in v3:
    - Reword commit message as suggested
    - Include acl from Jon
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

