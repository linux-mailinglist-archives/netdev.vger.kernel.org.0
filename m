Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8BDC188C1D
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 18:30:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726892AbgCQRal (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 13:30:41 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:49634 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726859AbgCQRak (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 13:30:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584466240;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OnyziK/rkPqgFggKR4X2W+5Dbj83i3diWutR0/2f97A=;
        b=Ep+gni+6PfWORv5b+T5nPB0aZpAx31BcrBVyBKMhsu+ZIK+5IoXf1xnrIIfOFFrgs2g6sD
        01QtYDOoNLHh3oK0vszY1w5nRptsDZtFcgOX6WY022dbOCq0t55BvtcNoXczXgsGNXTGgv
        XE1f6dpxWQjM9EE6AqRQkMMhVTUVbAg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-422-mMTm4NwqPNmxHkts4GpkeQ-1; Tue, 17 Mar 2020 13:30:35 -0400
X-MC-Unique: mMTm4NwqPNmxHkts4GpkeQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3E83690A07B;
        Tue, 17 Mar 2020 17:30:15 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CF2F61001DC0;
        Tue, 17 Mar 2020 17:30:14 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id D1F2C30721A66;
        Tue, 17 Mar 2020 18:30:13 +0100 (CET)
Subject: [PATCH RFC v1 13/15] tun: add XDP frame size
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
Date:   Tue, 17 Mar 2020 18:30:13 +0100
Message-ID: <158446621378.702578.2512691726801096724.stgit@firesoul>
In-Reply-To: <158446612466.702578.2795159620575737080.stgit@firesoul>
References: <158446612466.702578.2795159620575737080.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The tun driver have two code paths for running XDP (bpf_prog_run_xdp).
In both cases 'buflen' contains enough tailroom for skb_shared_info.

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 drivers/net/tun.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 79f248cb282d..c540ff2f5774 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1706,6 +1706,7 @@ static struct sk_buff *tun_build_skb(struct tun_struct *tun,
 		xdp_set_data_meta_invalid(&xdp);
 		xdp.data_end = xdp.data + len;
 		xdp.rxq = &tfile->xdp_rxq;
+		xdp.frame_sz = buflen;
 
 		act = bpf_prog_run_xdp(xdp_prog, &xdp);
 		if (act == XDP_REDIRECT || act == XDP_TX) {
@@ -2445,6 +2446,7 @@ static int tun_xdp_one(struct tun_struct *tun,
 		}
 		xdp_set_data_meta_invalid(xdp);
 		xdp->rxq = &tfile->xdp_rxq;
+		xdp->frame_sz = buflen;
 
 		act = bpf_prog_run_xdp(xdp_prog, xdp);
 		err = tun_xdp_act(tun, xdp_prog, xdp, act);


