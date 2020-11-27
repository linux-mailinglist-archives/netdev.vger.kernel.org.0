Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C96CA2C6287
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 11:11:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726591AbgK0KKr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 05:10:47 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:41156 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725854AbgK0KKr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Nov 2020 05:10:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606471846;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=5o1Y9jfYkIJfU2WLAw69zK9dshLpzcvcgkRyyicgbOU=;
        b=dI618EtTDPMjOvMaaRpI83kMPoNZ1KWa1R+JdUQomeoXFkYODfI2Em2tC2LFFL+oOHcuUr
        UfkzAChL9eflJFeHP27y2yJ2v0tCZgbhWZbDPvoZOmcTUONHcyfEk1ITKhyEoWCZpB7YV7
        3ALniBMYAH6M0iHue12m6kSmf9EVG7k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-504-NkSouSKJNYuAfQRppph5mw-1; Fri, 27 Nov 2020 05:10:41 -0500
X-MC-Unique: NkSouSKJNYuAfQRppph5mw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 49207185E49A;
        Fri, 27 Nov 2020 10:10:40 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-113-134.ams2.redhat.com [10.36.113.134])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DDD361002388;
        Fri, 27 Nov 2020 10:10:38 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>, mptcp@lists.01.org,
        Eric Dumazet <edumazet@google.com>
Subject: [PATCH net-next 0/6] mptcp: avoid workqueue usage for data
Date:   Fri, 27 Nov 2020 11:10:21 +0100
Message-Id: <cover.1606413118.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current locking schema used to protect the MPTCP data-path
requires the usage of the MPTCP workqueue to process the incoming
data, depending on trylock result.

The above poses scalability limits and introduces random delays
in MPTCP-level acks.

With this series we use a single spinlock to protect the MPTCP
data-path, removing the need for workqueue and delayed ack usage.

This additionally reduces the number of atomic operations required
per packet and cleans-up considerably the poll/wake-up code.

Paolo Abeni (6):
  mptcp: open code mptcp variant for lock_sock
  mptcp: implement wmem reservation
  mptcp: protect the rx path with the msk socket spinlock
  mptcp: allocate TX skbs in msk context
  mptcp: avoid a few atomic ops in the rx path
  mptcp: use mptcp release_cb for delayed tasks

 include/net/sock.h     |   1 +
 net/core/sock.c        |   2 +-
 net/mptcp/mptcp_diag.c |   2 +-
 net/mptcp/options.c    |  47 +--
 net/mptcp/protocol.c   | 733 ++++++++++++++++++++++++++++++-----------
 net/mptcp/protocol.h   |  34 +-
 net/mptcp/subflow.c    |  14 +-
 7 files changed, 598 insertions(+), 235 deletions(-)

-- 
2.26.2

