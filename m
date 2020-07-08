Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A7CA217CB8
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 03:44:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729188AbgGHBoV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 21:44:21 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:3810 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728676AbgGHBoV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 21:44:21 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0681i01M027867
        for <netdev@vger.kernel.org>; Tue, 7 Jul 2020 18:44:20 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=iH7F5CUuq0H89aPSjRhAhuvMtXVcGlkM5KQgZ5r6x/U=;
 b=H6ncyrQ4dc5K3RpNsro1svVripFGMeny1PyOeH6NnMIR75LRk9uJg6aDux8+OK0JJVFX
 SyRAfaq55KHODHVcPX77aAviz6XwrUkXpOTU3p5Ur8g630Sy9U6Sd06KF0XeWtu+/ifU
 nyTs/vpGmaHErPdTjkzWn9JipKyEjqQF5L4= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 322q9vqkmn-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 07 Jul 2020 18:44:20 -0700
Received: from intmgw004.03.ash8.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 7 Jul 2020 18:44:18 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id D6095294591E; Tue,  7 Jul 2020 18:44:13 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Hostname: devbig005.ftw2.facebook.com
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf 0/2] bpf: net: Fixes in sk_user_data of reuseport_array
Date:   Tue, 7 Jul 2020 18:44:13 -0700
Message-ID: <20200708014413.1990641-1-kafai@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-07_15:2020-07-07,2020-07-07 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 priorityscore=1501 adultscore=0 lowpriorityscore=0 phishscore=0
 malwarescore=0 spamscore=0 mlxscore=0 clxscore=1015 cotscore=-2147483648
 suspectscore=13 impostorscore=0 mlxlogscore=375 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007080009
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This set fixes two issues on sk_user_data when a sk is added to
a reuseport_array.

The first patch is to avoid the sk_user_data being copied
to a cloned sk.  The second patch avoids doing bpf_sk_reuseport_detach()
on sk_user_data that is not managed by reuseport_array.

Since the changes are mostly related to bpf reuseport_array, so it is
currently tagged as bpf fixes.

Martin KaFai Lau (2):
  bpf: net: Avoid copying sk_user_data of reuseport_array during
    sk_clone
  bpf: net: Avoid incorrect bpf_sk_reuseport_detach call

 include/net/sock.h           |  3 ++-
 kernel/bpf/reuseport_array.c | 14 ++++++++++----
 2 files changed, 12 insertions(+), 5 deletions(-)

--=20
2.24.1

