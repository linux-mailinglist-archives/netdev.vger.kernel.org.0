Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED5211A28E3
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 20:55:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729798AbgDHSzT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 14:55:19 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:38009 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727963AbgDHSzS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Apr 2020 14:55:18 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue109 [212.227.15.145]) with ESMTPA (Nemesis) id
 1MTiHb-1jjihD1mRh-00U4Cr; Wed, 08 Apr 2020 20:54:58 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Boris Pismenny <borisp@mellanox.com>,
        Aviad Yehezkel <aviadye@mellanox.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Sitnicki <jakub@cloudflare.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>,
        Simon Horman <simon.horman@netronome.com>,
        Davide Caratti <dcaratti@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net/tls: fix const assignment warning
Date:   Wed,  8 Apr 2020 20:54:43 +0200
Message-Id: <20200408185452.279040-1-arnd@arndb.de>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:s2ekPbRiCj8XbJbqCtFITnCU5qx2sljqiQialUMXh9xL7YIesyQ
 IunrRXr8qvuNMCnleLG6FrI0yMnVmsqFi4lfjeokgQ7crXdqslhjJ/MYxB/rzVvoHv0DcKy
 UALDPTsBWoN9+NOikWH8mPojs4fvp/DP/QDDkjZo1rwZ6pYJja3ItnjQ/fSGrjHkFs3vB4p
 aC8RxKTyeqPMu0TNJJ7mg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:XNlwvoRgn/I=:GPc09Rlc6JdxKCcvTUiRFh
 rVW3CTvjmOR2VUuEh66iRj7PaBTRepfr8su6tv1gSuRas/a7FyCISchnCEDz+RyEC1YQiGdj6
 YEFxUUpZel6OVHm2oGiWQxzJ8HoWNKKmPBk3eqQeDDQiGwtR9WCesMN++w7KOHDYA93dk3BAI
 OtdkCWVxVMQnBxFzoAiLv1GznKGTAza0Vty89jucwlFYj+nUi1sZxbxCVc8ImcQpBa+fWwdhe
 p50n8+xQw0XNypgSYclT79I6z66q3HvMIrt/Ief6qVZ1jZGv4WsuNzXasG+yfHhvEaPlDXzgf
 mI0RYRq2vH1S4/EIC/yx48LZcfUWBWzw3ylWtZ5E6QBLIuQ6dRn7St85jkvppQ5U4IpTy2qJi
 cKsmhGNcfMUIugnF1mR3z/igT3cnVhvfs6epCK4e1kNXm/Mw/fZgzqPnRQVrjabJZdAoeVf+c
 MHjhY3tbXLROg1tJx0UG6qMuZf8EOw/xrd/gKUHqPO57fAGrqug6bZBiSI2D9a2DzisbOTiBX
 KiHT6mIouLIHgXjJHuq3QxbnN1bSTAF2uAkwX0D5MqQeODST8mNy40JAK8O+uz1l6dx5baMpL
 Z7pXqlrrHHqmJuWXk1pGuX9VwSxt+Sfrroc6zZpTRPidJxXvCr3FR/C1EdqMjf1VnH82stceB
 ResMdJ68vjD0dpWcMKOiSGwDypGweXtN0DlaVMOqxoBNqSJ/9WKqNEJK2EOOZALIZ3foHtygH
 +1Fm+Jv6/xj7i37pjTwfRgiyxIjSeYaEINMwROloFYp2Fl/00EW3Y7QPNaIT3CwbZkfUztsLH
 hY5GP1aH3tOsfc7CZY40wMJHlwatnerCq+0Z9QguDecdZ2/A7c=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Building with some experimental patches, I came across a warning
in the tls code:

include/linux/compiler.h:215:30: warning: assignment discards 'const' qualifier from pointer target type [-Wdiscarded-qualifiers]
  215 |  *(volatile typeof(x) *)&(x) = (val);  \
      |                              ^
net/tls/tls_main.c:650:4: note: in expansion of macro 'smp_store_release'
  650 |    smp_store_release(&saved_tcpv4_prot, prot);

This appears to be a legitimate warning about assigning a const pointer
into the non-const 'saved_tcpv4_prot' global. Annotate both the ipv4 and
ipv6 pointers 'const' to make the code internally consistent.

Fixes: 5bb4c45d466c ("net/tls: Read sk_prot once when building tls proto ops")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 net/tls/tls_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index 156efce50dbd..0e989005bdc2 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -56,9 +56,9 @@ enum {
 	TLS_NUM_PROTS,
 };
 
-static struct proto *saved_tcpv6_prot;
+static const struct proto *saved_tcpv6_prot;
 static DEFINE_MUTEX(tcpv6_prot_mutex);
-static struct proto *saved_tcpv4_prot;
+static const struct proto *saved_tcpv4_prot;
 static DEFINE_MUTEX(tcpv4_prot_mutex);
 static struct proto tls_prots[TLS_NUM_PROTS][TLS_NUM_CONFIG][TLS_NUM_CONFIG];
 static struct proto_ops tls_sw_proto_ops;
-- 
2.26.0

