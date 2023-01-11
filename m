Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D49F6662F0
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 19:43:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235350AbjAKSnD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 13:43:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235533AbjAKSnB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 13:43:01 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13C653C3AD
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 10:43:00 -0800 (PST)
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30BGIknO032656
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 10:42:59 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=s2048-2021-q4;
 bh=7p+BnnT0sLmST7e3EtxXjdtABFJPi38m9osctzdzx6Y=;
 b=E/jA8tZ/GwlYC0kDZeKfYaJIjXgL8ah8PiXYCsiHJSsTYsnRoeFwyXJDJ9A5tkl2Jl8p
 bVwvxoInuG5eFQIvfOsnEoFyQZAowekYsWVZt+knoMpi1wZsB59OicpDrG4nbdw+r9gp
 2nTmmqEjI54GAYDsefz4hkJoSRHcUX4Ch4lpdzpe/WV6y+vJ4hJ0rvbqPtT55ioCfhRx
 1OT/Ul9ZMLRAjE1iMxjzaNGrZEWXlaCtvM4ue2QwZywKVdJa9X8akrlbBqV0cVNtgYJy
 4q3GdoZYvxAXcAxloo7gKHfW0FeFcG5CrqeClzQmXg6Lgdcz3ouAVE7ak8M20ubTIhaE qg== 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3n1k51wb2g-10
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 10:42:59 -0800
Received: from twshared25383.14.frc2.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Wed, 11 Jan 2023 10:42:54 -0800
Received: by devbig007.nao1.facebook.com (Postfix, from userid 544533)
        id 1F7C4EBD9505; Wed, 11 Jan 2023 10:42:46 -0800 (PST)
From:   Keith Busch <kbusch@meta.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <axboe@kernel.dk>, <io-uring@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Keith Busch <kbusch@kernel.org>
Subject: [PATCH] caif: don't assume iov_iter type
Date:   Wed, 11 Jan 2023 10:42:45 -0800
Message-ID: <20230111184245.3784393-1-kbusch@meta.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: _1Eq9NrJbBr0Ll-DMCpphLU944Ik1ntN
X-Proofpoint-GUID: _1Eq9NrJbBr0Ll-DMCpphLU944Ik1ntN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-11_08,2023-01-11_02,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Keith Busch <kbusch@kernel.org>

The details of the iov_iter types are appropriately abstracted, so
there's no need to check for specific type fields. Just let the
abstractions handle it.

This is preparing for io_uring/net's io_send to utilize the more
efficient ITER_UBUF.

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 net/caif/caif_socket.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/net/caif/caif_socket.c b/net/caif/caif_socket.c
index 748be72532485..1f2c1d7b90e23 100644
--- a/net/caif/caif_socket.c
+++ b/net/caif/caif_socket.c
@@ -533,10 +533,6 @@ static int caif_seqpkt_sendmsg(struct socket *sock, =
struct msghdr *msg,
 	if (msg->msg_namelen)
 		goto err;
=20
-	ret =3D -EINVAL;
-	if (unlikely(msg->msg_iter.nr_segs =3D=3D 0) ||
-	    unlikely(msg->msg_iter.iov->iov_base =3D=3D NULL))
-		goto err;
 	noblock =3D msg->msg_flags & MSG_DONTWAIT;
=20
 	timeo =3D sock_sndtimeo(sk, noblock);
--=20
2.30.2

