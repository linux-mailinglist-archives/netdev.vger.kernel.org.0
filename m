Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06D54186108
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 01:56:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729339AbgCPA4D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Mar 2020 20:56:03 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:60624 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729327AbgCPA4D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Mar 2020 20:56:03 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02G0siIg018388
        for <netdev@vger.kernel.org>; Sun, 15 Mar 2020 17:56:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=23jPoSKjDAvgEYXdvmnsgXW504f83y3UTraI7zwMd2c=;
 b=fomj5fNgSeiRRpmQr1qwZVQGwNRntWasx7iYgHMJNeweKRp514fkekJyhxNr/AZm3gH9
 e9tBHYWhz+tflFau8fn15aBCOqEUA/fdQu09c0/WGCsW8Je/xLYjypKQM6Q/BLbUQ3nf
 RO+gWfxE5QkDGz+mvb59aVU2RdjEVMjk5Ek= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2ysf6et9qs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Sun, 15 Mar 2020 17:56:02 -0700
Received: from intmgw004.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Sun, 15 Mar 2020 17:56:01 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 8C1A42942F81; Sun, 15 Mar 2020 17:55:59 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Hostname: devbig005.ftw2.facebook.com
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 0/4] bpftool: Add struct_ops support
Date:   Sun, 15 Mar 2020 17:55:59 -0700
Message-ID: <20200316005559.2952646-1-kafai@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-15_05:2020-03-12,2020-03-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 mlxlogscore=547 spamscore=0 mlxscore=0 malwarescore=0 priorityscore=1501
 lowpriorityscore=0 adultscore=0 clxscore=1015 phishscore=0 impostorscore=0
 suspectscore=13 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003160002
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This set adds "struct_ops" support to bpftool.

The first two patches improve the btf_dumper in bpftool.
Patch 1: print the enum's name (if it is found) instead of the
         enum's value.
Patch 2: print a char[] as a string if all characters are printable.

"struct_ops" stores the prog_id in a func ptr.
Instead of printing a prog_id,
patch 3 adds an option to btf_dumper to allow a func ptr's value
to be printed with the full func_proto info and the prog_name.

Patch 4 implements the "struct_ops" bpftool command.

Martin KaFai Lau (4):
  bpftool: Print the enum's name instead of value
  bpftool: Print as a string for char array
  bpftool: Translate prog_id to its bpf prog_name
  bpftool: Add struct_ops support

 .../Documentation/bpftool-struct_ops.rst      | 106 ++++
 tools/bpf/bpftool/bash-completion/bpftool     |  28 +
 tools/bpf/bpftool/btf_dumper.c                | 194 +++++-
 tools/bpf/bpftool/main.c                      |   3 +-
 tools/bpf/bpftool/main.h                      |   2 +
 tools/bpf/bpftool/struct_ops.c                | 595 ++++++++++++++++++
 6 files changed, 912 insertions(+), 16 deletions(-)
 create mode 100644 tools/bpf/bpftool/Documentation/bpftool-struct_ops.rst
 create mode 100644 tools/bpf/bpftool/struct_ops.c

-- 
2.17.1

