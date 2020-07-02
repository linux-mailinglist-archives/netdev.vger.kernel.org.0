Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CDA521172B
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 02:28:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728133AbgGBA2G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 20:28:06 -0400
Received: from gate2.alliedtelesis.co.nz ([202.36.163.20]:47391 "EHLO
        gate2.alliedtelesis.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728063AbgGBA1x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 20:27:53 -0400
Received: from mmarshal3.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id 2209D806A8;
        Thu,  2 Jul 2020 12:27:47 +1200 (NZST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1593649667;
        bh=jozzZ/2hQobL5VsEhPHLJTIZ0LjucmUM2BlpcwUKNKs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=V706w5fCDdn1FlTKPNSVSuOhCl1SOQyDpTn/8T6KdnS0iNViyc0uKewXQMpJyi8x9
         znc4CiHTy6t1dpeSB4yXA9o+epaKZpbOVPDDFyq+0/povckTe/p4PFmC2X7pqoLZJv
         xiUqRs4gKZco3BAQljPAXNaaYl9EFDlQfozInHygGEsfTS98LGbmyPNzizz9FkT/p/
         z2s6xjZjEl9z1Srm33FgocK2jDJfEgqRf97ZYUhHhPWN+DnHCzsepakcZ513+JxnCd
         GtukVD3cqfT/p1HX0zNPn2HSRWLG6Gddsc5O58zSj4J9r7BhqJ2zlN9k5aHR+GBvaS
         XU/pVTjhQqJeQ==
Received: from smtp (Not Verified[10.32.16.33]) by mmarshal3.atlnz.lc with Trustwave SEG (v7,5,8,10121)
        id <B5efd2a020001>; Thu, 02 Jul 2020 12:27:46 +1200
Received: from mattb-dl.ws.atlnz.lc (mattb-dl.ws.atlnz.lc [10.33.25.34])
        by smtp (Postfix) with ESMTP id 4A80013EDDC;
        Thu,  2 Jul 2020 12:27:45 +1200 (NZST)
Received: by mattb-dl.ws.atlnz.lc (Postfix, from userid 1672)
        id C86A94A02A3; Thu,  2 Jul 2020 12:27:46 +1200 (NZST)
From:   Matt Bennett <matt.bennett@alliedtelesis.co.nz>
To:     netdev@vger.kernel.org
Cc:     zbr@ioremap.net, ebiederm@xmission.com,
        linux-kernel@vger.kernel.org,
        Matt Bennett <matt.bennett@alliedtelesis.co.nz>
Subject: [PATCH 2/5] connector: Use 'current_user_ns' function
Date:   Thu,  2 Jul 2020 12:26:32 +1200
Message-Id: <20200702002635.8169-3-matt.bennett@alliedtelesis.co.nz>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200702002635.8169-1-matt.bennett@alliedtelesis.co.nz>
References: <20200702002635.8169-1-matt.bennett@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
x-atlnz-ls: pat
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for supporting the connector outside of the default
network namespace we switch to using this function now. As the connector
is still only supported in the default namespace this change is a no-op.

Signed-off-by: Matt Bennett <matt.bennett@alliedtelesis.co.nz>
---
 drivers/connector/cn_proc.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/connector/cn_proc.c b/drivers/connector/cn_proc.c
index 36a7823c56ec..d90aea555a21 100644
--- a/drivers/connector/cn_proc.c
+++ b/drivers/connector/cn_proc.c
@@ -139,11 +139,11 @@ void proc_id_connector(struct task_struct *task, in=
t which_id)
 	rcu_read_lock();
 	cred =3D __task_cred(task);
 	if (which_id =3D=3D PROC_EVENT_UID) {
-		ev->event_data.id.r.ruid =3D from_kuid_munged(&init_user_ns, cred->uid=
);
-		ev->event_data.id.e.euid =3D from_kuid_munged(&init_user_ns, cred->eui=
d);
+		ev->event_data.id.r.ruid =3D from_kuid_munged(current_user_ns(), cred-=
>uid);
+		ev->event_data.id.e.euid =3D from_kuid_munged(current_user_ns(), cred-=
>euid);
 	} else if (which_id =3D=3D PROC_EVENT_GID) {
-		ev->event_data.id.r.rgid =3D from_kgid_munged(&init_user_ns, cred->gid=
);
-		ev->event_data.id.e.egid =3D from_kgid_munged(&init_user_ns, cred->egi=
d);
+		ev->event_data.id.r.rgid =3D from_kgid_munged(current_user_ns(), cred-=
>gid);
+		ev->event_data.id.e.egid =3D from_kgid_munged(current_user_ns(), cred-=
>egid);
 	} else {
 		rcu_read_unlock();
 		return;
@@ -362,7 +362,7 @@ static void cn_proc_mcast_ctl(struct cn_msg *msg,
 		return;
=20
 	/* Can only change if privileged. */
-	if (!__netlink_ns_capable(nsp, &init_user_ns, CAP_NET_ADMIN)) {
+	if (!__netlink_ns_capable(nsp, current_user_ns(), CAP_NET_ADMIN)) {
 		err =3D EPERM;
 		goto out;
 	}
--=20
2.27.0

