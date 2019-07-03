Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FA525E60E
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 16:07:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbfGCOHK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 10:07:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49890 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725830AbfGCOHK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Jul 2019 10:07:10 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2A70B3162908;
        Wed,  3 Jul 2019 14:07:05 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-117-79.ams2.redhat.com [10.36.117.79])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1D0591001B21;
        Wed,  3 Jul 2019 14:07:02 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Subject: [PATCH net-next v2 0/5] net: use ICW for sk_proto->{send,recv}msg
Date:   Wed,  3 Jul 2019 16:06:51 +0200
Message-Id: <cover.1562162469.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Wed, 03 Jul 2019 14:07:10 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series extends ICW usage to one of the few remaining spots in fast-path
still hitting per packet retpoline overhead, namely the sk_proto->{send,recv}msg
calls.

The first 3 patches in this series refactor the existing code so that applying
the ICW macros is straight-forward: we demux inet_{recv,send}msg in ipv4 and
ipv6 variants so that each of them can easily select the appropriate TCP or UDP
direct call. While at it, a new helper is created to avoid excessive code
duplication, and the current ICWs for inet_{recv,send}msg are adjusted
accordingly.

The last 2 patches really introduce the new ICW use-case, respectively for the
ipv6 and the ipv4 code path.

This gives up to 5% performance improvement under UDP flood, and smaller but
measurable gains for TCP RR workloads.

v1 -> v2:
 - drop inet6_{recv,send}msg declaration from header file,
   prefer ICW macro instead
 - avoid unneeded reclaration for udp_sendmsg, as suggested by Willem

Paolo Abeni (5):
  inet: factor out inet_send_prepare()
  ipv6: provide and use ipv6 specific version for {recv,send}msg
  net: adjust socket level ICW to cope with ipv6 variant of
    {recv,send}msg
  ipv6: use indirect call wrappers for {tcp,udpv6}_{recv,send}msg()
  ipv4: use indirect call wrappers for {tcp,udp}_{recv,send}msg()

 include/net/inet_common.h |  1 +
 net/ipv4/af_inet.c        | 31 ++++++++++++++++++-----------
 net/ipv6/af_inet6.c       | 41 +++++++++++++++++++++++++++++++++++----
 net/socket.c              | 23 +++++++++++-----------
 4 files changed, 69 insertions(+), 27 deletions(-)

-- 
2.20.1

