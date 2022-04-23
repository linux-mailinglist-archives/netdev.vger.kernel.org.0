Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6D8D50CAED
	for <lists+netdev@lfdr.de>; Sat, 23 Apr 2022 16:02:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235916AbiDWOE6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Apr 2022 10:04:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235921AbiDWOEz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Apr 2022 10:04:55 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA04CBF59;
        Sat, 23 Apr 2022 07:01:58 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id q3so17001606plg.3;
        Sat, 23 Apr 2022 07:01:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qbWaCg87av5QkGfalhJMKMRl9w04duKo1d4+9bAwtbE=;
        b=bidheqFHzJaEQrtqov76Lq0+9bgIH/WOepEafOSjysyFK0tL42mq8RAyMFXp8Uff1/
         Eo8tK7Y1/Ra7Bag88koJjbC8xMsBkNN09f/zfD5Q4PduFKBRSs31yvki2x/RbTSmB8zD
         EJkZEE9kuGdVJn6K8PRxQ6SxowsMH20HLnsJXmW+iAnq1MaLje4TrPNixxgY3+1nDOKS
         tEut18gMuFReuJT+nLxSx2154HBglzSMCvGTZE82VaYGebXDVwydNkKaaoKaLR1sN4Yf
         oGaeu6HacnHgm0CYDyb0EKj4/ugVXInLYdOcO85YuO/D8pM35SUhDOjZurO9/S3FtGQ0
         hD4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qbWaCg87av5QkGfalhJMKMRl9w04duKo1d4+9bAwtbE=;
        b=tFNHOdLE22EH+eCbh25FbKR+nQ/uahU4ExTJ7R/eVdwalDHmHdJpLUHOa0ec48cXrO
         Tgxl1ZwAtkfILbLXT5p0PA1L0PUNviOInCyShnuqQ6V4PrBGWDM2PC+SQ4x20SvDIshv
         niExlCOEwckZYFpRMnMpj4l9D7FrlTCuE8FTG6vs389irzH5lm9Ud/rXGZkzkk7hGbG7
         b74s0M7FcSUi4Ln8h0Eon4y/LBFm+rh5TQunWY0qNeF3kONIqecgP2a2AKIUwEn+wbAM
         KHzd3lBFdCs9DBc48JSpc1UQ17/PXsKdwVEc6L0M08EEUg23ruMQ/Ke6DSb+t242IKpD
         HOBA==
X-Gm-Message-State: AOAM530HTMHWP0uSMWmP4ipWW1ExgvoIFEumKrf36MDqNV4gnciSfbA+
        hXN98IRHSo7ecWUaHcmtReM=
X-Google-Smtp-Source: ABdhPJyaH8zf/+f/AVMGUEGUDi+GMYmz6CgEgdZSmoo8c2v4NKlxB1biZDPsBc1c5B9mF9Wr2w1upA==
X-Received: by 2002:a17:90a:ab08:b0:1cd:34ec:c731 with SMTP id m8-20020a17090aab0800b001cd34ecc731mr21946385pjq.202.1650722518458;
        Sat, 23 Apr 2022 07:01:58 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:6001:1e2f:5400:3ff:fef5:fd57])
        by smtp.gmail.com with ESMTPSA id e6-20020a17090a77c600b001cd4989fedcsm9282071pjs.40.2022.04.23.07.01.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Apr 2022 07:01:57 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH bpf-next 3/4] bpftool: Fix incorrect return in generated detach helper
Date:   Sat, 23 Apr 2022 14:00:57 +0000
Message-Id: <20220423140058.54414-4-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220423140058.54414-1-laoar.shao@gmail.com>
References: <20220423140058.54414-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is no return value of bpf_object__detach_skeleton(), so we'd
better not return it, that is formal.

Fixes: 5dc7a8b21144 ("bpftool, selftests/bpf: Embed object file inside skeleton")
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 tools/bpf/bpftool/gen.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/bpf/bpftool/gen.c b/tools/bpf/bpftool/gen.c
index 7678af364793..8f76d8d9996c 100644
--- a/tools/bpf/bpftool/gen.c
+++ b/tools/bpf/bpftool/gen.c
@@ -1171,7 +1171,7 @@ static int do_skeleton(int argc, char **argv)
 		static inline void					    \n\
 		%1$s__detach(struct %1$s *obj)				    \n\
 		{							    \n\
-			return bpf_object__detach_skeleton(obj->skeleton);  \n\
+			bpf_object__detach_skeleton(obj->skeleton);	    \n\
 		}							    \n\
 		",
 		obj_name
-- 
2.17.1

