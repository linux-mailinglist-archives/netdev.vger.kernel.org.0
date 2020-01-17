Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74E04140FDC
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 18:28:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729108AbgAQR2e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jan 2020 12:28:34 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:46092 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729049AbgAQR2d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jan 2020 12:28:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579282112;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=/mnw4crB1zW5t64x4jbmc53aFkBw5KwUEgtzL7eehUY=;
        b=BYPWiAMOenqcFfWaXq8JF7EP8xfMqW+cOK3yb/IVo63KrgG0B9krDMrbCH9rYGpwllZW+q
        aPG2BfP5X7gKpJCnn2qhUIQY3A8W9gxTzvNEgtdPTnVR0ZmQ9dP9exZkeUlHJkhSlWGCKo
        rQuwgwnOyS815uVcyUZUZoBcgVvo9OA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-412-BMKdMvVsNPa9Hwgw0Spjog-1; Fri, 17 Jan 2020 12:28:26 -0500
X-MC-Unique: BMKdMvVsNPa9Hwgw0Spjog-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9743EDB22;
        Fri, 17 Jan 2020 17:28:25 +0000 (UTC)
Received: from localhost.localdomain.com (unknown [10.36.118.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 916D15D9CD;
        Fri, 17 Jan 2020 17:28:24 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Subject: [PATCH net 0/3] udp: behave under memory pressure
Date:   Fri, 17 Jan 2020 18:27:53 +0100
Message-Id: <cover.1579281705.git.pabeni@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Williem reported that in some scenarios the UDP protocol can keep a lot o=
f
memory in use on an idle system. He also diagnosed the root cause in the
forward allocated memory bulk free.

This series addresses the issue adding memory pressure tracking for the U=
DP
protocol, and flushing the fwd allocated memory if the protocol is under
memory pressure.

The first two patches clean-up the current memory pressure helpers for UD=
P
usage, and the 3rd one is the actual fix.

Targeting the net tree, as this addresses a reported issue. I guess even
net-next can be considered a valid target, as this also changes slightly =
the
protocol behavior under memory pressure. Please advise on the preferred o=
ption.

Paolo Abeni (3):
  net: generic enter_memory_pressure implementation.
  net: add annotation to memory_pressure lockless access
  udp: avoid bulk memory scheduling on memory pressure.

 include/net/sock.h |  4 ++--
 include/net/udp.h  |  2 ++
 net/core/sock.c    | 10 +++++++---
 net/ipv4/udp.c     | 13 ++++++++++++-
 net/ipv6/udp.c     |  2 ++
 5 files changed, 25 insertions(+), 6 deletions(-)

--=20
2.21.0

