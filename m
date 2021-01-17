Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE6432F95E8
	for <lists+netdev@lfdr.de>; Sun, 17 Jan 2021 23:24:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730262AbhAQWVd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jan 2021 17:21:33 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:59238 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728172AbhAQWV3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jan 2021 17:21:29 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10HMKTLX188305;
        Sun, 17 Jan 2021 22:20:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2020-01-29;
 bh=aQXP7VaR4helTx5fp3TxcstYosj8Dr8qshg/Npy+5HE=;
 b=dgT6IyMfYYDsofTr4x8Elmp4QLP2p/ghavxHC8fpP/3C3mzG3w5XGinkD+ZKyC1mvd1s
 Vr1IRRx40pV44i3h7mjIapEDDellBRW7n4nZR6qIoAdnbpm0zx2jvPcOFZ8e4NAh1EiY
 nuOXBW0Qs0lENhTyE5+42LUAq4RBSF/xHXEFEoSdYtJzVAHSVrRtgPHVcdN8NNT0MFgg
 P1Br9xPcc7bU4EtZpGpYwylsaAsqBt9aasMNLlu2Ard4t8ZTmtC3NkNk322hffYuBcdb
 7KgbM+NCYqmpKe0krp8MmXTYMu5yfSjhMiptmJGXr8IEEgn6QGwNhb7UR9YL2x2inPj4 xA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 363xyhj8ey-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 17 Jan 2021 22:20:29 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10HMK2VJ160336;
        Sun, 17 Jan 2021 22:20:28 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 364a1vp91x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 17 Jan 2021 22:20:28 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 10HMKR1U028171;
        Sun, 17 Jan 2021 22:20:27 GMT
Received: from localhost.localdomain (/95.45.14.174)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 17 Jan 2021 14:20:27 -0800
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, morbo@google.com,
        shuah@kernel.org, bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH v2 bpf-next 0/4] libbpf: BTF dumper support for typed data
Date:   Sun, 17 Jan 2021 22:16:00 +0000
Message-Id: <1610921764-7526-1-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9867 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 adultscore=0
 mlxscore=0 spamscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101170140
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9867 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 malwarescore=0 mlxlogscore=999 bulkscore=0 priorityscore=1501 spamscore=0
 mlxscore=0 impostorscore=0 lowpriorityscore=0 suspectscore=0 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101170140
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a libbpf dumper function that supports dumping a representation
of data passed in using the BTF id associated with the data in a
manner similar to the bpf_snprintf_btf helper.

Default output format is identical to that dumped by bpf_snprintf_btf(),
for example a "struct sk_buff" representation would look like this:

struct sk_buff){
 (union){
  (struct){
   .next = (struct sk_buff *)0xffffffffffffffff,
   .prev = (struct sk_buff *)0xffffffffffffffff,
   (union){
    .dev = (struct net_device *)0xffffffffffffffff,
    .dev_scratch = (long unsigned int)18446744073709551615,
   },
  },
...

Patches 1 and 2 make functions available that are needed during
dump operations.

Patch 3 implements the dump functionality in a manner similar
to that in kernel/bpf/btf.c, but with a view to fitting into
libbpf more naturally.  For example, rather than using flags,
boolean dump options are used to control output.

Patch 4 is a selftest that utilizes a dump printf function
to snprintf the dump output to a string for comparison with
expected output.  Tests deliberately mirror those in
snprintf_btf helper test to keep output consistent.

Changes since RFC [1]

- The initial approach explored was to share the kernel code
  with libbpf using #defines to paper over the different needs;
  however it makes more sense to try and fit in with libbpf
  code style for maintenance.  A comment in the code points at
  the implementation in kernel/bpf/btf.c and notes that any
  issues found in it should be fixed there or vice versa;
  mirroring the tests should help with this also
  (Andrii)

[1] https://lore.kernel.org/bpf/1610386373-24162-1-git-send-email-alan.maguire@oracle.com/T/#t

Alan Maguire (4):
  libbpf: add btf_has_size() and btf_int() inlines
  libbpf: make skip_mods_and_typedefs available internally in libbpf
  libbpf: BTF dumper support for typed data
  selftests/bpf: add dump type data tests to btf dump tests

 tools/lib/bpf/btf.h                               |  36 +
 tools/lib/bpf/btf_dump.c                          | 974 ++++++++++++++++++++++
 tools/lib/bpf/libbpf.c                            |   4 +-
 tools/lib/bpf/libbpf.map                          |   5 +
 tools/lib/bpf/libbpf_internal.h                   |   2 +
 tools/testing/selftests/bpf/prog_tests/btf_dump.c | 233 ++++++
 6 files changed, 1251 insertions(+), 3 deletions(-)

-- 
1.8.3.1

