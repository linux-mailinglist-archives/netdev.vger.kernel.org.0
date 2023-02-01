Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49B36686D33
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 18:37:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231646AbjBARhN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 12:37:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232059AbjBARhF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 12:37:05 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 856157D9A5
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 09:35:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675272948;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FDN2oUrxfhWHvX9N/vDCnLvcS04hB2Sskt8cijTVb7A=;
        b=MF8BwNDNlXgpuRPwn/8/0e8dN+AnGz3B47WV7n5c2Itc8BPPXo2f+xvoMO1ocHyB2Zfebh
        mKsyDJBG0AHi0+p05XE0eIF5XASTYxPz1YMgenjbtVjR3kbHnTT+43hAmlHuERDq81uM6H
        wAFktCgZUmuRd6TDTRUqDGszj7RrMns=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-142-YLanIt3dNSGNVOsjeaxxww-1; Wed, 01 Feb 2023 12:31:57 -0500
X-MC-Unique: YLanIt3dNSGNVOsjeaxxww-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9337C281DE6D;
        Wed,  1 Feb 2023 17:31:56 +0000 (UTC)
Received: from firesoul.localdomain (ovpn-208-9.brq.redhat.com [10.40.208.9])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4F4E62026D4B;
        Wed,  1 Feb 2023 17:31:56 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 5A889300005EE;
        Wed,  1 Feb 2023 18:31:55 +0100 (CET)
Subject: [PATCH bpf-next V2 2/4] selftests/bpf: xdp_hw_metadata cleanup cause
 segfault
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     bpf@vger.kernel.org, Stanislav Fomichev <sdf@google.com>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        martin.lau@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        yhs@fb.com, john.fastabend@gmail.com, dsahern@gmail.com,
        willemb@google.com, void@manifault.com, kuba@kernel.org,
        xdp-hints@xdp-project.net
Date:   Wed, 01 Feb 2023 18:31:55 +0100
Message-ID: <167527271533.937063.5717065138099679142.stgit@firesoul>
In-Reply-To: <167527267453.937063.6000918625343592629.stgit@firesoul>
References: <167527267453.937063.6000918625343592629.stgit@firesoul>
User-Agent: StGit/1.4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Using xdp_hw_metadata I experince Segmentation fault
after seeing "detaching bpf program....".

On my system the segfault happened when accessing bpf_obj->skeleton
in xdp_hw_metadata__destroy(bpf_obj) call. That doesn't make any sense
as this memory have not been freed by program at this point in time.

Prior to calling xdp_hw_metadata__destroy(bpf_obj) the function
close_xsk() is called for each RX-queue xsk.  The real bug lays
in close_xsk() that unmap via munmap() the wrong memory pointer.
The call xsk_umem__delete(xsk->umem) will free xsk->umem, thus
the call to munmap(xsk->umem, UMEM_SIZE) will have unpredictable
behavior. And man page explain subsequent references to these
pages will generate SIGSEGV.

Unmapping xsk->umem_area instead removes the segfault.

Fixes: 297a3f124155 ("selftests/bpf: Simple program to dump XDP RX metadata")
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 tools/testing/selftests/bpf/xdp_hw_metadata.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/xdp_hw_metadata.c b/tools/testing/selftests/bpf/xdp_hw_metadata.c
index 3823b1c499cc..438083e34cce 100644
--- a/tools/testing/selftests/bpf/xdp_hw_metadata.c
+++ b/tools/testing/selftests/bpf/xdp_hw_metadata.c
@@ -121,7 +121,7 @@ static void close_xsk(struct xsk *xsk)
 		xsk_umem__delete(xsk->umem);
 	if (xsk->socket)
 		xsk_socket__delete(xsk->socket);
-	munmap(xsk->umem, UMEM_SIZE);
+	munmap(xsk->umem_area, UMEM_SIZE);
 }
 
 static void refill_rx(struct xsk *xsk, __u64 addr)


