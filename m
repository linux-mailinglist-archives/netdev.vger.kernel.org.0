Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFD8420AF73
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 12:14:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727102AbgFZKOH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 06:14:07 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:33510 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726981AbgFZKOB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 06:14:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593166440;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=1rZj+k4k0jmD4UU6X0+JzsWX5/N4TmiRm5l7UTfTieA=;
        b=fa/xjxuu7L8g8vx7LzkqL1TNQbW1HITbbdQVVz7MfU/LdYc82Z8alsl2mQH2LnUn6LzYXZ
        I1ouTUdKI/y+jyceMLnWaQRc9GmtvFcmZCQIfCapmNBhPvW+if2I8GogUhiZ3etMrCabZf
        h1rmB3xpwSyKwEdCXd8ciEiFTdr5p0A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-253-WAO_JzgtNrawHIvGRjBfDA-1; Fri, 26 Jun 2020 06:13:54 -0400
X-MC-Unique: WAO_JzgtNrawHIvGRjBfDA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CD10B464;
        Fri, 26 Jun 2020 10:13:52 +0000 (UTC)
Received: from linux.fritz.box.com (ovpn-114-92.ams2.redhat.com [10.36.114.92])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8EB355D9C5;
        Fri, 26 Jun 2020 10:13:51 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     mptcp@lists.01.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>
Subject: [PATCH net-next 0/4] mptcp: refactor token container
Date:   Fri, 26 Jun 2020 12:12:45 +0200
Message-Id: <cover.1593159603.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently the msk sockets are stored in a single radix tree, protected by a
global spin_lock. This series moves to an hash table, allocated at boot time,
with per bucker spin_lock - alike inet_hashtables, but using a different key:
the token itself.

The above improves scalability, as write operations will have a far later chance
to compete for lock acquisition, allows lockless lookup, and will allow
easier msk traversing - e.g. for diag interface implementation's sake.

This also introduces trivial, related, kunit tests and move the existing in
kernel's one to kunit.

Paolo Abeni (4):
  mptcp: add __init annotation on setup functions
  mptcp: refactor token container
  mptcp: move crypto test to KUNIT
  mptcp: introduce token KUNIT self-tests

 net/mptcp/Kconfig       |  20 ++-
 net/mptcp/Makefile      |   4 +
 net/mptcp/crypto.c      |  63 +--------
 net/mptcp/crypto_test.c |  72 +++++++++++
 net/mptcp/pm.c          |   2 +-
 net/mptcp/pm_netlink.c  |   2 +-
 net/mptcp/protocol.c    |  49 ++++---
 net/mptcp/protocol.h    |  24 ++--
 net/mptcp/subflow.c     |  21 ++-
 net/mptcp/token.c       | 280 ++++++++++++++++++++++++++++------------
 net/mptcp/token_test.c  | 139 ++++++++++++++++++++
 11 files changed, 486 insertions(+), 190 deletions(-)
 create mode 100644 net/mptcp/crypto_test.c
 create mode 100644 net/mptcp/token_test.c

-- 
2.26.2

