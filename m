Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31A17B8A3A
	for <lists+netdev@lfdr.de>; Fri, 20 Sep 2019 06:49:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729799AbfITEtS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Sep 2019 00:49:18 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:51718 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437130AbfITEtR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Sep 2019 00:49:17 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 666F9205A9;
        Fri, 20 Sep 2019 06:49:15 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id kBNcZKR_q3cx; Fri, 20 Sep 2019 06:49:14 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 37895205E5;
        Fri, 20 Sep 2019 06:49:13 +0200 (CEST)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Fri, 20 Sep 2019
 06:49:13 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id B28C53182607;
 Fri, 20 Sep 2019 06:49:12 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     <netdev@vger.kernel.org>
CC:     Steffen Klassert <steffen.klassert@secunet.com>,
        Willem de Bruijn <willemb@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "Subash Abhinov Kasiviswanathan" <subashab@codeaurora.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Subject: [PATCH RFC 0/5] Support fraglist GRO/GSO
Date:   Fri, 20 Sep 2019 06:49:00 +0200
Message-ID: <20190920044905.31759-1-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset adds support to do GRO/GSO by chaining packets
of the same flow at the SKB frag_list pointer. This avoids
the overhead to merge payloads into one big packet, and
on the other end, if GSO is needed it avoids the overhead
of splitting the big packet back to the native form.

Patch 1 Enables UDP GRO by default.

Patch 2 adds netdev feature flags to enable listifyed GRO,
this implements one of the configuration options discussed
at netconf 2019.

Patch 3 adds a netdev software feature set that defaults to off
and assigns the new listifyed GRO feature flag to it.

Patch 4 adds the core infrastructure to do fraglist GRO/GSO.

Patch 5 enables UDP to use fraglist GRO/GSO if configured and no
GRO supported socket is found.

I have only meaningful forwarding performance measurements.
I did some tests for the local receive path with netperf and iperf,
but in this case the sender that generates the packets is the
bottleneck. So the benchmarks are not that meaningful for the
receive path.

Paolo Abeni did some benchmarks of the local receive path for the v2
version of this pachset, results can be found here:

https://www.spinics.net/lists/netdev/msg551158.html

I used my IPsec forwarding test setup for the performance measurements:

           ------------         ------------
        -->| router 1 |-------->| router 2 |--
        |  ------------         ------------  |
        |                                     |
        |       --------------------          |
        --------|Spirent Testcenter|<----------
                --------------------

net-next (September 7th):

Single stream UDP frame size 1460 Bytes: 1.161.000 fps (13.5 Gbps).

----------------------------------------------------------------------

net-next (September 7th) + standard UDP GRO/GSO:

Single stream UDP frame size 1460 Bytes: 1.801.000 fps (21 Gbps).

----------------------------------------------------------------------

net-next (September 7th) + fraglist UDP GRO/GSO:

Single stream UDP frame size 1460 Bytes: 2.860.000 fps (33.4 Gbps).

-----------------------------------------------------------------------

Changes from v1:

- Add IPv6 support.
- Split patchset to enable UDP GRO by default before adding
  fraglist GRO support.
- Mark fraglist GRO packets as CHECKSUM_NONE.
- Take a refcount on the first segment skb when doing fraglist
  segmentation. With this we can use the same error handling
  path as with standard segmentation.

Changes from v2:

- Add a netdev feature flag to configure listifyed GRO.
- Fix UDP GRO enabling for IPv6.
- Fix a rcu_read_lock() imbalance.
- Fix error path in skb_segment_list().

Changes from v3:

- Rename NETIF_F_GRO_LIST to NETIF_F_GRO_FRAGLIST and add
  NETIF_F_GSO_FRAGLIST.
- Move introduction of SKB_GSO_FRAGLIST to patch 2.
- Use udpv6_encap_needed_key instead of udp_encap_needed_key in IPv6.
- Move some missplaced code from patch 5 to patch 1 where it belongs to.

