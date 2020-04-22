Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 904C11B49E2
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 18:10:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727123AbgDVQKM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 12:10:12 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:39936 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727118AbgDVQKJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 12:10:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587571808;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Z3N+8cPp1OgtoEEvybGnKs8IFjqYaFI9v8EsmIDdCwI=;
        b=d/Vi4UenPkFaNbOzvLlcmQhHrRnpSvyy8+X6gi6EeHrMPdijcFT4Prnj1zMxcPgCJrMdr/
        Qic0eCtdtRJm9cw4xDKL+yqoOb5iArjQAF7RuEopkhA+2JydBU+yp48bLoTrZCZTJ5m5qO
        0oF8qYypFmrfcOVFMrXgOaZfrKw/Rxk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-269-Shw2MsJpPKSj7apU7vsgww-1; Wed, 22 Apr 2020 12:10:02 -0400
X-MC-Unique: Shw2MsJpPKSj7apU7vsgww-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0C6B0108442F;
        Wed, 22 Apr 2020 16:10:00 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.3])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 64CB819C70;
        Wed, 22 Apr 2020 16:09:54 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 892CE30631A9B;
        Wed, 22 Apr 2020 18:09:53 +0200 (CEST)
Subject: [PATCH net-next 30/33] xdp: clear grow memory in
 bpf_xdp_adjust_tail()
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     sameehj@amazon.com
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, zorik@amazon.com, akiyano@amazon.com,
        gtzalik@amazon.com,
        =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        steffen.klassert@secunet.com
Date:   Wed, 22 Apr 2020 18:09:53 +0200
Message-ID: <158757179349.1370371.14581472372520364962.stgit@firesoul>
In-Reply-To: <158757160439.1370371.13213378122947426220.stgit@firesoul>
References: <158757160439.1370371.13213378122947426220.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clearing memory of tail when grow happens, because it is too easy
to write a XDP_PASS program that extend the tail, which expose
this memory to users that can run tcpdump.

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 net/core/filter.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/core/filter.c b/net/core/filter.c
index 5e9c387f74eb..889d96a690c2 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3442,6 +3442,10 @@ BPF_CALL_2(bpf_xdp_adjust_tail, struct xdp_buff *, xdp, int, offset)
 	if (unlikely(data_end < xdp->data + ETH_HLEN))
 		return -EINVAL;
 
+	/* Clear memory area on grow, can contain uninit kernel memory */
+	if (offset > 0)
+		memset(xdp->data_end, 0, offset);
+
 	xdp->data_end = data_end;
 
 	return 0;


