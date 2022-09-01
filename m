Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 210445A96B6
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 14:26:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233489AbiIAM0g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 08:26:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233484AbiIAM0d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 08:26:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4537412691C
        for <netdev@vger.kernel.org>; Thu,  1 Sep 2022 05:26:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662035191;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=Ba4/08sykqXduBdQKVgFxpLptZZtBX0Ltk6pJDa2ndI=;
        b=cWq67aBdx1TtDAn2Hind8k394T0/pKXQLHWo0BP0LIXc+85iIO8gcACakdWHCVHQGIyhRu
        164ntr2W+B+fwc943VhM7svse6mMsPnJP1oHTQd6qDQUNZ1MDLEZzda0I8Dsz2e0DUSwFe
        Wy9adGZlzLGb5xDB1uxMzAWh8BPtmQI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-589-Ti1VGnxFPDSuHH-08AJm5g-1; Thu, 01 Sep 2022 08:26:28 -0400
X-MC-Unique: Ti1VGnxFPDSuHH-08AJm5g-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EFFC7185A7A4;
        Thu,  1 Sep 2022 12:26:27 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.72])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3DF6C1121314;
        Thu,  1 Sep 2022 12:26:27 +0000 (UTC)
Subject: [PATCH net v3 0/6] rxrpc: Miscellaneous fixes
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Marc Dionne <marc.dionne@auristor.com>,
        Jeffrey E Altman <jaltman@auristor.com>,
        linux-afs@lists.infradead.org, dhowells@redhat.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Thu, 01 Sep 2022 13:26:26 +0100
Message-ID: <166203518656.271364.567426359603115318.stgit@warthog.procyon.org.uk>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Here are some fixes for AF_RXRPC:

 (1) Fix the handling of ICMP/ICMP6 packets.  This is a problem due to
     rxrpc being switched to acting as a UDP tunnel, thereby allowing it to
     steal the packets before they go through the UDP Rx queue.  UDP
     tunnels can't get ICMP/ICMP6 packets, however.  This patch adds an
     additional encap hook so that they can.

 (2) Fix the encryption routines in rxkad to handle packets that have more
     than three parts correctly.  The problem is that ->nr_frags doesn't
     count the initial fragment, so the sglist ends up too short.

 (3) Fix a problem with destruction of the local endpoint potentially
     getting repeated.

 (4) Fix the calculation of the time at which to resend.
     jiffies_to_usecs() gives microseconds, not nanoseconds.

 (5) Fix AFS to work out when callback promises and locks expire based on
     the time an op was issued rather than the time the first reply packet
     arrives.  We don't know how long the server took between calculating
     the expiry interval and transmitting the reply.

 (6) Given (5), rxrpc_get_reply_time() is no longer used, so remove it.

The patches are tagged here:

	git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git
	rxrpc-fixes-20220901

and can also be found on the following branch:

	https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git/log/?h=rxrpc-fixes

Changes
=======
ver #3)
 - Fixed an uninitialised variable.

ver #2)
 - Added some missing cpp-conditionals for rxrpc IPV6 support.
 - Replaced the callback promise time calculation patch with one that used
   the time of op issue rather than time of first reply packet as a base.
 - Added an additional patch to remove the rxrpc function to retrieve the
   time of first reply.

Link: http://lists.infradead.org/pipermail/linux-afs/2022-August/005547.html # v1
Link: http://lists.infradead.org/pipermail/linux-afs/2022-August/005552.html # v2

David
---
David Howells (6):
      rxrpc: Fix ICMP/ICMP6 error handling
      rxrpc: Fix an insufficiently large sglist in rxkad_verify_packet_2()
      rxrpc: Fix local destruction being repeated
      rxrpc: Fix calc of resend age
      afs: Use the operation issue time instead of the reply time for callbacks
      rxrpc: Remove rxrpc_get_reply_time() which is no longer used


 Documentation/networking/rxrpc.rst |  11 --
 fs/afs/flock.c                     |   2 +-
 fs/afs/fsclient.c                  |   2 +-
 fs/afs/internal.h                  |   3 +-
 fs/afs/rxrpc.c                     |   7 +-
 fs/afs/yfsclient.c                 |   3 +-
 include/linux/udp.h                |   1 +
 include/net/af_rxrpc.h             |   2 -
 include/net/udp_tunnel.h           |   4 +
 net/ipv4/udp.c                     |   2 +
 net/ipv4/udp_tunnel_core.c         |   1 +
 net/ipv6/udp.c                     |   5 +-
 net/rxrpc/ar-internal.h            |   1 +
 net/rxrpc/call_event.c             |   2 +-
 net/rxrpc/local_object.c           |   4 +
 net/rxrpc/peer_event.c             | 293 +++++++++++++++++++++++++----
 net/rxrpc/recvmsg.c                |  43 -----
 net/rxrpc/rxkad.c                  |   2 +-
 18 files changed, 280 insertions(+), 108 deletions(-)


