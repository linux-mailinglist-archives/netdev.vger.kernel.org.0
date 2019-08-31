Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4138DA4495
	for <lists+netdev@lfdr.de>; Sat, 31 Aug 2019 15:13:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727053AbfHaNNc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Aug 2019 09:13:32 -0400
Received: from mxf1.seznam.cz ([77.75.78.123]:31670 "EHLO mxf1.seznam.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726516AbfHaNNc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 31 Aug 2019 09:13:32 -0400
Received: from email.seznam.cz
        by email-smtpc9a.ko.seznam.cz (email-smtpc9a.ko.seznam.cz [10.53.11.15])
        id 59263c19a7d28eb359a8b201;
        Sat, 31 Aug 2019 15:13:29 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=email.cz; s=beta;
        t=1567257209; bh=Y2btOxW4niJetCFjZRRvSjrI4LjhqTndw2H+culs3eE=;
        h=Received:From:To:Subject:Date:Message-Id:Mime-Version:X-Mailer:
         Content-Type;
        b=bjgbhCcYhQvdtiKBw9MNcnd+1SSXsVL4pre6rXfdo3fDwVhtxaIY8qZDLw6gTS6jK
         KIt+vH0ZjEB47nmqYxrqzLg0YlvE8bGjAdHHF7rKuEqtDRzNCWxPbsXFOsETZl9oXC
         mSZP5Tl/aAxRJ2kZ0SnzA5Kg7phOI41cWNYUW1m0=
Received: from unknown ([::ffff:82.144.143.34])
        by email.seznam.cz (szn-ebox-4.5.361) with HTTP;
        Sat, 31 Aug 2019 15:13:27 +0200 (CEST)
From:   <tomaspaukrt@email.cz>
To:     <netdev@vger.kernel.org>
Subject: iproute2: tc: potential buffer overflow
Date:   Sat, 31 Aug 2019 15:13:27 +0200 (CEST)
Message-Id: <8fo.ZWfD.3kvedbSyU2M.1TQd9t@seznam.cz>
Mime-Version: 1.0 (szn-mime-2.0.45)
X-Mailer: szn-ebox-4.5.361
Content-Type: multipart/mixed;
        boundary="=_58d034d211e2564e0834bfe2=700f373c-f2c6-582a-8fb7-e9ce948cd897_="
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=_58d034d211e2564e0834bfe2=700f373c-f2c6-582a-8fb7-e9ce948cd897_=
Content-Type: text/plain;
	charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi,

there are two potentially dangerous calls of strcpy function in the progra=
m "tc". In the attachment is a patch that fixes this issue.

Tomas
--=_58d034d211e2564e0834bfe2=700f373c-f2c6-582a-8fb7-e9ce948cd897_=
Content-Type: text/x-diff;
	charset=us-ascii;
	name=iproute2-overflow-fix.patch
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	size=917;
	filename=iproute2-overflow-fix.patch

diff --git a/tc/m_ipt.c b/tc/m_ipt.c=0A=
index cc95eab7..cb64380b 100644=0A=
--- a/tc/m_ipt.c=0A=
+++ b/tc/m_ipt.c=0A=
@@ -269,7 +269,8 @@ static int build_st(struct xtables_target *target, str=
uct ipt_entry_target *t)=0A=
 		} else {=0A=
 			target->t =3D t;=0A=
 		}=0A=
-		strcpy(target->t->u.user.name, target->name);=0A=
+		strncpy(target->t->u.user.name, target->name,=0A=
+			sizeof(target->t->u.user.name) - 1);=0A=
 		return 0;=0A=
 	}=0A=
 =0A=
diff --git a/tc/m_xt_old.c b/tc/m_xt_old.c=0A=
index 6a4509a9..974ac496 100644=0A=
--- a/tc/m_xt_old.c=0A=
+++ b/tc/m_xt_old.c=0A=
@@ -177,7 +177,8 @@ build_st(struct xtables_target *target, struct xt_entr=
y_target *t)=0A=
 	if (t =3D=3D NULL) {=0A=
 		target->t =3D fw_calloc(1, size);=0A=
 		target->t->u.target_size =3D size;=0A=
-		strcpy(target->t->u.user.name, target->name);=0A=
+		strncpy(target->t->u.user.name, target->name,=0A=
+			sizeof(target->t->u.user.name) - 1);=0A=
 		set_revision(target->t->u.user.name, target->revision);=0A=
 =0A=
 		if (target->init !=3D NULL)=0A=

--=_58d034d211e2564e0834bfe2=700f373c-f2c6-582a-8fb7-e9ce948cd897_=--

