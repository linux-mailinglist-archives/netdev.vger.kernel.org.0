Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 251434D5898
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 04:02:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345094AbiCKDDW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 22:03:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240995AbiCKDDU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 22:03:20 -0500
Received: from smtp.tom.com (smtprz02.163.net [106.3.154.235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0BF7F9AE7C
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 19:02:17 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by vip-app02.163.net (Postfix) with ESMTP id A210E440163
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 11:02:16 +0800 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tom.com; s=mail;
        t=1646967736; bh=lU6HzNdZHgcc5KiwB5BXRJdLlGkJStkMFzd16R4L3jc=;
        h=From:To:Cc:Subject:Date:From;
        b=XWEk04t8YeEqCoh0KeGQSVfBDO8NhJr+Jx0r+NrJzZRGKXXcCApRRl2na2ImMs0Re
         pF1IEQM95FYCPvtvM40U4cTQndUnxmsoV3StmlJaYD4LA5OC77K4A2h6d0UFUURrri
         KzHeAYz8i1z2+CSpp/9RwHuJ0/eC/ARLdafjx03Q=
Received: from localhost (HELO smtp.tom.com) ([127.0.0.1])
          by localhost (TOM SMTP Server) with SMTP ID 855997407
          for <netdev@vger.kernel.org>;
          Fri, 11 Mar 2022 11:02:16 +0800 (CST)
X-Virus-Scanned: Debian amavisd-new at mxtest.tom.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tom.com; s=mail;
        t=1646967736; bh=lU6HzNdZHgcc5KiwB5BXRJdLlGkJStkMFzd16R4L3jc=;
        h=From:To:Cc:Subject:Date:From;
        b=XWEk04t8YeEqCoh0KeGQSVfBDO8NhJr+Jx0r+NrJzZRGKXXcCApRRl2na2ImMs0Re
         pF1IEQM95FYCPvtvM40U4cTQndUnxmsoV3StmlJaYD4LA5OC77K4A2h6d0UFUURrri
         KzHeAYz8i1z2+CSpp/9RwHuJ0/eC/ARLdafjx03Q=
Received: from localhost.localdomain (unknown [101.93.196.13])
        by antispamvip.163.net (Postfix) with ESMTPA id 55FAF15414F8;
        Fri, 11 Mar 2022 11:02:13 +0800 (CST)
From:   Mingbao Sun <sunmingbao@tom.com>
To:     Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@fb.com>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     sunmingbao@tom.com, tyler.sun@dell.com, ping.gan@dell.com,
        yanxiu.cai@dell.com, libin.zhang@dell.com, ao.sun@dell.com
Subject: [PATCH 0/3] NVMe/TCP: support specifying the congestion-control
Date:   Fri, 11 Mar 2022 11:01:10 +0800
Message-Id: <20220311030113.73384-1-sunmingbao@tom.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mingbao Sun <tyler.sun@dell.com>

Hi all,

congestion-control could have a noticeable impaction on the
performance of TCP-based communications. This is of course true
to NVMe_over_TCP.

Different congestion-controls (e.g., cubic, dctcp) are suitable for
different scenarios. Proper adoption of congestion control would benefit
the performance. On the contrary, the performance could be destroyed.

Though we can specify the congestion-control of NVMe_over_TCP via
writing '/proc/sys/net/ipv4/tcp_congestion_control', but this also
changes the congestion-control of all the future TCP sockets that
have not been explicitly assigned the congestion-control, thus bringing
potential impaction on their performance.

So it makes sense to make NVMe_over_TCP support specifying the
congestion-control.

patch 1/3 export a symbol on behalf of the following ones.
patch 2/3 addresses the NVMe/TCP host side.
patch 3/3 addresses the NVMe/TCP target side.

Since the change made to netdev is pretty simple, so the patch
is generated against nvme-5.18 of the nvme.git.

Mingbao Sun (3):
  tcp: export symbol tcp_set_congestion_control
  nvme-tcp: support specifying the congestion-control
  nvmet-tcp: support specifying the congestion-control

 drivers/nvme/host/fabrics.c    | 12 +++++++++++
 drivers/nvme/host/fabrics.h    |  2 ++
 drivers/nvme/host/tcp.c        | 15 +++++++++++++-
 drivers/nvme/target/configfs.c | 37 ++++++++++++++++++++++++++++++++++
 drivers/nvme/target/nvmet.h    |  1 +
 drivers/nvme/target/tcp.c      | 11 ++++++++++
 net/ipv4/tcp_cong.c            |  1 +
 7 files changed, 78 insertions(+), 1 deletion(-)

-- 
2.26.2

