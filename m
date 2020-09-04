Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A1B125DF7E
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 18:13:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727066AbgIDQNj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 12:13:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726947AbgIDQNd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 12:13:33 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8B5FC061247
        for <netdev@vger.kernel.org>; Fri,  4 Sep 2020 09:13:32 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id a9so6599116wmm.2
        for <netdev@vger.kernel.org>; Fri, 04 Sep 2020 09:13:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=r5Ypt2i5o7p6XAAulXW4iZCF9Jky9zXLQDQcsSL+JwI=;
        b=iQ+DNj3yfOULjXXeM25GLhsssn6UfEKoL2ySHnvL/gCi900fuHh9QwtYHZyUrYEe0r
         g8eWOSwetaScL4UDn56Ehc9i6ffTHCpw3w6u1dGrW/pt9Aqymwz7MQKHrJB13xj2giL8
         0DpmG2JI98pcVSsTmCIMqMbGvDJka9Jam0pfm4tcGLTAGsi5iz+e7AD3NA8NSa85o/41
         Nq2o4RTxp1fiZhop7+2725HB2frR5D+rT/+Q7ZEhYtADlXGnOOiyRbbdB5N9kQrSJvX1
         o9W7NoA1P4UpSUqKcThAgJg7BzDtNBZ4C0c0JHSxQRKP6kkgyroKx0qAZHULLisho8Vr
         1aSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=r5Ypt2i5o7p6XAAulXW4iZCF9Jky9zXLQDQcsSL+JwI=;
        b=ikAaZHtsu7kBzJ8cdZR0MThX9YfHnvM+X6jOCUJBZ9EL5aHYAP2SZ0ALG2t6bcsPuD
         0GBUeHlq0ujH0XmewNKAD/eGMf242mp2cnTdN8kBCJNwhFbym7A19ilE13QtCRYHoHpM
         jjhAwcfxJqDDakhWWHLTf2VOjPwvRB2jsEJEe7lkRJnmSwa7CTzzL0A8sZaTqVWNni3I
         oMKvWDSsFzRWEKF2+MD74H6cx/zbKnIPMez4FVn/rQQ1ovHqCmOC2FBdhblPfxzjYiRV
         fJm9q8jm66eY8rn5wYYcFdzuNaAZXtelhMxOXbHN7UuNdcIvB/XjGkrLD3gnIDbx+f6T
         w/7w==
X-Gm-Message-State: AOAM532cG5aFe4PYmDMwPcEarfhcK+XWrgvdV9vTjViyXSINl+uYDdPv
        dZaeZvjMdm6OnGa0I+D4fCieSw==
X-Google-Smtp-Source: ABdhPJzkneI/d/hPFnmrGeMryuVYR/UALlZRGUWuF9bWBq+aF0mc9og2EByzXF+ZBo8YzGusjDOaPg==
X-Received: by 2002:a7b:c5d0:: with SMTP id n16mr8077048wmk.7.1599236011208;
        Fri, 04 Sep 2020 09:13:31 -0700 (PDT)
Received: from localhost.localdomain ([194.35.117.134])
        by smtp.gmail.com with ESMTPSA id a83sm11909611wmh.48.2020.09.04.09.13.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2020 09:13:30 -0700 (PDT)
From:   Quentin Monnet <quentin@isovalent.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Martynas Pumputis <m@lambda.lt>,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next 1/2] tools: bpftool: dump outer maps content
Date:   Fri,  4 Sep 2020 17:13:12 +0100
Message-Id: <20200904161313.29535-2-quentin@isovalent.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200904161313.29535-1-quentin@isovalent.com>
References: <20200904161313.29535-1-quentin@isovalent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Although user space can lookup and dump the content of an outer map
(hash-of-maps or array-of-maps), bpftool does not allow to do so.

It seems that the only reason for that is historical. Lookups for outer
maps was added in commit 14dc6f04f49d ("bpf: Add syscall lookup support
for fd array and htab"), and although the relevant code in bpftool had
not been merged yet, I suspect it had already been written with the
assumption that user space could not read outer maps.

Let's remove the restriction, dump for outer maps works with no further
change.

Reported-by: Martynas Pumputis <m@lambda.lt>
Signed-off-by: Quentin Monnet <quentin@isovalent.com>
---
 tools/bpf/bpftool/map.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/tools/bpf/bpftool/map.c b/tools/bpf/bpftool/map.c
index bc0071228f88..cb3a75eb5531 100644
--- a/tools/bpf/bpftool/map.c
+++ b/tools/bpf/bpftool/map.c
@@ -739,10 +739,6 @@ static int dump_map_elem(int fd, void *key, void *value,
 	/* lookup error handling */
 	lookup_errno = errno;
 
-	if (map_is_map_of_maps(map_info->type) ||
-	    map_is_map_of_progs(map_info->type))
-		return 0;
-
 	if (json_output) {
 		jsonw_start_object(json_wtr);
 		jsonw_name(json_wtr, "key");
-- 
2.25.1

