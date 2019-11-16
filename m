Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6515BFEBCA
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 12:22:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727527AbfKPLWz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 06:22:55 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:42874 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727505AbfKPLWy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Nov 2019 06:22:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573903374;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RVu85RivfwVZM9INv3LcREXxrptqzk3KQQxrg6JwlMM=;
        b=E2NpI5JboAWofqbFqCjy6JN7eoLjVAJ4bO0iDm7T1TxdBEW5kmSi0NItrD7qo7EeWTvgpC
        68IDIiR0KuBxQL4+jfLqwrwg9GuM1VNSveJzrdhcjX13Nn9F6LIo2ftIpmdfCQfAQ3OODB
        ivlGRa7FriJraua8sJuOgwZzZlFatRM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-97-ZyWPBGozPi-EYZ6C183RDw-1; Sat, 16 Nov 2019 06:22:51 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5AD7F107ACC4;
        Sat, 16 Nov 2019 11:22:49 +0000 (UTC)
Received: from firesoul.localdomain (ovpn-200-41.brq.redhat.com [10.40.200.41])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 08C191036C81;
        Sat, 16 Nov 2019 11:22:49 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 389F530FC134D;
        Sat, 16 Nov 2019 12:22:48 +0100 (CET)
Subject: [net-next v2 PATCH 3/3] page_pool: extend tracepoint to also
 include the page PFN
From:   Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Toke =?utf-8?q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Matteo Croce <mcroce@redhat.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>
Date:   Sat, 16 Nov 2019 12:22:48 +0100
Message-ID: <157390336816.4062.15284686673295583294.stgit@firesoul>
In-Reply-To: <157390333500.4062.15569811103072483038.stgit@firesoul>
References: <157390333500.4062.15569811103072483038.stgit@firesoul>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: ZyWPBGozPi-EYZ6C183RDw-1
X-Mimecast-Spam-Score: 2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The MM tracepoint for page free (called kmem:mm_page_free) doesn't provide
the page pointer directly, instead it provides the PFN (Page Frame Number).
This is annoying when writing a page_pool leak detector in BPF.

This patch change page_pool tracepoints to also provide the PFN.
The page pointer is still provided to allow other kinds of
troubleshooting from BPF.

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 include/trace/events/page_pool.h |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/include/trace/events/page_pool.h b/include/trace/events/page_p=
ool.h
index ee7f1aca7839..2f2a10e8eb56 100644
--- a/include/trace/events/page_pool.h
+++ b/include/trace/events/page_pool.h
@@ -8,6 +8,7 @@
 #include <linux/types.h>
 #include <linux/tracepoint.h>
=20
+#include <trace/events/mmflags.h>
 #include <net/page_pool.h>
=20
 TRACE_EVENT(page_pool_release,
@@ -49,16 +50,18 @@ TRACE_EVENT(page_pool_state_release,
 =09=09__field(const struct page_pool *,=09pool)
 =09=09__field(const struct page *,=09=09page)
 =09=09__field(u32,=09=09=09=09release)
+=09=09__field(unsigned long,=09=09=09pfn)
 =09),
=20
 =09TP_fast_assign(
 =09=09__entry->pool=09=09=3D pool;
 =09=09__entry->page=09=09=3D page;
 =09=09__entry->release=09=3D release;
+=09=09__entry->pfn=09=09=3D page_to_pfn(page);
 =09),
=20
-=09TP_printk("page_pool=3D%p page=3D%p release=3D%u",
-=09=09  __entry->pool, __entry->page, __entry->release)
+=09TP_printk("page_pool=3D%p page=3D%p pfn=3D%lu release=3D%u",
+=09=09  __entry->pool, __entry->page, __entry->pfn, __entry->release)
 );
=20
 TRACE_EVENT(page_pool_state_hold,
@@ -72,16 +75,18 @@ TRACE_EVENT(page_pool_state_hold,
 =09=09__field(const struct page_pool *,=09pool)
 =09=09__field(const struct page *,=09=09page)
 =09=09__field(u32,=09=09=09=09hold)
+=09=09__field(unsigned long,=09=09=09pfn)
 =09),
=20
 =09TP_fast_assign(
 =09=09__entry->pool=09=3D pool;
 =09=09__entry->page=09=3D page;
 =09=09__entry->hold=09=3D hold;
+=09=09__entry->pfn=09=3D page_to_pfn(page);
 =09),
=20
-=09TP_printk("page_pool=3D%p page=3D%p hold=3D%u",
-=09=09  __entry->pool, __entry->page, __entry->hold)
+=09TP_printk("page_pool=3D%p page=3D%p pfn=3D%lu hold=3D%u",
+=09=09  __entry->pool, __entry->page, __entry->pfn, __entry->hold)
 );
=20
 #endif /* _TRACE_PAGE_POOL_H */

