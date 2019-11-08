Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76974F536F
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 19:20:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727210AbfKHSUd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 13:20:33 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:29662 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726446AbfKHSUd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 13:20:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573237232;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=XVB+8Y+BOU3YP07+qU7F9r488uZcAFtKX5p9i/hOhtc=;
        b=F/YLkW6VblDJLFDUiwOFCeC+5pWzGxfwlLwnxyfdzRAQm2vKO+ZGsRe6Ng5godvHJOt4wt
        OthfV36bcAUEwmQqwS8MfTvDLv/SEhy4iS5BEzis6S/siAw+PlyPkIdfP1vyc4G6HNSvlH
        /F+YxU6IVvjwFL8+v09eFIhDXJzErYQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-396-GY3gCyzZNKSgDSmg6dI8sw-1; Fri, 08 Nov 2019 13:20:29 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 80D4F1005500;
        Fri,  8 Nov 2019 18:20:27 +0000 (UTC)
Received: from firesoul.localdomain (ovpn-200-27.brq.redhat.com [10.40.200.27])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 06D9960BE1;
        Fri,  8 Nov 2019 18:20:19 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id B75D530FC134D;
        Fri,  8 Nov 2019 19:20:17 +0100 (CET)
Subject: [net-next v1 PATCH 0/2] Change XDP lifetime guarantees for
 page_pool objects
From:   Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Toke =?utf-8?q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Matteo Croce <mcroce@redhat.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>
Date:   Fri, 08 Nov 2019 19:20:17 +0100
Message-ID: <157323719180.10408.3472322881536070517.stgit@firesoul>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: GY3gCyzZNKSgDSmg6dI8sw-1
X-Mimecast-Spam-Score: 2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset change XDP lifetime guarantees for page_pool objects
(registered via the xdp_rxq_info_reg_mem_model API). The new guarantee
is that page_pool objects stay valid (are not free'ed) until all
inflight pages are returned.

It was commit d956a048cd3f (=E2=80=9Cxdp: force mem allocator removal and
periodic warning=E2=80=9D) that introduce the force removal of page_pool
objects (after 120 second). While working on extending page_pool
recycling to cover SKBs[1], we[2] realised that this force removal
approach was a mistake.

Tested and monitored via bpftrace scripts provide here[3].

[1] https://github.com/xdp-project/xdp-project/tree/master/areas/mem
[2] we =3D=3D Ilias, Jonathan, Tariq, Saeed and me
[3] https://github.com/xdp-project/xdp-project/tree/master/areas/mem/bpftra=
ce

---

Jesper Dangaard Brouer (2):
      xdp: revert forced mem allocator removal for page_pool
      page_pool: make inflight returns more robust via blocking alloc cache


 include/net/page_pool.h    |    2 ++
 include/trace/events/xdp.h |   35 +++--------------------------------
 net/core/page_pool.c       |   32 +++++++++++++++++++++++++-------
 net/core/xdp.c             |   36 +++++++++++++-----------------------
 4 files changed, 43 insertions(+), 62 deletions(-)

--

