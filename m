Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E01D8262168
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 22:51:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730131AbgIHUu5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 16:50:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:36676 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726002AbgIHUu5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 16:50:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599598255;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=GNy0om5JoIr/7BIEu2NYFIA3pWbUzYKjbhajhLYwcS4=;
        b=HwAmKgMBqRwSdnKo4i/9eH8/PlE7PnroBWXJs5WdNndnFtcl9KN7wFjMubXk6fY9ctsBzR
        iJZywOMukPPxto++iJEKMazb5VqSNoR7yJnOS81C5jMQM7YQ+ExoYVlCQnjjzpUj89EGkg
        V0tJFWjgvLQK/7bLpAjGqe44kizoaP4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-580-s2UwwdvRMC2PDhM6x0qbfw-1; Tue, 08 Sep 2020 16:50:53 -0400
X-MC-Unique: s2UwwdvRMC2PDhM6x0qbfw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BB81B1084C9D;
        Tue,  8 Sep 2020 20:50:52 +0000 (UTC)
Received: from warthog.procyon.org.uk (ovpn-113-6.rdu2.redhat.com [10.10.113.6])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E4C895C22E;
        Tue,  8 Sep 2020 20:50:51 +0000 (UTC)
Subject: [PATCH net-next 0/3] rxrpc: Allow more calls to same peer
From:   David Howells <dhowells@redhat.com>
To:     netdev@vger.kernel.org
Cc:     dhowells@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 08 Sep 2020 21:50:51 +0100
Message-ID: <159959825107.645007.502549394334535916.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Here are some development patches for AF_RXRPC that allow more simultaneous
calls to be made to the same peer with the same security parameters.  The
current code allows a maximum of 4 simultaneous calls, which limits the afs
filesystem to that many simultaneous threads.  This increases the limit to
16.

To make this work, the way client connections are limited has to be changed
(incoming call/connection limits are unaffected) as the current code
depends on queuing calls on a connection and then pushing the connection
through a queue.  The limit is on the number of available connections.

This is changed such that there's a limit[*] on the total number of calls
systemwide across all namespaces, but the limit on the number of client
connections is removed.

Once a call is allowed to proceed, it finds a bundle of connections and
tries to grab a call slot.  If there's a spare call slot, fine, otherwise
it will wait.  If there's already a waiter, it will try to create another
connection in the bundle, unless the limit of 4 is reached (4 calls per
connection, giving 16).

A number of things throttle someone trying to set up endless connections:

 - Calls that fail immediately have their conns deleted immediately,

 - Calls that don't fail immediately have to wait for a timeout,

 - Connections normally get automatically reaped if they haven't been used
   for 2m, but this is sped up to 2s if the number of connections rises
   over 900.  This number is tunable by sysctl.


[*] Technically two limits - kernel sockets and userspace rxrpc sockets are
    accounted separately.

The patches are tagged here:

	git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git
	rxrpc-next-20200908

and can also be found on this branch:

	http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/log/?h=rxrpc-next

David
---
David Howells (3):
      rxrpc: Impose a maximum number of client calls
      rxrpc: Rewrite the client connection manager
      rxrpc: Allow multiple client connections to the same peer


 include/trace/events/rxrpc.h |   33 +-
 net/rxrpc/ar-internal.h      |   68 +--
 net/rxrpc/conn_client.c      | 1087 +++++++++++++++-------------------
 net/rxrpc/conn_event.c       |   14 +-
 net/rxrpc/conn_object.c      |   12 +-
 net/rxrpc/conn_service.c     |    7 +
 net/rxrpc/local_object.c     |    4 +-
 net/rxrpc/net_ns.c           |    5 +-
 net/rxrpc/output.c           |    6 +
 net/rxrpc/proc.c             |    2 +-
 net/rxrpc/rxkad.c            |    8 +-
 net/rxrpc/sysctl.c           |   10 +-
 12 files changed, 565 insertions(+), 691 deletions(-)


