Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D82691BB576
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 06:50:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726334AbgD1EuB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 00:50:01 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:34659 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725917AbgD1EuB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 00:50:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588049399;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=2rnvwTU0bdcv0i2Iy3BuVSHcVapVzzi+YvkRwobbBm8=;
        b=UJBzdJKHrHWtae7H1FmSJq5I74zUz7sZgyJdYmImmB6ad5aNKbDY4K31MjXs1pnhxvGtjk
        /FarIpvCftfPrJue28enrNQUBKx99KbuAtgamiYcwy1M8uPhUXcRQ3jWjpA20uH++uIRBw
        1JvTs6cKMxyCHcWn/4892aQrLsszxhk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-229-4E2djSixM5arJbl7oXv6lw-1; Tue, 28 Apr 2020 00:49:56 -0400
X-MC-Unique: 4E2djSixM5arJbl7oXv6lw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8BF051899520;
        Tue, 28 Apr 2020 04:49:54 +0000 (UTC)
Received: from localhost.localdomain.com (vpn2-54-127.bne.redhat.com [10.64.54.127])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8D0B31001DC2;
        Tue, 28 Apr 2020 04:49:51 +0000 (UTC)
From:   Gavin Shan <gshan@redhat.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, netanel@amazon.com,
        akiyano@amazon.com, gtzalik@amazon.com, davem@davemloft.net,
        gshan@redhat.com, shan.gavin@gmail.com
Subject: [PATCH v2] net/ena: Fix build warning in ena_xdp_set()
Date:   Tue, 28 Apr 2020 14:49:45 +1000
Message-Id: <20200428044945.123511-1-gshan@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This fixes the following build warning in ena_xdp_set(), which is
observed on aarch64 with 64KB page size.

   In file included from ./include/net/inet_sock.h:19,
      from ./include/net/ip.h:27,
      from drivers/net/ethernet/amazon/ena/ena_netdev.c:46:
   drivers/net/ethernet/amazon/ena/ena_netdev.c: In function         \
   =E2=80=98ena_xdp_set=E2=80=99:                                        =
            \
   drivers/net/ethernet/amazon/ena/ena_netdev.c:557:6: warning:      \
   format =E2=80=98%lu=E2=80=99                                          =
            \
   expects argument of type =E2=80=98long unsigned int=E2=80=99, but argu=
ment 4      \
   has type =E2=80=98int=E2=80=99                                        =
            \
   [-Wformat=3D] "Failed to set xdp program, the current MTU (%d) is   \
   larger than the maximum allowed MTU (%lu) while xdp is on",

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
v2: Make ENA_PAGE_SIZE to be "unsigned long" and verify on aarch64
    with 4KB or 64KB page size configuration
---
 drivers/net/ethernet/amazon/ena/ena_netdev.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.h b/drivers/net/e=
thernet/amazon/ena/ena_netdev.h
index 97dfd0c67e84..9e1860d81908 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.h
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.h
@@ -69,7 +69,7 @@
  * 16kB.
  */
 #if PAGE_SIZE > SZ_16K
-#define ENA_PAGE_SIZE SZ_16K
+#define ENA_PAGE_SIZE (_AC(SZ_16K, UL))
 #else
 #define ENA_PAGE_SIZE PAGE_SIZE
 #endif
--=20
2.23.0

