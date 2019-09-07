Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2549AAC6E3
	for <lists+netdev@lfdr.de>; Sat,  7 Sep 2019 15:57:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390240AbfIGN5v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Sep 2019 09:57:51 -0400
Received: from mxc1.seznam.cz ([77.75.79.23]:27390 "EHLO mxc1.seznam.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388458AbfIGN5v (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 7 Sep 2019 09:57:51 -0400
X-Greylist: delayed 831 seconds by postgrey-1.27 at vger.kernel.org; Sat, 07 Sep 2019 09:57:49 EDT
Received: from email.seznam.cz
        by email-smtpc4a.ko.seznam.cz (email-smtpc4a.ko.seznam.cz [10.53.10.105])
        id 2e5993aed0ad21042ed71db6;
        Sat, 07 Sep 2019 15:57:48 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=email.cz; s=beta;
        t=1567864668; bh=PhSESgMjFzSoOhtluOWqQddrbT48wDu7jTUGH3S4xdc=;
        h=Received:From:To:Cc:Subject:Date:Message-Id:References:
         Mime-Version:X-Mailer:Content-Type;
        b=PQlViTsm5vKyX6hCWHx1vnUDa3G/4S/4E8talx//F+DupM/CWuiAGm4Rg6WFhPKD3
         3dXL2EH9pNGPg8YzqSVCwYl2rsuDoPPVICkvb3jWFFlohTsYh5uYD6aO6Vz0W2TGNq
         EtrccjKaj9Y8t7GBQAZVRf7syI/96FOHgow1oc1w=
Received: from unknown ([::ffff:82.144.143.34])
        by email.seznam.cz (szn-ebox-4.5.361) with HTTP;
        Sat, 07 Sep 2019 15:43:54 +0200 (CEST)
From:   <tomaspaukrt@email.cz>
To:     "Stephen Hemminger" <stephen@networkplumber.org>
Cc:     <netdev@vger.kernel.org>
Subject: Re: iproute2: tc: potential buffer overflow
Date:   Sat, 07 Sep 2019 15:43:54 +0200 (CEST)
Message-Id: <GDc.ZWft.5PWTByZfjjr.1TSxGQ@seznam.cz>
References: <8fo.ZWfD.3kvedbSyU2M.1TQd9t@seznam.cz>
        <20190831083751.3814ee37@hermes.lan>
Mime-Version: 1.0 (szn-mime-2.0.45)
X-Mailer: szn-ebox-4.5.361
Content-Type: multipart/mixed;
        boundary="=_10e0b20c4518cbd37ab2c2b4=700f373c-f2c6-582a-8fb7-e9ce948cd897_="
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=_10e0b20c4518cbd37ab2c2b4=700f373c-f2c6-582a-8fb7-e9ce948cd897_=
Content-Type: text/plain;
	charset=utf-8
Content-Transfer-Encoding: quoted-printable

The updated patch is in the attachment.

---------- P=C5=AFvodn=C3=AD e-mail ----------
Od: Stephen Hemminger <stephen@networkplumber.org>
Komu: tomaspaukrt@email.cz
Datum: 31. 8. 2019 17:38:01
P=C5=99edm=C4=9Bt: Re: iproute2: tc: potential buffer overflow
On Sat, 31 Aug 2019 15:13:27 +0200 (CEST)
<tomaspaukrt@email.cz> wrote:

> Hi,
> 
> there are two potentially dangerous calls of strcpy function in the prog=
ram "tc". In the attachment is a patch that fixes this issue.
> 
> Tomas

This looks correct.

Please fix with strlcpy() instead; that is clearer.
Plus you can use XT_EXTENSION_MAX_NAMELEN here (optional).
--=_10e0b20c4518cbd37ab2c2b4=700f373c-f2c6-582a-8fb7-e9ce948cd897_=
Content-Type: text/x-diff;
	charset=us-ascii;
	name=iproute2-overflow-fix.patch
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	size=1075;
	filename=iproute2-overflow-fix.patch

commit 46be35fbded24c75786ce178c516d7fba991a90a=0A=
Author: Tomas Paukrt <tomaspaukrt@email.cz>=0A=
Date:   Sat Sep 7 15:34:30 2019 +0200=0A=
=0A=
    tc: fix potential buffer overflow=0A=
=0A=
diff --git a/tc/m_ipt.c b/tc/m_ipt.c=0A=
index cc95eab..e47ae6b 100644=0A=
--- a/tc/m_ipt.c=0A=
+++ b/tc/m_ipt.c=0A=
@@ -269,7 +269,8 @@ static int build_st(struct xtables_target *target, str=
uct ipt_entry_target *t)=0A=
 		} else {=0A=
 			target->t =3D t;=0A=
 		}=0A=
-		strcpy(target->t->u.user.name, target->name);=0A=
+		strlcpy(target->t->u.user.name, target->name,=0A=
+			sizeof(target->t->u.user.name));=0A=
 		return 0;=0A=
 	}=0A=
 =0A=
diff --git a/tc/m_xt_old.c b/tc/m_xt_old.c=0A=
index 6a4509a..dd27adf 100644=0A=
--- a/tc/m_xt_old.c=0A=
+++ b/tc/m_xt_old.c=0A=
@@ -177,7 +177,8 @@ build_st(struct xtables_target *target, struct xt_entr=
y_target *t)=0A=
 	if (t =3D=3D NULL) {=0A=
 		target->t =3D fw_calloc(1, size);=0A=
 		target->t->u.target_size =3D size;=0A=
-		strcpy(target->t->u.user.name, target->name);=0A=
+		strlcpy(target->t->u.user.name, target->name,=0A=
+			sizeof(target->t->u.user.name));=0A=
 		set_revision(target->t->u.user.name, target->revision);=0A=
 =0A=
 		if (target->init !=3D NULL)=0A=

--=_10e0b20c4518cbd37ab2c2b4=700f373c-f2c6-582a-8fb7-e9ce948cd897_=--

