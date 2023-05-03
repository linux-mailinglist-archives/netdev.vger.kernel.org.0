Return-Path: <netdev+bounces-163-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ADBF86F5926
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 15:38:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3D9C62815EA
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 13:38:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AB64D524;
	Wed,  3 May 2023 13:38:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D22B46AC
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 13:38:04 +0000 (UTC)
Received: from mx0.infotecs.ru (mx0.infotecs.ru [91.244.183.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CD0E2D4E;
	Wed,  3 May 2023 06:38:02 -0700 (PDT)
Received: from mx0.infotecs-nt (localhost [127.0.0.1])
	by mx0.infotecs.ru (Postfix) with ESMTP id 206DB11226F0;
	Wed,  3 May 2023 16:38:00 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx0.infotecs.ru 206DB11226F0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=infotecs.ru; s=mx;
	t=1683121080; bh=GnrCJpVJCNk0NV1fxPQBwc/dFUx7eKHwkbX2sWg9ynY=;
	h=From:To:CC:Subject:Date:References:In-Reply-To:From;
	b=rfCGWQgjOiqjKlrbomwavwKOtmfxAVYvsgPfwOheu2TNVitZAKzLL1Pe2YZxGYPeb
	 PXolZKZqCI5KuAz6eu/FKPD3d4Nd2tTql1o74wH69XZwxfr4Ke+xHOXvf+KvcK2Pfr
	 mWhohTwaeU2AdI6jTpMXx1aoLfNWsC5DxcVA9xH8=
Received: from msk-exch-02.infotecs-nt (msk-exch-02.infotecs-nt [10.0.7.192])
	by mx0.infotecs-nt (Postfix) with ESMTP id 06C7730B5781;
	Wed,  3 May 2023 16:38:00 +0300 (MSK)
From: Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
CC: Simon Horman <simon.horman@corigine.com>, Neil Horman
	<nhorman@tuxdriver.com>, Xin Long <lucien.xin@gmail.com>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
	<kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	"linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"lvc-project@linuxtesting.org" <lvc-project@linuxtesting.org>
Subject: [PATCH net v4] sctp: fix a potential OOB access in
 sctp_sched_set_sched()
Thread-Topic: [PATCH net v4] sctp: fix a potential OOB access in
 sctp_sched_set_sched()
Thread-Index: AQHZfcR5cbjfVOs8NkmtkUREhiTeCg==
Date: Wed, 3 May 2023 13:37:59 +0000
Message-ID: <20230503133752.4176720-1-Ilia.Gavrilov@infotecs.ru>
References: <ZFJX3KLkcu4nON7l@t14s.localdomain>
In-Reply-To: <ZFJX3KLkcu4nON7l@t14s.localdomain>
Accept-Language: ru-RU, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.17.0.10]
x-exclaimer-md-config: 208ac3cd-1ed4-4982-a353-bdefac89ac0a
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-KLMS-Rule-ID: 1
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Lua-Profiles: 177146 [May 03 2023]
X-KLMS-AntiSpam-Version: 5.9.59.0
X-KLMS-AntiSpam-Envelope-From: Ilia.Gavrilov@infotecs.ru
X-KLMS-AntiSpam-Rate: 0
X-KLMS-AntiSpam-Status: not_detected
X-KLMS-AntiSpam-Method: none
X-KLMS-AntiSpam-Auth: dkim=none
X-KLMS-AntiSpam-Info: LuaCore: 510 510 bc345371020d3ce827abc4c710f5f0ecf15eaf2e, {Tracking_from_domain_doesnt_match_to}, d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;infotecs.ru:7.1.1;127.0.0.199:7.1.2
X-MS-Exchange-Organization-SCL: -1
X-KLMS-AntiSpam-Interceptor-Info: scan successful
X-KLMS-AntiPhishing: Clean, bases: 2023/05/03 11:29:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2023/05/03 11:33:00 #21212261
X-KLMS-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The 'sched' index value must be checked before accessing an element
of the 'sctp_sched_ops' array. Otherwise, it can lead to OOB access.

Note that it's harmless since the 'sched' parameter is checked before
calling 'sctp_sched_set_sched'.

Found by InfoTeCS on behalf of Linux Verification Center
(linuxtesting.org) with SVACE.

Reviewed-by: Xin Long <lucien.xin@gmail.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Ilia.Gavrilov <Ilia.Gavrilov@infotecs.ru>
---
V2:
 - Change the order of local variables=20
 - Specify the target tree in the subject
V3:
 - Change description
 - Remove 'fixes'
V4:
 - revert to V2
 net/sctp/stream_sched.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/sctp/stream_sched.c b/net/sctp/stream_sched.c
index 330067002deb..4d076a9b8592 100644
--- a/net/sctp/stream_sched.c
+++ b/net/sctp/stream_sched.c
@@ -146,18 +146,19 @@ static void sctp_sched_free_sched(struct sctp_stream =
*stream)
 int sctp_sched_set_sched(struct sctp_association *asoc,
 			 enum sctp_sched_type sched)
 {
-	struct sctp_sched_ops *n =3D sctp_sched_ops[sched];
 	struct sctp_sched_ops *old =3D asoc->outqueue.sched;
 	struct sctp_datamsg *msg =3D NULL;
+	struct sctp_sched_ops *n;
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

