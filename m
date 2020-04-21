Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F3EE1B2EB8
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 20:04:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726012AbgDUSEm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 14:04:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725930AbgDUSEl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 14:04:41 -0400
Received: from mail-qv1-xf41.google.com (mail-qv1-xf41.google.com [IPv6:2607:f8b0:4864:20::f41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B35F3C0610D5
        for <netdev@vger.kernel.org>; Tue, 21 Apr 2020 11:04:41 -0700 (PDT)
Received: by mail-qv1-xf41.google.com with SMTP id bu9so6990488qvb.13
        for <netdev@vger.kernel.org>; Tue, 21 Apr 2020 11:04:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=27OO6okPsl+Rgn9zh/Aewmvoc4itPJ/ehOiPRiBbC+Q=;
        b=Gf5h8nUrzQhCTeF7O2pVTa8UlE4p1q7Xd8SoCKfaIHbyNb+OTSRdyUS7kxqk/ePtJo
         XjW3/JG7NqoPWigOIpvQKXo1o9WiXyJCm6HE39Fjmzmp9V5YV2BVNl8OaVw6BiE8ME8F
         sAeR4r+dvz10Mc9BZ6lWiIm/sMPRhZ7NWGwUjyFW3IFFkP2leoFYFStadi19R7qTMXCh
         3HlfcQPnih9Rgkj4XAKDlq2ka29VgAvvaMaNXJlbqLaIOGlEa6kmgwcHRcq4yeR5rq14
         tFrNI/zavZ/qL5Wj5yvgsAP75QkLyjcB61fcS7fgqc95NeQKLgCjnwPj9Sy/tXvJD/Oa
         9tzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=27OO6okPsl+Rgn9zh/Aewmvoc4itPJ/ehOiPRiBbC+Q=;
        b=Cb5mBuajmos6qoN9//GlRquPIWiyECLtee5GGfqh0GS2/CLkXLXM+PS7A7tERf/zP8
         xmJq6xIvBtraNrVpaGlRM66fABo4v5PPDnKMBammsvEtIRtoH9TvOe+WxJEmGUhkz+Tm
         nK75X+qOcFPtHpSWm6AeWOmrYjPwTJ+oxFaFCbYdoz10aN1wmVtNMgyKf6W2NhLbWRtO
         4+XchI6SvQ0NAwXo0mvuo6SZw/1jNlAayi0cD8lVC4T8jbZXqetosoESJJPdsPRxaA3r
         0FWGD3i3SG7Bfj02obsOkU6OOe0igzXp8vkYAhFk9Z4xufh8KD4ttRI8CeKhy3VwXgtH
         2TXw==
X-Gm-Message-State: AGi0PuakcLC9D5fVEKqjmBoMLxYvucfbsB4fG0BwSsgSfsfvJWATbpCI
        fY+fvYoHTdB/RV/Yo5U/YJ089w==
X-Google-Smtp-Source: APiQypLes30RzfoWF7O2nMpio7cM1yxDIj2fHzZ7A/T8n0AYHuy7Qobyq5is5rZSL6f+XxlIvaG40A==
X-Received: by 2002:a0c:9e2f:: with SMTP id p47mr19766285qve.211.1587492280971;
        Tue, 21 Apr 2020 11:04:40 -0700 (PDT)
Received: from mojaone.lan (23-233-27-60.cpe.pppoe.ca. [23.233.27.60])
        by smtp.gmail.com with ESMTPSA id t67sm2203827qka.17.2020.04.21.11.04.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 21 Apr 2020 11:04:39 -0700 (PDT)
From:   Jamal Hadi Salim <jhs@mojatatu.com>
X-Google-Original-From: Jamal Hadi Salim <jhs@emojatatu.com>
To:     stephen@networkplumber.org
Cc:     netdev@vger.kernel.org, dsahern@gmail.com, aclaudi@redhat.com,
        daniel@iogearbox.net, Jamal Hadi Salim <hadi@mojatatu.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>
Subject: [PATCH iproute2 1/1] bpf: Fix segfault when custom pinning is used
Date:   Tue, 21 Apr 2020 14:04:26 -0400
Message-Id: <20200421180426.6945-1-jhs@emojatatu.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jamal Hadi Salim <hadi@mojatatu.com>

Fixes: c0325b06382 ("bpf: replace snprintf with asprintf when dealing with long buffers")

Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
---
 lib/bpf.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/lib/bpf.c b/lib/bpf.c
index 10cf9bf4..cf636c9e 100644
--- a/lib/bpf.c
+++ b/lib/bpf.c
@@ -1509,12 +1509,12 @@ out:
 static int bpf_make_custom_path(const struct bpf_elf_ctx *ctx,
 				const char *todo)
 {
-	char *tmp = NULL;
+	char tmp[PATH_MAX] = {};
 	char *rem = NULL;
 	char *sub;
 	int ret;
 
-	ret = asprintf(&tmp, "%s/../", bpf_get_work_dir(ctx->type));
+	ret = sprintf(tmp, "%s/../", bpf_get_work_dir(ctx->type));
 	if (ret < 0) {
 		fprintf(stderr, "asprintf failed: %s\n", strerror(errno));
 		goto out;
@@ -1547,7 +1547,6 @@ static int bpf_make_custom_path(const struct bpf_elf_ctx *ctx,
 	ret = 0;
 out:
 	free(rem);
-	free(tmp);
 	return ret;
 }
 
-- 
2.20.1

