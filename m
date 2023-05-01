Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E02726F3AE3
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 01:14:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233217AbjEAXOQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 May 2023 19:14:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233209AbjEAXOH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 May 2023 19:14:07 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEFF635B0;
        Mon,  1 May 2023 16:14:04 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id ffacd0b85a97d-3062678861fso1509727f8f.0;
        Mon, 01 May 2023 16:14:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682982843; x=1685574843;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n8RA7X/L/leNHn/1HMTSlACeb8+DsSawTG5COyZPU+Q=;
        b=DhyL19lI5vv/dMIWTaHqB2GR/UHBozo3SfDGWzIAIgkjz7Beb/a4fc45GHtEpbQ4bY
         JSbVJrm43TKbzpnEOl1DeJURI7jehJMpGR/+lJIE/2BUb8Jzt84GByKPWbQ9UZ1xVj8L
         Fu+s/PoUjbIHkAZr/B6ycJGlMK3mvR9/lvSReVGMUiGUVnayQLCbzRLjuGPINpt3Ws1C
         KV0uvaws+leQ7Hi3SXDRBYA0+K/Gf+WcHlqa42S3tra5dOStz08FmavmeenpUyL/V3aO
         mBnY1ERuASpJ2PSyedZWdLCQc/BOSyr8aMJxq0pPYz22BjNTon4wssFISwNAwiScMPc0
         fDkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682982843; x=1685574843;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=n8RA7X/L/leNHn/1HMTSlACeb8+DsSawTG5COyZPU+Q=;
        b=KrqWUT7U2cczJOvjGnfsy4zF1eCHqlo0Zh0qqJCvZLD34idmFWggrlpEBbxNtcT4ND
         mtJ/LFBNTd6If/DGi7LFLOsw4gLqNZ8pkvM5fBE1zhUyjktPCAAYgB7YJOEf1D5qnQ//
         bm06zKyPkr/VLWFIXufg923d4mUGD2P/ztDyWTbzrrfmILIsLbOnZfHHFBo+6LNrRErz
         hpYfjVyCgb6/OZ2LZuME0n9srKI6VkEzcnakGjT/6YxS92UiyJGG9qeoWVHPatcWQGLD
         vZCmvf0uRofuMziXXdvBa5T+FS/pIUB/qhtWi7Qx6EwaHMLLDZtwZwvzHO/HRoi1JxGm
         SRKw==
X-Gm-Message-State: AC+VfDzDPpB++elu72rR/WQW69OwugZHSQFIWiFfV5o3VEjTwM/joT4e
        UBqCxxT4zb2EjaojlPQ9YyU=
X-Google-Smtp-Source: ACHHUZ5ct/GSZp53jF0wy+snTNNs6N2KLpkY8kZAxln2BuMpI5YYN3gZZnh+y/fj9ojL8yZiO4sOtg==
X-Received: by 2002:a05:6000:108f:b0:306:379e:d161 with SMTP id y15-20020a056000108f00b00306379ed161mr97121wrw.5.1682982842856;
        Mon, 01 May 2023 16:14:02 -0700 (PDT)
Received: from lucifer.home (host86-156-84-164.range86-156.btcentralplus.com. [86.156.84.164])
        by smtp.googlemail.com with ESMTPSA id v9-20020a05600c444900b003f173be2ccfsm48948904wmn.2.2023.05.01.16.14.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 May 2023 16:14:02 -0700 (PDT)
From:   Lorenzo Stoakes <lstoakes@gmail.com>
To:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>, Jens Axboe <axboe@kernel.dk>,
        Matthew Wilcox <willy@infradead.org>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Leon Romanovsky <leon@kernel.org>,
        Christian Benvenuti <benve@cisco.com>,
        Nelson Escobar <neescoba@cisco.com>,
        Bernard Metzler <bmt@zurich.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Ian Rogers <irogers@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bjorn Topel <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Christian Brauner <brauner@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        linux-fsdevel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        John Hubbard <jhubbard@nvidia.com>, Jan Kara <jack@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Mika Penttila <mpenttil@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Theodore Ts'o <tytso@mit.edu>, Peter Xu <peterx@redhat.com>,
        Lorenzo Stoakes <lstoakes@gmail.com>
Subject: [PATCH v6 2/3] mm/gup: disallow FOLL_LONGTERM GUP-nonfast writing to file-backed mappings
Date:   Tue,  2 May 2023 00:11:48 +0100
Message-Id: <ff543d504d2bf83f60b1fb478149b4b3d6298119.1682981880.git.lstoakes@gmail.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <cover.1682981880.git.lstoakes@gmail.com>
References: <cover.1682981880.git.lstoakes@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Writing to file-backed mappings which require folio dirty tracking using
GUP is a fundamentally broken operation, as kernel write access to GUP
mappings do not adhere to the semantics expected by a file system.

