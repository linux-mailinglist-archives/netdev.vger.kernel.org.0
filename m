Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 897002DFB2
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 16:26:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726512AbfE2O0w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 10:26:52 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:34483 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726118AbfE2O0v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 10:26:51 -0400
Received: by mail-wm1-f67.google.com with SMTP id e19so4412731wme.1
        for <netdev@vger.kernel.org>; Wed, 29 May 2019 07:26:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=NMzeE1KzUBulhguvNgyxSJ0OYCTDWlYGLYa5mcjyET4=;
        b=y64Hqqnqq6S5FIt+9NfS8B7uicKFOzWP5oQLX+cn90tY1NGdqFSoyZjhUerF1uydXJ
         fyYnHui6S6p3m+2OHmiZh9CaLX6m1oQu+STyPHL2AuQG2tQ1IB0s5YDO9AeX+Rb0SQZv
         ouVTKGKdbAX1ZnsHvUZJRicgr0v8C1WZ/CDzXF3IouLBOSz6ACgU8/znau0MFgcloyIp
         VVW0Sr/JISsT4CQHjAhaD+PEoc03k9QZU/flK0mjYmQXLMVbxxJszwFtRGheE/wdS/HT
         LG9ulym/kN1SV8lqhizWZaQMzG/0naGiMKX8GFxs1JqUsDG9lTVQocvS1DHzzFBnyGBP
         VrtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=NMzeE1KzUBulhguvNgyxSJ0OYCTDWlYGLYa5mcjyET4=;
        b=Jz1xqNLQyXQ8tJV3Oc2mOX0No+0dbXCzXkjBs0Ik7SiQbhQcsvR5NRe+2I5B3FfNhn
         UA6M5K5KTvFP/jxIHxVJs9q03D9uysVI51HG1xXKx09W38F73V8nIFGz0O/GnfNRbb17
         DH+ZiRqeeMS/jRRxUVnm8sxf1/NZ3RDQFS5XQrTzHEdDuOLX/quHN5jWpepKtBvYZhCX
         yZrkxKfAIj6YWbqcl5KtpWbuHs9YvEGHyNmvDWPr8U1BHTBBFP5LPws/6EeFxtiYh+Qs
         56sysDA0TUKLFe0tD5VKQugm46YLRDD6wyIrhCtfaIeP1z/I/DGjEzG40uZ+1Yf/mOdu
         A/og==
X-Gm-Message-State: APjAAAUQSmEqpEM6UConuB/fbRtJRlhcxqDECgf6KU8f0SJA+bVn6yCm
        8kTJn73rIZHug4z6z7ScjEz9AA==
X-Google-Smtp-Source: APXvYqxyesYvpFgTjKaPSSM1PttadaG3RZ70h99uPPznlndkmtdh2qZyiKXb6iTM6X7KPLZNlR6MtA==
X-Received: by 2002:a1c:7216:: with SMTP id n22mr7302482wmc.111.1559140009433;
        Wed, 29 May 2019 07:26:49 -0700 (PDT)
Received: from cbtest32.netronome.com ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id a124sm8671263wmh.3.2019.05.29.07.26.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 29 May 2019 07:26:48 -0700 (PDT)
From:   Quentin Monnet <quentin.monnet@netronome.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com,
        Quentin Monnet <quentin.monnet@netronome.com>
Subject: [PATCH bpf-next v2] libbpf: prevent overwriting of log_level in bpf_object__load_progs()
Date:   Wed, 29 May 2019 15:26:41 +0100
Message-Id: <20190529142641.888-1-quentin.monnet@netronome.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are two functions in libbpf that support passing a log_level
parameter for the verifier for loading programs:
bpf_object__load_xattr() and bpf_prog_load_xattr(). Both accept an
attribute object containing the log_level, and apply it to the programs
to load.

It turns out that to effectively load the programs, the latter function
eventually relies on the former. This was not taken into account when
adding support for log_level in bpf_object__load_xattr(), and the
log_level passed to bpf_prog_load_xattr() later gets overwritten with a
zero value, thus disabling verifier logs for the program in all cases:

bpf_prog_load_xattr()             // prog->log_level = attr1->log_level;
-> bpf_object__load()             // attr2->log_level = 0;
   -> bpf_object__load_xattr()    // <pass prog and attr2>
      -> bpf_object__load_progs() // prog->log_level = attr2->log_level;

Fix this by OR-ing the log_level in bpf_object__load_progs(), instead of
overwriting it.

v2: Fix commit log description (confusion on function names in v1).

Fixes: 60276f984998 ("libbpf: add bpf_object__load_xattr() API function to pass log_level")
Reported-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Quentin Monnet <quentin.monnet@netronome.com>
---
 tools/lib/bpf/libbpf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index ca4432f5b067..30cb08e2eb75 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -2232,7 +2232,7 @@ bpf_object__load_progs(struct bpf_object *obj, int log_level)
 	for (i = 0; i < obj->nr_programs; i++) {
 		if (bpf_program__is_function_storage(&obj->programs[i], obj))
 			continue;
-		obj->programs[i].log_level = log_level;
+		obj->programs[i].log_level |= log_level;
 		err = bpf_program__load(&obj->programs[i],
 					obj->license,
 					obj->kern_version);
-- 
2.17.1

