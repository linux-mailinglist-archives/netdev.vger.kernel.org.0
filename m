Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 797603D931D
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 18:24:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229914AbhG1QYh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 12:24:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38697 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229729AbhG1QYh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 12:24:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627489474;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=hSfP1WPVTqf8/bZdzp+e5bSt0opYo3WkWnERl9LJN3Q=;
        b=jTrl6YFMHBOtPIsU9VtdzSfTiP/xlJ/tCf+vHsZQrdgxG2DTScE9Yp/90ybjeYax3lDAe6
        zHGLESvPbc03NUjpHGa0k7O/RYVRlp3BK05BEoETRtj0TlyDT4qIFL6DdQVdYg+aOt9HYd
        XEANaHaD/K7xmRH92GdOOmEeIj3C3/Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-493-RW-2dLRWNpCkdWgmVpdN_A-1; Wed, 28 Jul 2021 12:24:33 -0400
X-MC-Unique: RW-2dLRWNpCkdWgmVpdN_A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2DCFE18C8C02;
        Wed, 28 Jul 2021 16:24:32 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-113-169.ams2.redhat.com [10.36.113.169])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 082475C1B4;
        Wed, 28 Jul 2021 16:24:30 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Subject: [PATCH net-next 0/6] sk_buff: optimize GRO for the common case
Date:   Wed, 28 Jul 2021 18:23:58 +0200
Message-Id: <cover.1627405778.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a trimmed down revision of "sk_buff: optimize layout for GRO",
specifically dropping the changes to the sk_buff layout[1].

This series tries to accomplish 2 goals:
- optimize the GRO stage for the most common scenario, avoiding a bunch
  of conditional and some more code
- let owned skbs entering the GRO engine, allowing backpressure in the
  veth GRO forward path.

A new sk_buff flag (!!!) is introduced and maintained for GRO's sake.
Such field uses an existing hole, so there is no change to the sk_buff
size.

[1] two main reasons:
- move skb->inner_ field requires some extra care, as some in kernel
  users access and the fields regardless of skb->encapsulation.
- extending secmark size clash with ct and nft uAPIs

address the all above is possible, I think, but for sure not in a single
series.

Paolo Abeni (6):
  sk_buff: introduce 'slow_gro' flags
  sk_buff: track dst status in slow_gro
  sk_buff: track extension status in slow_gro
  net: optimize GRO for the common case.
  skbuff: allow 'slow_gro' for skb carring sock reference
  veth: use skb_prepare_for_gro()

 drivers/net/veth.c     |  2 +-
 include/linux/skbuff.h |  6 ++++++
 include/net/dst.h      |  2 ++
 include/net/sock.h     |  9 +++++++++
 net/core/dev.c         | 32 ++++++++++++++++++++++++--------
 net/core/skbuff.c      | 27 ++++++++++++++++++++-------
 6 files changed, 62 insertions(+), 16 deletions(-)

-- 
2.26.3

