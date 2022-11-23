Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F5176356BE
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 10:34:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237937AbiKWJdL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 04:33:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237817AbiKWJcU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 04:32:20 -0500
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AEA11C120
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 01:31:22 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id C93872049B;
        Wed, 23 Nov 2022 10:31:20 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id LnfW9s9fvyb7; Wed, 23 Nov 2022 10:31:20 +0100 (CET)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id EECB520501;
        Wed, 23 Nov 2022 10:31:19 +0100 (CET)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id E7F8F80004A;
        Wed, 23 Nov 2022 10:31:19 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 23 Nov 2022 10:31:19 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Wed, 23 Nov
 2022 10:31:19 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 32D1C3182F94; Wed, 23 Nov 2022 10:31:19 +0100 (CET)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 2/6] xfrm: lwtunnel: squelch kernel warning in case XFRM encap type is not available
Date:   Wed, 23 Nov 2022 10:31:12 +0100
Message-ID: <20221123093117.434274-3-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221123093117.434274-1-steffen.klassert@secunet.com>
References: <20221123093117.434274-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eyal Birger <eyal.birger@gmail.com>

Ido reported that a kernel warning [1] can be triggered from
user space when the kernel is compiled with CONFIG_MODULES=y and
CONFIG_XFRM=n when adding an xfrm encap type route, e.g:

$ ip route add 198.51.100.0/24 dev dummy1 encap xfrm if_id 1
Error: lwt encapsulation type not supported.

The reason for the warning is that the LWT infrastructure has an
autoloading feature which is meant only for encap types that don't
use a net device,  which is not the case in xfrm encap.

Mute this warning for xfrm encap as there's no encap module to autoload
in this case.

[1]
 WARNING: CPU: 3 PID: 2746262 at net/core/lwtunnel.c:57 lwtunnel_valid_encap_type+0x4f/0x120
[...]
 Call Trace:
  <TASK>
  rtm_to_fib_config+0x211/0x350
  inet_rtm_newroute+0x3a/0xa0
  rtnetlink_rcv_msg+0x154/0x3c0
  netlink_rcv_skb+0x49/0xf0
  netlink_unicast+0x22f/0x350
  netlink_sendmsg+0x208/0x440
  ____sys_sendmsg+0x21f/0x250
  ___sys_sendmsg+0x83/0xd0
  __sys_sendmsg+0x54/0xa0
  do_syscall_64+0x35/0x80
  entry_SYSCALL_64_after_hwframe+0x63/0xcd

Reported-by: Ido Schimmel <idosch@idosch.org>
Fixes: 2c2493b9da91 ("xfrm: lwtunnel: add lwtunnel support for xfrm interfaces in collect_md mode")
Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
Tested-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/core/lwtunnel.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/core/lwtunnel.c b/net/core/lwtunnel.c
index 6fac2f0ef074..711cd3b4347a 100644
--- a/net/core/lwtunnel.c
+++ b/net/core/lwtunnel.c
@@ -48,9 +48,11 @@ static const char *lwtunnel_encap_str(enum lwtunnel_encap_types encap_type)
 		return "RPL";
 	case LWTUNNEL_ENCAP_IOAM6:
 		return "IOAM6";
+	case LWTUNNEL_ENCAP_XFRM:
+		/* module autoload not supported for encap type */
+		return NULL;
 	case LWTUNNEL_ENCAP_IP6:
 	case LWTUNNEL_ENCAP_IP:
-	case LWTUNNEL_ENCAP_XFRM:
 	case LWTUNNEL_ENCAP_NONE:
 	case __LWTUNNEL_ENCAP_MAX:
 		/* should not have got here */
-- 
2.25.1

