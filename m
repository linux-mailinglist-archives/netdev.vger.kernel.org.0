Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDB6856C413
	for <lists+netdev@lfdr.de>; Sat,  9 Jul 2022 01:15:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239633AbiGHSoX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 14:44:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238988AbiGHSoW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 14:44:22 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B7082CE31
        for <netdev@vger.kernel.org>; Fri,  8 Jul 2022 11:44:22 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 268HBmh5031191
        for <netdev@vger.kernel.org>; Fri, 8 Jul 2022 11:44:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=facebook; bh=IbaA6/aCRorxzxQ9WRGQtMw3AgVmYn9S1CvsZRpKYpY=;
 b=pxvQAlcLVmU3FEN/V4+Srj01u4ogG+uafcKXMCzQmIy2UZF7fhdfXdSIFTYTRpl7t4L2
 wRF0Nj/Ub1wK5Wm7FgqXIq+w/DC67exQnvl4vNUICSClJLTGqqSJGT/xj9qMOVemb661
 Z1wBnPSsdQIojD+KrBOx/AX1o1hzd/g8BB4= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3h6f69kxb8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 08 Jul 2022 11:44:21 -0700
Received: from twshared22934.08.ash9.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Fri, 8 Jul 2022 11:44:20 -0700
Received: by devbig038.lla2.facebook.com (Postfix, from userid 572232)
        id 3D1F52BA1E74; Fri,  8 Jul 2022 11:44:10 -0700 (PDT)
From:   Dylan Yudaken <dylany@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <io-uring@vger.kernel.org>
CC:     <netdev@vger.kernel.org>, <Kernel-team@fb.com>,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH for-next 0/3] io_uring: multishot recvmsg
Date:   Fri, 8 Jul 2022 11:43:54 -0700
Message-ID: <20220708184358.1624275-1-dylany@fb.com>
X-Mailer: git-send-email 2.30.2
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: MnxguybT4x5VOjidtPcDF8DgazGFaGyA
X-Proofpoint-ORIG-GUID: MnxguybT4x5VOjidtPcDF8DgazGFaGyA
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-08_15,2022-07-08_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

I have based this on this other patch series [2].

[1]: https://github.com/DylanZA/netbench/tree/main
[2]: https://lore.kernel.org/io-uring/20220708181838.1495428-1-dylany@fb.co=
m/

Dylan Yudaken (3):
  net: copy from user before calling __copy_msghdr
  net: copy from user before calling __get_compat_msghdr
  io_uring: support multishot in recvmsg

 include/linux/socket.h        |   7 +-
 include/net/compat.h          |   5 +-
 include/uapi/linux/io_uring.h |   7 ++
 io_uring/net.c                | 195 ++++++++++++++++++++++++++++------
 io_uring/net.h                |   5 +
 net/compat.c                  |  39 +++----
 net/socket.c                  |  37 +++----
 7 files changed, 215 insertions(+), 80 deletions(-)


base-commit: 9802dee74e7f30ab52dc5f346373185cd860afab
--=20
2.30.2

