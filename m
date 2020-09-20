Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDBE827127A
	for <lists+netdev@lfdr.de>; Sun, 20 Sep 2020 07:02:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726943AbgITFCJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Sep 2020 01:02:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726760AbgITFCI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Sep 2020 01:02:08 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64946C061755;
        Sat, 19 Sep 2020 22:02:08 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id b17so5219723pji.1;
        Sat, 19 Sep 2020 22:02:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VVuA7I40ahfUSFUhF/rh76ojr9Knrl+A3vaZY0vD+mA=;
        b=RtxpiOKSLr1NSy3ffy2+RruORNC2xkcNG3fz5n9HxaLj0Mb5ih7x7TRziM1EYyPuPZ
         yp1pNewgL99sSf5PDa4dNpIjnheAYLpa8F9xRnYmYyCU2efLXSTZpCqX74mxjkOeCXnZ
         HQCdSWp/Am3SK5EoIA1LlEoVK7ofClZp4NgofTRYy52JlLTE6534vX+hi5WH45Lc4QBs
         Hqfezf9TzgX0GIskuG72ouM08jtsw2UsydZz3mXrcQwT3kN/IB6CKWIm+k6LDuz2XMUQ
         O1GYJa9vZTK/gEp4QHl/PUIj7UCpWY2vNlR+x9t8wqOlxo6utGKyqRMu++KGsq2iiymn
         or/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VVuA7I40ahfUSFUhF/rh76ojr9Knrl+A3vaZY0vD+mA=;
        b=FNyx5UmJlG1yIStSjF+ddgilmlOibtveNbtETn70ZhK42o5DPE3qqsINYT39HPTM4b
         rD2xrYaLVolkA42D/yKqRj6/NmR2eFCLg9WHV2RiTfyzIYy8dXFiAOa3tWUnPWInwXZi
         cTUxHsByxH7d2uZ43VQKR/a8Tc3OlfIHnBGVHtnPqoT1QAIEPISCn+N0jSjzctwseMky
         +VcXe2AqqdSKUFz5zKzusru+2aZ53qnhjhwR9VqZTGzXiV5KXNV2r+w7nbufqI20Qv25
         rmQzCKlvF3OY6uRvd6H96G5WPQ86hQyLLjpPAXqnEVneB7yvGmFaEGt1tR65VdGIF49j
         jyqg==
X-Gm-Message-State: AOAM532/MXJqX7JiEvWNIz3WMn+MyBk15TGL7DyJEbrByd2193BkQuBU
        l9IEBZUhgTEJ99AXbXlNhBA=
X-Google-Smtp-Source: ABdhPJw5qgPMIAPvD2E0wCa/1tGvhtBbZnlZsoCPVIAeOynYj3mgr10coUuwlKAJsvf7M3syWO2i3w==
X-Received: by 2002:a17:90a:ab8f:: with SMTP id n15mr19257434pjq.139.1600578128006;
        Sat, 19 Sep 2020 22:02:08 -0700 (PDT)
Received: from localhost.localdomain ([2001:470:e92d:10:d88d:3b4f:9cac:cf18])
        by smtp.gmail.com with ESMTPSA id w19sm8432556pfq.60.2020.09.19.22.02.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Sep 2020 22:02:07 -0700 (PDT)
From:   Tony Ambardar <tony.ambardar@gmail.com>
X-Google-Original-From: Tony Ambardar <Tony.Ambardar@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Tony Ambardar <Tony.Ambardar@gmail.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-arch@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH bpf v1 2/3] bpf: prevent .BTF section elimination
Date:   Sat, 19 Sep 2020 22:01:34 -0700
Message-Id: <a635b5d3e2da044e7b51ec1315e8910fbce0083f.1600417359.git.Tony.Ambardar@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1600417359.git.Tony.Ambardar@gmail.com>
References: <cover.1600417359.git.Tony.Ambardar@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Systems with memory or disk constraints often reduce the kernel footprint
by configuring LD_DEAD_CODE_DATA_ELIMINATION. However, this can result in
removal of any BTF information.

Use the KEEP() macro to preserve the BTF data as done with other important
sections, while still allowing for smaller kernels.

Fixes: 90ceddcb4950 ("bpf: Support llvm-objcopy for vmlinux BTF")

Signed-off-by: Tony Ambardar <Tony.Ambardar@gmail.com>
---
 include/asm-generic/vmlinux.lds.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 5430febd34be..7636bc71c71f 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -661,7 +661,7 @@
 #define BTF								\
 	.BTF : AT(ADDR(.BTF) - LOAD_OFFSET) {				\
 		__start_BTF = .;					\
-		*(.BTF)							\
+		KEEP(*(.BTF))						\
 		__stop_BTF = .;						\
 	}								\
 	. = ALIGN(4);							\
-- 
2.25.1

