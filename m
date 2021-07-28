Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 863B83D938B
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 18:48:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229737AbhG1QsI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 12:48:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbhG1QsI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 12:48:08 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4329FC061764
        for <netdev@vger.kernel.org>; Wed, 28 Jul 2021 09:48:06 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id da26so4156752edb.1
        for <netdev@vger.kernel.org>; Wed, 28 Jul 2021 09:48:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=anyfinetworks-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EfomRu8c6V1fahvhuLBzuVvQkkgH2iJnqviz3zz4Tos=;
        b=Ud0PZOdDtj6w7Yx1+aKFZAXmmbfL/gJnF2Ra9F9Cy4EPW419uk8bDqVmSmmmO8mNui
         X8xneiSj/T6BbxIj4VqO4uovHXuJlmGPyWwh09FmW9hj4EC2TyiAQTvRScJYusW+bE4e
         JACr3ry8yy3ZdUeuYtqU8ZEytRST5Sm9GDKyI+tz+qdagETXYgYhxq9adQZiFNU69DRp
         yHTveFI2qGXM3sBw2+DHaAyayUr3ZpN8gzLPOV/pARppR/4liiCh9Fc64u37/YfDXZzq
         zMFYgOMe6OpYnXTEYZAKAvbiyxUG2oAc2lP1Aj8y4RVndU+T8Cmwmw7cpo3boHIB9Jso
         CNAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EfomRu8c6V1fahvhuLBzuVvQkkgH2iJnqviz3zz4Tos=;
        b=m3iRQ3L/3VifFLHqSyG9hEMnYc+ybIafsOsQIaEFvLcqxldaVUMNAWECSkOF1EDAa7
         tiDav6tBNYIxZUYz3rVs0rfhQTxUn3rUQwhZC/pCY7aZDlmKw8Kbu/aeBItYj0TrXzxT
         HBw5jChMe0JocElGYyXWm/OdNmagy9NA7hStFA/ykJthgs671thQEejcI5kpAa/qajz1
         mX6bint5sLHy0TF3UqbidD6A0WxcPFlUnJ3WYJuIpHMdDTbBluhJSkcPSujmzKJN/ERS
         KCiVe/QgsW128DwVQqIcGVM346VuipoEsqujARxenXJhPyHok1l6Vwz9SI4ecZ00eIGd
         kNzQ==
X-Gm-Message-State: AOAM5304CbHd3kKrrFPDF2NsIaiTZPyt4k9LcCV3j5N9SomBV0N9K/k0
        Dlf9pTQOU1AM0rvkE30hiR3exw==
X-Google-Smtp-Source: ABdhPJx2s99e8BoFNZ9ExaFW69V1ZKIuudpgtWLAWSF2ShSxUAKSVEHUGyfVpC1yJoUua0bRY7hxvg==
X-Received: by 2002:a05:6402:d68:: with SMTP id ec40mr916872edb.344.1627490884920;
        Wed, 28 Jul 2021 09:48:04 -0700 (PDT)
Received: from anpc2.lan (static-213-115-136-2.sme.telenor.se. [213.115.136.2])
        by smtp.gmail.com with ESMTPSA id c28sm86465ejc.102.2021.07.28.09.48.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 09:48:04 -0700 (PDT)
From:   Johan Almbladh <johan.almbladh@anyfinetworks.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        Tony.Ambardar@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>
Subject: [PATCH] bpf: Fix off-by-one in tail call count limiting
Date:   Wed, 28 Jul 2021 18:47:41 +0200
Message-Id: <20210728164741.350370-1-johan.almbladh@anyfinetworks.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <5afe26c6-7ab1-88ab-a3e0-eb007256a856@iogearbox.net>
References: <5afe26c6-7ab1-88ab-a3e0-eb007256a856@iogearbox.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Before, the interpreter allowed up to MAX_TAIL_CALL_CNT + 1 tail calls.
Now precisely MAX_TAIL_CALL_CNT is allowed, which is in line with the
behavior of the x86 JITs.

Signed-off-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
---
 kernel/bpf/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 9b1577498373..67682b3afc84 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -1559,7 +1559,7 @@ static u64 ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn)
 
 		if (unlikely(index >= array->map.max_entries))
 			goto out;
-		if (unlikely(tail_call_cnt > MAX_TAIL_CALL_CNT))
+		if (unlikely(tail_call_cnt >= MAX_TAIL_CALL_CNT))
 			goto out;
 
 		tail_call_cnt++;
-- 
2.25.1

