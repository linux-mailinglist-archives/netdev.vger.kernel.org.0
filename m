Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD05C280BFA
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 03:34:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387491AbgJBBes (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 21:34:48 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:17760 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387483AbgJBBes (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 21:34:48 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0921TxXx017902
        for <netdev@vger.kernel.org>; Thu, 1 Oct 2020 18:34:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=RLaLj3qxcgKezrSBfiL8nHa0Zwel37aSP/vmPNkg9NY=;
 b=IbR+6nD5qEXrZEP6wzz+nvaFKwL+SpCLCB7paOZQGPVBWHthtCUaIvtSbqjdAHaVTJP0
 jZoNuzWBiGyXv/gHl7XtTjfR9iR5wScM8z1ZHTgYsjZQKy3xJD/NeKwqbjy49TD53dTn
 nm1ZwxKzKzFa0mAXEzN6A8UZUQ/kSgd5wSQ= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 33vvgrs70w-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 01 Oct 2020 18:34:47 -0700
Received: from intmgw004.03.ash8.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 1 Oct 2020 18:34:45 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 63EA02945DB0; Thu,  1 Oct 2020 18:34:42 -0700 (PDT)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>, Stanislav Fomichev <sdf@google.com>
Subject: [PATCH bpf-next 0/2] Do not limit cb_flags when creating child sk from listen sk
Date:   Thu, 1 Oct 2020 18:34:42 -0700
Message-ID: <20201002013442.2541568-1-kafai@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-01_10:2020-10-01,2020-10-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 clxscore=1015 phishscore=0 mlxscore=0 bulkscore=0 spamscore=0
 impostorscore=0 lowpriorityscore=0 adultscore=0 mlxlogscore=642
 suspectscore=13 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2010020005
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This set fixes an issue that the bpf_skops_init_child() unnecessarily
limited the child sk from inheriting all bpf_sock_ops_cb_flags
of the listen sk.  It also adds a test to check that.

Martin KaFai Lau (2):
  bpf: tcp: Do not limit cb_flags when creating child sk from listen sk
  bpf: selftest: Ensure the child sk inherited all bpf_sock_ops_cb_flags

 include/net/tcp.h                             | 33 -------------------
 net/ipv4/tcp_minisocks.c                      |  1 -
 .../bpf/prog_tests/tcp_hdr_options.c          | 12 +++++++
 .../bpf/progs/test_misc_tcp_hdr_options.c     |  4 +--
 .../bpf/progs/test_tcp_hdr_options.c          |  7 ++--
 .../selftests/bpf/test_tcp_hdr_options.h      |  5 +--
 6 files changed, 22 insertions(+), 40 deletions(-)

--=20
2.24.1

