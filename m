Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 916541B49C5
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 18:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726997AbgDVQJZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 12:09:25 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:49758 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726105AbgDVQJZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 12:09:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587571763;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6BKKDeUPqrM2uQgScDFc8FnWnsJNpzlUMZkybJDQVP8=;
        b=JRRdTw+iCHtstrX56hGer2PvkGerDETTEnorOoHdCX3Bp/zOXSgLcFP25AO7xRdFa3QQLk
        9vpWmUHeTml6yU+KFXs0tXWysVJYpX0MOgqVonItqc4WAolbHWVRGf7WuEa70XYgp8pk9z
        CaTTnz5J9bDa6zo3ZJtvhOLHcPq/Mx0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-469-1O6YVLdJMViiuAZD_UHZtQ-1; Wed, 22 Apr 2020 12:09:22 -0400
X-MC-Unique: 1O6YVLdJMViiuAZD_UHZtQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AA1CB1005F99;
        Wed, 22 Apr 2020 16:09:10 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.3])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A34FC6062B;
        Wed, 22 Apr 2020 16:09:03 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id B2F2530000272;
        Wed, 22 Apr 2020 18:09:02 +0200 (CEST)
Subject: [PATCH net-next 20/33] vhost_net: also populate XDP frame size
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
Date:   Wed, 22 Apr 2020 18:09:02 +0200
Message-ID: <158757174266.1370371.14475202001364271065.stgit@firesoul>
In-Reply-To: <158757160439.1370371.13213378122947426220.stgit@firesoul>
References: <158757160439.1370371.13213378122947426220.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
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
index 87469d67ede8..69af007e22f4 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -745,6 +745,7 @@ static int vhost_net_build_xdp(struct vhost_net_virtqueue *nvq,
 	xdp->data = buf + pad;
 	xdp->data_end = xdp->data + len;
 	hdr->buflen = buflen;
+	xdp->frame_sz = buflen;
 
 	--net->refcnt_bias;
 	alloc_frag->offset += buflen;


