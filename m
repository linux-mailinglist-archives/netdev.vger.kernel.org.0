Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A0B21917CD
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 18:40:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727630AbgCXRiv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 13:38:51 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:34309 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727223AbgCXRiu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 13:38:50 -0400
Received: by mail-pg1-f195.google.com with SMTP id t3so9395995pgn.1;
        Tue, 24 Mar 2020 10:38:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=k3CEfxk16dpPoeXIJ4gQHapRgGSMbuvWPkC6OnFy/lo=;
        b=pZIZWiNTS6NiC1osiWqClGip4xTNcwQT5Ogh6khQdui9Yp/pbvPSRe03aw6Y/OtEXG
         ky7ITlKI/JPXbqDL5TeAuHwcmLQtAw1Mv2Vn5IAZLDgogrG5dmzMt0vOrTBIUYDEkGOu
         2uBmpIZRzTGR2qcTkX06DrdkdswBTkB5bJuhpfIeIAO9k2VQ3rCUFV27hgFbb37QHD4N
         Xddk++7YDUBJZvLtk2G3RpKbxBwaFbEseazCXys0QJcQ/2WWb7yKWRDFXfJjF7MFyToY
         F7csBu9F1PKCEA6bE8NQt7zF+mmVwfC29SpZahzYpl3suhnPvRDruPojs8ZU76tBD7TD
         pc0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=k3CEfxk16dpPoeXIJ4gQHapRgGSMbuvWPkC6OnFy/lo=;
        b=Cea+1E2dzNTxt2J1bZSqh+0Uw1G/rknP8Gx1dkOGcub5WMNYH3XMRXTxvTBVkilOny
         Sp8YaVIa5daaur1rHdCNseax1S5rmGCi3mupTdPt0DKRQF9vohj3fcoArhccx2wRkIvT
         YDNKeF7sLldeBtqTCJKM+1s+7LhvP8ZMxOuZJTT0rnUWe2NrdPrZZ1EfKdDrW50XzU4U
         nBVg62NzUsldY1HOfvsaV5l0NQyhqn6XD22UmmIhTPL6gmuG1y6s4V/YxjthvvekhtRb
         qIm+QWvI4SsrgIUcuWW4RrLRTGJAhxWua/lKEu67I8NocX3mqBCbJNMk90jvVidjjkfa
         /zmQ==
X-Gm-Message-State: ANhLgQ2rl3v/HXkweasdwuVKGkQ3NgNnATKARd3f/u9JecUGuKqTVcKt
        zfcTwd0HdNle8sy1BWcPJ3g=
X-Google-Smtp-Source: ADFU+vtBnHvUpgsQivZuxIpV5esK6HtLRx/vSvdoXjO4GbWtEC+fFVqNGQSb9OFHIXRSlDopktx4RA==
X-Received: by 2002:a62:fc07:: with SMTP id e7mr31479408pfh.299.1585071529668;
        Tue, 24 Mar 2020 10:38:49 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id x27sm16815505pfj.74.2020.03.24.10.38.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 24 Mar 2020 10:38:49 -0700 (PDT)
Subject: [bpf-next PATCH 03/10] bpf: verifer,
 adjust_scalar_min_max_vals to always call update_reg_bounds()
From:   John Fastabend <john.fastabend@gmail.com>
To:     ecree@solarflare.com, yhs@fb.com, alexei.starovoitov@gmail.com,
        daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com
Date:   Tue, 24 Mar 2020 10:38:37 -0700
Message-ID: <158507151689.15666.566796274289413203.stgit@john-Precision-5820-Tower>
In-Reply-To: <158507130343.15666.8018068546764556975.stgit@john-Precision-5820-Tower>
References: <158507130343.15666.8018068546764556975.stgit@john-Precision-5820-Tower>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, for all op verification we call __red_deduce_bounds() and
__red_bound_offset() but we only call __update_reg_bounds() in bitwise
ops. However, we could benefit from calling __update_reg_bounds() in
BPF_ADD, BPF_SUB, and BPF_MUL cases as well.

For example, a register with state 'R1_w=invP0' when we subtract from
it,

 w1 -= 2

Before coerce we will now have an smin_value=S64_MIN, smax_value=U64_MAX
and unsigned bounds umin_value=0, umax_value=U64_MAX. These will then
be clamped to S32_MIN, U32_MAX values by coerce in the case of alu32 op
as done in above example. However tnum will be a constant because the
ALU op is done on a constant.

Without update_reg_bounds() we have a scenario where tnum is a const
but our unsigned bounds do not reflect this. By calling update_reg_bounds
after coerce to 32bit we further refine the umin_value to U64_MAX in the
alu64 case or U32_MAX in the alu32 case above.

Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 kernel/bpf/verifier.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index f7a34b1..fea9725 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -5202,6 +5202,7 @@ static int adjust_scalar_min_max_vals(struct bpf_verifier_env *env,
 		coerce_reg_to_size(dst_reg, 4);
 	}
 
+	__update_reg_bounds(dst_reg);
 	__reg_deduce_bounds(dst_reg);
 	__reg_bound_offset(dst_reg);
 	return 0;

