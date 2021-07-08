Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EBD63BF378
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 03:18:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230295AbhGHBVf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 21:21:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230317AbhGHBVc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 21:21:32 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBC4BC061768;
        Wed,  7 Jul 2021 18:18:49 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id s18so4216832pgg.8;
        Wed, 07 Jul 2021 18:18:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=PDnPozsiQEH5D0xDZSajlCyRC9yDJg8xI1V4UhI3dBY=;
        b=OFOTdE7Yy+IXCcC8PqOoSMeW03emeQB/2lFfTZgm4MpIW81f+HJ+/C2LTN1ZWkPfZ4
         67Y0rJbTUulFVLwKkfy3eiuI4nQdeHxddAaeHvrNMtv2kB645X8qOKh5FwJWF97oH5gq
         PIImnFnk1ZzL6YEb+JRg2rE1yqcWnS3nlfx6Lh6lBX0mbI4IJ7UZbWuQPbNqajUY2fty
         JLipQRLFsmMiLs8pPmym0bV5eosBQ8MxNpElmZMWGDlABk7MmmiabWVrmCGSv4r61iHO
         cfKHBq8Kcntjmp6DQ9Spi3dd5aa4k1MZsZL5HtnBcKDeMpzzkLDoRczJc3Y+HZaQ/+Vi
         gDsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=PDnPozsiQEH5D0xDZSajlCyRC9yDJg8xI1V4UhI3dBY=;
        b=VckkYlMD8onFdpym0LGaRWSTV6dRiRCcer1+Ox9bmIidYfs/FwxLWA1tIMLza4E3D/
         ZeNdON6DrcnJYdHoOY9NnUPALx65UxIAt3OKXtMuMAqLO6WeX5VmgVljwz0w3NfY4Pzy
         OB2U6gq0rL20ffKhKLQM3WOQZ8OM1x87cZoSgGvkSZUtCBTnANs3junjSEVEvgbOTUIn
         iHVNx+rApOiBChMvY9myPJI1XJ1BSgFxuXg0JqmKYWtJtywx4JXiN7z384nmLiziUlYS
         uIlunlQFrbyZU0TD1zf77oGK+g8GuiHEQ0ocX/I9GpVXjFpW3yaeK4WlXgHh3GD1F/To
         hiew==
X-Gm-Message-State: AOAM531w6oDKM9kjphDbOsxfUqm7euNVgP+J5eSxEipGtxbeSOsIh0Nw
        4sU6SvyzvA4sLBxe71LxXi8=
X-Google-Smtp-Source: ABdhPJyoNua+iudouW4Ab1EYIclehUZOXqnDVEAMQhNCE0Af3yx865NAGrt0kPVsxAcyUSChilK/IA==
X-Received: by 2002:a63:43c4:: with SMTP id q187mr28769160pga.172.1625707129230;
        Wed, 07 Jul 2021 18:18:49 -0700 (PDT)
Received: from ast-mbp.thefacebook.com ([2620:10d:c090:400::5:9f4e])
        by smtp.gmail.com with ESMTPSA id d20sm417450pfn.219.2021.07.07.18.18.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 07 Jul 2021 18:18:48 -0700 (PDT)
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     davem@davemloft.net
Cc:     daniel@iogearbox.net, andrii@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v5 bpf-next 07/11] bpf: Relax verifier recursion check.
Date:   Wed,  7 Jul 2021 18:18:29 -0700
Message-Id: <20210708011833.67028-8-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.13.5
In-Reply-To: <20210708011833.67028-1-alexei.starovoitov@gmail.com>
References: <20210708011833.67028-1-alexei.starovoitov@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

In the following bpf subprogram:
static int timer_cb(void *map, void *key, void *value)
{
    bpf_timer_set_callback(.., timer_cb);
}

the 'timer_cb' is a pointer to a function.
ld_imm64 insn is used to carry this pointer.
bpf_pseudo_func() returns true for such ld_imm64 insn.

Unlike bpf_for_each_map_elem() the bpf_timer_set_callback() is asynchronous.
Relax control flow check to allow such "recursion" that is seen as an infinite
loop by check_cfg(). The distinction between bpf_for_each_map_elem() the
bpf_timer_set_callback() is done in the follow up patch.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 kernel/bpf/verifier.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index cb393de3c818..1511f92b4cf4 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -9463,8 +9463,12 @@ static int visit_func_call_insn(int t, int insn_cnt,
 		init_explored_state(env, t + 1);
 	if (visit_callee) {
 		init_explored_state(env, t);
-		ret = push_insn(t, t + insns[t].imm + 1, BRANCH,
-				env, false);
+		ret = push_insn(t, t + insns[t].imm + 1, BRANCH, env,
+				/* It's ok to allow recursion from CFG point of
+				 * view. __check_func_call() will do the actual
+				 * check.
+				 */
+				bpf_pseudo_func(insns + t));
 	}
 	return ret;
 }
-- 
2.30.2

