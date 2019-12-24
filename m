Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7900B129FB7
	for <lists+netdev@lfdr.de>; Tue, 24 Dec 2019 10:31:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726352AbfLXJb2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Dec 2019 04:31:28 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:33229 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726091AbfLXJb2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Dec 2019 04:31:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1577179887;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=DT0y+3Q1OP+vNQ1TzNnwdIc0JhSIyW7bghnrb3lE1cE=;
        b=hVl/8YmGMJktsW3TKdwaSs3KA1nkWGO6XCXjohUEQoIRRIkR/U9mZnRf6RLsHjyx8lQ5XA
        6Lnuy+Wo0/WbGBjmaM43qJ22MT/tZBqJn0a0bY9TdW90he5Z8bMyS6yGzCWnYEj2SR5VPT
        lE5YSNHW/pDI4rYcxauoqiz3nsOFZUY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-247-LKoIEWhFPR6nRI_inDZ9YQ-1; Tue, 24 Dec 2019 04:31:25 -0500
X-MC-Unique: LKoIEWhFPR6nRI_inDZ9YQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 518158024CC;
        Tue, 24 Dec 2019 09:31:24 +0000 (UTC)
Received: from wlan-180-229.mxp.redhat.com (wlan-180-229.mxp.redhat.com [10.32.180.229])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4E6B310018FF;
        Tue, 24 Dec 2019 09:31:23 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Vlad Buslov <vladbu@mellanox.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>
Subject: [PATCH net 0/2] net/sched: avoid walk() while deleting filters that still use rtnl_lock
Date:   Tue, 24 Dec 2019 10:30:51 +0100
Message-Id: <cover.1577179314.git.dcaratti@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

we don't need to use walk() on deletion of TC filters, at least for those
implementations that don't have TCF_PROTO_OPS_DOIT_UNLOCKED.

- patch 1/2 restores walk() semantic in cls_u32, that was recently
  changed to fix semi-configured filters in the error path of u32_change(=
).
- patch 2/2 moves the delete_empty() logic to cls_flower, the only filter
  that currently needs to guard against concurrent insert/delete.
  For flower, the current delete_empty() still [ab,]uses walk(), to
  preserve the bugfixes introduced by [1] and [2]: a follow-up commit
  in the future can implement a proper delete_empty() that avoids calls
  to fl_walk().

(tested with tdc "concurrency", "matchall", "basic" and "u32")

[1] 6676d5e416ee ("net: sched: set dedicated tcf_walker flag when tp is e=
mpty")
[2] 8b64678e0af8 ("net: sched: refactor tp insert/delete for concurrent e=
xecution")

Davide Caratti (2):
  Revert "net/sched: cls_u32: fix refcount leak in the error path of
    u32_change()"
  net/sched: add delete_empty() to filters and use it in cls_flower

 include/net/sch_generic.h |  2 ++
 net/sched/cls_api.c       | 29 ++++-------------------------
 net/sched/cls_flower.c    | 23 +++++++++++++++++++++++
 net/sched/cls_u32.c       | 25 -------------------------
 4 files changed, 29 insertions(+), 50 deletions(-)

--=20
2.24.1

