Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A4082191F2
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 23:07:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726129AbgGHVHo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 17:07:44 -0400
Received: from gate2.alliedtelesis.co.nz ([202.36.163.20]:57475 "EHLO
        gate2.alliedtelesis.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725964AbgGHVHo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 17:07:44 -0400
Received: from mmarshal3.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 69BA28011F;
        Thu,  9 Jul 2020 09:07:41 +1200 (NZST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1594242461;
        bh=lOcqW9kQBQPUKzn+30nL5JxuhuLG/kivjJrZYxfwTPk=;
        h=From:To:Cc:Subject:Date;
        b=PYntDVm/kOXFeLFLSv/YvB2ZgwrpvamSLf9HgLHh8S1p+jie/31lL1KDjdFWvBoFV
         nefWoI949/rrlfez5UpObMKaUpDaYOqAPRi87rq7diA1znfWEhRLa6fVPcsLyyZ/rA
         H4u0vAqBNcXa5d1y5MWFjQRrc4zAEEiprk1gAjqr8m1uTM8pP36X8kzDf1V57t1e13
         /QDulgqu8sWTOHYG1ucbyGovY2E/En850nwKzVQTtTZZPqd2W3ACxWzY5l6oHW8j4/
         5OzGAnDwzmNZXXZGovIpmA+qze8W5jvteYecfvL0Y/CdR4MPrLREMD5DBGvkscdfMa
         /ZzrKAd7J6FLA==
Received: from smtp (Not Verified[10.32.16.33]) by mmarshal3.atlnz.lc with Trustwave SEG (v7,5,8,10121)
        id <B5f06359b0000>; Thu, 09 Jul 2020 09:07:41 +1200
Received: from hamishm-dl.ws.atlnz.lc (hamishm-dl.ws.atlnz.lc [10.33.24.30])
        by smtp (Postfix) with ESMTP id 2B07A13EEA8;
        Thu,  9 Jul 2020 09:07:38 +1200 (NZST)
Received: by hamishm-dl.ws.atlnz.lc (Postfix, from userid 1133)
        id DDDFE2A00D7; Thu,  9 Jul 2020 09:07:17 +1200 (NZST)
From:   Hamish Martin <hamish.martin@alliedtelesis.co.nz>
To:     davem@davemloft.net, kuba@kernel.org, jmaloy@redhat.com,
        ying.xue@windriver.com
Cc:     netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net,
        tuong.t.lien@dektech.com.au, hoang.h.le@dektech.com.au,
        canh.d.luu@dektech.com.au, chris.packham@alliedtelesis.co.nz,
        john.thompson@alliedtelesis.co.nz,
        Hamish Martin <hamish.martin@alliedtelesis.co.nz>
Subject: [PATCH v2] tipc: fix retransmission on unicast links
Date:   Thu,  9 Jul 2020 09:06:44 +1200
Message-Id: <20200708210644.27161-1-hamish.martin@alliedtelesis.co.nz>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
x-atlnz-ls: pat
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A scenario has been observed where a 'bc_init' message for a link is not
retransmitted if it fails to be received by the peer. This leads to the
peer never establishing the link fully and it discarding all other data
received on the link. In this scenario the message is lost in transit to
the peer.

The issue is traced to the 'nxt_retr' field of the skb not being
initialised for links that aren't a bc_sndlink. This leads to the
comparison in tipc_link_advance_transmq() that gates whether to attempt
retransmission of a message performing in an undesirable way.
Depending on the relative value of 'jiffies', this comparison:
    time_before(jiffies, TIPC_SKB_CB(skb)->nxt_retr)
may return true or false given that 'nxt_retr' remains at the
uninitialised value of 0 for non bc_sndlinks.

This is most noticeable shortly after boot when jiffies is initialised
to a high value (to flush out rollover bugs) and we compare a jiffies of,
say, 4294940189 to zero. In that case time_before returns 'true' leading
to the skb not being retransmitted.

The fix is to ensure that all skbs have a valid 'nxt_retr' time set for
them and this is achieved by refactoring the setting of this value into
a central function.
With this fix, transmission losses of 'bc_init' messages do not stall
the link establishment forever because the 'bc_init' message is
retransmitted and the link eventually establishes correctly.

Fixes: 382f598fb66b ("tipc: reduce duplicate packets for unicast traffic"=
)
Acked-by: Jon Maloy <jmaloy@redhat.com>
Signed-off-by: Hamish Martin <hamish.martin@alliedtelesis.co.nz>
---

Changes in v2:
- Ack from Jon Molloy
- Added Fixes tag
- submitting to netdev. v1 went to tipc-discussion only

 net/tipc/link.c | 26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

diff --git a/net/tipc/link.c b/net/tipc/link.c
index ee3b8d0576b8..263d950e70e9 100644
--- a/net/tipc/link.c
+++ b/net/tipc/link.c
@@ -921,6 +921,21 @@ static void link_prepare_wakeup(struct tipc_link *l)
=20
 }
=20
+/**
+ * tipc_link_set_skb_retransmit_time - set the time at which retransmiss=
ion of
+ *                                     the given skb should be next atte=
mpted
+ * @skb: skb to set a future retransmission time for
+ * @l: link the skb will be transmitted on
+ */
+static void tipc_link_set_skb_retransmit_time(struct sk_buff *skb,
+					      struct tipc_link *l)
+{
+	if (link_is_bc_sndlink(l))
+		TIPC_SKB_CB(skb)->nxt_retr =3D TIPC_BC_RETR_LIM;
+	else
+		TIPC_SKB_CB(skb)->nxt_retr =3D TIPC_UC_RETR_TIME;
+}
+
 void tipc_link_reset(struct tipc_link *l)
 {
 	struct sk_buff_head list;
@@ -1036,9 +1051,7 @@ int tipc_link_xmit(struct tipc_link *l, struct sk_b=
uff_head *list,
 				return -ENOBUFS;
 			}
 			__skb_queue_tail(transmq, skb);
-			/* next retransmit attempt */
-			if (link_is_bc_sndlink(l))
-				TIPC_SKB_CB(skb)->nxt_retr =3D TIPC_BC_RETR_LIM;
+			tipc_link_set_skb_retransmit_time(skb, l);
 			__skb_queue_tail(xmitq, _skb);
 			TIPC_SKB_CB(skb)->ackers =3D l->ackers;
 			l->rcv_unacked =3D 0;
@@ -1139,9 +1152,7 @@ static void tipc_link_advance_backlog(struct tipc_l=
ink *l,
 		if (unlikely(skb =3D=3D l->backlog[imp].target_bskb))
 			l->backlog[imp].target_bskb =3D NULL;
 		__skb_queue_tail(&l->transmq, skb);
-		/* next retransmit attempt */
-		if (link_is_bc_sndlink(l))
-			TIPC_SKB_CB(skb)->nxt_retr =3D TIPC_BC_RETR_LIM;
+		tipc_link_set_skb_retransmit_time(skb, l);
=20
 		__skb_queue_tail(xmitq, _skb);
 		TIPC_SKB_CB(skb)->ackers =3D l->ackers;
@@ -1584,8 +1595,7 @@ static int tipc_link_advance_transmq(struct tipc_li=
nk *l, struct tipc_link *r,
 			/* retransmit skb if unrestricted*/
 			if (time_before(jiffies, TIPC_SKB_CB(skb)->nxt_retr))
 				continue;
-			TIPC_SKB_CB(skb)->nxt_retr =3D (is_uc) ?
-					TIPC_UC_RETR_TIME : TIPC_BC_RETR_LIM;
+			tipc_link_set_skb_retransmit_time(skb, l);
 			_skb =3D pskb_copy(skb, GFP_ATOMIC);
 			if (!_skb)
 				continue;
--=20
2.27.0

