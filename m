Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1D9915132D
	for <lists+netdev@lfdr.de>; Tue,  4 Feb 2020 00:24:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726930AbgBCXYz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 18:24:55 -0500
Received: from gate2.alliedtelesis.co.nz ([202.36.163.20]:53510 "EHLO
        gate2.alliedtelesis.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726474AbgBCXYz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Feb 2020 18:24:55 -0500
Received: from mmarshal3.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id B20D3806B7;
        Tue,  4 Feb 2020 12:24:51 +1300 (NZDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1580772291;
        bh=+w7IRyue1MBR5b05+nY7WCMRjhPds+Z3/mRS/mEeTok=;
        h=From:To:Cc:Subject:Date;
        b=XX73JqGEE12oQBq+fCOMPF5GY0PSzjNOWpCLQ4cTsoVc4Y4ZLe3Lz0hoGHGy2d5Tp
         CyvWZOFIwpTVvpT3erAZ2Gx/Cs9eKm0G1j1ingbi0nvba0ozB3LV58i61IpgRV/UAm
         8MYHqHMzkoZthdFgQNvADQtC7VhDWTVktnWENl52KCf59SCjTvGeB8KmTgU94ZVywK
         cW9vxuiUPbRMyNo1vhEG1wvvbU7ozmv0yQiWcadVqnsR3Pu2e6v2b5CWTDqrSmjmuX
         3TK5RuSHcBQX8uoDnnlTZdl9IO01osnXaWUeItNYRLABxEtiTdobaoEkd3q1dG9l9+
         OK45bp90jMCOw==
Received: from smtp (Not Verified[10.32.16.33]) by mmarshal3.atlnz.lc with Trustwave SEG (v7,5,8,10121)
        id <B5e38abc40000>; Tue, 04 Feb 2020 12:24:52 +1300
Received: from ridgek-dl.ws.atlnz.lc (ridgek-dl.ws.atlnz.lc [10.33.22.15])
        by smtp (Postfix) with ESMTP id 5E06113EED4;
        Tue,  4 Feb 2020 12:24:51 +1300 (NZDT)
Received: by ridgek-dl.ws.atlnz.lc (Postfix, from userid 1637)
        id 778F6140303; Tue,  4 Feb 2020 12:24:51 +1300 (NZDT)
From:   Ridge Kennedy <ridge.kennedy@alliedtelesis.co.nz>
To:     netdev@vger.kernel.org
Cc:     gnault@redhat.com, tparkin@katalix.com, jchapman@katalix.com,
        Ridge Kennedy <ridge.kennedy@alliedtelesis.co.nz>
Subject: [PATCH v2 net] l2tp: Allow duplicate session creation with UDP
Date:   Tue,  4 Feb 2020 12:24:00 +1300
Message-Id: <20200203232400.28981-1-ridge.kennedy@alliedtelesis.co.nz>
X-Mailer: git-send-email 2.25.0
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
 net/l2tp/l2tp_core.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index f82ea12bac37..425b95eb7e87 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -322,8 +322,13 @@ int l2tp_session_register(struct l2tp_session *sessi=
on,
=20
 		spin_lock_bh(&pn->l2tp_session_hlist_lock);
=20
+		/* IP encap expects session IDs to be globally unique, while
+		 * UDP encap doesn't.
+		 */
 		hlist_for_each_entry(session_walk, g_head, global_hlist)
-			if (session_walk->session_id =3D=3D session->session_id) {
+			if (session_walk->session_id =3D=3D session->session_id &&
+			    (session_walk->tunnel->encap =3D=3D L2TP_ENCAPTYPE_IP ||
+			     tunnel->encap =3D=3D L2TP_ENCAPTYPE_IP)) {
 				err =3D -EEXIST;
 				goto err_tlock_pnlock;
 			}
--=20
2.25.0

