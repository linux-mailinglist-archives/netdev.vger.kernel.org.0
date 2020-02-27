Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D0221715FF
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 12:30:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728888AbgB0La6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 06:30:58 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:28718 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728848AbgB0La5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 06:30:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582803057;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=8l0oVJTbttoovimQzJBzeRRr8d1Rm0yZ6OGWioZUuHc=;
        b=D7TN9EBdnCCPeb0o06NgHCXzkgneUhqILwRft+ebCJfsFWq7die1GHxvi34ht52cLR2AQv
        9dao0zCUMWJ5LWPVdqRb8DyrXgJ1g5ROzQ8UoB6rZNxKb3mw6HfFGfLe/OI/v4AhQ2pcZh
        FNGrDxsSYkj8vM3aOt26MgIORjz805M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-148-xZuCpHAkOe6T0aabJN3HUg-1; Thu, 27 Feb 2020 06:30:53 -0500
X-MC-Unique: xZuCpHAkOe6T0aabJN3HUg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DE6338017CC;
        Thu, 27 Feb 2020 11:30:51 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-117-88.ams2.redhat.com [10.36.117.88])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AF6881BC6D;
        Thu, 27 Feb 2020 11:30:50 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Kirill Tkhai <ktkhai@virtuozzo.com>
Subject: [PATCH net-next 0/2] net: cleanup datagram receive helpers
Date:   Thu, 27 Feb 2020 12:30:36 +0100
Message-Id: <cover.1582802470.git.pabeni@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Several receive helpers have an optional destructor argument, which uglif=
y
the code a bit and is taxed by retpoline overhead.

This series refactor the code so that we can drop such optional argument,
cleaning the helpers a bit and avoiding an indirect call in fast path.

The first patch refactor a bit the caller, so that the second patch
actually dropping the argument is more straight-forward

Paolo Abeni (2):
  unix: uses an atomic type for scm files accounting
  net: datagram: drop 'destructor' argument from several helpers

 include/linux/skbuff.h | 12 ++----------
 include/net/af_unix.h  |  2 +-
 net/core/datagram.c    | 25 +++++++------------------
 net/ipv4/udp.c         | 14 ++++++++------
 net/unix/af_unix.c     | 27 ++++++++++-----------------
 5 files changed, 28 insertions(+), 52 deletions(-)

--=20
2.21.1

