Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CC221D2D7A
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 12:52:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727847AbgENKvm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 06:51:42 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:45188 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726176AbgENKvl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 06:51:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589453500;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QgmQQ3BdP3fG2j1xwjXam7QeuzlwY8kv6oC0rf1kJv0=;
        b=JTSYjxCJ9dLujwZ7nF/RSP03zsnzB9vuHw62aEW2hEAogBd33lBc3CRuIXvelibGUdbH4h
        S1NRzYNSYqefcVut1ocZ4mL5MZVKORC36F4rsmO0ajPsnR1z77lnWRJopcxmt+JTnYE+I8
        8ZqfJ6j7ajLEbhQZoUMQAe+/ZeejFbI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-274-LpzPMr23P4mThsJv9sSGdg-1; Thu, 14 May 2020 06:51:39 -0400
X-MC-Unique: LpzPMr23P4mThsJv9sSGdg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3EF58100CCC0;
        Thu, 14 May 2020 10:51:37 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.32])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 93D946A977;
        Thu, 14 May 2020 10:51:31 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 74F09300020FC;
        Thu, 14 May 2020 12:51:30 +0200 (CEST)
Subject: [PATCH net-next v4 30/33] xdp: clear grow memory in
 bpf_xdp_adjust_tail()
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     sameehj@amazon.com
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org,
        =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>
Date:   Thu, 14 May 2020 12:51:30 +0200
Message-ID: <158945349039.97035.5262100484553494.stgit@firesoul>
In-Reply-To: <158945314698.97035.5286827951225578467.stgit@firesoul>
References: <158945314698.97035.5286827951225578467.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clearing memory of tail when grow happens, because it is too easy
to write a XDP_PASS program that extend the tail, which expose
this memory to users that can run tcpdump.

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 net/core/filter.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/core/filter.c b/net/core/filter.c
index ec3ab2e2d800..691235208e0b 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3427,6 +3427,10 @@ BPF_CALL_2(bpf_xdp_adjust_tail, struct xdp_buff *, xdp, int, offset)
 	if (unlikely(data_end < xdp->data + ETH_HLEN))
 		return -EINVAL;
 
+	/* Clear memory area on grow, can contain uninit kernel memory */
+	if (offset > 0)
+		memset(xdp->data_end, 0, offset);
+
 	xdp->data_end = data_end;
 
 	return 0;


