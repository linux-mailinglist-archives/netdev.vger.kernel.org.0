Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B4CD5730FE
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 10:25:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235564AbiGMIZ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 04:25:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235529AbiGMIZl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 04:25:41 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10CE0B7DB
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 01:23:46 -0700 (PDT)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26CLkKID002080
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 01:23:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=facebook; bh=Km0IeZTUL0HdVB6PFs9WNFiXX3rWttJeOF99Ub81JvU=;
 b=I1yV+zuFIYmC+PvzFbC6Ex5NrZ0KphieOf7IQf2mXLNqI1wOKmdowH5r3ArbZM5WNQS1
 Tw/tXBlEwSzy6KkoVZBsVc1gBxO5efdpDXnieaI/ex3s8ji1cG1jKixcQtUXtvN5X9Rw
 6rhGuEAqjVjrt9tdft7qaea5ZAVmVYFfVe8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3h9h5hjd0w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 01:23:45 -0700
Received: from twshared22934.08.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Wed, 13 Jul 2022 01:23:45 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 9A5752ED8C1B; Wed, 13 Jul 2022 01:23:41 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <io-uring@vger.kernel.org>
CC:     <netdev@vger.kernel.org>, <Kernel-team@fb.com>,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH v2 for-next 0/3] io_uring: multishot recvmsg
Date:   Wed, 13 Jul 2022 01:23:18 -0700
Message-ID: <20220713082321.1445020-1-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: xPsbnX0Ka_JBhB32XdNVz8D1JCplpE0c
X-Proofpoint-GUID: xPsbnX0Ka_JBhB32XdNVz8D1JCplpE0c
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-12_14,2022-07-13_01,2022-06-22_01
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds multishot support to recvmsg in io_uring.

The idea is that you submit a single multishot recvmsg and then receive
completions as and when data arrives. For recvmsg each completion also has
control data, and this is necessarily included in the same buffer as the
payload.

In order to do this a new structure is used: io_uring_recvmsg_out. This
specifies the length written of the name, control and payload. As well as
including the flags.
The layout of the buffer is <header><name><control><payload> where the
lengths are those specified in the original msghdr used to issue the recvms=
g.

I suspect this API will be the most contentious part of this series and wou=
ld
appreciate any comments on it.

For completeness I considered having the original struct msghdr as the head=
er,
but size wise it is much bigger (72 bytes including an iovec vs 16 bytes he=
re).
Testing also showed a 1% slowdown in terms of QPS.

Using a mini network tester [1] shows 14% QPS improvment using this API, ho=
wever
this is likely to go down to ~8% with the latest allocation cache added by =
Jens.

[1]: https://github.com/DylanZA/netbench/tree/main

Patches 1,2 change the copy_msghdr code to take a user_msghdr as input
Patch 3 is the multishot feature

v2:
 * Rebase without netbuf recycling provided by io_uring
 * Fix payload field output with MSG_TRUNC set to match recvmsg(2)

Dylan Yudaken (3):
  net: copy from user before calling __copy_msghdr
  net: copy from user before calling __get_compat_msghdr
  io_uring: support multishot in recvmsg

 include/linux/socket.h        |   7 +-
 include/net/compat.h          |   5 +-
 include/uapi/linux/io_uring.h |   7 ++
 io_uring/net.c                | 212 ++++++++++++++++++++++++++++------
 io_uring/net.h                |   6 +
 net/compat.c                  |  39 +++----
 net/socket.c                  |  37 +++---
 7 files changed, 228 insertions(+), 85 deletions(-)


base-commit: 20898aeac6b82d8eb6247754494584b2f6cafd53
--=20
2.30.2

