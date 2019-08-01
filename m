Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 479247DCE0
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 15:53:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730029AbfHANxN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 09:53:13 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:33997 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725804AbfHANxN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Aug 2019 09:53:13 -0400
Received: by mail-qt1-f193.google.com with SMTP id k10so1115185qtq.1
        for <netdev@vger.kernel.org>; Thu, 01 Aug 2019 06:53:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=GOOUHqMAJNavjh4iBb/nfJRnmkoHSovDN9/qa8ZYaqg=;
        b=bEpVM8CBXO1py9oqb/KmhvF46cmDUAB1PYD8JcD482Vkj2CNVR/NfOmQf4Kp+Be4bx
         IV5DDIvDlb/sVgWCJPnCdcuhT3cIm/P4xcIlU6x6ykBpwWmrVcwWecP0ckZHxsukxffr
         3PJzVZHabdvLvUY65bwkuDiR0LFwWJtZgpqubhZW2mTITBZM1nISpjjnOu3Isv1DCL5W
         l3oy710k+Y1IIlQEsVcOJvovE8IT6ZEEBNK4/07q8121qJRyaoUcLxokDSmgntQONY25
         gVGVLEbBnPOSZitYrKUFDeHIxtYxBgDk160NtYuBHWYjESCp4w4GYNKfxQ+q4r76HD9i
         Vpdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=GOOUHqMAJNavjh4iBb/nfJRnmkoHSovDN9/qa8ZYaqg=;
        b=jbEFIhbeOJCwCk4JCPRwCnjzBrSfZnFnJuV/UWj8A5WYRvDBgYeGtcjOH7gGn2GgL6
         T1dPw5sYNPyXSUESEN3u4OxLHa8o+l2x8OaND79Z45JnTlul0V6/AwLtEpeGTCc+aUFO
         WAOmtcxxUlIpNLA7FAJ7/dkWZwRPnmtkHN1SGEAlGVLTbW2HmMXuRjOAAFqsjoA9sBNJ
         6MeOXjHnjWs0Of6ZrdE6jI1Pumpu08D7JYE1sQ+NjETw+hURnKbUDHX0ngjZ+iG/0CpZ
         5XdcEEiNiclOK7IXuyk/GFb03qSbXNnqroZJAp2iUg2I+1TGB4/MvxSyIMCyG+lN4jCj
         cxYA==
X-Gm-Message-State: APjAAAUKqj+yogzijHSrk52HIVb0TDo5xB+ejQvIIfx9G/TCGny4e1p6
        BhEo2L8MLFj7tJNU+KIfQL6z/g==
X-Google-Smtp-Source: APXvYqzmvdiYgCaNk/Yz+gbe7oNfFDqe0wURnfCNuFEHKGuwE3yol4RVqwU9utglEwBQz1egeTJ56Q==
X-Received: by 2002:ac8:4412:: with SMTP id j18mr92082065qtn.165.1564667592464;
        Thu, 01 Aug 2019 06:53:12 -0700 (PDT)
Received: from qcai.nay.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id f132sm29393640qke.88.2019.08.01.06.53.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Aug 2019 06:53:11 -0700 (PDT)
From:   Qian Cai <cai@lca.pw>
To:     davem@davemloft.net
Cc:     saeedm@mellanox.com, tariqt@mellanox.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Qian Cai <cai@lca.pw>
Subject: [PATCH v2] net/mlx5e: always initialize frag->last_in_page
Date:   Thu,  1 Aug 2019 09:52:54 -0400
Message-Id: <1564667574-31542-1-git-send-email-cai@lca.pw>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The commit 069d11465a80 ("net/mlx5e: RX, Enhance legacy Receive Queue
memory scheme") introduced an undefined behaviour below due to
"frag->last_in_page" is only initialized in mlx5e_init_frags_partition()
when,

if (next_frag.offset + frag_info[f].frag_stride > PAGE_SIZE)

or after bailed out the loop,

for (i = 0; i < mlx5_wq_cyc_get_size(&rq->wqe.wq); i++)

As the result, there could be some "frag" have uninitialized
value of "last_in_page".

Later, get_frag() obtains those "frag" and check "frag->last_in_page" in
mlx5e_put_rx_frag() and triggers the error during boot. Fix it by always
initializing "frag->last_in_page" to "false" in
mlx5e_init_frags_partition().

UBSAN: Undefined behaviour in
drivers/net/ethernet/mellanox/mlx5/core/en_rx.c:325:12
load of value 170 is not a valid value for type 'bool' (aka '_Bool')
Call trace:
 dump_backtrace+0x0/0x264
 show_stack+0x20/0x2c
 dump_stack+0xb0/0x104
 __ubsan_handle_load_invalid_value+0x104/0x128
 mlx5e_handle_rx_cqe+0x8e8/0x12cc [mlx5_core]
 mlx5e_poll_rx_cq+0xca8/0x1a94 [mlx5_core]
 mlx5e_napi_poll+0x17c/0xa30 [mlx5_core]
 net_rx_action+0x248/0x940
 __do_softirq+0x350/0x7b8
 irq_exit+0x200/0x26c
 __handle_domain_irq+0xc8/0x128
 gic_handle_irq+0x138/0x228
 el1_irq+0xb8/0x140
 arch_cpu_idle+0x1a4/0x348
 do_idle+0x114/0x1b0
 cpu_startup_entry+0x24/0x28
 rest_init+0x1ac/0x1dc
 arch_call_rest_init+0x10/0x18
 start_kernel+0x4d4/0x57c

Fixes: 069d11465a80 ("net/mlx5e: RX, Enhance legacy Receive Queue memory scheme")
Signed-off-by: Qian Cai <cai@lca.pw>
---

v2: zero-init the whole struct instead per Tariq.

 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 47eea6b3a1c3..e1810c03a510 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -331,12 +331,11 @@ static inline u64 mlx5e_get_mpwqe_offset(struct mlx5e_rq *rq, u16 wqe_ix)
 
 static void mlx5e_init_frags_partition(struct mlx5e_rq *rq)
 {
-	struct mlx5e_wqe_frag_info next_frag, *prev;
+	struct mlx5e_wqe_frag_info next_frag = {};
+	struct mlx5e_wqe_frag_info *prev = NULL;
 	int i;
 
 	next_frag.di = &rq->wqe.di[0];
-	next_frag.offset = 0;
-	prev = NULL;
 
 	for (i = 0; i < mlx5_wq_cyc_get_size(&rq->wqe.wq); i++) {
 		struct mlx5e_rq_frag_info *frag_info = &rq->wqe.info.arr[0];
-- 
1.8.3.1

