Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88E4F1D579E
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 19:23:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726715AbgEORXQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 13:23:16 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:50522 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726219AbgEORXQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 13:23:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589563394;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=r+1s+tgTg+MUfYSr+A1VDjS89rNEqCAIVAygtqWDay0=;
        b=QTFzwdxS9Jo7HrITqSOUXLCF0O9WqYZ2moUFsIh+0qZp6xOF1Uptmc598Nk8KfpTbAOeUE
        tOnNxjX3MCP15cd+A6AgjXHcYVA/rNmXVtAQQYgd1qci8OjW+ZM7+qJWGM+qkTGXYgnm/n
        HUneu74kfivgYu7/KLPZM6VEwYH2RWg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-327-Mb3sdlsKM3mDkzsnr2oQKA-1; Fri, 15 May 2020 13:23:11 -0400
X-MC-Unique: Mb3sdlsKM3mDkzsnr2oQKA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B1FA18014D7;
        Fri, 15 May 2020 17:23:09 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-115-8.ams2.redhat.com [10.36.115.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E6050600F5;
        Fri, 15 May 2020 17:23:07 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Christoph Paasch <cpaasch@apple.com>, mptcp@lists.01.org,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next v2 0/3] mptcp: fix MP_JOIN failure handling
Date:   Fri, 15 May 2020 19:22:14 +0200
Message-Id: <cover.1589558049.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
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

v1 -> v2:
 - be more conservative about drop_req initialization

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
 net/mptcp/subflow.c                | 18 ++++++++++++------
 7 files changed, 35 insertions(+), 26 deletions(-)

-- 
2.21.3

