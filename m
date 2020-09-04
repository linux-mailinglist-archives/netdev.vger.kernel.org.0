Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A11625E229
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 21:49:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726791AbgIDTtE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 15:49:04 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:43276 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726265AbgIDTtE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 15:49:04 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 084JiS27019773
        for <netdev@vger.kernel.org>; Fri, 4 Sep 2020 12:49:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=C54RzPYh0WcdtnHkSujzfGk55J7PC3BFeV3fyo30ulg=;
 b=AVWGPPNi8G6y9WSSFyqXXXmz6PmjUF9RVvaG7cqSj/Rco2ViKjqNCY4nLZU0h2lr3ZGH
 0A5of2XsVBjkQsdzQNuyy7MsR7rBX4bUDUjM6SFMjfchNfUQb19uB181NYR9omlhCebw
 t/53NfNbtM464sKQm4ecHM5+/VOznGQqEt8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 33b99qn4m8-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 04 Sep 2020 12:49:03 -0700
Received: from intmgw005.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 4 Sep 2020 12:49:01 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id B2A0D3704C1B; Fri,  4 Sep 2020 12:49:00 -0700 (PDT)
From:   Yonghong Song <yhs@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
Subject: [PATCH bpf-next 0/2] bpf: permit map_ptr arithmetic with opcode add and offset 0
Date:   Fri, 4 Sep 2020 12:49:00 -0700
Message-ID: <20200904194900.3031319-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-04_15:2020-09-04,2020-09-04 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 impostorscore=0 suspectscore=8 mlxscore=0 spamscore=0 adultscore=0
 phishscore=0 lowpriorityscore=0 clxscore=1015 malwarescore=0
 mlxlogscore=718 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2009040171
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With CORE, it is possible that the compiler may produce code like
  r1 =3D 0  // relocation instruction
  map_ptr +=3D r1
  ...
Currently verifier does not allow map_ptr arithmetic, even for adding wit=
h 0.
This patch set relaxed the condition so the above code can be accepted.
Patch #1 is the kernel implementation and Patch #2 added selftest tests t=
o
cover the new functionality.

Yonghong Song (2):
  bpf: permit map_ptr arithmetic with opcode add and offset 0
  selftests/bpf: add test for map_ptr arithmetic

 kernel/bpf/verifier.c                         |  3 ++
 .../selftests/bpf/progs/map_ptr_kern.c        |  4 +--
 .../testing/selftests/bpf/verifier/map_ptr.c  | 32 +++++++++++++++++++
 3 files changed, 37 insertions(+), 2 deletions(-)

--=20
2.24.1

