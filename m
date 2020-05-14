Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4E281D3C6E
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 21:16:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728759AbgENSxf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 14:53:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:52882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728736AbgENSxd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 May 2020 14:53:33 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A8BF42078C;
        Thu, 14 May 2020 18:53:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589482412;
        bh=gmJHuoKP4vuZXIRcNdIkm9jGlWqb1LToHSB1kWzEJSk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pG2Dp1DYlDFTGW+3TyFYytkgfY0UA4Jr19c5t4LguOvcLY31igehy8afPuLZ+YVTZ
         1akwvmoktYn3RT/u/2CPMLrXLwoZ6PnUPqxrRfLv19KURCldXbDYOP9oOEzPX5KNvt
         gbgv+ViFpFn5uODSGa+14JZSO3229OIWSrzqGrnI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Gavin Shan <gshan@redhat.com>, Shay Agroskin <shayagr@amazon.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 17/49] net/ena: Fix build warning in ena_xdp_set()
Date:   Thu, 14 May 2020 14:52:38 -0400
Message-Id: <20200514185311.20294-17-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200514185311.20294-1-sashal@kernel.org>
References: <20200514185311.20294-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Gavin Shan <gshan@redhat.com>

[ Upstream commit caec66198d137c26f0d234abc498866a58c64150 ]

This fixes the following build warning in ena_xdp_set(), which is
observed on aarch64 with 64KB page size.

   In file included from ./include/net/inet_sock.h:19,
      from ./include/net/ip.h:27,
      from drivers/net/ethernet/amazon/ena/ena_netdev.c:46:
   drivers/net/ethernet/amazon/ena/ena_netdev.c: In function         \
   ‘ena_xdp_set’:                                                    \
   drivers/net/ethernet/amazon/ena/ena_netdev.c:557:6: warning:      \
   format ‘%lu’                                                      \
   expects argument of type ‘long unsigned int’, but argument 4      \
   has type ‘int’                                                    \
   [-Wformat=] "Failed to set xdp program, the current MTU (%d) is   \
   larger than the maximum allowed MTU (%lu) while xdp is on",

Signed-off-by: Gavin Shan <gshan@redhat.com>
Acked-by: Shay Agroskin <shayagr@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.h b/drivers/net/ethernet/amazon/ena/ena_netdev.h
index dc02950a96b8d..28412f11a9ca0 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.h
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.h
@@ -68,7 +68,7 @@
  * 16kB.
  */
 #if PAGE_SIZE > SZ_16K
-#define ENA_PAGE_SIZE SZ_16K
+#define ENA_PAGE_SIZE (_AC(SZ_16K, UL))
 #else
 #define ENA_PAGE_SIZE PAGE_SIZE
 #endif
-- 
2.20.1

