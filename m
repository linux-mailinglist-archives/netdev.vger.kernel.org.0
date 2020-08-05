Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7727123CBF0
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 18:07:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726338AbgHEQEB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 12:04:01 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:20760 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726202AbgHEPsi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 11:48:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596642331;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=2rdWMsfVYoLVMGMuU1zSO9y5DV7npaEchPj2O2QlCzs=;
        b=gqstTDtoesNQpmIXXrmaVyp1fjVXg9pB5CuuWcQrCkV5M57coYkYX0MisWG8xrv6zUm76Y
        KMdDB3I4PugRZrBe79JUB4o0ZGSag3tb+up3l2V4SiiopX/FWB2XYWJ3XvuT0m28UQ5ZBR
        hXv7qG8iOnwoKf+y8HADzfyRlhvQ69E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-358-TzVqO_I0MwqTgX4ANH4PbQ-1; Wed, 05 Aug 2020 09:18:39 -0400
X-MC-Unique: TzVqO_I0MwqTgX4ANH4PbQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DB70091270;
        Wed,  5 Aug 2020 13:18:37 +0000 (UTC)
Received: from epycfail.redhat.com (unknown [10.36.110.53])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DCBC5380;
        Wed,  5 Aug 2020 13:18:35 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        heiko.carstens@de.ibm.com, Cong Wang <xiyou.wangcong@gmail.com>
Subject: [PATCH net-next] ip_tunnel_core: Fix build for archs without _HAVE_ARCH_IPV6_CSUM
Date:   Wed,  5 Aug 2020 15:18:21 +0200
Message-Id: <a85e9878716c2904488d56335320b7131613e94c.1596633316.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On architectures defining _HAVE_ARCH_IPV6_CSUM, we get
csum_ipv6_magic() defined by means of arch checksum.h headers. On
other architectures, we actually need to include net/ip6_checksum.h
to be able to use it.

Without this include, building with defconfig breaks at least for
s390.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Fixes: 4cb47a8644cc ("tunnels: PMTU discovery support for directly bridged IP packets")
Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
---
I'm submitting this for net-next despite the fact it's closed, as
the offending code isn't merged to net.git yet. Should I rather
submit this to... linux-next?

 net/ipv4/ip_tunnel_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv4/ip_tunnel_core.c b/net/ipv4/ip_tunnel_core.c
index 9ddee2a0c66d..75c6013ff9a4 100644
--- a/net/ipv4/ip_tunnel_core.c
+++ b/net/ipv4/ip_tunnel_core.c
@@ -25,6 +25,7 @@
 #include <net/protocol.h>
 #include <net/ip_tunnels.h>
 #include <net/ip6_tunnel.h>
+#include <net/ip6_checksum.h>
 #include <net/arp.h>
 #include <net/checksum.h>
 #include <net/dsfield.h>
-- 
2.27.0

