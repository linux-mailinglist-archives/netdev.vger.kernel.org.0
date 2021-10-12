Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A20842A8F2
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 17:58:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237260AbhJLQAu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 12:00:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:47032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234892AbhJLQAt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 12:00:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C5ACB610A2;
        Tue, 12 Oct 2021 15:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634054328;
        bh=hhr8Za+sOqGfSog81Gg0OPIGq0DbwAaWnk+7OCHOX2s=;
        h=From:To:Cc:Subject:Date:From;
        b=HZySk2HbvOVvlU2fI1IM3eFhqq8SgerPgIn7zOBn63OXBEYnRa8wz7KGEYNR+ICCt
         fga7E5UrgRj2AbFob+CL43RacdQ9CVVRvNv4UI7582RNgOomZXDe+NrJTs9B1AA3+M
         zGIsEYISxCqNQI2nQtvAKnC+3mdp1wXVS3rxg9X3Rxgi49fDCV8f6SzSb2Ben07EDa
         EMW/ebXIhmpEUkDRbKW9fJICYHTQJnK2PGZ3qOSdh1SFw3ea/C7tvyMu2WjuiUZ4UO
         Q9UjNmdeVcJ4pVGkl2gQFkvsmxJZnACDR72unvmKhOZnUU7vjglQw6Y2v8kJbhm9aX
         DBuM6PB2Xe5ow==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, ralf@linux-mips.org, jreuter@yaina.de,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, jmaloy@redhat.com,
        ying.xue@windriver.com, linux-hams@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 0/6] net: constify dev_addr passing for protocols
Date:   Tue, 12 Oct 2021 08:58:34 -0700
Message-Id: <20211012155840.4151590-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 406f42fa0d3c ("net-next: When a bond have a massive amount 
of VLANs...") introduced a rbtree for faster Ethernet address look
up. To maintain netdev->dev_addr in this tree we need to make all
the writes to it got through appropriate helpers.

netdev->dev_addr will be made const to prevent direct writes.
This set sprinkles const across variables and arguments in protocol
code which are used to hold references to netdev->dev_addr.

Jakub Kicinski (6):
  ax25: constify dev_addr passing
  rose: constify dev_addr passing
  llc/snap: constify dev_addr passing
  ipv6: constify dev_addr passing
  tipc: constify dev_addr passing
  decnet: constify dev_addr passing

 include/net/ax25.h     | 13 +++++++------
 include/net/datalink.h |  2 +-
 include/net/dn.h       |  2 +-
 include/net/llc.h      |  2 +-
 include/net/llc_if.h   |  3 ++-
 include/net/ndisc.h    |  2 +-
 include/net/rose.h     |  8 ++++----
 net/802/p8022.c        |  2 +-
 net/802/psnap.c        |  2 +-
 net/ax25/af_ax25.c     |  2 +-
 net/ax25/ax25_dev.c    |  2 +-
 net/ax25/ax25_iface.c  |  6 +++---
 net/ax25/ax25_in.c     |  4 ++--
 net/ax25/ax25_out.c    |  2 +-
 net/ipv6/addrconf.c    |  4 ++--
 net/ipv6/ndisc.c       |  4 ++--
 net/llc/llc_c_ac.c     |  2 +-
 net/llc/llc_if.c       |  2 +-
 net/llc/llc_output.c   |  2 +-
 net/llc/llc_proc.c     |  2 +-
 net/netrom/af_netrom.c |  4 ++--
 net/netrom/nr_dev.c    |  6 +++---
 net/netrom/nr_route.c  |  4 ++--
 net/rose/af_rose.c     |  5 +++--
 net/rose/rose_dev.c    |  6 +++---
 net/rose/rose_link.c   |  8 ++++----
 net/rose/rose_route.c  | 10 ++++++----
 net/tipc/bearer.c      |  4 ++--
 net/tipc/bearer.h      |  2 +-
 net/tipc/eth_media.c   |  2 +-
 net/tipc/ib_media.c    |  2 +-
 31 files changed, 63 insertions(+), 58 deletions(-)

-- 
2.31.1

