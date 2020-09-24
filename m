Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFD2D27789E
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 20:45:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728733AbgIXSpR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 14:45:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728605AbgIXSpR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 14:45:17 -0400
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com [IPv6:2607:f8b0:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2000EC0613CE
        for <netdev@vger.kernel.org>; Thu, 24 Sep 2020 11:45:17 -0700 (PDT)
Received: by mail-oi1-x242.google.com with SMTP id i17so35058oig.10
        for <netdev@vger.kernel.org>; Thu, 24 Sep 2020 11:45:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:user-agent:mime-version
         :content-transfer-encoding;
        bh=MuxPIm0lhtfPHdY4f32KjCf9K32XfoZ0wHk8KFObcAE=;
        b=qL0qf05zTzY1QjT4FB5dZpkpN51S4FetA/WGD897r2wxWP0NFh/ghwaSjeQ8YqmtfR
         jxJrvdZ1gvziPHz9LRSlCsbeVEkBIURW5kAuSAkQlchiBlv/SFZfzNh5JYfpS8GTt8+Q
         5PnQA7hjxEZ2cmKgaDU2+Dnl9aG+ODJ1gD037fxJOYfG1s454hGbYIQjyhHpNaDmqulf
         auE099v3Igmz1B1w2bExjzsuMUqdCjJIdsih5bCDAc/8JnVBa+jOBoaevJXcb/WQPI8/
         MybuTi+ugQSPko2mvdRLqUYyTTIYVm606daNrRjY6uGzGWfpyuHjxREc/A1Hw0wOyETJ
         IcEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=MuxPIm0lhtfPHdY4f32KjCf9K32XfoZ0wHk8KFObcAE=;
        b=MXrYMP30SpdsDovZkVgf1xk/Slv8/32JO8EY5RTH9KGDxX+lk0UjtOYIxZ/Dp0/hgE
         q6ThKrbl4kNiTUiiP/pGlX9KNaZiACuilJzKr8Z736HCaAdCkW331lVNDGIpEGsPc6ar
         eo9U/5NMjJD9Bfe0TM6XfzeTTdloIG7HrJM32tygfXYvhBWQZ5ZMFPZX6lYSQ5nmdtgX
         2izbdG7XGGWUZ+72fMWtkOivZM9P7E+rH4OLcWWqBQSiSs76LQi68xr1kmfc8umvpWux
         b/M6QlmuqnTsoc/bInNnyujqGzzaeBWrdk7LHUM725xGtbLqAxGYEkUOHkGnnMiN6jXw
         O1cQ==
X-Gm-Message-State: AOAM531KXhM5sKEydHtuOGa+YwhtolzWeUkKmpw0/JRZ7yj6SZF0W01z
        r1cXoYOV1nNexIBW9F67DRAhZccSy343QA==
X-Google-Smtp-Source: ABdhPJzk4CceBiiVrbOk9Io0VVL0A1nj1DiFKh0sITMXrGreuxEiOsQqU1ZT54w4QfgWx71KQbbH9g==
X-Received: by 2002:aca:d549:: with SMTP id m70mr106388oig.49.1600973116259;
        Thu, 24 Sep 2020 11:45:16 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id l23sm20163otk.79.2020.09.24.11.45.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2020 11:45:15 -0700 (PDT)
Subject: [bpf-next PATCH 1/2] bpf,
 verifier: Remove redundant var_off.value ops in scalar known reg
 cases
From:   John Fastabend <john.fastabend@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, john.fastabend@gmail.com
Date:   Thu, 24 Sep 2020 11:45:06 -0700
Message-ID: <160097310597.12106.6191783180902126213.stgit@john-Precision-5820-Tower>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In BPF_AND and BPF_OR alu cases we have this pattern when the src and dst
tnum is a constant.

 1 dst_reg->var_off = tnum_[op](dst_reg->var_off, src_reg.var_off)
 2 scalar32_min_max_[op]
 3       if (known) return
 4 scalar_min_max_[op]
 5       if (known)
 6          __mark_reg_known(dst_reg,
                   dst_reg->var_off.value [op] src_reg.var_off.value)

The result is in 1 we calculate the var_off value and store it in the
dst_reg. Then in 6 we duplicate this logic doing the op again on the
value.

The duplication comes from the the tnum_[op] handlers because they have
already done the value calcuation. For example this is tnum_and().

 struct tnum tnum_and(struct tnum a, struct tnum b)
 {
	u64 alpha, beta, v;

	alpha = a.value | a.mask;
	beta = b.value | b.mask;
	v = a.value & b.value;
	return TNUM(v, alpha & beta & ~v);
 }

So lets remove the redundant op calculation. Its confusing for readers
and unnecessary. Its also not harmful because those ops have the
property, r1 & r1 = r1 and r1 | r1 = r1.

Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 kernel/bpf/verifier.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 15ab889b0a3f..33fcc18fdd39 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -5818,8 +5818,7 @@ static void scalar_min_max_and(struct bpf_reg_state *dst_reg,
 	u64 umax_val = src_reg->umax_value;
 
 	if (src_known && dst_known) {
-		__mark_reg_known(dst_reg, dst_reg->var_off.value &
-					  src_reg->var_off.value);
+		__mark_reg_known(dst_reg, dst_reg->var_off.value);
 		return;
 	}
 
@@ -5889,8 +5888,7 @@ static void scalar_min_max_or(struct bpf_reg_state *dst_reg,
 	u64 umin_val = src_reg->umin_value;
 
 	if (src_known && dst_known) {
-		__mark_reg_known(dst_reg, dst_reg->var_off.value |
-					  src_reg->var_off.value);
+		__mark_reg_known(dst_reg, dst_reg->var_off.value);
 		return;
 	}
 

