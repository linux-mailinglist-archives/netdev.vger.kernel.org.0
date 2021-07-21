Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85B063D145D
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 18:45:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232712AbhGUQEg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 12:04:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:53095 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231950AbhGUQEf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 12:04:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626885911;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=8XrJTbfGwQxmmnHQYAiD/fMjI50f42+C+fH1pExCF1E=;
        b=bRxWpf/aXz3lXcky8Tf+AanVhISAsXlr8e3yzEsAh4NpIDIGlltgpswsZ6r/LyJZTzbGD1
        ZtlvbKGSXnnQ7IYfh3hnJG2qfO6Pqu2GzsUtrNocWEMVWGEwFtOTADzVjGySVmuz4rpNIg
        zfhdMqmeVFFO/2N9jccQIhFhiULYUZU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-92-fIm9tmOmPk2MbtfuQLzd2g-1; Wed, 21 Jul 2021 12:45:10 -0400
X-MC-Unique: fIm9tmOmPk2MbtfuQLzd2g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8FADC94DC2;
        Wed, 21 Jul 2021 16:45:08 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-114-219.ams2.redhat.com [10.36.114.219])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CE5B8797C1;
        Wed, 21 Jul 2021 16:45:05 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Westphal <fw@strlen.de>,
        Eric Dumazet <edumazet@google.com>,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Subject: [PATCH RFC 0/9] sk_buff: optimize layout for GRO
Date:   Wed, 21 Jul 2021 18:44:32 +0200
Message-Id: <cover.1626879395.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a very early draft - in a different world would be
replaced by hallway discussion at in-person conference - aimed at
outlining some ideas and collect feedback on the overall outlook.
There are still bugs to be fixed, more test and benchmark need, etc.

There are 3 main goals:
- [try to] avoid the overhead for uncommon conditions at GRO time
  (patches 1-4)
- enable backpressure for the veth GRO path (patches 5-6)
- reduce the number of cacheline used by the sk_buff lifecycle
  from 4 to 3, at least in some common scenarios (patches 1,7-9).
  The idea here is avoid the initialization of some fields and
  control their validity with a bitmask, as presented by at least
  Florian and Jesper in the past.

The above requires a bit of code churn in some places and, yes,
a few new bits in the sk_buff struct (using some existing holes)

Paolo Abeni (9):
  sk_buff: track nfct status in newly added skb->_state
  sk_buff: track dst status in skb->_state
  sk_buff: move the active_extensions into the state bitfield
  net: optimize GRO for the common case.
  skbuff: introduce has_sk state bit.
  veth: use skb_prepare_for_gro()
  sk_buff: move inner header fields after tail
  sk_buff: move vlan field after tail.
  sk_buff: access secmark via getter/setter

 drivers/net/veth.c               |   2 +-
 include/linux/skbuff.h           | 117 ++++++++++++++++++++++---------
 include/net/dst.h                |   3 +
 include/net/sock.h               |   9 +++
 net/core/dev.c                   |  31 +++++---
 net/core/skbuff.c                |  40 +++++++----
 net/netfilter/nfnetlink_queue.c  |   6 +-
 net/netfilter/nft_meta.c         |   6 +-
 net/netfilter/xt_CONNSECMARK.c   |   8 +--
 net/netfilter/xt_SECMARK.c       |   2 +-
 security/apparmor/lsm.c          |  15 ++--
 security/selinux/hooks.c         |  10 +--
 security/smack/smack_lsm.c       |   4 +-
 security/smack/smack_netfilter.c |   4 +-
 14 files changed, 175 insertions(+), 82 deletions(-)

-- 
2.26.3

