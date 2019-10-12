Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E10BDD4BEF
	for <lists+netdev@lfdr.de>; Sat, 12 Oct 2019 03:54:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728089AbfJLByf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 21:54:35 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:41408 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726903AbfJLBye (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 21:54:34 -0400
Received: by mail-pf1-f194.google.com with SMTP id q7so7079266pfh.8;
        Fri, 11 Oct 2019 18:54:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XR2n34xXjC/7ocn7v74lqd3awYFNRTOmHAVF9A1J9OU=;
        b=U1Z90jMNlXgVvmjnXsQs15YRgwC9WJW/iX0G0SRcbHymiifo6JzpAQYHoXocJ6yv8t
         TKqjH2rU5JWMzPYgeDIWdtm5qt/7/xJ1KtCW+O1A9mjPG0R7nttRHX2fWG3aUyIS5vBM
         +FTNr4d0NzroXLjHENuu4NgU9bIz3ROH5xhkr2H2wpVot0ZaDpPdmQXLOKdvyo+mwt/T
         RDxJUHbabpnHeD1fjmadNUtQArLDunRG3S7vJ4Z9Z5JvRIdP457Ny8DgrpmqOPPNNCk1
         rze9Hc1fZhJZ1U/RkD8Y83GAhkC+fE42IyhXkiOxcb/wA+fgtnJ+qW/osJ79Fz7B9WCM
         41RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XR2n34xXjC/7ocn7v74lqd3awYFNRTOmHAVF9A1J9OU=;
        b=FKl7KuODxSmBFQYFhZd6XaF+1EiwyOxzm6QMwBtsuJ4FxDUBxG2tRvpsvwGEFTxQ1V
         W/blJ/IYQffLqMzVYb91X/OQ01lACm9+dYacNrc7F91D3mcVCM4Os8/bogBKpN3ezH/u
         UwNhivOaPZRL9UZSexgDkhuxIAD2ydWNgkYWUoJpNulDUEJRZcbiiNgoYwM+sH5x1+Ml
         02Dx5dxEq2nKOk+nR5TubAiDqmJP4zvVHdD4Z8MHV5gl1RXm4fOjOXIl/s8G95nx/pbE
         dSU3DCFQQjcKge0Jk/Pn8XJ7ndWZe/1L/Vr0wpL7k7vG6KVT6hFXZnuKx+8gCQIk7YHV
         BTKQ==
X-Gm-Message-State: APjAAAUIPqKyBx4TT4kiIxHrO50p2uoq2pZStQYvnIiP2O1br+lJs+P6
        lOhGw/PGRCl3m5bU8FF5ROo=
X-Google-Smtp-Source: APXvYqzGEv7ahV5HYDXwoKttYyR7AVek3+lc6pBmvHkkAjwJAxR1YRK6ZUHwVhBEaytbBLk75yk88Q==
X-Received: by 2002:a62:2783:: with SMTP id n125mr1983129pfn.167.1570845274086;
        Fri, 11 Oct 2019 18:54:34 -0700 (PDT)
Received: from localhost.localdomain (KD124211219252.ppp-bb.dion.ne.jp. [124.211.219.252])
        by smtp.gmail.com with ESMTPSA id e127sm10992187pfe.37.2019.10.11.18.54.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Oct 2019 18:54:33 -0700 (PDT)
From:   prashantbhole.linux@gmail.com
To:     "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Prashant Bhole <prashantbhole.linux@gmail.com>,
        David Ahern <dsahern@gmail.com>, kvm@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH net-next 0/3] vhost_net: access ptr ring using tap recvmsg
Date:   Sat, 12 Oct 2019 10:53:54 +0900
Message-Id: <20191012015357.1775-1-prashantbhole.linux@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Prashant Bhole <prashantbhole.linux@gmail.com>

vhost_net needs to peek tun packet sizes to allocate virtio buffers.
Currently it directly accesses tap ptr ring to do it. Jason Wang
suggested to achieve this using msghdr->msg_control and modifying the
behavior of tap recvmsg.

This change will be useful in future in case of virtio-net XDP
offload. Where packets will be XDP processed in tap recvmsg and vhost
will see only non XDP_DROP'ed packets.

Patch 1: reorganizes the tun_msg_ctl so that it can be extended by
 the means of different commands. tap sendmsg recvmsg will behave
 according to commands.

Patch 2: modifies recvmsg implementation to produce packet pointers.
 vhost_net uses recvmsg API instead of ptr_ring_consume().

Patch 3: removes ptr ring usage in vhost and functions those export
 ptr ring from tun/tap.

Prashant Bhole (3):
  tuntap: reorganize tun_msg_ctl usage
  vhost_net: user tap recvmsg api to access ptr ring
  tuntap: remove usage of ptr ring in vhost_net

 drivers/net/tap.c      | 44 ++++++++++++++---------
 drivers/net/tun.c      | 45 +++++++++++++++---------
 drivers/vhost/net.c    | 79 ++++++++++++++++++++++--------------------
 include/linux/if_tun.h |  9 +++--
 4 files changed, 103 insertions(+), 74 deletions(-)

-- 
2.21.0

