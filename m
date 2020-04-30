Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F10D1BF6A2
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 13:22:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727853AbgD3LWP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 07:22:15 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:40789 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727835AbgD3LWO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 07:22:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588245734;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fyXj64W9iXvtE0nTB1aqjNrwMULziy0GGmOR3N9mZoY=;
        b=PebKi8iOr2AuGnrNpTJBgHs004WHcKQbQLNU15E5Y0nRBO42MbRSMtQ6n5r8mWzYcIfAca
        1uzPbIVQ4yU330JmNR0eNfaPnQbWqxJcRNHGPbXRpP6D+/YSCdPFj1kz7may+uIDc/z3cN
        QX1c4V2S4ZTMLSZ1sO/V3RuablQfes8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-493-6pQlfhy5M2WVMfqU8V_6ow-1; Thu, 30 Apr 2020 07:22:12 -0400
X-MC-Unique: 6pQlfhy5M2WVMfqU8V_6ow-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 174FB8015CB;
        Thu, 30 Apr 2020 11:22:10 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2AA115C1B0;
        Thu, 30 Apr 2020 11:22:04 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 25447324DB2C0;
        Thu, 30 Apr 2020 13:22:03 +0200 (CEST)
Subject: [PATCH net-next v2 20/33] vhost_net: also populate XDP frame size
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     sameehj@amazon.com
Cc:     Jason Wang <jasowang@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org, zorik@amazon.com,
        akiyano@amazon.com, gtzalik@amazon.com,
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
Date:   Thu, 30 Apr 2020 13:22:03 +0200
Message-ID: <158824572308.2172139.1144470511173466125.stgit@firesoul>
In-Reply-To: <158824557985.2172139.4173570969543904434.stgit@firesoul>
References: <158824557985.2172139.4173570969543904434.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In vhost_net_build_xdp() the 'buf' that gets queued via an xdp_buff
have embedded a struct tun_xdp_hdr (located at xdp->data_hard_start)
which contains the buffer length 'buflen' (with tailroom for
skb_shared_info). Also storing this buflen in xdp->frame_sz, does not
obsolete struct tun_xdp_hdr, as it also contains a struct
virtio_net_hdr with other information.

Cc: Jason Wang <jasowang@redhat.com>
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 drivers/vhost/net.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 2927f02cc7e1..516519dcc8ff 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -747,6 +747,7 @@ static int vhost_net_build_xdp(struct vhost_net_virtqueue *nvq,
 	xdp->data = buf + pad;
 	xdp->data_end = xdp->data + len;
 	hdr->buflen = buflen;
+	xdp->frame_sz = buflen;
 
 	--net->refcnt_bias;
 	alloc_frag->offset += buflen;


