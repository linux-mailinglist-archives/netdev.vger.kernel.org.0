Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D10C12B030D
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 11:49:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727943AbgKLKtC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 05:49:02 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:56815 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727762AbgKLKtC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 05:49:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605178141;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=R8OCa7Uh+ORdqE3z6odRC5dwpb2DnPpFXc0970NX0Qs=;
        b=UuxeqQEUsrCK3SBjdxHnyO4VUcnETOwuMPxPWCLcV/lIgXxoCdRxER3eQjOQPENekFGOWk
        Pa5ODZ4Ikmhl3Ka//Z+17dZzAjJYerZR+IhUkHBv2KhoVnGLETbNHVTn/4RyHcWE99Wqd9
        lRsZbrjX8DbWXZU1b+iuNZLZaNKGKcc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-110-Z7kqR-gBP0SxoaVIilkghg-1; Thu, 12 Nov 2020 05:48:57 -0500
X-MC-Unique: Z7kqR-gBP0SxoaVIilkghg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0582E1084D79;
        Thu, 12 Nov 2020 10:48:56 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-112-208.ams2.redhat.com [10.36.112.208])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CCDDD5C3E1;
        Thu, 12 Nov 2020 10:48:54 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>, mptcp@lists.01.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 00/13] mptcp: improve multiple xmit streams support
Date:   Thu, 12 Nov 2020 11:47:58 +0100
Message-Id: <cover.1605175834.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series improves MPTCP handling of multiple concurrent
xmit streams.

The to-be-transmitted data is enqueued to a subflow only when
the send window is open, keeping the subflows xmit queue shorter
and allowing for faster switch-over.

The above requires a more accurate msk socket state tracking
and some additional infrastructure to allow pushing the data
pending in the msk xmit queue as soon as the MPTCP's send window
opens (patches 6-10).

As a side effect, the MPTCP socket could enqueue data to subflows
after close() time - to completely spooling the data sitting in the 
msk xmit queue. Dealing with the requires some infrastructure and 
core TCP changes (patches 1-5)

Finally, patches 11-12 introduce a more accurate tracking of the other
end's receive window.

Overall this refactor the MPTCP xmit path, without introducing
new features - the new code is covered by the existing self-tests.

Florian Westphal (2):
  mptcp: rework poll+nospace handling
  mptcp: keep track of advertised windows right edge

Paolo Abeni (11):
  tcp: factor out tcp_build_frag()
  mptcp: use tcp_build_frag()
  tcp: factor out __tcp_close() helper
  mptcp: introduce mptcp_schedule_work
  mptcp: reduce the arguments of mptcp_sendmsg_frag
  mptcp: add accounting for pending data
  mptcp: introduce MPTCP snd_nxt
  mptcp: refactor shutdown and close
  mptcp: move page frag allocation in mptcp_sendmsg()
  mptcp: try to push pending data on snd una updates
  mptcp: send explicit ack on delayed ack_seq incr

 include/net/tcp.h      |   4 +
 net/ipv4/tcp.c         | 128 +++---
 net/mptcp/options.c    |  30 +-
 net/mptcp/pm.c         |   3 +-
 net/mptcp/pm_netlink.c |   6 +-
 net/mptcp/protocol.c   | 969 ++++++++++++++++++++++++-----------------
 net/mptcp/protocol.h   |  72 ++-
 net/mptcp/subflow.c    |  33 +-
 8 files changed, 758 insertions(+), 487 deletions(-)

-- 
2.26.2

