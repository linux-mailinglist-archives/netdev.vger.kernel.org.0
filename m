Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF64E2EC0C4
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 17:03:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727031AbhAFQCN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 11:02:13 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:54890 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725925AbhAFQCM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 11:02:12 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 106FtftW089467;
        Wed, 6 Jan 2021 15:59:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=e280thpeH4MDj+q41MOrlKwQhwr0+ZqgSZTW/ewQcjs=;
 b=uIjNH2JKtab15z7hmqijke50pN59OsA9mCfXgSYKnP+BVSpOY99S1dFzULkEt8DTmxgm
 kyW11yuqL5W4R2CFhbEGUmZR3MofR66qamrCL4+bwtB8fhWCuus87VLeDNNFcyh5E6Ci
 u/PMxhJjfdBUY+nQ4wPR7X2WGEUUE2jbRLzi/CtE4zuNqQkoWTlurLwyf2lxNBsMJ+4e
 z8heDckYwbXjOT7CD4Z1FIX7HHZVhnu8Km7ldoTQsLaZJMCTvEq+epkWn9x01r4tdW09
 EX8ovXxkcHGJjaTNtCefu3UF9eTLFoh8dSzVkIWykrM82CGxnRt56m7Oliarp2GfVVm4 3A== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 35wftx856u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 06 Jan 2021 15:59:37 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 106FtOwo154567;
        Wed, 6 Jan 2021 15:59:37 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 35w3g17tm9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Jan 2021 15:59:37 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 106FxXO2027087;
        Wed, 6 Jan 2021 15:59:33 GMT
Received: from localhost.uk.oracle.com (/10.175.165.159)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 Jan 2021 15:59:33 +0000
From:   Alan Maguire <alan.maguire@oracle.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, toke@redhat.com,
        wanghai38@huawei.com, quentin@isovalent.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alan Maguire <alan.maguire@oracle.com>
Subject: [PATCH bpf] bpftool: fix compilation failure for net.o with older glibc
Date:   Wed,  6 Jan 2021 15:59:06 +0000
Message-Id: <1609948746-15369-1-git-send-email-alan.maguire@oracle.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9855 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 adultscore=0
 phishscore=0 spamscore=0 mlxlogscore=939 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101060098
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9855 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 mlxscore=0
 bulkscore=0 priorityscore=1501 impostorscore=0 clxscore=1011
 lowpriorityscore=0 mlxlogscore=942 malwarescore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101060098
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For older glibc ~2.17, #include'ing both linux/if.h and net/if.h
fails due to complaints about redefinition of interface flags:

  CC       net.o
In file included from net.c:13:0:
/usr/include/linux/if.h:71:2: error: redeclaration of enumerator ‘IFF_UP’
  IFF_UP    = 1<<0,  /* sysfs */
  ^
/usr/include/net/if.h:44:5: note: previous definition of ‘IFF_UP’ was here
     IFF_UP = 0x1,  /* Interface is up.  */

The issue was fixed in kernel headers in [1], but since compilation
of net.c picks up system headers the problem can recur.

Dropping #include <linux/if.h> resolves the issue and it is
not needed for compilation anyhow.

[1] https://lore.kernel.org/netdev/1461512707-23058-1-git-send-email-mikko.rapeli__34748.27880641$1462831734$gmane$org@iki.fi/

Fixes: f6f3bac08ff9 ("tools/bpf: bpftool: add net support")
Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
---
 tools/bpf/bpftool/net.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/bpf/bpftool/net.c b/tools/bpf/bpftool/net.c
index 3fae61e..ff3aa0c 100644
--- a/tools/bpf/bpftool/net.c
+++ b/tools/bpf/bpftool/net.c
@@ -11,7 +11,6 @@
 #include <bpf/bpf.h>
 #include <bpf/libbpf.h>
 #include <net/if.h>
-#include <linux/if.h>
 #include <linux/rtnetlink.h>
 #include <linux/socket.h>
 #include <linux/tc_act/tc_bpf.h>
-- 
1.8.3.1

