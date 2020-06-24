Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88CD0207F1A
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 00:06:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389171AbgFXWGP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 18:06:15 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:37289 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388749AbgFXWGP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jun 2020 18:06:15 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 754baf50;
        Wed, 24 Jun 2020 21:47:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:mime-version:content-transfer-encoding;
         s=mail; bh=APcwkX27kriXFHRoZT3VOKQosQY=; b=PqZgm5XzScKOf2INAdKe
        F8tTyJ3TDajaiE6njkOWX/YU1/Me+ezUtdD+L0RLGnrllTXhpt59DZK0v+V1pUP5
        Ey3jozjmLyCdt1U3r2rnyneZ9h2IQv1+o+Bai/quLVd4x60GufQFr55YiDVI4MRQ
        rwcFooiq7iwpB1uyifn+oJ/kARMJnR74DGW7/6QdAY2ZsPsVmIcS0tJZznR4lbQV
        Vb6zT3S70LHSNf/+ZCRRwzIh5o6NKoZxS8A3/UJrE0ZHaTlNHpNpPcMKWtV8N1pI
        6aFYgG7XFKMkvdT9tWwiPN5rfrDxiGOjmDFYmaCneEWDgZI/kHscb4MIixESpURN
        0A==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 533ec915 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Wed, 24 Jun 2020 21:47:09 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH net 0/4] napi_gro_receive caller return value cleanups
Date:   Wed, 24 Jun 2020 16:06:02 -0600
Message-Id: <20200624220606.1390542-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In 6570bc79c0df ("net: core: use listified Rx for GRO_NORMAL in
napi_gro_receive()"), the GRO_NORMAL case stopped calling
netif_receive_skb_internal, checking its return value, and returning
GRO_DROP in case it failed. Instead, it calls into
netif_receive_skb_list_internal (after a bit of indirection), which
doesn't return any error. Therefore, napi_gro_receive will never return
GRO_DROP, making handling GRO_DROP dead code.

I emailed the author of 6570bc79c0df on netdev [1] to see if this change
was intentional, but the dlink.ru email address has been disconnected,
and looking a bit further myself, it seems somewhat infeasible to start
propagating return values backwards from the internal machinations of
netif_receive_skb_list_internal.

Taking a look at all the callers of napi_gro_receive, it appears that
three are checking the return value for the purpose of comparing it to
the now never-happening GRO_DROP, and one just casts it to (void), a
likely historical leftover. Every other of the 120 callers does not
bother checking the return value.

And it seems like these remaining 116 callers are doing the right thing:
after calling napi_gro_receive, the packet is now in the hands of the
upper layers of the newtworking, and the device driver itself has no
business now making decisions based on what the upper layers choose to
do. Incrementing stats counters on GRO_DROP seems like a mistake, made
by these three drivers, but not by the remaining 117.

It would seem, therefore, that after rectifying these four callers of
napi_gro_receive, that I should go ahead and just remove returning the
value from napi_gro_receive all together. However, napi_gro_receive has
a function event tracer, and being able to introspect into the
networking stack to see how often napi_gro_receive is returning whatever
interesting GRO status (aside from _DROP) remains an interesting
data point worth keeping for debugging.

So, this series simply gets rid of the return value checking for the
four useless places where that check never evaluates to anything
meaningful.

[1] https://lore.kernel.org/netdev/20200624210606.GA1362687@zx2c4.com/

Jason A. Donenfeld (4):
  wireguard: receive: account for napi_gro_receive never returning
    GRO_DROP
  socionext: account for napi_gro_receive never returning GRO_DROP
  hns: do not cast return value of napi_gro_receive to null
  wil6210: account for napi_gro_receive never returning GRO_DROP

 drivers/net/ethernet/hisilicon/hns/hns_enet.c |  2 +-
 drivers/net/ethernet/socionext/netsec.c       |  4 +-
 drivers/net/wireguard/receive.c               | 10 +----
 drivers/net/wireless/ath/wil6210/txrx.c       | 39 ++++++-------------
 4 files changed, 17 insertions(+), 39 deletions(-)

-- 
2.27.0

