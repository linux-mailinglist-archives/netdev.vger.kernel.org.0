Return-Path: <netdev+bounces-4593-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F88270D76F
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 10:29:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 28A0C1C20C39
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 08:29:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CA961DDF9;
	Tue, 23 May 2023 08:29:51 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61F421D2BF
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 08:29:51 +0000 (UTC)
Received: from mx0.infotecs.ru (mx0.infotecs.ru [91.244.183.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12D5A2695;
	Tue, 23 May 2023 01:29:48 -0700 (PDT)
Received: from mx0.infotecs-nt (localhost [127.0.0.1])
	by mx0.infotecs.ru (Postfix) with ESMTP id 99E0D119C847;
	Tue, 23 May 2023 11:29:44 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx0.infotecs.ru 99E0D119C847
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=infotecs.ru; s=mx;
	t=1684830584; bh=l7tm0vAG33rwVVbla8sHO3ovuZj7nN3i8qj/PPGqDcM=;
	h=From:To:CC:Subject:Date:From;
	b=B7wONk6/8zrDooE5B3FZP9t+Xo68hCD5k+HYS+E3Qcz8ygubne07IWje4fdECAkeR
	 joYL9pH8Kd1m2/ZE666bA0ulxMNQzvTrw/ehQfDOWEKc/cYeHarTpzaIaCA9xDIDkG
	 QE46XlSqQIgqA8zVG29toO+Il3gik2T2HnXt2MCQ=
Received: from msk-exch-01.infotecs-nt (msk-exch-01.infotecs-nt [10.0.7.191])
	by mx0.infotecs-nt (Postfix) with ESMTP id 96F5A30CFAF2;
	Tue, 23 May 2023 11:29:44 +0300 (MSK)
From: Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>
To: "David S. Miller" <davem@davemloft.net>
CC: David Ahern <dsahern@kernel.org>, Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, "Vlad
 Yasevich" <vyasevic@redhat.com>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "lvc-project@linuxtesting.org"
	<lvc-project@linuxtesting.org>
Subject: [PATCH net] ipv6: Fix out-of-bounds access in ipv6_find_tlv()
Thread-Topic: [PATCH net] ipv6: Fix out-of-bounds access in ipv6_find_tlv()
Thread-Index: AQHZjVC60BCTLkGAM0GRT+QNTyB9AA==
Date: Tue, 23 May 2023 08:29:44 +0000
Message-ID: <20230523082903.117626-1-Ilia.Gavrilov@infotecs.ru>
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
X-KLMS-AntiSpam-Lua-Profiles: 177530 [May 23 2023]
X-KLMS-AntiSpam-Version: 5.9.59.0
X-KLMS-AntiSpam-Envelope-From: Ilia.Gavrilov@infotecs.ru
X-KLMS-AntiSpam-Rate: 0
X-KLMS-AntiSpam-Status: not_detected
X-KLMS-AntiSpam-Method: none
X-KLMS-AntiSpam-Auth: dkim=none
X-KLMS-AntiSpam-Info: LuaCore: 513 513 41a024eb192917672f8141390381bc9a34ec945f, {Tracking_from_domain_doesnt_match_to}, 127.0.0.199:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;infotecs.ru:7.1.1
X-MS-Exchange-Organization-SCL: -1
X-KLMS-AntiSpam-Interceptor-Info: scan successful
X-KLMS-AntiPhishing: Clean, bases: 2023/05/23 07:14:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2023/05/23 05:11:00 #21371280
X-KLMS-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

optlen is fetched without checking whether there is more than one byte to p=
arse.
It can lead to out-of-bounds access.

Found by InfoTeCS on behalf of Linux Verification Center
(linuxtesting.org) with SVACE.

Fixes: 3c73a0368e99 ("ipv6: Update ipv6 static library with newly needed fu=
nctions")
Signed-off-by: Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>
---
 net/ipv6/exthdrs_core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv6/exthdrs_core.c b/net/ipv6/exthdrs_core.c
index da46c4284676..49e31e4ae7b7 100644
--- a/net/ipv6/exthdrs_core.c
+++ b/net/ipv6/exthdrs_core.c
@@ -143,6 +143,8 @@ int ipv6_find_tlv(const struct sk_buff *skb, int offset=
, int type)
 			optlen =3D 1;
 			break;
 		default:
+			if (len < 2)
+				goto bad;
 			optlen =3D nh[offset + 1] + 2;
 			if (optlen > len)
 				goto bad;
--=20
2.30.2

