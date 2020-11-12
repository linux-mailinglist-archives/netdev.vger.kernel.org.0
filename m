Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1419E2B0B7C
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 18:46:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726205AbgKLRq1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 12:46:27 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34001 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725999AbgKLRq1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 12:46:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605203186;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=KfbWGUuCzLgBWD+bbt6bFT/H+lwpvPHLlvbYkqXPlAo=;
        b=RWnJZaByXb35M74FzYLwg6Eh3LNvBfipxWy9K97KOwovxdb8K8sk5QCEehWCqV+rUk1w07
        Q23fwX9mZAT2JZ2NVhlnIRr4hyxp1XR1J7Us2xXAcQ2cIcoSZQFNqllQk5pQe3dEixJOMe
        xBx8gr1eFJfrQBy/7vGlT5cMAUkNCVw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-293-PNadXp2hOkeXYkkh7GGf7Q-1; Thu, 12 Nov 2020 12:46:23 -0500
X-MC-Unique: PNadXp2hOkeXYkkh7GGf7Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 29059809DF3;
        Thu, 12 Nov 2020 17:46:22 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-112-208.ams2.redhat.com [10.36.112.208])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7B4505578C;
        Thu, 12 Nov 2020 17:46:19 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>, mptcp@lists.01.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 00/13] mptcp: improve multiple xmit streams support
Date:   Thu, 12 Nov 2020 18:45:20 +0100
Message-Id: <cover.1605199807.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
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

v1 -> v2:
 - this is just a report, to cope with patchwork issues, no changes
   at all

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

