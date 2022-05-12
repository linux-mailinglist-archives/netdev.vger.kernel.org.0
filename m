Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 525CE52415A
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 02:06:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349562AbiELAGB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 20:06:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349559AbiELAF6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 20:05:58 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB609201AE
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 17:05:56 -0700 (PDT)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24BMwV6u011360
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 17:05:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=UW3BRkmsIS6ERhImFCkgarioVnNPWrsAy37AUgVPMOs=;
 b=Vw08cmee0g0tyXl+t+Z84MWgw9GZyoOKa5i18uFcXqVcDUVlBzBgIUTpDO390kPD2+wS
 URIsQfa9ZgOnMf4/+Ch44sfnpuhLhBFTGwJ3WgeB5gh/DoZE7/8/nsclfKY4/RwZZvEy
 sqh5PyTm3dceTFr+VI7GWXxVMoYBVwFZYZc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3fyx2n9ndx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 17:05:56 -0700
Received: from twshared24024.25.frc3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 11 May 2022 17:05:54 -0700
Received: by devbig933.frc1.facebook.com (Postfix, from userid 6611)
        id 3E7E34AD2434; Wed, 11 May 2022 17:05:46 -0700 (PDT)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <netdev@vger.kernel.org>
CC:     David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, <kernel-team@fb.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next 0/4] net: inet: Retire port only listening_hash
Date:   Wed, 11 May 2022 17:05:46 -0700
Message-ID: <20220512000546.188616-1-kafai@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: leBV45giagV9uYMeoQmIVOfRufAiBdIB
X-Proofpoint-ORIG-GUID: leBV45giagV9uYMeoQmIVOfRufAiBdIB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-11_07,2022-05-11_01,2022-02-23_01
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series is to retire the port only listening_hash.

The listen sk is currently stored in two hash tables,
listening_hash (hashed by port) and lhash2 (hashed by port and address).

After commit 0ee58dad5b06 ("net: tcp6: prefer listeners bound to an addre=
ss")
and commit d9fbc7f6431f ("net: tcp: prefer listeners bound to an address"=
),
the TCP-SYN lookup fast path does not use listening_hash.

The commit 05c0b35709c5 ("tcp: seq_file: Replace listening_hash with lhas=
h2")
also moved the seq_file (/proc/net/tcp) iteration usage from
listening_hash to lhash2.

There are still a few listening_hash usages left.
One of them is inet_reuseport_add_sock() which uses the listening_hash
to search a listen sk during the listen() system call.  This turns
out to be very slow on use cases that listen on many different
VIPs at a popular port (e.g. 443).  [ On top of the slowness in
adding to the tail in the IPv6 case ]. A latter patch has a
selftest to demonstrate this case.

This series takes this chance to move all remaining listening_hash
usages to lhash2 and then retire listening_hash.

Martin KaFai Lau (4):
  net: inet: Remove count from inet_listen_hashbucket
  net: inet: Open code inet_hash2 and inet_unhash2
  net: inet: Retire port only listening_hash
  net: selftests: Stress reuseport listen

 include/net/inet_connection_sock.h            |   2 -
 include/net/inet_hashtables.h                 |  42 +------
 net/dccp/proto.c                              |   1 -
 net/ipv4/inet_diag.c                          |   5 +-
 net/ipv4/inet_hashtables.c                    | 119 +++++-------------
 net/ipv4/tcp.c                                |   1 -
 net/ipv4/tcp_ipv4.c                           |  21 ++--
 net/ipv6/inet6_hashtables.c                   |   5 +-
 net/mptcp/mptcp_diag.c                        |   4 +-
 tools/testing/selftests/net/Makefile          |   2 +
 .../selftests/net/stress_reuseport_listen.c   | 105 ++++++++++++++++
 .../selftests/net/stress_reuseport_listen.sh  |  25 ++++
 12 files changed, 180 insertions(+), 152 deletions(-)
 create mode 100644 tools/testing/selftests/net/stress_reuseport_listen.c
 create mode 100755 tools/testing/selftests/net/stress_reuseport_listen.s=
h

--=20
2.30.2

