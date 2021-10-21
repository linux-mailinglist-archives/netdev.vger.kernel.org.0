Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C6384361C7
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 14:37:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231664AbhJUMjk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 08:39:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:29064 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230190AbhJUMji (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Oct 2021 08:39:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634819842;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=HWHcgiYDzaXrjPI7m9/Xp249PFRd3etzjepjjebnpmw=;
        b=VlAYXwucq3v4yB3ewjfdXvFK0qmU2evKpUbk1q2pJJ4QA7/em3ZpRlp/j7OBgGSYyKyTMm
        c+PrFa1UzJYlQOaB5e6PkADq05c7gyCFQLe1jjpnfHGs62jxfSZ1303zgRgCsW2Ca8B+Wo
        yt6sBrZBKe9Dng/0PFsjXhYjS9KU8+w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-11-_h6xohpQMd2xpvBYc-s13A-1; Thu, 21 Oct 2021 08:37:19 -0400
X-MC-Unique: _h6xohpQMd2xpvBYc-s13A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 51B481018720;
        Thu, 21 Oct 2021 12:37:18 +0000 (UTC)
Received: from localhost (unknown [10.39.208.31])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2F9F1100E12D;
        Thu, 21 Oct 2021 12:37:16 +0000 (UTC)
From:   =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, sgarzare@redhat.com,
        davem@davemloft.net, kuba@kernel.org,
        =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>
Subject: [PATCH 00/10] RFC: SO_PEERCRED for AF_VSOCK
Date:   Thu, 21 Oct 2021 16:37:04 +0400
Message-Id: <20211021123714.1125384-1-marcandre.lureau@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This RFC aims to implement some support for SO_PEERCRED with AF_VSOCK,
so vsock servers & clients can lookup the basic peer credentials.
(further support for SO_PEERSEC could also be useful)

This is pretty straightforward for loopback transport, where both ends
are on the same host.

For vhost transport, the host will set the peer credentials associated with
the process who called VHOST_SET_OWNER (ex QEMU).

For virtio transport, the credentials are cleared upon connect, as
providing foreign credentials wouldn't make much sense.

I haven't looked at other transports. What do you think of this approach?

Note: I think it would be a better to set the peer credentials when we
actually can provide them, rather than at creation time, but I haven't
found a way yet. Help welcome!

Marc-André Lureau (10):
  sock: move sock_init_peercred() from af_unix
  sock: move sock_copy_peercred() from af_unix
  vsock: owner field is specific to VMCI
  sock: add sock_swap_peercred
  virtio/vsock: add copy_peercred() to virtio_transport
  vsock: set socket peercred
  vsock/loopback: implement copy_peercred()
  vhost/vsock: save owner pid & creds
  vhost/vsock: implement copy_peercred
  vsock/virtio: clear peer creds on connect

 drivers/vhost/vsock.c                   | 46 +++++++++++++++++
 include/linux/virtio_vsock.h            |  2 +
 include/net/af_vsock.h                  |  2 +
 include/net/sock.h                      |  9 ++++
 net/core/sock.c                         | 66 +++++++++++++++++++++++++
 net/unix/af_unix.c                      | 50 ++-----------------
 net/vmw_vsock/af_vsock.c                |  8 +++
 net/vmw_vsock/virtio_transport.c        | 22 ++++++++-
 net/vmw_vsock/virtio_transport_common.c |  9 ++++
 net/vmw_vsock/vsock_loopback.c          |  7 +++
 10 files changed, 175 insertions(+), 46 deletions(-)


base-commit: e0bfcf9c77d9b2c11d2767f0c747f7721ae0cc51
-- 
2.33.0.721.g106298f7f9

