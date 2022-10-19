Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64A0260425C
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 13:00:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231741AbiJSLAC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 07:00:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234995AbiJSK72 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 06:59:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDD55169CE5
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 03:29:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666175289;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=y7r7YnLY1wgAwTgoY9fjwArfo1xFtIZQl0s3nkpTNEU=;
        b=YvG84/iDfe93JWctT4nUCYA2QxRFkKUrcR0ONX+EIZnCu+Z8NA1TaNAb2Yk/nsYOM1JmLH
        9H2DtID+tV5iSY55MPSwnlE1cgUUUY2hOJhBg2IlAXFcbUrxZIQa1CCNxjGCbeaVCB+M5i
        g18AfF1x7MgkOVW8X8I6XOLJCThhCK0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-107-sRsxGDfuOVaEkfcTDGs-RA-1; Wed, 19 Oct 2022 06:02:30 -0400
X-MC-Unique: sRsxGDfuOVaEkfcTDGs-RA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9FD308279A8;
        Wed, 19 Oct 2022 10:02:29 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.39.194.193])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0876A200BBD2;
        Wed, 19 Oct 2022 10:02:22 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, mptcp@lists.linux.dev,
        David Ahern <dsahern@kernel.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>
Subject: [PATCH net-next 0/2] udp: avoid false sharing on receive
Date:   Wed, 19 Oct 2022 12:01:59 +0200
Message-Id: <cover.1666173045.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Under high UDP load, the BH processing and the user-space receiver can
run on different cores.

The UDP implementation does a lot of effort to avoid false sharing in
the receive path, but recent changes to the struct sock layout moved
the sk_forward_alloc and the sk_rcvbuf fields on the same cacheline:

        /* --- cacheline 4 boundary (256 bytes) --- */
                struct sk_buff *   tail;
        } sk_backlog;
        int                        sk_forward_alloc;
        unsigned int               sk_reserved_mem;
        unsigned int               sk_ll_usec;
        unsigned int               sk_napi_id;
        int                        sk_rcvbuf;

sk_forward_alloc is updated by the BH, while sk_rcvbuf is accessed by
udp_recvmsg(), causing false sharing.

A possible solution would be to re-order the struct sock fields to avoid
the false sharing. Such change is subject to being invalidated by future
changes and could have negative side effects on other workload.

Instead this series uses a different approach, touching only the UDP
socket layout. 

The first patch generalizes the custom setsockopt infrastructure, to
allow UDP tracking the buffer size, and the second patch addresses the
issue, copying the relevant buffer information into an already hot
cacheline.

Overall the above gives a 10% peek throughput increase under UDP flood.

Paolo Abeni (2):
  net: introduce and use custom sockopt socket flag
  udp: track the forward memory release threshold in an hot cacheline

 include/linux/net.h  |  1 +
 include/linux/udp.h  |  3 +++
 net/ipv4/udp.c       | 22 +++++++++++++++++++---
 net/ipv6/udp.c       |  8 ++++++--
 net/mptcp/protocol.c |  4 ++++
 net/socket.c         |  8 +-------
 6 files changed, 34 insertions(+), 12 deletions(-)

-- 
2.37.3

