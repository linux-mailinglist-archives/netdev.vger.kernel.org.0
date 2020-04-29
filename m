Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 235931BD9E3
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 12:42:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726625AbgD2KmV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 06:42:21 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:29838 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726558AbgD2KmU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 06:42:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588156939;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=hrJpRjqlEu/UcuxY5AVUv/22u4ZTEP9BFfbUeRUtUSE=;
        b=fQqxhNrsfdNpHo6xQdIillQR3rALuWlD7z57NCtTeZ+4RsLCAdJQ1L720X5VjoVMENlj29
        Brkoztyu8pce7+zwGpeyTjsmCB2fDKX6a+s5OpsMUE74JoB4/1upzS2nk93ruSUZGHLhgR
        AvRqkNJignXIG0fqRbQXYX/GD5BG77E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-405-IGo0j1nsPCyJAcLZPm34Uw-1; Wed, 29 Apr 2020 06:42:17 -0400
X-MC-Unique: IGo0j1nsPCyJAcLZPm34Uw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 93732EC1AA;
        Wed, 29 Apr 2020 10:42:15 +0000 (UTC)
Received: from linux.fritz.box.com (ovpn-114-45.ams2.redhat.com [10.36.114.45])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B0CEF282E6;
        Wed, 29 Apr 2020 10:42:12 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Christoph Paasch <cpaasch@apple.com>, mptcp@lists.01.org
Subject: [PATCH net 0/5] mptcp: fix incoming options parsing
Date:   Wed, 29 Apr 2020 12:41:44 +0200
Message-Id: <cover.1588156257.git.pabeni@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
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

Paolo Abeni (5):
  mptcp: consolidate synack processing.
  mptcp: move option parsing into mptcp_incoming_options()
  mptcp: avoid a WARN on bad input.
  mptcp: fix 'use_ack' option access.
  mptcp: initialize the data_fin field for mpc packets

 include/linux/tcp.h  | 51 ------------------------
 include/net/mptcp.h  |  3 --
 net/ipv4/tcp_input.c |  7 ----
 net/mptcp/options.c  | 95 +++++++++++++++++++-------------------------
 net/mptcp/protocol.c |  6 +--
 net/mptcp/protocol.h | 43 +++++++++++++++++++-
 net/mptcp/subflow.c  | 81 +++++++++++++++++++++++--------------
 7 files changed, 137 insertions(+), 149 deletions(-)

--=20
2.21.1

