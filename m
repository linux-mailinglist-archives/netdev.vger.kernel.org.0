Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5705E44C197
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 13:51:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231759AbhKJMxt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 07:53:49 -0500
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:32850 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229653AbhKJMxs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Nov 2021 07:53:48 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R261e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=guwen@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0UvuzFxJ_1636548651;
Received: from e02h04404.eu6sqa(mailfrom:guwen@linux.alibaba.com fp:SMTPD_---0UvuzFxJ_1636548651)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 10 Nov 2021 20:50:58 +0800
From:   Wen Gu <guwen@linux.alibaba.com>
To:     kgraul@linux.ibm.com, tonylu@linux.alibaba.com
Cc:     davem@davemloft.net, kuba@kernel.org, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        dust.li@linux.alibaba.com, xuanzhuo@linux.alibaba.com,
        guwen@linux.alibaba.com
Subject: [RFC PATCH 0/2] Two RFC patches for the same SMC socket wait queue mismatch issue
Date:   Wed, 10 Nov 2021 20:50:49 +0800
Message-Id: <1636548651-44649-1-git-send-email-guwen@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, Karsten

Thanks for your reply. The previous discussion about the issue of socket
wait queue mismatch in SMC fallback can be referred from:
https://lore.kernel.org/all/db9acf73-abef-209e-6ec2-8ada92e2cfbc@linux.ibm.com/

This set of patches includes two RFC patches, they are both aimed to fix
the same issue, the mismatch of socket wait queue in SMC fallback.

In your last reply, I am suggested to add the complete description about
the intention of initial patch in order that readers can understand the
idea behind it. This has been done in "[RFC PATCH net v2 0/2] net/smc: Fix
socket wait queue mismatch issue caused by fallback" of this mail.

Unfortunately, I found a defect later in the solution of the initial patch
or the v2 patch mentioned above. The defect is about fasync_list and related
to 67f562e3e14 ("net/smc: transfer fasync_list in case of fallback").

When user applications use sock_fasync() to insert entries into fasync_list,
the wait queue they operate is smc socket->wq. But in initial patch or
the v2 patch, I swapped sk->sk_wq of smc socket and clcsocket in smc_create(),
thus the sk_data_ready / sk_write_space.. of smc will wake up clcsocket->wq
finally. So the entries added into smc socket->wq.fasync_list won't be woken
up at all before fallback.

So the solution in initial patch or the v2 patch of this mail by swapping
sk->sk_wq of smc socket and clcsocket seems a bad way to fix this issue.

Therefore, I tried another solution by removing the wait queue entries from
smc socket->wq to clcsocket->wq during the fallback, which is described in the
"[RFC PATCH net 2/2] net/smc: Transfer remaining wait queue entries" of this
mail. In our test environment, this patch can fix the fallback issue well.

I am looking forward to hear your opinions. Thank you.

Cheers,
Wen Gu

Wen Gu (2):
  net/smc: Fix socket wait queue mismatch issue caused by fallback
  net/smc: Transfer remaining wait queue entries

