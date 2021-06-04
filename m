Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AB4139B73C
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 12:38:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230041AbhFDKju (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 06:39:50 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:12357 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbhFDKjt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Jun 2021 06:39:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1622803083; x=1654339083;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=4sXc9RFUGLKrPBrTE/aA0NwwQbDYVun7rUmFq44v2zA=;
  b=KZmv+fk030p1ROt1V3Mb0BeYbAb9YOJmx0mZuNGvEFSzTngDIaoW+GKF
   NixSCOP7VvGa3IpLKpHDVha3ym9Wg/jR0q32rk9Mdp79ihgdDjm7OKvzG
   S+OX8Oheyl9zFMN2fnUpsMeaVOqqAepXBzEh5rOoZf1hjtiGPLLuetuUu
   7o9Y+/WbyoYcSkfpLEw3t+6s8tnEeXPDMQWLYhptrpnkeLNhFYTJhFcsq
   ppHWY/lZ/D6rJLP120jjFhEuvCZ2iz1FnwzvkOEueeFKHp00nLKFqdnj3
   6rqmQpzN5IuVcEQ4lFaPv+eSWHNkBJgUgFZUFGbHSv6Non0LL4lRH3lKH
   w==;
IronPort-SDR: abUF0oX24C7cEcjkxaszfgou2C+JQ+g7Cgg7mlDxB67pz2LZxGWM0gNeJSpYgSr9rxLFWdGOpt
 cBDo5VV8is6ATpynZlOqOoXMlUelK5Mi9JQaOvHthZ3zdfNituA9qEjAmKxYe96w74WmekP5Kq
 Icqk19Cmb7tPDmcQlZR74z8V+Szibp1xN/bUkFaNXeruhZ0LWK3JbRo1+YZVC7gHWec0ff8+gU
 W2IGbjzoPrOauJWvIwfG+UKFsR1vucKXeoSGkuMAheeog84fhQpA7XDSW1zA6CYGPCxbuQvvR4
 4yA=
X-IronPort-AV: E=Sophos;i="5.83,248,1616482800"; 
   d="scan'208";a="124079584"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Jun 2021 03:38:02 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 4 Jun 2021 03:38:02 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2176.2 via Frontend Transport; Fri, 4 Jun 2021 03:38:00 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <roopa@nvidia.com>, <nikolay@nvidia.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <UNGLinuxDriver@microchip.com>
CC:     <bridge@lists.linux-foundation.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next] net: bridge: mrp: Update ring transitions.
Date:   Fri, 4 Jun 2021 12:37:47 +0200
Message-ID: <20210604103747.3824212-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

According to the standard IEC 62439-2, the number of transitions needs
to be counted for each transition 'between' ring state open and ring
state closed and not from open state to closed state.

Therefore fix this for both ring and interconnect ring.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 net/bridge/br_mrp.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/bridge/br_mrp.c b/net/bridge/br_mrp.c
index cd2b1e424e54..f7012b7d7ce4 100644
--- a/net/bridge/br_mrp.c
+++ b/net/bridge/br_mrp.c
@@ -627,8 +627,7 @@ int br_mrp_set_ring_state(struct net_bridge *br,
 	if (!mrp)
 		return -EINVAL;
 
-	if (mrp->ring_state == BR_MRP_RING_STATE_CLOSED &&
-	    state->ring_state != BR_MRP_RING_STATE_CLOSED)
+	if (mrp->ring_state != state->ring_state)
 		mrp->ring_transitions++;
 
 	mrp->ring_state = state->ring_state;
@@ -715,8 +714,7 @@ int br_mrp_set_in_state(struct net_bridge *br, struct br_mrp_in_state *state)
 	if (!mrp)
 		return -EINVAL;
 
-	if (mrp->in_state == BR_MRP_IN_STATE_CLOSED &&
-	    state->in_state != BR_MRP_IN_STATE_CLOSED)
+	if (mrp->in_state != state->in_state)
 		mrp->in_transitions++;
 
 	mrp->in_state = state->in_state;
-- 
2.31.1

