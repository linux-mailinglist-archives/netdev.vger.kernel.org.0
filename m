Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 078D2183431
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 16:13:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727817AbgCLPNq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 11:13:46 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:41623 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727317AbgCLPNq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 11:13:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584026025;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=W5FqBwMSbeRe4p3igBDvoZujQRiWRTKdR1MJR648s/Q=;
        b=bLReC9trochUyKJ882S15sVEvbDZiWJMup0Yk24u1fpyE/Vy19HVTA5aPG0dLKi+mbIOdl
        nvU9ZGV1Bd3UgE23rQIWWCsrLnuMPt0R39uFeFmUUGNiNjakSuCk7h1PzNpRkmHQ7Wqdqj
        G0qbTK+Fk4CxW1xNvqy1H+MKVIc0D98=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-374-zdb5uh-AP6KI8qcdAyM5dA-1; Thu, 12 Mar 2020 11:13:43 -0400
X-MC-Unique: zdb5uh-AP6KI8qcdAyM5dA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 61462189D6C0;
        Thu, 12 Mar 2020 15:13:42 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-117-153.ams2.redhat.com [10.36.117.153])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4F30E19C6A;
        Thu, 12 Mar 2020 15:13:41 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 0/2] mptcp: simplify mptcp_accept()
Date:   Thu, 12 Mar 2020 16:13:20 +0100
Message-Id: <cover.1584006115.git.pabeni@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently we allocate the MPTCP master socket at accept time.

The above makes mptcp_accept() quite complex, and requires checks is seve=
ral
places for NULL MPTCP master socket.

These series simplify the MPTCP accept implementation, moving the master =
socket
allocation at syn-ack time, so that we drop unneeded checks with the foll=
ow-up
patch.

Note: patch 2/2 will conflict with net commit 2398e3991bda ("mptcp: alway=
s=20
include dack if possible."). If the following will help, I can send a reb=
ased
version of the series after that net is merged back into net-next.

Paolo Abeni (2):
  mptcp: create msk early
  mptcp: drop unneeded checks

 net/mptcp/options.c  |  2 +-
 net/mptcp/protocol.c | 83 ++++++++++++++++++++++++--------------------
 net/mptcp/protocol.h |  4 +--
 net/mptcp/subflow.c  | 50 ++++++++++++++------------
 net/mptcp/token.c    | 31 ++---------------
 5 files changed, 78 insertions(+), 92 deletions(-)

--=20
2.21.1

