Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC1A884380
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 06:55:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725835AbfHGEzr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 00:55:47 -0400
Received: from gate2.alliedtelesis.co.nz ([202.36.163.20]:55157 "EHLO
        gate2.alliedtelesis.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725792AbfHGEzq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 00:55:46 -0400
Received: from mmarshal3.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 65B24806B6;
        Wed,  7 Aug 2019 16:55:44 +1200 (NZST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1565153744;
        bh=x9ecF6bLMiGMmebBLcnCPuRdPc6IIbrhLzl3HkotE68=;
        h=From:To:Cc:Subject:Date;
        b=fPeSSHzWv7GqtQxygRzPFVzIkCGLov0zduBGpqMASMABcvC68g308wb8r6G8guLjU
         eB5/SiOzvFo+1PIV9HSh3JfCnVbZN0kHHCWbNV3d2tWnn38HDgG7Wo4LkfdjZFX9h5
         umwp8oEbQnd5FJpuHtJoXUJoIAy2cRojrODN7WOgQp/AUFEOaUkxxoQq8195se9iXf
         1ysQLswiwiG57snLNPfLUq/qVgsiWZBs785SvSoi53aNy401hg1kBaRxBF77w/Zdhk
         N5stKB3/5VSLIamRLWvwcNXxiWRTlhzxcgne1+RrgrVhAppoCFmsnm2MU5z7uvtGR5
         qolcnzunju6ZA==
Received: from smtp (Not Verified[10.32.16.33]) by mmarshal3.atlnz.lc with Trustwave SEG (v7,5,8,10121)
        id <B5d4a59d00000>; Wed, 07 Aug 2019 16:55:44 +1200
Received: from chrisp-dl.ws.atlnz.lc (chrisp-dl.ws.atlnz.lc [10.33.22.30])
        by smtp (Postfix) with ESMTP id 84EB713EEDE;
        Wed,  7 Aug 2019 16:55:46 +1200 (NZST)
Received: by chrisp-dl.ws.atlnz.lc (Postfix, from userid 1030)
        id 230AE1E1136; Wed,  7 Aug 2019 16:55:44 +1200 (NZST)
From:   Chris Packham <chris.packham@alliedtelesis.co.nz>
To:     jon.maloy@ericsson.com, ying.xue@windriver.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net,
        linux-kernel@vger.kernel.org,
        Chris Packham <chris.packham@alliedtelesis.co.nz>
Subject: [PATCH] tipc: set addr_trail_end when using explicit node addresses
Date:   Wed,  7 Aug 2019 16:55:43 +1200
Message-Id: <20190807045543.28373-1-chris.packham@alliedtelesis.co.nz>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
x-atlnz-ls: pat
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When tipc uses auto-generated node addresses it goes through a duplicate
address detection phase to ensure the address is unique.

When using explicitly configured node names the DAD phase is skipped.
However addr_trail_end was being left set to 0 which causes parts of the
tipc state machine to assume that the address is not yet valid and
unnecessarily delays the discovery phase. By setting addr_trail_end to
jiffies when using explicit addresses we ensure that we move straight to
discovery.

Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
---
 net/tipc/discover.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/tipc/discover.c b/net/tipc/discover.c
index c138d68e8a69..f83bfe8c9443 100644
--- a/net/tipc/discover.c
+++ b/net/tipc/discover.c
@@ -361,6 +361,8 @@ int tipc_disc_create(struct net *net, struct tipc_bea=
rer *b,
 	if (!tipc_own_addr(net)) {
 		tn->addr_trial_end =3D jiffies + msecs_to_jiffies(1000);
 		msg_set_type(buf_msg(d->skb), DSC_TRIAL_MSG);
+	} else {
+		tn->addr_trial_end =3D jiffies;
 	}
 	memcpy(&d->dest, dest, sizeof(*dest));
 	d->net =3D net;
--=20
2.22.0

