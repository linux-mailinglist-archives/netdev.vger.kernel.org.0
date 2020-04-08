Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1FDA1A2055
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 13:52:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728733AbgDHLwc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 07:52:32 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:26619 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727612AbgDHLwc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Apr 2020 07:52:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586346751;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Wf4KK1glfn0j7wEoqm5slw5+RRseFskZ8T5RVpqxLiY=;
        b=E9Hr8ajNTY/TCK7lv32A1zYNSIDYjiAjFCrN905UU7nThaGRLqEmLxM+o489z9J2cLo4jT
        GDDbZHRc9xRtsGhQbTGf2GLneb/jcBMpiG29MlTzutk0qhPLUysSbSfmMZD9arUdXuwPRx
        P39Zw+XC8GnaRVXrJDGmL5uAUMUcwjw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-482-JDIV8boRP-uxnRwB0bWs2A-1; Wed, 08 Apr 2020 07:52:29 -0400
X-MC-Unique: JDIV8boRP-uxnRwB0bWs2A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9F29D8024DB;
        Wed,  8 Apr 2020 11:52:27 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.40])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E74691001F43;
        Wed,  8 Apr 2020 11:52:21 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 17696300020FA;
        Wed,  8 Apr 2020 13:52:21 +0200 (CEST)
Subject: [PATCH RFC v2 21/33] vhost_net: also populate XDP frame size
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
        Saeed Mahameed <saeedm@mellanox.com>
Date:   Wed, 08 Apr 2020 13:52:21 +0200
Message-ID: <158634674102.707275.8538224465361298932.stgit@firesoul>
In-Reply-To: <158634658714.707275.7903484085370879864.stgit@firesoul>
References: <158634658714.707275.7903484085370879864.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
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
index 18e205eeb9af..5bf608766fc2 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -745,6 +745,7 @@ static int vhost_net_build_xdp(struct vhost_net_virtqueue *nvq,
 	xdp->data = buf + pad;
 	xdp->data_end = xdp->data + len;
 	hdr->buflen = buflen;
+	xdp->frame_sz = buflen;
 
 	--net->refcnt_bias;
 	alloc_frag->offset += buflen;


