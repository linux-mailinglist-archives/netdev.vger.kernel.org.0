Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F606188C14
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 18:30:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726845AbgCQRaN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 13:30:13 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:50328 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726386AbgCQRaM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 13:30:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584466212;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ubMXoWwW994Xs3LQl5VxMmYKwZwOhMnJEtdL6z8h+Sk=;
        b=IGci5UMZAupScTDaz3Sm4YN1WyYO+OPHNRBnclnSBRm4jvFLeUfIoFlVqK4ng3NRrudsAw
        aes5XYgbKGhr3ap+rSYbOdAIaqvUERX84UEkxXJIKdt7QeMUjZl2cV5nO1Upg9Fez1sMFp
        N81B5YU6VnWzayvRKIcFRdLpRm7Ouzo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-7-7T-LkGS0MpigjQREG0ZfIg-1; Tue, 17 Mar 2020 13:30:09 -0400
X-MC-Unique: 7T-LkGS0MpigjQREG0ZfIg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 47AC68B5D76;
        Tue, 17 Mar 2020 17:29:55 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7BCC860BEE;
        Tue, 17 Mar 2020 17:29:54 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 7BA9A30721A66;
        Tue, 17 Mar 2020 18:29:53 +0100 (CET)
Subject: [PATCH RFC v1 09/15] xdp: clear grow memory in bpf_xdp_adjust_tail()
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     sameehj@amazon.com
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, zorik@amazon.com, akiyano@amazon.com,
        gtzalik@amazon.com,
        =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Date:   Tue, 17 Mar 2020 18:29:53 +0100
Message-ID: <158446619342.702578.1522482431365026926.stgit@firesoul>
In-Reply-To: <158446612466.702578.2795159620575737080.stgit@firesoul>
References: <158446612466.702578.2795159620575737080.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To reviewers: Need some opinions if this is needed?

(TODO: Squash patch)
---
 net/core/filter.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/core/filter.c b/net/core/filter.c
index 0ceddee0c678..669f29992177 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3432,6 +3432,12 @@ BPF_CALL_2(bpf_xdp_adjust_tail, struct xdp_buff *, xdp, int, offset)
 	if (unlikely(data_end < xdp->data + ETH_HLEN))
 		return -EINVAL;
 
+	// XXX: To reviewers: How paranoid are we? Do we really need to
+	/* clear memory area on grow, as in-theory can contain uninit kmem */
+	if (offset > 0) {
+		memset(xdp->data_end, 0, offset);
+	}
+
 	xdp->data_end = data_end;
 
 	return 0;


