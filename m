Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B6BF6F44A1
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 15:05:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234343AbjEBNF1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 09:05:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234029AbjEBNFD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 09:05:03 -0400
Received: from mx0.infotecs.ru (mx0.infotecs.ru [91.244.183.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 641CB5252;
        Tue,  2 May 2023 06:04:07 -0700 (PDT)
Received: from mx0.infotecs-nt (localhost [127.0.0.1])
        by mx0.infotecs.ru (Postfix) with ESMTP id 00E2910B66F1;
        Tue,  2 May 2023 16:03:25 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx0.infotecs.ru 00E2910B66F1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=infotecs.ru; s=mx;
        t=1683032605; bh=XeUJxsBSQd1pjrQXTV5YP3H+DxqnTGptCJyjoilPwJg=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=DGsaepVYzleqpK/ZFnyAanNKuYVsN+7vqFFjhly7VO7T2ke37yOfWvRGXkZkKAkQw
         U5cZcETyQBiRXSLU5ucnK2YSPaOMlu/dH4gw1dUKpA4/vpWx5p2jNBcn5+Kn8wND+r
         Uu8pTZnnuoV+0B8Ww4SC1ehiqo6qh4WznO9w6sy4=
Received: from msk-exch-02.infotecs-nt (msk-exch-02.infotecs-nt [10.0.7.192])
        by mx0.infotecs-nt (Postfix) with ESMTP id F0DE130A2CA0;
        Tue,  2 May 2023 16:03:24 +0300 (MSK)
From:   Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>
To:     Simon Horman <simon.horman@corigine.com>
CC:     Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Xin Long <lucien.xin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lvc-project@linuxtesting.org" <lvc-project@linuxtesting.org>
Subject: [PATCH net v2] sctp: fix a potential buffer overflow in
 sctp_sched_set_sched()
Thread-Topic: [PATCH net v2] sctp: fix a potential buffer overflow in
 sctp_sched_set_sched()
Thread-Index: AQHZfPZ6+AjI4Yq7k0+w8RGcNMvKHg==
Date:   Tue, 2 May 2023 13:03:24 +0000
Message-ID: <20230502130316.2680585-1-Ilia.Gavrilov@infotecs.ru>
References: <ZFD6UgOFeUCbbIOC@corigine.com>
In-Reply-To: <ZFD6UgOFeUCbbIOC@corigine.com>
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
X-KLMS-AntiSpam-Lua-Profiles: 177118 [May 02 2023]
X-KLMS-AntiSpam-Version: 5.9.59.0
X-KLMS-AntiSpam-Envelope-From: Ilia.Gavrilov@infotecs.ru
X-KLMS-AntiSpam-Rate: 0
X-KLMS-AntiSpam-Status: not_detected
X-KLMS-AntiSpam-Method: none
X-KLMS-AntiSpam-Auth: dkim=none
X-KLMS-AntiSpam-Info: LuaCore: 510 510 bc345371020d3ce827abc4c710f5f0ecf15eaf2e, {Tracking_from_domain_doesnt_match_to}, 127.0.0.199:7.1.2;infotecs.ru:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1
X-MS-Exchange-Organization-SCL: -1
X-KLMS-AntiSpam-Interceptor-Info: scan successful
X-KLMS-AntiPhishing: Clean, bases: 2023/05/02 11:01:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2023/05/02 09:07:00 #21205017
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
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Ilia.Gavrilov <Ilia.Gavrilov@infotecs.ru>
---
V2:
 - Change the order of local variables=20
 - Specify the target tree in the subject
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