A GUP caller uses the direct mapping to access the folio, which does not
cause write notify to trigger, nor does it enforce that the caller marks
the folio dirty.

The problem arises when, after an initial write to the folio, writeback
results in the folio being cleaned and then the caller, via the GUP
interface, writes to the folio again.

As a result of the use of this secondary, direct, mapping to the folio no
write notify will occur, and if the caller does mark the folio dirty, this
will be done so unexpectedly.

For example, consider the following scenario:-

1. A folio is written to via GUP which write-faults the memory, notifying
   the file system and dirtying the folio.
2. Later, writeback is triggered, resulting in the folio being cleaned and
   the PTE being marked read-only.
3. The GUP caller writes to the folio, as it is mapped read/write via the
   direct mapping.
4. The GUP caller, now done with the page, unpins it and sets it dirty
   (though it does not have to).

This results in both data being written to a folio without writenotify, and
the folio being dirtied unexpectedly (if the caller decides to do so).

This issue was first reported by Jan Kara [1] in 2018, where the problem
resulted in file system crashes.

This is only relevant when the mappings are file-backed and the underlying
file system requires folio dirty tracking. File systems which do not, such
as shmem or hugetlb, are not at risk and therefore can be written to
without issue.

Unfortunately this limitation of GUP has been present for some time and
requires future rework of the GUP API in order to provide correct write
access to such mappings.

However, for the time being we introduce this check to prevent the most
egregious case of this occurring, use of the FOLL_LONGTERM pin.

These mappings are considerably more likely to be written to after
folios are cleaned and thus simply must not be permitted to do so.

This patch changes only the slow-path GUP functions, a following patch
adapts the GUP-fast path along similar lines.

[1]:https://lore.kernel.org/linux-mm/20180103100430.GE4911@quack2.suse.cz/

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: Mika Penttilä <mpenttil@redhat.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
---
 mm/gup.c | 41 ++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 40 insertions(+), 1 deletion(-)

diff --git a/mm/gup.c b/mm/gup.c
index ff689c88a357..0f09dec0906c 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -959,16 +959,51 @@ static int faultin_page(struct vm_area_struct *vma,
 	return 0;
 }
 
+/*
+ * Writing to file-backed mappings which require folio dirty tracking using GUP
+ * is a fundamentally broken operation, as kernel write access to GUP mappings
+ * do not adhere to the semantics expected by a file system.
+ *
+ * Consider the following scenario:-
+ *
+ * 1. A folio is written to via GUP which write-faults the memory, notifying
+ *    the file system and dirtying the folio.
+ * 2. Later, writeback is triggered, resulting in the folio being cleaned and
+ *    the PTE being marked read-only.
+ * 3. The GUP caller writes to the folio, as it is mapped read/write via the
+ *    direct mapping.
+ * 4. The GUP caller, now done with the page, unpins it and sets it dirty
+ *    (though it does not have to).
+ *
+ * This results in both data being written to a folio without writenotify, and
+ * the folio being dirtied unexpectedly (if the caller decides to do so).
+ */
+static bool writeable_file_mapping_allowed(struct vm_area_struct *vma,
+					   unsigned long gup_flags)
+{
+	/* If we aren't pinning then no problematic write can occur. */
+	if (!(gup_flags & (FOLL_GET | FOLL_PIN)))
+		return true;
+
+	/* We limit this check to the most egregious case - a long term pin. */
+	if (!(gup_flags & FOLL_LONGTERM))
+		return true;
+
+	/* If the VMA requires dirty tracking then GUP will be problematic. */
+	return vma_needs_dirty_tracking(vma);
+}
+
 static int check_vma_flags(struct vm_area_struct *vma, unsigned long gup_flags)
 {
 	vm_flags_t vm_flags = vma->vm_flags;
 	int write = (gup_flags & FOLL_WRITE);
 	int foreign = (gup_flags & FOLL_REMOTE);
+	bool vma_anon = vma_is_anonymous(vma);
 
 	if (vm_flags & (VM_IO | VM_PFNMAP))
 		return -EFAULT;
 
-	if (gup_flags & FOLL_ANON && !vma_is_anonymous(vma))
+	if ((gup_flags & FOLL_ANON) && !vma_anon)
 		return -EFAULT;
 
 	if ((gup_flags & FOLL_LONGTERM) && vma_is_fsdax(vma))
@@ -978,6 +1013,10 @@ static int check_vma_flags(struct vm_area_struct *vma, unsigned long gup_flags)
 		return -EFAULT;
 
 	if (write) {
+		if (!vma_anon &&
+		    !writeable_file_mapping_allowed(vma, gup_flags))
+			return -EFAULT;
+
 		if (!(vm_flags & VM_WRITE)) {
 			if (!(gup_flags & FOLL_FORCE))
 				return -EFAULT;
-- 
2.40.1

