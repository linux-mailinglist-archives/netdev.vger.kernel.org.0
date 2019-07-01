Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8AFA2A14A
	for <lists+netdev@lfdr.de>; Sat, 25 May 2019 00:28:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404523AbfEXW2I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 18:28:08 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:44774 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404398AbfEXW10 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 18:27:26 -0400
Received: by mail-wr1-f65.google.com with SMTP id w13so3023872wru.11
        for <netdev@vger.kernel.org>; Fri, 24 May 2019 15:27:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=US70ctyVgh5ZhQm+sb5H0syPlHMSWIxsmSGMyVGS7A4=;
        b=ZZ/ik6N89EWclWocMkVm/HyM8wUl8xdhNYDEr6kLUVHDVrBM9bBJksPrzc4mu6TEAF
         Ide0FoVBvIqq6FBXiZaX081rPnXYOXeHy5RPGFnS93srK8ETqzBS6gHvm69WqCX8fQrw
         EruQdIxwnVp1dSWEqnTNbZ3AE3u0kDwj2k+/jsLognTeVR59FXCZXScvqyU0MezBv4CQ
         lWsqW+fSW3WJcl1anVDFuVbXzpDuEDwEg7I+cAxtJPUYHgcKxiRVebq4/diAffbXe7NB
         +cBzDgspnPErh7W8JMVY6OuurT5EyMjgsYq5qViUct7/FfYgA31ezSStmm44LbSjo2Pz
         78QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=US70ctyVgh5ZhQm+sb5H0syPlHMSWIxsmSGMyVGS7A4=;
        b=KS5PmqT2ibDLeZZo6Qa77l9TZ6JPfjUYNeLv0P5a3sljyL3HEZMghINgh7dWOrlzmV
         D/gfy2Xc5RqWPqwfqUzgwFwQgnkKPFqDFoDUZQ+1Ml0Phf+L6dRLlW5/3ngR0voxLBTj
         uMUpo6sIDx7LzfTU3k28bPxgTLiBHQ+FCJLaeQYoZxLXGFqrOwxuXMePWTI1uuMirH8U
         b3bStmqtZlJ8ZMPlYihAzbebSVNfUxuT0Ji+UfAC6XWfr+5TSRSBKTW6vnzm6zsG7ERJ
         zH1Wk392bMpZ150+bpW1fWUl/je2SljQcHNv7z3Eqnjz2kFoCWqk+B1iCsN+ptQajaLi
         18WQ==
X-Gm-Message-State: APjAAAW5/ilWF/3/Z6hFLWy691BlT6HjXSjdCUtVKdtc8QnS45n3lsTD
        ecBgeMcaAr9a23bufxV8ZTPOFg==
X-Google-Smtp-Source: APXvYqznCWa9DLMOFhnqD/EKm+JHPTNWz6UQ3FV/BzM7l5OSH0nfVmJX/RDEHyPH/0gHEBtlzvnlfw==
X-Received: by 2002:adf:dc84:: with SMTP id r4mr7313896wrj.85.1558736844626;
        Fri, 24 May 2019 15:27:24 -0700 (PDT)
Received: from cbtest28.netronome.com ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id y10sm7194961wmg.8.2019.05.24.15.27.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 24 May 2019 15:27:23 -0700 (PDT)
From:   Jiong Wang <jiong.wang@netronome.com>
To:     alexei.starovoitov@gmail.com, daniel@iogearbox.net
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com, davem@davemloft.net,
        paul.burton@mips.com, udknight@gmail.com, zlim.lnx@gmail.com,
        illusionist.neo@gmail.com, naveen.n.rao@linux.ibm.com,
        sandipan@linux.ibm.com, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, jakub.kicinski@netronome.com,
        Jiong Wang <jiong.wang@netronome.com>
Subject: [PATCH v9 bpf-next 03/17] bpf: introduce new mov32 variant for doing explicit zero extension
Date:   Fri, 24 May 2019 23:25:14 +0100
Message-Id: <1558736728-7229-4-git-send-email-jiong.wang@netronome.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1558736728-7229-1-git-send-email-jiong.wang@netronome.com>
References: <1558736728-7229-1-git-send-email-jiong.wang@netronome.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The encoding for this new variant is based on BPF_X format. "imm" field was
0 only, now it could be 1 which means doing zero extension unconditionally

  .code = BPF_ALU | BPF_MOV | BPF_X
  .dst_reg = DST
  .src_reg = SRC
  .imm  = 1

We use this new form for doing zero extension for which verifier will
guarantee SRC == DST.

Implications on JIT back-ends when doing code-gen for
BPF_ALU | BPF_MOV | BPF_X:
  1. No change if hardware already does zero extension unconditionally for
     sub-register write.
  2. Otherwise, when seeing imm == 1, just generate insns to clear high
     32-bit. No need to generate insns for the move because when imm == 1,
     dst_reg is the same as src_reg at the moment.

Interpreter doesn't need change as well. It is doing unconditionally zero
extension for mov32 already.

One helper macro BPF_ZEXT_REG is added to help creating zero extension
insn using this new mov32 variant.

One helper function insn_is_zext is added for checking one insn is an
zero extension on dst. This will be widely used by a few JIT back-ends in
later patches in this set.

Signed-off-by: Jiong Wang <jiong.wang@netronome.com>
---
 include/linux/filter.h | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/include/linux/filter.h b/include/linux/filter.h
index 7148bab..bb10ffb 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -160,6 +160,20 @@ struct ctl_table_header;
 		.off   = 0,					\
 		.imm   = IMM })
 
+/* Special form of mov32, used for doing explicit zero extension on dst. */
+#define BPF_ZEXT_REG(DST)					\
+	((struct bpf_insn) {					\
+		.code  = BPF_ALU | BPF_MOV | BPF_X,		\
+		.dst_reg = DST,					\
+		.src_reg = DST,					\
+		.off   = 0,					\
+		.imm   = 1 })
+
+static inline bool insn_is_zext(const struct bpf_insn *insn)
+{
+	return insn->code == (BPF_ALU | BPF_MOV | BPF_X) && insn->imm == 1;
+}
+
 /* BPF_LD_IMM64 macro encodes single 'load 64-bit immediate' insn */
 #define BPF_LD_IMM64(DST, IMM)					\
 	BPF_LD_IMM64_RAW(DST, 0, IMM)
-- 
2.7.4

