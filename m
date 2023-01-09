Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F08246624BA
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 12:54:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234714AbjAILyV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 06:54:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236585AbjAILyG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 06:54:06 -0500
X-Greylist: delayed 305 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 09 Jan 2023 03:54:04 PST
Received: from mx0.infotecs.ru (mx0.infotecs.ru [91.244.183.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E1FBBC4;
        Mon,  9 Jan 2023 03:54:04 -0800 (PST)
Received: from mx0.infotecs-nt (localhost [127.0.0.1])
        by mx0.infotecs.ru (Postfix) with ESMTP id 9906B115A6D0;
        Mon,  9 Jan 2023 14:54:02 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx0.infotecs.ru 9906B115A6D0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=infotecs.ru; s=mx;
        t=1673265242; bh=ZXSwrerDkXcdQ+WWtvdH5WrD8pokhX2bGkxfVSiTOuA=;
        h=From:To:CC:Subject:Date:From;
        b=CS9j6l5TWg9+Ga6JM9yDos8KAzAPKbUaZu78AJjGkHMMoRGojxOEqZ5gs2PSAKpP0
         8+83VAl2swHBEa7O78b6wrUc4mxXO+jCUMffcUW52wvTpirD0bJFQWkVVTlZWXQ5dS
         PM51tFwMj0HrGCFN31Of85Z+8CdZZEOg5XRtLdvM=
Received: from msk-exch-01.infotecs-nt (msk-exch-01.infotecs-nt [10.0.7.191])
        by mx0.infotecs-nt (Postfix) with ESMTP id 968D130D0A0A;
        Mon,  9 Jan 2023 14:54:02 +0300 (MSK)
Received: from msk-exch-01.infotecs-nt (10.0.7.191) by msk-exch-01.infotecs-nt
 (10.0.7.191) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1118.12; Mon, 9 Jan
 2023 14:54:02 +0300
Received: from msk-exch-01.infotecs-nt ([fe80::89df:c35f:46be:fd07]) by
 msk-exch-01.infotecs-nt ([fe80::89df:c35f:46be:fd07%14]) with mapi id
 15.02.1118.012; Mon, 9 Jan 2023 14:54:02 +0300
From:   Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
CC:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "coreteam@netfilter.org" <coreteam@netfilter.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lvc-project@linuxtesting.org" <lvc-project@linuxtesting.org>
Subject: [PATCH] netfilter: ipset: Fix overflow before widen in the
 bitmap_ip_create() function.
Thread-Topic: [PATCH] netfilter: ipset: Fix overflow before widen in the
 bitmap_ip_create() function.
Thread-Index: AQHZJCER6ItbAfvk9EO+bS1fujtoFQ==
Date:   Mon, 9 Jan 2023 11:54:02 +0000
Message-ID: <20230109115432.3001636-1-Ilia.Gavrilov@infotecs.ru>
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
X-KLMS-AntiSpam-Lua-Profiles: 174564 [Jan 09 2023]
X-KLMS-AntiSpam-Version: 5.9.59.0
X-KLMS-AntiSpam-Envelope-From: Ilia.Gavrilov@infotecs.ru
X-KLMS-AntiSpam-Rate: 0
X-KLMS-AntiSpam-Status: not_detected
X-KLMS-AntiSpam-Method: none
X-KLMS-AntiSpam-Auth: dkim=none
X-KLMS-AntiSpam-Info: LuaCore: 502 502 69dee8ef46717dd3cb3eeb129cb7cc8dab9e30f6, {Tracking_from_domain_doesnt_match_to}, infotecs.ru:7.1.1;127.0.0.199:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1
X-MS-Exchange-Organization-SCL: -1
X-KLMS-AntiSpam-Interceptor-Info: scan successful
X-KLMS-AntiPhishing: Clean, bases: 2023/01/09 09:37:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2023/01/09 09:04:00 #20749700
X-KLMS-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When first_ip is 0, last_ip is 0xFFFFFFF, and netmask is 31, the value of
an arithmetic expression 2 << (netmask - mask_bits - 1) is subject
to overflow due to a failure casting operands to a larger data type
before performing the arithmetic.

Note that it's harmless since the value will be checked at the next step.

Found by InfoTeCS on behalf of Linux Verification Center
(linuxtesting.org) with SVACE.

Fixes: b9fed748185a ("netfilter: ipset: Check and reject crazy /0 input par=
ameters")
Signed-off-by: Ilia.Gavrilov <Ilia.Gavrilov@infotecs.ru>
---
 net/netfilter/ipset/ip_set_bitmap_ip.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/ipset/ip_set_bitmap_ip.c b/net/netfilter/ipset/i=
p_set_bitmap_ip.c
index a8ce04a4bb72..b8f0fb37378f 100644
--- a/net/netfilter/ipset/ip_set_bitmap_ip.c
+++ b/net/netfilter/ipset/ip_set_bitmap_ip.c
@@ -309,7 +309,7 @@ bitmap_ip_create(struct net *net, struct ip_set *set, s=
truct nlattr *tb[],
=20
 		pr_debug("mask_bits %u, netmask %u\n", mask_bits, netmask);
 		hosts =3D 2 << (32 - netmask - 1);
-		elements =3D 2 << (netmask - mask_bits - 1);
+		elements =3D 2UL << (netmask - mask_bits - 1);
 	}
 	if (elements > IPSET_BITMAP_MAX_RANGE + 1)
 		return -IPSET_ERR_BITMAP_RANGE_SIZE;
--=20
2.30.2
