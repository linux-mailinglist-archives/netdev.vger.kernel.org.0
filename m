Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 341912D469A
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 17:21:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731766AbgLIQTJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 11:19:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:35200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730122AbgLIQTI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Dec 2020 11:19:08 -0500
From:   Jakub Kicinski <kuba@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     davem@davemloft.net, simon.horman@netronome.com
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        Jakub Kicinski <kuba@kernel.org>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH net-next] nfp: silence set but not used warning with IPV6=n
Date:   Wed,  9 Dec 2020 08:18:21 -0800
Message-Id: <20201209161821.1040796-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Test robot reports:

drivers/net/ethernet/netronome/nfp/crypto/tls.c: In function 'nfp_net_tls_rx_resync_req':
drivers/net/ethernet/netronome/nfp/crypto/tls.c:477:18: warning: variable 'ipv6h' set but not used [-Wunused-but-set-variable]
  477 |  struct ipv6hdr *ipv6h;
      |                  ^~~~~
In file included from include/linux/compiler_types.h:65,
                    from <command-line>:
drivers/net/ethernet/netronome/nfp/crypto/tls.c: In function 'nfp_net_tls_add':
include/linux/compiler_attributes.h:208:41: warning: statement will never be executed [-Wswitch-unreachable]
  208 | # define fallthrough                    __attribute__((__fallthrough__))
      |                                         ^~~~~~~~~~~~~
drivers/net/ethernet/netronome/nfp/crypto/tls.c:299:3: note: in expansion of macro 'fallthrough'
  299 |   fallthrough;
      |   ^~~~~~~~~~~

Use the IPv6 header in the switch, it doesn't matter which header
we use to read the version field.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/netronome/nfp/crypto/tls.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/netronome/nfp/crypto/tls.c b/drivers/net/ethernet/netronome/nfp/crypto/tls.c
index 9b32ae46011c..84d66d138c3d 100644
--- a/drivers/net/ethernet/netronome/nfp/crypto/tls.c
+++ b/drivers/net/ethernet/netronome/nfp/crypto/tls.c
@@ -492,7 +492,7 @@ int nfp_net_tls_rx_resync_req(struct net_device *netdev,
 		goto err_cnt_ign;
 	}
 
-	switch (iph->version) {
+	switch (ipv6h->version) {
 	case 4:
 		sk = inet_lookup_established(dev_net(netdev), &tcp_hashinfo,
 					     iph->saddr, th->source, iph->daddr,
-- 
2.26.2

