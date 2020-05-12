Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87FAD1CF687
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 16:11:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730201AbgELOLR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 10:11:17 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:41613 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728085AbgELOLR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 10:11:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589292675;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=XKh6cIrJloyxlO/DTVFjFMHqTi2+m2kafLrybOXp1TQ=;
        b=etiEfyYpf6orcKEDtYoqdTTcK24u3lDgm20H0shzyKir6SpFC65lUQYx1A2sgR2jKKLxEr
        2TMD9OxxYWnRxzo6QRtr+zf+vWV/JwdR8pBa2Z+cmfsQlrqgK+wpYnNKZ3Lg3a559yvl62
        OmAb1fK4pKjShABFiOMCLbaUTLlWY5w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-507-CUyY899FNJaBwMhHYUDxng-1; Tue, 12 May 2020 10:11:13 -0400
X-MC-Unique: CUyY899FNJaBwMhHYUDxng-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7F5A319200C9;
        Tue, 12 May 2020 14:11:12 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-115-10.ams2.redhat.com [10.36.115.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 383D15D9DD;
        Tue, 12 May 2020 14:11:11 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Christoph Paasch <cpaasch@apple.com>
Subject: [RFC PATCH 0/3] mptcp: fix MP_JOIN failure handling
Date:   Tue, 12 May 2020 16:08:07 +0200
Message-Id: <cover.1589280857.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
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
specific bit in a 'struct sock' hole, and leveraging that to allow
tcp_check_req releasing the request socket when needed.

The above allows cleaning-up a bit current MPTCP hooking in tcp_check_req().

An alternative solution, possibly cleaner but more invasive, would be
changing the 'bool *own_req' syn_recv_sock() argument into 'int *req_status'
and let MPTCP set it to 'REQ_DROP'.

Paolo Abeni (3):
  mptcp: add new sock flag to deal with join subflows
  inet_connection_sock: factor out destroy helper.
  mptcp: cope better with MP_JOIN failure

 include/linux/tcp.h                |  1 +
 include/net/inet_connection_sock.h |  8 ++++++++
 include/net/mptcp.h                | 17 ++++++++++-------
 net/ipv4/inet_connection_sock.c    |  6 +-----
 net/ipv4/tcp_minisocks.c           |  2 +-
 net/mptcp/protocol.c               |  7 -------
 net/mptcp/subflow.c                | 17 +++++++++++------
 7 files changed, 32 insertions(+), 26 deletions(-)

-- 
2.21.3

