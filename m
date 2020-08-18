Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7A7A2490B5
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 00:23:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726904AbgHRWXS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 18:23:18 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:19520 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726799AbgHRWXO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 18:23:14 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07IMDOuF006385
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 15:23:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=9c3ZuDwr2uOpTm5OWCQEezdAmZ5DrDsJbhRbj1zx6Fk=;
 b=l1a2le90xC/nQ0FXLfoLJcItpSIZDp5BH89uO2fEwrc8sE9FkUDHs+MjubNz0k3LA8My
 1NqFlHfAG1uZKcjHjCfXX3pdpRkFXiSJ85Kd/qljV1tMHocAGyE3bniZiyGNBhGgInok
 ezP6ycPnohbqA3lY2p1jt1ZfuRGPwW+HBKw= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3304m2we98-11
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 15:23:14 -0700
Received: from intmgw005.03.ash8.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 18 Aug 2020 15:23:13 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 7B9ED37050C9; Tue, 18 Aug 2020 15:23:09 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf v2 0/3] bpf: two fixes for bpf iterators
Date:   Tue, 18 Aug 2020 15:23:09 -0700
Message-ID: <20200818222309.2181236-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-18_16:2020-08-18,2020-08-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=499
 impostorscore=0 mlxscore=0 bulkscore=0 suspectscore=8 spamscore=0
 phishscore=0 lowpriorityscore=0 malwarescore=0 clxscore=1015 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008180160
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Patch #1 fixed a rcu stall warning when traversing large number
of tasks/files without overflowing seq_file buffer. The method
is to control the number of visited objects in bpf_seq_read()
so all bpf iterators will benefit.

Patch #2 calculated tid properly in a namespace in order to avoid
visiting the name task multiple times.

Patch #3 handled read() error code EAGAIN properly in bpftool
bpf_iter userspace code to collect pids. The change is needed
due to Patch #1.

Yonghong Song (3):
  bpf: fix a rcu_sched stall issue with bpf task/task_file iterator
  bpf: avoid visit same object multiple times
  bpftool: handle EAGAIN error code properly in pids collection

 kernel/bpf/bpf_iter.c    | 15 ++++++++++++++-
 kernel/bpf/task_iter.c   |  3 ++-
 tools/bpf/bpftool/pids.c |  2 ++
 3 files changed, 18 insertions(+), 2 deletions(-)

--=20
2.24.1

