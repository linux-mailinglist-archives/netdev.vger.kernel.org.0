Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A3A21BF8B9
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 15:02:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726774AbgD3NCS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 09:02:18 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:28023 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726483AbgD3NCS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 09:02:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588251736;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=xw2Xb2wJ2xu8H2TQq5DhUVlSudmCRsSvtB7aXWKTiB8=;
        b=AXawLevpqw7Z/XvBdoy8HsBjRM6l8lCgKU5P7nLLXwMgKd8bWFKU7kUJwEEm9qa8NjERIK
        h3FoJ3KmVpUDkMOy+gDZC+I0h+iZDDvv+WfnlLW4YeJRZHSbvij6z2EyzxY9+ibvqiHwRO
        w56CLhr3wZYKR2sPAJxBM4NQfNxsEXQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-512-VehS5wkVOEyQ2Ngh40cmhg-1; Thu, 30 Apr 2020 09:02:13 -0400
X-MC-Unique: VehS5wkVOEyQ2Ngh40cmhg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 899DB80B70A;
        Thu, 30 Apr 2020 13:02:09 +0000 (UTC)
Received: from linux.fritz.box.com (ovpn-114-219.ams2.redhat.com [10.36.114.219])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D83CC6A942;
        Thu, 30 Apr 2020 13:02:06 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Christoph Paasch <cpaasch@apple.com>, mptcp@lists.01.org
Subject: [PATCH net v2 0/5] mptcp: fix incoming options parsing
Date:   Thu, 30 Apr 2020 15:01:50 +0200
Message-Id: <cover.1588243786.git.pabeni@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series addresses a serious issue in MPTCP option parsing.

This is bigger than the usual -net change, but I was unable to find a
working, sane, smaller fix.

The core change is inside patch 2/5 which moved MPTCP options parsing fro=
m
the TCP code inside existing MPTCP hooks and clean MPTCP options status o=
n
each processed packet.

The patch 1/5 is a needed pre-requisite, and patches 3,4,5 are smaller,
related fixes.

v1 -> v2:
 - cleaned-up patch 1/5
 - rebased on top of current -net

Paolo Abeni (5):
  mptcp: consolidate synack processing.
  mptcp: move option parsing into  mptcp_incoming_options()
  mptcp: avoid a WARN on bad input.
  mptcp: fix 'use_ack' option access.
  mptcp: initialize the data_fin field for mpc packets

 include/linux/tcp.h  | 51 ------------------------
 include/net/mptcp.h  |  3 --
 net/ipv4/tcp_input.c |  7 ----
 net/mptcp/options.c  | 95 +++++++++++++++++++-------------------------
 net/mptcp/protocol.c |  6 +--
 net/mptcp/protocol.h | 43 +++++++++++++++++++-
 net/mptcp/subflow.c  | 82 ++++++++++++++++++++++++--------------
 7 files changed, 138 insertions(+), 149 deletions(-)

--=20
2.21.1

