Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C45D4117ED
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 17:11:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234250AbhITPNC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 11:13:02 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:9472 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232118AbhITPNB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 11:13:01 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18KALYDJ005194
        for <netdev@vger.kernel.org>; Mon, 20 Sep 2021 08:11:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=9/8mcYEeeNNKtnM5oQISRIsSerLVdZaWFVzA7XmsXB0=;
 b=d23QMmtbEryMCxQ+3RPfeOojdOzxlg8XHpKJH4RjNXOh7p2O/mZJcgHGSluPFu820vdw
 g7XRGwDp9a6ELU58Y/Jj5qtsZ4hhx7wi9ycKI4/FW9L5hZyubLti0wRea7Vj5Zj03dwQ
 P6AkdUWlyNdlJubaVgZK59OVwVG9nXTDNno= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3b6mkmtppc-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 20 Sep 2021 08:11:34 -0700
Received: from intmgw002.25.frc3.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Mon, 20 Sep 2021 08:11:29 -0700
Received: by devbig030.frc3.facebook.com (Postfix, from userid 158236)
        id 64A146E18CB8; Mon, 20 Sep 2021 08:11:22 -0700 (PDT)
From:   Dave Marchevsky <davemarchevsky@fb.com>
To:     <bpf@vger.kernel.org>
CC:     <netdev@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Yonghong Song <yhs@fb.com>,
        Dave Marchevsky <davemarchevsky@fb.com>
Subject: [RFC PATCH bpf-next 0/2] bpf: keep track of prog verification stats
Date:   Mon, 20 Sep 2021 08:11:10 -0700
Message-ID: <20210920151112.3770991-1-davemarchevsky@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-FB-Source: Intern
X-Proofpoint-GUID: UBRk-d1lKqRPH8PzM93QuqBxru6pwBrF
X-Proofpoint-ORIG-GUID: UBRk-d1lKqRPH8PzM93QuqBxru6pwBrF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-20_07,2021-09-20_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 phishscore=0
 priorityscore=1501 adultscore=0 mlxlogscore=999 bulkscore=0
 impostorscore=0 suspectscore=0 spamscore=0 clxscore=1015 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109200098
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The verifier currently logs some useful statistics in
print_verification_stats. Although the text log is an effective feedback
tool for an engineer iterating on a single application, it would also be
useful to enable tracking these stats in a more structured form for
fleetwide or historical analysis, which this patchset attempts to do.

A concrete motivating usecase which came up in recent weeks:

A team owns a complex BPF program, with various folks extending its
functionality over the years. An engineer tries to make a relatively
simple addition but encounters "BPF program is too large. Processed
1000001 insn".=20

Their changes bumped the processed insns from 700k to over the limit and
there's no obvious way to simplify. They must now consider a large
refactor in order to incorporate the new feature. What if there was some
previous change which bumped processed insns from 200k->700k which
_could_ be modified to stress verifier less? Tracking historical
verifier stats for each version of the program over the years would
reduce manual work necessary to find such a change.


Although parsing the text log could work for this scenario, a solution
that's resilient to log format and other verifier changes would be
preferable.

This patchset adds a bpf_prog_verif_stats struct - containing the same
data logged by print_verification_stats - which can be retrieved as part
of bpf_prog_info. Looking for general feedback on approach and a few
specific areas before fleshing it out further:

* None of my usecases require storing verif_stats for the lifetime of a
  loaded prog, but adding to bpf_prog_aux felt more correct than trying
  to pass verif_stats back as part of BPF_PROG_LOAD
* The verif_stats are probably not generally useful enough to warrant
  inclusion in fdinfo, but hoping to get confirmation before removing
  that change in patch 1
* processed_insn, verification_time, and total_states are immediately
  useful for me, rest were added for parity with
	print_verification_stats. Can remove.
* Perhaps a version field would be useful in verif_stats in case future
  verifier changes make some current stats meaningless
* Note: stack_depth stat was intentionally skipped to keep patch 1
  simple. Will add if approach looks good.

Dave Marchevsky (2):
  bpf: add verifier stats to bpf_prog_info and fdinfo
  selftests/bpf: add verif_stats test

 include/linux/bpf.h                           |  1 +
 include/uapi/linux/bpf.h                      | 10 ++++++
 kernel/bpf/syscall.c                          | 20 +++++++++--
 kernel/bpf/verifier.c                         | 13 +++++++
 tools/include/uapi/linux/bpf.h                | 10 ++++++
 .../selftests/bpf/prog_tests/verif_stats.c    | 34 +++++++++++++++++++
 6 files changed, 86 insertions(+), 2 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/verif_stats.c

--=20
2.30.2

