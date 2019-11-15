Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 768FCFE0D4
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 16:06:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727577AbfKOPGE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 10:06:04 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:39341 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727406AbfKOPGE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 10:06:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573830364;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=TODaIAwhcCK/CDTAy8pB/JaSNs2DJO3Mkp3NEKFUlpo=;
        b=bJwXh2OxwsfV7WfGTVq/xOyecn1hP7fHPBQ+SmdcHkhKUmhcHNmgWK8ZHenm3rnLNLVNqu
        7vr1wyL0PdCQ5iymfpF4IQVGT0LCGnGk3ft8/4/qJeFlUsQ3CTjS8f5vpIAOol/5zXRjcC
        /rVXifSYq16Ighw6+MfXKCkGssRLwcA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-29-BY7Tp7GWOLGHIL03QnnoSg-1; Fri, 15 Nov 2019 10:06:02 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3937D1005511;
        Fri, 15 Nov 2019 15:06:01 +0000 (UTC)
Received: from firesoul.localdomain (ovpn-200-41.brq.redhat.com [10.40.200.41])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5051D6055E;
        Fri, 15 Nov 2019 15:05:55 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 06A0B30FC134F;
        Fri, 15 Nov 2019 16:05:54 +0100 (CET)
Subject: [net-next v1 PATCH 0/4] page_pool: followup changes to restore
 tracepoint features
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
Date:   Fri, 15 Nov 2019 16:05:53 +0100
Message-ID: <157383032789.3173.11648581637167135301.stgit@firesoul>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: BY7Tp7GWOLGHIL03QnnoSg-1
X-Mimecast-Spam-Score: 2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset is a followup to Jonathan patch, that do not release
pool until inflight =3D=3D 0. That changed page_pool to be responsible for
its own delayed destruction instead of relying on xdp memory model.

As the page_pool maintainer, I'm promoting the use of tracepoint to
troubleshoot and help driver developers verify correctness when
converting at driver to use page_pool. The role of xdp:mem_disconnect
have changed, which broke my bpftrace tools for shutdown verification.
With these changes, the same capabilities are regained.

---

Jesper Dangaard Brouer (4):
      xdp: remove memory poison on free for struct xdp_mem_allocator
      page_pool: add destroy attempts counter and rename tracepoint
      page_pool: block alloc cache during shutdown
      page_pool: extend tracepoint to also include the page PFN


 include/net/page_pool.h          |    2 ++
 include/trace/events/page_pool.h |   22 +++++++++++++++-------
 net/core/page_pool.c             |   17 +++++++++++++++--
 net/core/xdp.c                   |    5 -----
 4 files changed, 32 insertions(+), 14 deletions(-)

--

