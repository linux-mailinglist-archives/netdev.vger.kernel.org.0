Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B91261B5E6D
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 16:57:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728711AbgDWO5y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 10:57:54 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:28409 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726380AbgDWO5y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 10:57:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587653872;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=b0hvb2Erv6ciUI+yL+7+HbGlb0w/di3/rQ5m5fWC6Is=;
        b=Ysj0CWD7y3idWTlPC/HBgGkr2Qsp3EMfhh5VLDq52UmHRhxF62f6qwnQwv7oy9t8qTT7ot
        o1nEcY7o1E3z3TH0acQgskh96QJAtaTLs1FvYc14cp4l4+5efMhOoQ7OZIyYZp+ZgI0BVD
        ONaxxjmg6E/FBxPcWvZKlrJbu/NDRzw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-457-mFmkiRd0Ou6S0Z_u91cYWg-1; Thu, 23 Apr 2020 10:57:49 -0400
X-MC-Unique: mFmkiRd0Ou6S0Z_u91cYWg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B0A81180F100;
        Thu, 23 Apr 2020 14:57:47 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.3])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E622710021B3;
        Thu, 23 Apr 2020 14:57:41 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id B5DE3300020FB;
        Thu, 23 Apr 2020 16:57:40 +0200 (CEST)
Subject: [PATCH net-next 0/2] Fix qdisc noop issue caused by driver and
 identify future bugs
From:   Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        ruxandra.radulescu@nxp.com, ioana.ciornei@nxp.com,
        nipun.gupta@nxp.com, shawnguo@kernel.org
Date:   Thu, 23 Apr 2020 16:57:40 +0200
Message-ID: <158765382862.1613879.11444486146802159959.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I've been very puzzled why networking on my NXP development board,
using driver dpaa2-eth, stopped working when I updated the kernel
version >= 5.3.  The observable issue were that interface would drop
all TX packets, because it had assigned the qdisc noop.

This turned out the be a NIC driver bug, that would only get triggered
when using sysctl net/core/default_qdisc=fq_codel. It was non-trivial
to find out[1] this was driver related. Thus, this patchset besides
fixing the driver bug, also helps end-user identify the issue.

[1]: https://github.com/xdp-project/xdp-project/blob/master/areas/arm64/board_nxp_ls1088/nxp-board04-troubleshoot-qdisc.org

---

Jesper Dangaard Brouer (2):
      net: sched: report ndo_setup_tc failures via extack
      dpaa2-eth: fix return codes used in ndo_setup_tc


 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c |    4 ++--
 net/sched/cls_api.c                              |    5 ++++-
 2 files changed, 6 insertions(+), 3 deletions(-)

--

