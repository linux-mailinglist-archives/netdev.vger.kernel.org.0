Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7CAA207F41
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 00:20:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389045AbgFXWUy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 18:20:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388706AbgFXWUx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 18:20:53 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76D7FC061573;
        Wed, 24 Jun 2020 15:20:52 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id y2so3971182ioy.3;
        Wed, 24 Jun 2020 15:20:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:user-agent:mime-version
         :content-transfer-encoding;
        bh=mWdP3fCXWF1/IaU6NZlDeLwG9jVrK9kOQYwG+cvhPUo=;
        b=BDRIjC8pFHtuYyAqnbKIJZRyHy5m/hHVcQ/Wds6ZFpyKajQaAmeUXLaYeB2pC4hqmP
         gAItWlza3BUK5KvTgrS7c1qduKDu+et0GdrE2GAs5MLQTQpeORDUSFiKbsCgoDPhRL+K
         PK7VgK9njIGrdtJyDJJam78yVxI+9dMlyQ/NPJhv2z35PjVGyMacLW+SFkYI+0UYVJQ+
         CjdGVfC5PcdVhACH0Z8mIuUFLNSdc0qK5qpVJ4aQI1ZL3HRy2Fc7TlDyJXQ3YbUMhXAJ
         4Q8mFkCJiZlp5n5gdpWlx00bMQjgy12ghZa1URKNnBQWVi45Hsrv74Dp7VKAzCwI9Nyb
         SWhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=mWdP3fCXWF1/IaU6NZlDeLwG9jVrK9kOQYwG+cvhPUo=;
        b=PW9srSFuSNCLH6qEdFZi08SHkeDIZ1ek9QAYv8b7u5Ljd6OxtrbKRf1rb/e0Xj7Psd
         buDKzPQI5zA7sMIbwAOHf4c9ceLuHYIk9yDtr6pPZ5yg7JI7NueYByY187LY5AI30DHE
         MoBN7J1jM7zlDJhf8ajcbJWJBaAGnK1mQPBJWI1WZw0Uwvptbcr8UT8Fnfo5vVd4aGMf
         Huwy9mUYgjst5qKtgz90+PfDsKtFe+SGo5Kwwd8BuUZ/7ZsP2Ufuk5jACkFm7oscYZ7J
         QUAwUihvPtI1bWtkfQZsH63EWM7Fq+g2th4m8SvDa9IzdASQWpHnN9tjVOSk36bNDBZ/
         HiYA==
X-Gm-Message-State: AOAM5331TWllMO+II89JW+a27/KEJOOcdVvBwiNXIzuZEVX/b/9uD4F/
        8gIOCz+bgxmOfgupe3m4qLg=
X-Google-Smtp-Source: ABdhPJyzhXu5BWub1oyh0ph3FXUrUndZiEU3Fl9//+cm8at1jhWROINpUUDvumi7ku1O6MjrWVxXag==
X-Received: by 2002:a5e:dc46:: with SMTP id s6mr18667897iop.189.1593037251780;
        Wed, 24 Jun 2020 15:20:51 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id a20sm8701973ila.5.2020.06.24.15.20.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Jun 2020 15:20:51 -0700 (PDT)
Subject: [bpf PATCH] bpf: Do not allow btf_ctx_access with __int128 types
From:   John Fastabend <john.fastabend@gmail.com>
To:     jolsa@kernel.org, andrii.nakryiko@gmail.com, ast@kernel.org,
        daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com
Date:   Wed, 24 Jun 2020 15:20:39 -0700
Message-ID: <159303723962.11287.13309537171132420717.stgit@john-Precision-5820-Tower>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To ensure btf_ctx_access() is safe the verifier checks that the BTF
arg type is an int, enum, or pointer. When the function does the
BTF arg lookup it uses the calculation 'arg = off / 8'  using the
fact that registers are 8B. This requires that the first arg is
in the first reg, the second in the second, and so on. However,
for __int128 the arg will consume two registers by default LLVM
implementation. So this will cause the arg layout assumed by the
'arg = off / 8' calculation to be incorrect.

Because __int128 is uncommon this patch applies the easiest fix and
will force int types to be sizeof(u64) or smaller so that they will
fit in a single register.

v2: remove unneeded parens per Andrii's feedback

Fixes: 9e15db66136a1 ("bpf: Implement accurate raw_tp context access via BTF")
Acked-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 include/linux/btf.h |    5 +++++
 kernel/bpf/btf.c    |    4 ++--
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/include/linux/btf.h b/include/linux/btf.h
index 5c1ea99..8b81fbb 100644
--- a/include/linux/btf.h
+++ b/include/linux/btf.h
@@ -82,6 +82,11 @@ static inline bool btf_type_is_int(const struct btf_type *t)
 	return BTF_INFO_KIND(t->info) == BTF_KIND_INT;
 }
 
+static inline bool btf_type_is_small_int(const struct btf_type *t)
+{
+	return btf_type_is_int(t) && t->size <= sizeof(u64);
+}
+
 static inline bool btf_type_is_enum(const struct btf_type *t)
 {
 	return BTF_INFO_KIND(t->info) == BTF_KIND_ENUM;
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 58c9af1..9a1a98d 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -3746,7 +3746,7 @@ bool btf_ctx_access(int off, int size, enum bpf_access_type type,
 				return false;
 
 			t = btf_type_skip_modifiers(btf, t->type, NULL);
-			if (!btf_type_is_int(t)) {
+			if (!btf_type_is_small_int(t)) {
 				bpf_log(log,
 					"ret type %s not allowed for fmod_ret\n",
 					btf_kind_str[BTF_INFO_KIND(t->info)]);
@@ -3768,7 +3768,7 @@ bool btf_ctx_access(int off, int size, enum bpf_access_type type,
 	/* skip modifiers */
 	while (btf_type_is_modifier(t))
 		t = btf_type_by_id(btf, t->type);
-	if (btf_type_is_int(t) || btf_type_is_enum(t))
+	if (btf_type_is_small_int(t) || btf_type_is_enum(t))
 		/* accessing a scalar */
 		return true;
 	if (!btf_type_is_ptr(t)) {

