Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB0176F3F28
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 10:35:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233661AbjEBIfX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 04:35:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233158AbjEBIfW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 04:35:22 -0400
X-Greylist: delayed 523 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 02 May 2023 01:35:17 PDT
Received: from mx0.infotecs.ru (mx0.infotecs.ru [91.244.183.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99FCA3C0C;
        Tue,  2 May 2023 01:35:17 -0700 (PDT)
Received: from mx0.infotecs-nt (localhost [127.0.0.1])
        by mx0.infotecs.ru (Postfix) with ESMTP id 644FD108AF9C;
        Tue,  2 May 2023 11:26:30 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx0.infotecs.ru 644FD108AF9C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=infotecs.ru; s=mx;
        t=1683015990; bh=m8D8J1VQUATKJTZzY+gdxzLobO6f59B6cKPL1bk4e0M=;
        h=From:To:CC:Subject:Date:From;
        b=gASnqsd8nqMY+YDG/pklyCP2unjn/d8TDsDAWtMBrWnLb1tF4J9BqWuHZzSh71tGJ
         YYEhTUuM6zlDrBaJht2r0GIg7WrP5u7fq92FnUrQsOoa+aH4ybB39xadhJbR3dCHwm
         o6NtXsemCP1rS2cAeJwdrMGUq1Z5/e7xl0Z509uQ=
Received: from msk-exch-01.infotecs-nt (msk-exch-01.infotecs-nt [10.0.7.191])
        by mx0.infotecs-nt (Postfix) with ESMTP id 5AC0430633DA;
        Tue,  2 May 2023 11:26:30 +0300 (MSK)
From:   Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>
To:     Neil Horman <nhorman@tuxdriver.com>
CC:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Xin Long <lucien.xin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lvc-project@linuxtesting.org" <lvc-project@linuxtesting.org>
Subject: [PATCH] sctp: fix a potential buffer overflow in
 sctp_sched_set_sched()
Thread-Topic: [PATCH] sctp: fix a potential buffer overflow in
 sctp_sched_set_sched()
Thread-Index: AQHZfM/L3fQfyLzenEuG6u7YLaEbHQ==
Date:   Tue, 2 May 2023 08:26:30 +0000
Message-ID: <20230502082622.2392659-1-Ilia.Gavrilov@infotecs.ru>
Accept-Language: ru-RU, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.17.0.10]
x-exclaimer-md-config: 208ac3cd-1ed4-4982-a353-bdefac89ac0a
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-KLMS-Rule-ID: 1
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Lua-Profiles: 177098 [May 02 2023]
X-KLMS-AntiSpam-Version: 5.9.59.0
X-KLMS-AntiSpam-Envelope-From: Ilia.Gavrilov@infotecs.ru
X-KLMS-AntiSpam-Rate: 0
X-KLMS-AntiSpam-Status: not_detected
X-KLMS-AntiSpam-Method: none
X-KLMS-AntiSpam-Auth: dkim=none
X-KLMS-AntiSpam-Info: LuaCore: 510 510 bc345371020d3ce827abc4c710f5f0ecf15eaf2e, {Tracking_from_domain_doesnt_match_to}, 127.0.0.199:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;infotecs.ru:7.1.1
X-MS-Exchange-Organization-SCL: -1
X-KLMS-AntiSpam-Interceptor-Info: scan successful
X-KLMS-AntiPhishing: Clean, bases: 2023/05/02 06:48:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2023/05/02 03:46:00 #21204364
X-KLMS-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 'sched' index value must be checked before accessing an element
of the 'sctp_sched_ops' array. Otherwise, it can lead to buffer overflow.

Note that it's harmless since the 'sched' parameter is checked before
calling 'sctp_sched_set_sched'.

Found by InfoTeCS on behalf of Linux Verification Center
(linuxtesting.org) with SVACE.

Fixes: 5bbbbe32a431 ("sctp: introduce stream scheduler foundations")
Signed-off-by: Ilia.Gavrilov <Ilia.Gavrilov@infotecs.ru>
---
 net/sctp/stream_sched.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/sctp/stream_sched.c b/net/sctp/stream_sched.c
index 330067002deb..a339917d7197 100644
--- a/net/sctp/stream_sched.c
+++ b/net/sctp/stream_sched.c
@@ -146,18 +146,19 @@ static void sctp_sched_free_sched(struct sctp_stream =
*stream)
 int sctp_sched_set_sched(struct sctp_association *asoc,
 			 enum sctp_sched_type sched)
 {
-	struct sctp_sched_ops *n =3D sctp_sched_ops[sched];
+	struct sctp_sched_ops *n;
 	struct sctp_sched_ops *old =3D asoc->outqueue.sched;
 	struct sctp_datamsg *msg =3D NULL;
 	struct sctp_chunk *ch;
 	int i, ret =3D 0;
=20
-	if (old =3D=3D n)
-		return ret;
-
 	if (sched > SCTP_SS_MAX)
 		return -EINVAL;
=20
+	n =3D sctp_sched_ops[sched];
+	if (old =3D=3D n)
+		return ret;
+
 	if (old)
 		sctp_sched_free_sched(&asoc->stream);
=20
--=20
2.30.2
