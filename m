Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4DB6665AEF
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 13:00:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239072AbjAKL7v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 06:59:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbjAKL7E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 06:59:04 -0500
Received: from mx0.infotecs.ru (mx0.infotecs.ru [91.244.183.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F35A21A5;
        Wed, 11 Jan 2023 03:57:42 -0800 (PST)
Received: from mx0.infotecs-nt (localhost [127.0.0.1])
        by mx0.infotecs.ru (Postfix) with ESMTP id 04DDF13607D1;
        Wed, 11 Jan 2023 14:57:40 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx0.infotecs.ru 04DDF13607D1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=infotecs.ru; s=mx;
        t=1673438260; bh=49kxLRcwh3/YE3yMeeqbymVlkYlZKux8cg7gP0DQr/Q=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=G1Al9D6YFmtWwwZNG6Le3yDxDfxYTLh4lUz5oHq9RotGW56oJyPHPNM6xz7sso3mB
         7neg5vAksZVH6fotgD0RKvB13tPugD9Rt/BvV7DNi8FPZaqpxIoZ5dh/MXVJm9szjr
         QDLHvfUDyU+/2YKZplzfi6x5bjlX8CRy6Vokn7vM=
Received: from msk-exch-01.infotecs-nt (msk-exch-01.infotecs-nt [10.0.7.191])
        by mx0.infotecs-nt (Postfix) with ESMTP id 01618316576D;
        Wed, 11 Jan 2023 14:57:40 +0300 (MSK)
Received: from msk-exch-01.infotecs-nt (10.0.7.191) by msk-exch-01.infotecs-nt
 (10.0.7.191) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1118.12; Wed, 11 Jan
 2023 14:57:39 +0300
Received: from msk-exch-01.infotecs-nt ([fe80::89df:c35f:46be:fd07]) by
 msk-exch-01.infotecs-nt ([fe80::89df:c35f:46be:fd07%14]) with mapi id
 15.02.1118.012; Wed, 11 Jan 2023 14:57:39 +0300
From:   Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>
To:     Simon Horman <simon.horman@corigine.com>
CC:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
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
Subject: [PATCH v2] netfilter: ipset: Fix overflow before widen in the
 bitmap_ip_create() function.
Thread-Topic: [PATCH v2] netfilter: ipset: Fix overflow before widen in the
 bitmap_ip_create() function.
Thread-Index: AQHZJbPnp5vC0uHQHEOGReEeA2xCQA==
Date:   Wed, 11 Jan 2023 11:57:39 +0000
Message-ID: <20230111115741.3347031-1-Ilia.Gavrilov@infotecs.ru>
References: <Y76NQ7tQVB7kE0dG@corigine.com>
In-Reply-To: <Y76NQ7tQVB7kE0dG@corigine.com>
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
X-KLMS-AntiSpam-Lua-Profiles: 174635 [Jan 11 2023]
X-KLMS-AntiSpam-Version: 5.9.59.0
X-KLMS-AntiSpam-Envelope-From: Ilia.Gavrilov@infotecs.ru
X-KLMS-AntiSpam-Rate: 0
X-KLMS-AntiSpam-Status: not_detected
X-KLMS-AntiSpam-Method: none
X-KLMS-AntiSpam-Auth: dkim=none
X-KLMS-AntiSpam-Info: LuaCore: 502 502 69dee8ef46717dd3cb3eeb129cb7cc8dab9e30f6, {Tracking_from_domain_doesnt_match_to}, 127.0.0.199:7.1.2;infotecs.ru:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1
X-MS-Exchange-Organization-SCL: -1
X-KLMS-AntiSpam-Interceptor-Info: scan successful
X-KLMS-AntiPhishing: Clean, bases: 2023/01/11 06:26:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2023/01/11 02:11:00 #20757923
X-KLMS-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When first_ip is 0, last_ip is 0xFFFFFFFF, and netmask is 31, the value of
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
v2: Fix typo of the last_ip value in the description. Fix the expression fo=
r 'hosts'.
 net/netfilter/ipset/ip_set_bitmap_ip.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_bitmap_ip.c b/net/netfilter/ipset/i=
p_set_bitmap_ip.c
index a8ce04a4bb72..e4fa00abde6a 100644
--- a/net/netfilter/ipset/ip_set_bitmap_ip.c
+++ b/net/netfilter/ipset/ip_set_bitmap_ip.c
@@ -308,8 +308,8 @@ bitmap_ip_create(struct net *net, struct ip_set *set, s=
truct nlattr *tb[],
 			return -IPSET_ERR_BITMAP_RANGE;
=20
 		pr_debug("mask_bits %u, netmask %u\n", mask_bits, netmask);
-		hosts =3D 2 << (32 - netmask - 1);
-		elements =3D 2 << (netmask - mask_bits - 1);
+		hosts =3D 2U << (32 - netmask - 1);
+		elements =3D 2UL << (netmask - mask_bits - 1);
 	}
 	if (elements > IPSET_BITMAP_MAX_RANGE + 1)
 		return -IPSET_ERR_BITMAP_RANGE_SIZE;
--=20
2.30.2
