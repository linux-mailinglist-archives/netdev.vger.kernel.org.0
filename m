Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DE8F13D027
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 23:35:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730602AbgAOWf2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 17:35:28 -0500
Received: from gate2.alliedtelesis.co.nz ([202.36.163.20]:52860 "EHLO
        gate2.alliedtelesis.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728899AbgAOWf2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 17:35:28 -0500
Received: from mmarshal3.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 8D0A583646
        for <netdev@vger.kernel.org>; Thu, 16 Jan 2020 11:35:24 +1300 (NZDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1579127724;
        bh=0nhHBLGmvOULT+ZSNHeCCRUdb3Rf6JmfovIVM2EeNjo=;
        h=From:To:Cc:Subject:Date;
        b=fFMD0veCYmjzkHwA6RHbka9atDweEO0kVCLsMH9uh6pCuGU8FnyjOuwJvIdRZI7bw
         prs5skgt5eXIckAKdA/B8lFyTgTmLK6uMkTRr7tn5sGbDmuKNVvDjZwMB/djb8Q6/H
         DT+8MGCt8aZD6RnLxlR/7MxYJdknROGtimrFunjOBAKwpNBCN8NOto02otBP2y+0/0
         cjEjI46NWwBQAvPpXBKqqqD3w4apxfaBCmE5sZyvfHYXFXyT84OLQ6YsXs58EIcSd0
         ZieyIYNiAdRvj3UGvJHE/itLzwBK6wDIHt1gKBJpQAshEZZsulnSMBcr40gaoaudAR
         8aHLZ5qG4CLKQ==
Received: from smtp (Not Verified[10.32.16.33]) by mmarshal3.atlnz.lc with Trustwave SEG (v7,5,8,10121)
        id <B5e1f93a90000>; Thu, 16 Jan 2020 11:35:24 +1300
Received: from ridgek-dl.ws.atlnz.lc (ridgek-dl.ws.atlnz.lc [10.33.22.46])
        by smtp (Postfix) with ESMTP id 777CC13EEB9;
        Thu, 16 Jan 2020 11:35:20 +1300 (NZDT)
Received: by ridgek-dl.ws.atlnz.lc (Postfix, from userid 1637)
        id 92AD9140BE2; Thu, 16 Jan 2020 11:35:21 +1300 (NZDT)
From:   Ridge Kennedy <ridge.kennedy@alliedtelesis.co.nz>
To:     netdev@vger.kernel.org
Cc:     Ridge Kennedy <ridge.kennedy@alliedtelesis.co.nz>
Subject: [PATCH net] l2tp: Allow duplicate session creation with UDP
Date:   Thu, 16 Jan 2020 11:34:47 +1300
Message-Id: <20200115223446.7420-1-ridge.kennedy@alliedtelesis.co.nz>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
x-atlnz-ls: pat
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the past it was possible to create multiple L2TPv3 sessions with the
same session id as long as the sessions belonged to different tunnels.
The resulting sessions had issues when used with IP encapsulated tunnels,
but worked fine with UDP encapsulated ones. Some applications began to
rely on this behaviour to avoid having to negotiate unique session ids.

Some time ago a change was made to require session ids to be unique acros=
s
all tunnels, breaking the applications making use of this "feature".

This change relaxes the duplicate session id check to allow duplicates
if both of the colliding sessions belong to UDP encapsulated tunnels.

Fixes: dbdbc73b4478 ("l2tp: fix duplicate session creation")
Signed-off-by: Ridge Kennedy <ridge.kennedy@alliedtelesis.co.nz>
---
 net/l2tp/l2tp_core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index f82ea12bac37..0cc86227c618 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -323,7 +323,9 @@ int l2tp_session_register(struct l2tp_session *sessio=
n,
 		spin_lock_bh(&pn->l2tp_session_hlist_lock);
=20
 		hlist_for_each_entry(session_walk, g_head, global_hlist)
-			if (session_walk->session_id =3D=3D session->session_id) {
+			if (session_walk->session_id =3D=3D session->session_id &&
+			    (session_walk->tunnel->encap =3D=3D L2TP_ENCAPTYPE_IP ||
+			     tunnel->encap =3D=3D L2TP_ENCAPTYPE_IP)) {
 				err =3D -EEXIST;
 				goto err_tlock_pnlock;
 			}
--=20
2.24.0

