Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A9ED686DB6
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 19:13:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231491AbjBASNt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 13:13:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbjBASNs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 13:13:48 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4351124C83
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 10:13:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675275182;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=aBiZv6kgolXZRi0uzRYeVBHuWMhXVUDzRvu/mO7RexM=;
        b=PdxxF95kaLD8e2DDE+kdYfvyFZFQgSR1RWGipjYMvVpH+Iki8OWIScG4tmADxfzvyN9Z/N
        ZQMy6JM0M+NiYq8/XMk7j5DnZkU8qz3flaQifjKD55BGWH/GHN+1AZYYI8Whozr7WU3j2y
        FvrMB61pfuwgYeyeHZ4s/g5FIfvLuZo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-114-0RFGbqu5NZOl6jNmgqUKWQ-1; Wed, 01 Feb 2023 13:12:57 -0500
X-MC-Unique: 0RFGbqu5NZOl6jNmgqUKWQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2BC2B855308;
        Wed,  1 Feb 2023 18:12:56 +0000 (UTC)
Received: from firesoul.localdomain (ovpn-208-9.brq.redhat.com [10.40.208.9])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D93A82026D4B;
        Wed,  1 Feb 2023 18:12:55 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id B44AD300005EE;
        Wed,  1 Feb 2023 19:12:54 +0100 (CET)
Subject: [PATCH bpf-next V1] selftests/bpf: fix unmap bug in
 prog_tests/xdp_metadata.c
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     bpf@vger.kernel.org, Stanislav Fomichev <sdf@google.com>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        martin.lau@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        yhs@fb.com, john.fastabend@gmail.com, dsahern@gmail.com,
        willemb@google.com, void@manifault.com, kuba@kernel.org,
        xdp-hints@xdp-project.net
Date:   Wed, 01 Feb 2023 19:12:54 +0100
Message-ID: <167527517464.938135.13750760520577765269.stgit@firesoul>
User-Agent: StGit/1.4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The function close_xsk() unmap via munmap() the wrong memory pointer.

The call xsk_umem__delete(xsk->umem) have already freed xsk->umem.
Thus the call to munmap(xsk->umem, UMEM_SIZE) will have unpredictable
behavior that can lead to Segmentation fault elsewhere, as man page
explain subsequent references to these pages will generate SIGSEGV.

Fixes: e2a46d54d7a1 ("selftests/bpf: Verify xdp_metadata xdp->af_xdp path")
Reported-by: Martin KaFai Lau <martin.lau@kernel.org>
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 .../selftests/bpf/prog_tests/xdp_metadata.c        |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_metadata.c b/tools/testing/selftests/bpf/prog_tests/xdp_metadata.c
index e033d48288c0..241909d71c7e 100644
--- a/tools/testing/selftests/bpf/prog_tests/xdp_metadata.c
+++ b/tools/testing/selftests/bpf/prog_tests/xdp_metadata.c
@@ -121,7 +121,7 @@ static void close_xsk(struct xsk *xsk)
 		xsk_umem__delete(xsk->umem);
 	if (xsk->socket)
 		xsk_socket__delete(xsk->socket);
-	munmap(xsk->umem, UMEM_SIZE);
+	munmap(xsk->umem_area, UMEM_SIZE);
 }
 
 static void ip_csum(struct iphdr *iph)


