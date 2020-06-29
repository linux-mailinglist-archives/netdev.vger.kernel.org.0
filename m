Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1415720DE96
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 23:53:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389115AbgF2U1F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 16:27:05 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:55754 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1732681AbgF2U1D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 16:27:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593462422;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=O7ZVTsrBJ+O5RqXyvN0KbuxHOv/sVXGRb+pXDm71DxU=;
        b=cOl8DDV+Ez8csd0hSL4WYyX0T8XYexvOynzWy0didwqzwYs1vCJg5YGVIdM/CDeLBkZ+Op
        7Pek/oL31m0aB1wreefUGvmxEvi6NTKsQEt4E4GKJzhIocsDkDpUqdEMvZyBvKnkogQCHF
        BWG/Dzkh6C0rVDdejMZ0W8VGc2ufcuA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-5-Y94fP-RpOw6N_ZA-Vo8D-w-1; Mon, 29 Jun 2020 16:26:46 -0400
X-MC-Unique: Y94fP-RpOw6N_ZA-Vo8D-w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6DDF3EC1A1;
        Mon, 29 Jun 2020 20:26:44 +0000 (UTC)
Received: from new-host-5.redhat.com (unknown [10.40.194.100])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9FA6D7BEBB;
        Mon, 29 Jun 2020 20:26:42 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        mptcp@lists.01.org
Subject: [PATCH net-next 0/6] MPTCP: improve fallback to TCP
Date:   Mon, 29 Jun 2020 22:26:19 +0200
Message-Id: <cover.1593461586.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

there are situations where MPTCP sockets should fall-back to regular TCP:
this series reworks the fallback code to pursue the following goals:

1) cleanup the non fallback code, removing most of 'if (<fallback>)' in
   the data path
2) improve performance for non-fallback sockets, avoiding locks in poll()

further work will also leverage on this changes to achieve:

a) more consistent behavior of gestockopt()/setsockopt() on passive sockets
   after fallback
b) support for "infinite maps" as per RFC8684, section 3.7

the series is made of the following items:

- patch 1 lets sendmsg() / recvmsg() / poll() use the main socket also
  after fallback
- patch 2 fixes 'simultaneous connect' scenario after fallback. The
  problem was present also before the rework, but the fix is much easier
  to implement after patch 1
- patch 3, 4, 5 are clean-ups for code that is no more needed after the
  fallback rework
- patch 6 fixes a race condition between close() and poll(). The problem
  was theoretically present before the rework, but it became almost
  systematic after patch 1

Davide Caratti (2):
  net: mptcp: improve fallback to TCP
  mptcp: fallback in case of simultaneous connect

Paolo Abeni (4):
  mptcp: check for plain TCP sock at accept time
  mptcp: create first subflow at msk creation time
  mptcp: __mptcp_tcp_fallback() returns a struct sock
  mptcp: close poll() races

 net/mptcp/options.c  |   9 +-
 net/mptcp/protocol.c | 267 ++++++++++++++-----------------------------
 net/mptcp/protocol.h |  43 +++++++
 net/mptcp/subflow.c  |  57 ++++++---
 4 files changed, 175 insertions(+), 201 deletions(-)

-- 
2.26.2

