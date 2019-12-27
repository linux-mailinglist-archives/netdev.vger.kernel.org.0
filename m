Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D643612B60D
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 18:13:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726936AbfL0RNZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 12:13:25 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:22232 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726379AbfL0RNY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Dec 2019 12:13:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1577466803;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=Rmj8E5yL9BatiEgjOvcPTEtZXANr7YUpfWiF1mIXN2g=;
        b=VZQhXvAHmXcOiH712g4cWFp/j/C5SALvoANBGxkZnbzF8205Nau+ZTjac/yBgB/60cPx9Y
        /Kd5befBz3UKu2booKcSav2eVmPCaz1RPwSL9UxL5Mop9iN4rhJduAuTbLsHXSgvjyESiQ
        OUWRZxQnY6gWrtIq2l/XF5OUAt46pH8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-50-XC5q9m49PF-re6NKpyKRfw-1; Fri, 27 Dec 2019 12:13:19 -0500
X-MC-Unique: XC5q9m49PF-re6NKpyKRfw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1555D800D41;
        Fri, 27 Dec 2019 17:13:18 +0000 (UTC)
Received: from firesoul.localdomain (ovpn-200-26.brq.redhat.com [10.40.200.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 40E9C5C28C;
        Fri, 27 Dec 2019 17:13:15 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id E271030736C73;
        Fri, 27 Dec 2019 18:13:13 +0100 (CET)
Subject: [net-next v6 PATCH 0/2] page_pool: NUMA node handling fixes
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, lirongqing@baidu.com,
        linyunsheng@huawei.com,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Saeed Mahameed <saeedm@mellanox.com>, mhocko@kernel.org,
        peterz@infradead.org, linux-kernel@vger.kernel.org
Date:   Fri, 27 Dec 2019 18:13:13 +0100
Message-ID: <157746672570.257308.7385062978550192444.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The recently added NUMA changes (merged for v5.5) to page_pool, it both
contains a bug in handling NUMA_NO_NODE condition, and added code to
the fast-path.

This patchset fixes the bug and moves code out of fast-path. The first
patch contains a fix that should be considered for 5.5. The second
patch reduce code size and overhead in case CONFIG_NUMA is disabled.

Currently the NUMA_NO_NODE setting bug only affects driver 'ti_cpsw'
(drivers/net/ethernet/ti/), but after this patchset, we plan to move
other drivers (netsec and mvneta) to use NUMA_NO_NODE setting.

---

Jesper Dangaard Brouer (2):
      page_pool: handle page recycle for NUMA_NO_NODE condition
      page_pool: help compiler remove code in case CONFIG_NUMA=n


 net/core/page_pool.c |   89 +++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 70 insertions(+), 19 deletions(-)

--

