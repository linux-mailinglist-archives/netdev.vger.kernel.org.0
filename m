Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6941223CCD4
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 19:08:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728472AbgHERI0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 13:08:26 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:26004 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728400AbgHERGS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 13:06:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596647176;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=BJTmQpoAkIpbguLFUsJigmbm7ftZPVlO31weMkCEohw=;
        b=YTSODPq1TlbwSsAc+8WttxOTlJSlEkfvPKfazyouXBeG+5pCf/t9GewWDADBuZ751ulDnR
        i9CYbVhGFCl6Dbz2OOu+P/9CbSq2p2NistIo5QIaIuxUFTwVQNJrWuTfOS5JSqvCBDqD/L
        cP06CdY3GZzwG+2+o6ivnjlSBm8be6Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-138-FgJlMIBBOEqWZYWlkZ1Vjw-1; Wed, 05 Aug 2020 09:39:35 -0400
X-MC-Unique: FgJlMIBBOEqWZYWlkZ1Vjw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 390D5100A8DF;
        Wed,  5 Aug 2020 13:39:34 +0000 (UTC)
Received: from maya.cloud.tilaa.com (unknown [10.36.110.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EDB792DE95;
        Wed,  5 Aug 2020 13:39:33 +0000 (UTC)
Received: from localhost (055-041-157-037.ip-addr.inexio.net [37.157.41.55])
        by maya.cloud.tilaa.com (Postfix) with ESMTPSA id D853F40093;
        Wed,  5 Aug 2020 15:39:32 +0200 (CEST)
Date:   Wed, 5 Aug 2020 15:39:31 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org, heiko.carstens@de.ibm.com,
        Cong Wang <xiyou.wangcong@gmail.com>
Subject: [PATCH RESEND net-next] ip_tunnel_core: Fix build for archs without
 _HAVE_ARCH_IPV6_CSUM
Message-ID: <20200805153931.50a3d518@redhat.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
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

Re-sending as original copy seems to be stuck in some SMTP queue.

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

