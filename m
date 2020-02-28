Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D9A61738D1
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 14:47:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727320AbgB1Npy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 08:45:54 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:23366 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727031AbgB1Npv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 08:45:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582897550;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=ogktrVYZtCFQty5C20zFxRtlpSvUxdJSscrT/vhvY1k=;
        b=VYmi/iyeCYdePodmLV8r4u4T53Fldn4FXLoxxoD8j3KE47KDc+sd79vkF2cxwWHIyoD4Np
        xU67MRGOWFyy+7Cdqi1t8JxPHfkSPJE0z8oRxMQSXD8J8rYdzevGNZgce6vyQmm1TYihHI
        I//IT1tD9+kmKyHpWAjrWQx7DEsM8QY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-252-ncgtDUUDNTqhffi6Yy4mMg-1; Fri, 28 Feb 2020 08:45:46 -0500
X-MC-Unique: ncgtDUUDNTqhffi6Yy4mMg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1159910CE781;
        Fri, 28 Feb 2020 13:45:45 +0000 (UTC)
Received: from localhost.localdomain.com (unknown [10.36.118.48])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DC4DC9299C;
        Fri, 28 Feb 2020 13:45:43 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Kirill Tkhai <ktkhai@virtuozzo.com>
Subject: [PATCH net-next v2 0/2] net: cleanup datagram receive helpers
Date:   Fri, 28 Feb 2020 14:45:20 +0100
Message-Id: <cover.1582897428.git.pabeni@redhat.com>
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

v1 -> v2:
 - call scm_stat_del() only when not peeking - Kirill
 - fix build issue with CONFIG_INET_ESPINTCP

Paolo Abeni (2):
  unix: uses an atomic type for scm files accounting
  net: datagram: drop 'destructor' argument from several helpers

 include/linux/skbuff.h | 12 ++----------
 include/net/af_unix.h  |  2 +-
 net/core/datagram.c    | 25 +++++++------------------
 net/ipv4/udp.c         | 14 ++++++++------
 net/unix/af_unix.c     | 28 +++++++++++-----------------
 net/xfrm/espintcp.c    |  2 +-
 6 files changed, 30 insertions(+), 53 deletions(-)

--=20
2.21.1

