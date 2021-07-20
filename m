Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A50923CFA23
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 15:09:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232292AbhGTM2V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 08:28:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:37096 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229631AbhGTM2U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Jul 2021 08:28:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626786538;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=SOA99KkdJ05lNqKqr3EAdXmaadG46SeVLoD9l5GHUiM=;
        b=MBDBIqQKGkCGK9zFD+yx8cpisn5aUwXru97MWFzqaLR0x8MRZrCFpoQMnkuJSfs6y0vx/o
        krUuDbFlx1Bd2KppImmFMP2YMomF/sZCkvf6CtyyhCN7VZx1wJ7GCiQTLoQXq8zANqrYJX
        zNdkidP6C8EVx37yFof7hv+8LNVMkqg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-478-6QhTvBi1PIqNDzlNfjoxEQ-1; Tue, 20 Jul 2021 09:08:57 -0400
X-MC-Unique: 6QhTvBi1PIqNDzlNfjoxEQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C29BA800050;
        Tue, 20 Jul 2021 13:08:55 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-114-77.ams2.redhat.com [10.36.114.77])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 58AB560CA1;
        Tue, 20 Jul 2021 13:08:54 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Coco Li <lixiaoyan@google.com>
Subject: [PATCH net] ipv6: fix another slab-out-of-bounds in fib6_nh_flush_exceptions
Date:   Tue, 20 Jul 2021 15:08:40 +0200
Message-Id: <6f48619a725daf4bfaea7dad94504f722ab1b4f6.1626786511.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While running the self-tests on a KASAN enabled kernel, I observed a
slab-out-of-bounds splat very similar to the one reported in
commit 821bbf79fe46 ("ipv6: Fix KASAN: slab-out-of-bounds Read in
 fib6_nh_flush_exceptions").

We additionally need to take care of fib6_metrics initialization
failure when the caller provides an nh.

The fix is similar, explicitly free the route instead of calling
fib6_info_release on a half-initialized object.

Fixes: f88d8ea67fbdb ("ipv6: Plumb support for nexthop object in a fib6_info")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/ipv6/route.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 7b756a7dc036..b6ddf23d3833 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -3769,7 +3769,7 @@ static struct fib6_info *ip6_route_info_create(struct fib6_config *cfg,
 		err = PTR_ERR(rt->fib6_metrics);
 		/* Do not leave garbage there. */
 		rt->fib6_metrics = (struct dst_metrics *)&dst_default_metrics;
-		goto out;
+		goto out_free;
 	}
 
 	if (cfg->fc_flags & RTF_ADDRCONF)
-- 
2.26.3

