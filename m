Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6020EE6AC
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 17:38:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728546AbfD2PiG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 11:38:06 -0400
Received: from gateway32.websitewelcome.com ([192.185.145.101]:29955 "EHLO
        gateway32.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728438AbfD2PiF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 11:38:05 -0400
Received: from cm12.websitewelcome.com (cm12.websitewelcome.com [100.42.49.8])
        by gateway32.websitewelcome.com (Postfix) with ESMTP id 0AF0A1A521FC
        for <netdev@vger.kernel.org>; Mon, 29 Apr 2019 10:38:05 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id L8M0hEF1xiQerL8M1huJnK; Mon, 29 Apr 2019 10:38:05 -0500
X-Authority-Reason: nr=8
Received: from [189.250.54.97] (port=52388 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.91)
        (envelope-from <gustavo@embeddedor.com>)
        id 1hL8Lt-001QMb-7P; Mon, 29 Apr 2019 10:38:01 -0500
Date:   Mon, 29 Apr 2019 10:37:55 -0500
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     Solarflare linux maintainers <linux-net-drivers@solarflare.com>,
        Edward Cree <ecree@solarflare.com>,
        Martin Habets <mhabets@solarflare.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH net-next] sfc: mcdi_port: Mark expected switch fall-through
Message-ID: <20190429153755.GA10596@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.9.4 (2018-02-28)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 189.250.54.97
X-Source-L: No
X-Exim-ID: 1hL8Lt-001QMb-7P
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [189.250.54.97]:52388
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 20
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation to enabling -Wimplicit-fallthrough, mark switch
cases where we are expecting to fall through.

This patch fixes the following warning:

drivers/net/ethernet/sfc/mcdi_port.c: In function ‘efx_mcdi_phy_decode_link’:
./include/linux/compiler.h:77:22: warning: this statement may fall through [-Wimplicit-fallthrough=]
 # define unlikely(x) __builtin_expect(!!(x), 0)
                      ^~~~~~~~~~~~~~~~~~~~~~~~~~
./include/asm-generic/bug.h:125:2: note: in expansion of macro ‘unlikely’
  unlikely(__ret_warn_on);     \
  ^~~~~~~~
drivers/net/ethernet/sfc/mcdi_port.c:344:3: note: in expansion of macro ‘WARN_ON’
   WARN_ON(1);
   ^~~~~~~
drivers/net/ethernet/sfc/mcdi_port.c:345:2: note: here
  case MC_CMD_FCNTL_OFF:
  ^~~~

Warning level 3 was used: -Wimplicit-fallthrough=3

This patch is part of the ongoing efforts to enable
-Wimplicit-fallthrough.

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/net/ethernet/sfc/mcdi_port.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/sfc/mcdi_port.c b/drivers/net/ethernet/sfc/mcdi_port.c
index 9382bb0b4d5a..a4bbfebe3d64 100644
--- a/drivers/net/ethernet/sfc/mcdi_port.c
+++ b/drivers/net/ethernet/sfc/mcdi_port.c
@@ -342,6 +342,7 @@ static void efx_mcdi_phy_decode_link(struct efx_nic *efx,
 		break;
 	default:
 		WARN_ON(1);
+		/* Fall through */
 	case MC_CMD_FCNTL_OFF:
 		link_state->fc = 0;
 		break;
-- 
2.21.0

