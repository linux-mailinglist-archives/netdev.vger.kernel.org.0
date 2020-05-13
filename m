Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B7121D1971
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 17:31:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732383AbgEMPbW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 11:31:22 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:26770 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728678AbgEMPbW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 11:31:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589383880;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=CNJTIIxEQ9zZEmVQKMUcM6wXoekFuTernYzAb46FlGI=;
        b=f7whdmYUak7tTgK/MrHj44J3CkN/W1dzizYVL0AbKdTPE+g12I+R+HUTLfgxGkqsBKikeq
        fU4ZI6r/JIVv6UFrkNz6WV1/TX9zqftTC6HDHZTNkRUlmdCN9P8qAE8Jhgpk7KII5HhcES
        z9jbO9oIJcL+4ikUleAOlfmzzQtR6Fg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-249-vbHgatMsNQ6QgAw5YKXEmA-1; Wed, 13 May 2020 11:31:14 -0400
X-MC-Unique: vbHgatMsNQ6QgAw5YKXEmA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A6D85835B4A;
        Wed, 13 May 2020 15:31:13 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-113-27.ams2.redhat.com [10.36.113.27])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4A1E91000337;
        Wed, 13 May 2020 15:31:12 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Christoph Paasch <cpaasch@apple.com>
Subject: [PATCH net-next 0/3] mptcp: fix MP_JOIN failure handling
Date:   Wed, 13 May 2020 17:31:01 +0200
Message-Id: <cover.1589383730.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently if we hit an MP_JOIN failure on the third ack, the child socket is
closed with reset, but the request socket is not deleted, causing weird
behaviors.

The main problem is that MPTCP's MP_JOIN code needs to plug it's own
'valid 3rd ack' checks and the current TCP callbacks do not allow that.

This series tries to address the above shortcoming introducing a new MPTCP
specific bit in a 'struct tcp_request_sock' hole, and leveraging that to allow
tcp_check_req releasing the request socket when needed.

The above allows cleaning-up a bit current MPTCP hooking in tcp_check_req().

An alternative solution, possibly cleaner but more invasive, would be
changing the 'bool *own_req' syn_recv_sock() argument into 'int *req_status'
and let MPTCP set it to 'REQ_DROP'.

RFC -> v1:
 - move the drop_req bit inside tcp_request_sock (Eric)

Paolo Abeni (3):
  mptcp: add new sock flag to deal with join subflows
  inet_connection_sock: factor out destroy helper.
  mptcp: cope better with MP_JOIN failure

 include/linux/tcp.h                |  3 +++
 include/net/inet_connection_sock.h |  8 ++++++++
 include/net/mptcp.h                | 17 ++++++++++-------
 net/ipv4/inet_connection_sock.c    |  6 +-----
 net/ipv4/tcp_minisocks.c           |  2 +-
 net/mptcp/protocol.c               |  7 -------
 net/mptcp/subflow.c                | 17 +++++++++++------
 7 files changed, 34 insertions(+), 26 deletions(-)

-- 
2.21.3

