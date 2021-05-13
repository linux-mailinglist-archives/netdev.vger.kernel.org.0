Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 065D937F53E
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 12:03:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232417AbhEMKEk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 06:04:40 -0400
Received: from mx2.suse.de ([195.135.220.15]:37384 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232803AbhEMKEQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 May 2021 06:04:16 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1620900185; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=mSXvMzPiVbs1p8U5teTrqe++A9Kur1ffFfsRtolTEq4=;
        b=Bt3HWyrBQzhFA/VHRnLOrbIQmpMXluR0avJegIDgYP/25lKg9FIZAPmZkKNNj4Tn46vHsx
        DqH+iMtGCUU89BF3407TPvLq70y+9QiQwuomJ/KD69JlH6Mpq8EAgwwGKMJeCtvkebsFoG
        WMLd9rAM4L+C5WZX30UyH56rbG89gqM=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 85808AFE5;
        Thu, 13 May 2021 10:03:05 +0000 (UTC)
From:   Juergen Gross <jgross@suse.com>
To:     xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        linux-block@vger.kernel.org, netdev@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Cc:     Juergen Gross <jgross@suse.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>,
        Jens Axboe <axboe@kernel.dk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>
Subject: [PATCH 0/8] xen: harden frontends against malicious backends
Date:   Thu, 13 May 2021 12:02:54 +0200
Message-Id: <20210513100302.22027-1-jgross@suse.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Xen backends of para-virtualized devices can live in dom0 kernel, dom0
user land, or in a driver domain. This means that a backend might
reside in a less trusted environment than the Xen core components, so
a backend should not be able to do harm to a Xen guest (it can still
mess up I/O data, but it shouldn't be able to e.g. crash a guest by
other means or cause a privilege escalation in the guest).

Unfortunately many frontends in the Linux kernel are fully trusting
their respective backends. This series is starting to fix the most
important frontends: console, disk and network.

It was discussed to handle this as a security problem, but the topic
was discussed in public before, so it isn't a real secret.

Juergen Gross (8):
  xen: sync include/xen/interface/io/ring.h with Xen's newest version
  xen/blkfront: read response from backend only once
  xen/blkfront: don't take local copy of a request from the ring page
  xen/blkfront: don't trust the backend response data blindly
  xen/netfront: read response from backend only once
  xen/netfront: don't read data from request on the ring page
  xen/netfront: don't trust the backend response data blindly
  xen/hvc: replace BUG_ON() with negative return value

 drivers/block/xen-blkfront.c    | 118 +++++++++-----
 drivers/net/xen-netfront.c      | 184 ++++++++++++++-------
 drivers/tty/hvc/hvc_xen.c       |  15 +-
 include/xen/interface/io/ring.h | 278 ++++++++++++++++++--------------
 4 files changed, 369 insertions(+), 226 deletions(-)

-- 
2.26.2

