Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 654CC1BF6B7
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 13:23:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727871AbgD3LXI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 07:23:08 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:40374 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726483AbgD3LXI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 07:23:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588245787;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZH79RTrqNEsWsIDtHYmP1vv8R2/Hbw946zRrNmszoms=;
        b=ZNOQHT6S0vAM/kiIvtg/iSbG/iQmU/oNN3DsH8nAVRQGkrHd9roKd/ngTmhf/bLulM+niL
        QNhgUquoFzXYbm6WqVrMG+xy/ldUTPOTmyCYqtk2EKBSZpGwe1vhK3sVpJv6ZHzlXylNvB
        kyt6kFvTTbb08YGYNxKD9hwcgMPIY88=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-206-97kBMGDdORy6maLutXbcVQ-1; Thu, 30 Apr 2020 07:23:03 -0400
X-MC-Unique: 97kBMGDdORy6maLutXbcVQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DDFB2107ACCA;
        Thu, 30 Apr 2020 11:23:00 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 03740605E1;
        Thu, 30 Apr 2020 11:22:55 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 04D23324DB2C1;
        Thu, 30 Apr 2020 13:22:54 +0200 (CEST)
Subject: [PATCH net-next v2 30/33] xdp: clear grow memory in
 bpf_xdp_adjust_tail()
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     sameehj@amazon.com
Cc:     =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
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
Date:   Thu, 30 Apr 2020 13:22:54 +0200
Message-ID: <158824577394.2172139.14338239626840236208.stgit@firesoul>
In-Reply-To: <158824557985.2172139.4173570969543904434.stgit@firesoul>
References: <158824557985.2172139.4173570969543904434.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clearing memory of tail when grow happens, because it is too easy
to write a XDP_PASS program that extend the tail, which expose
this memory to users that can run tcpdump.

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
---
 net/core/filter.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/core/filter.c b/net/core/filter.c
index 40e749d57cc1..7af583648c8d 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3438,6 +3438,10 @@ BPF_CALL_2(bpf_xdp_adjust_tail, struct xdp_buff *,=
 xdp, int, offset)
 	if (unlikely(data_end < xdp->data + ETH_HLEN))
 		return -EINVAL;
=20
+	/* Clear memory area on grow, can contain uninit kernel memory */
+	if (offset > 0)
+		memset(xdp->data_end, 0, offset);
+
 	xdp->data_end =3D data_end;
=20
 	return 0;


