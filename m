Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B306634D035
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 14:38:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231366AbhC2Mhj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 08:37:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231363AbhC2Mh3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 08:37:29 -0400
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FF35C061574;
        Mon, 29 Mar 2021 05:37:29 -0700 (PDT)
Received: by mail-ot1-x329.google.com with SMTP id w21-20020a9d63950000b02901ce7b8c45b4so12102472otk.5;
        Mon, 29 Mar 2021 05:37:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pK8UIcnRx4QQ3Btv2WqHIXhdKMyfXlhaYgEAW2yfd5Y=;
        b=EILcPnz2y67mky+A2k5ohkqCxvA12zKUAfHFYSN9F23/xIF70lVOxNXy8VrC6vluLv
         hEQdTOS7lP3BOlqYtocboPHrfKit+9GQnCtWDULfzb31fRxaMDcqNj6UbKViP6rVaCB9
         JCulP+QNoRoVEj4bPWUc+abLCvTd+LUt828YNqtNFeq6zFa/Tx+pVf/FbcMSh6lzkZEX
         Eo/GDuk1BwoAIPGjruFAMMFlYpgAlrnEbN3NiJLrjArEqdJoZy7+ISdxJFZcPy0WBxvE
         d9cTfLKu4LYpmEKuGjk85QSq5TnMaILJIan9V6OcKaPgMvbY+4M6mxZFUEKdQNt7D629
         toYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pK8UIcnRx4QQ3Btv2WqHIXhdKMyfXlhaYgEAW2yfd5Y=;
        b=pTKTRx2HrzXoAwvAZQ1cCMeP1oc74ufUuN5AhVactvKN5SuLUW+B8op0dUXx3MYzaw
         YI29RQ7ww9ZNvj+2zXyzrV0RgsM0E44cqzQM+X9rylUyzOPSyHuCYlsMiC7f4FLtbv3I
         KWG2tUU6MrtyetX4OHPd72pJqoNRPVicAtVdJf19Pbks/dskC25WOmnGIrU62x/4Z5V9
         SrihpcZ69T88YnKn3vrVM14yaZXUWr0pAg02Y4n2Iy41qTvc1I5s3jfuEX2vYNMVoIMt
         n3T2TqSIK3ULfoRkehPOz6ib3Q3HkPVNhx6ubV8+iXSSWCk42TYedK9vckLkY4iaY97S
         3pKw==
X-Gm-Message-State: AOAM533jtgG2jtI/39jjV7N3tAfxa6sdNTDUkh1xvrer0INOM8TE9UdH
        385xmxDoEebzu5ZFgXCMhIs=
X-Google-Smtp-Source: ABdhPJw3VCk/VUkSPd0TAHStpy7RM1JJZli+Jte7UorebVkvs0o5+yeuVP2OfpBPyDYsqZb/i6e53w==
X-Received: by 2002:a9d:6a9:: with SMTP id 38mr23032292otx.365.1617021449067;
        Mon, 29 Mar 2021 05:37:29 -0700 (PDT)
Received: from localhost.localdomain ([50.236.19.102])
        by smtp.gmail.com with ESMTPSA id m14sm4452271otn.69.2021.03.29.05.37.22
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Mar 2021 05:37:28 -0700 (PDT)
From:   qianjun.kernel@gmail.com
To:     akpm@linux-foundation.org, ast@kernel.org, daniel@iogearbox.net,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org, linux-mm@kvack.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, jun qian <qianjun.kernel@gmail.com>
Subject: [PATCH V2 1/1] mm:improve the performance during fork
Date:   Mon, 29 Mar 2021 20:36:35 +0800
Message-Id: <20210329123635.56915-1-qianjun.kernel@gmail.com>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: jun qian <qianjun.kernel@gmail.com>

In our project, Many business delays come from fork, so
we started looking for the reason why fork is time-consuming.
I used the ftrace with function_graph to trace the fork, found
that the vm_normal_page will be called tens of thousands and
the execution time of this vm_normal_page function is only a
few nanoseconds. And the vm_normal_page is not a inline function.
So I think if the function is inline style, it maybe reduce the
call time overhead.

I did the following experiment:

use the bpftrace tool to trace the fork time :

bpftrace -e 'kprobe:_do_fork/comm=="redis-server"/ {@st=nsecs;} \
kretprobe:_do_fork /comm=="redis-server"/{printf("the fork time \
is %d us\n", (nsecs-@st)/1000)}'

no inline vm_normal_page:
result:
the fork time is 40743 us
the fork time is 41746 us
the fork time is 41336 us
the fork time is 42417 us
the fork time is 40612 us
the fork time is 40930 us
the fork time is 41910 us

inline vm_normal_page:
result:
the fork time is 39276 us
the fork time is 38974 us
the fork time is 39436 us
the fork time is 38815 us
the fork time is 39878 us
the fork time is 39176 us

In the same test environment, we can get 3% to 4% of
performance improvement.

note:the test data is from the 4.18.0-193.6.3.el8_2.v1.1.x86_64,
because my product use this version kernel to test the redis
server, If you need to compare the latest version of the kernel
test data, you can refer to the version 1 Patch.

We need to compare the changes in the size of vmlinux:
                  inline           non-inline       diff
vmlinux size      9709248 bytes    9709824 bytes    -576 bytes

Signed-off-by: jun qian <qianjun.kernel@gmail.com>
---
 mm/memory.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memory.c b/mm/memory.c
index eeae590e526a..6ade9748d425 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -592,7 +592,7 @@ static void print_bad_pte(struct vm_area_struct *vma, unsigned long addr,
  * PFNMAP mappings in order to support COWable mappings.
  *
  */
-struct page *vm_normal_page(struct vm_area_struct *vma, unsigned long addr,
+inline struct page *vm_normal_page(struct vm_area_struct *vma, unsigned long addr,
 			    pte_t pte)
 {
 	unsigned long pfn = pte_pfn(pte);
-- 
2.18.2

