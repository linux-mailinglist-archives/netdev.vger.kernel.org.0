Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C57B92AACF3
	for <lists+netdev@lfdr.de>; Sun,  8 Nov 2020 19:50:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728083AbgKHSuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Nov 2020 13:50:23 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:47685 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727910AbgKHSuV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Nov 2020 13:50:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604861420;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=+R/u4JqTEFO8k1qmJC/9npI5sv7PCM1YR62/F+OGITw=;
        b=Nbj+KqCfn0Rg1NbUa6/wgWJwKaW8029DFyYwQBuvgwio2P9dfl/QQ1n7WyjJEXfMLPO8B/
        3JSXBkclzZS+5+Vd+Mbzf8gtjfjL4WHlQBp+QatyPXpHXu/y6Y3k2UVPD6T+gRZTqjTTYW
        DHcL5LPAoKwIVbDaBuatHdKR5WPVfLA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-590-YBb37H5SMBSFOl4AK4VjCg-1; Sun, 08 Nov 2020 13:50:18 -0500
X-MC-Unique: YBb37H5SMBSFOl4AK4VjCg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 815BD802B6C;
        Sun,  8 Nov 2020 18:50:17 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-112-90.ams2.redhat.com [10.36.112.90])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ED94E21E90;
        Sun,  8 Nov 2020 18:50:13 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, mptcp@lists.01.org
Subject: [PATCH net] mptcp: provide rmem[0] limit
Date:   Sun,  8 Nov 2020 19:49:59 +0100
Message-Id: <37af798bd46f402fb7c79f57ebbdd00614f5d7fa.1604861097.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The mptcp proto struct currently does not provide the
required limit for forward memory scheduling. Under
pressure sk_rmem_schedule() will unconditionally try
to use such field and will oops.

Address the issue inheriting the tcp limit, as we already
do for the wmem one.

Fixes: ("mptcp: add missing memory scheduling in the rx path")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/protocol.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index e7419fd15d84..88f2a7a0ccb8 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2467,6 +2467,7 @@ static struct proto mptcp_prot = {
 	.memory_pressure	= &tcp_memory_pressure,
 	.stream_memory_free	= mptcp_memory_free,
 	.sysctl_wmem_offset	= offsetof(struct net, ipv4.sysctl_tcp_wmem),
+	.sysctl_rmem_offset	= offsetof(struct net, ipv4.sysctl_tcp_rmem),
 	.sysctl_mem	= sysctl_tcp_mem,
 	.obj_size	= sizeof(struct mptcp_sock),
 	.slab_flags	= SLAB_TYPESAFE_BY_RCU,
-- 
2.26.2

