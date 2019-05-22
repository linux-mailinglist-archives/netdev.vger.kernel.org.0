Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56C0926A2F
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 20:55:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729676AbfEVSzy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 14:55:54 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:41232 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728533AbfEVSzy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 14:55:54 -0400
Received: by mail-wr1-f67.google.com with SMTP id g12so80938wro.8
        for <netdev@vger.kernel.org>; Wed, 22 May 2019 11:55:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=US70ctyVgh5ZhQm+sb5H0syPlHMSWIxsmSGMyVGS7A4=;
        b=ugMxHAElW8YYpn4MsEFuK+I8btrlNfsR31LyPdYcdeSIpPdK7Ughp5SN/C3PDjbm9x
         oOfDNpPRvPXZQ2/unzF78fzwlMNJTDo7cln4YGZzElECu3A8KXsiSDihY66Cka52opyw
         05G3LvkEev1vIO42nPsVCWetT4I6gBKleMi3F412slnER9gGwfhndNvb5qZGrF29i0Z0
         MLklbJWvz9DnCTCyN3MV4QSVsUivWvoZiSKKm46L3teT3sHK4aiGwsAD4+kjOBemAeMr
         g0ZawRSP65et8THhP8V3s/1uKkIYOWgVhRXGp/h8dAyVSjFaPZIfaAritsFoS9UIogO6
         K+/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=US70ctyVgh5ZhQm+sb5H0syPlHMSWIxsmSGMyVGS7A4=;
        b=QSJKNi/cCmkSC/RDlNSOYBMPPB1LLU3VFQzj61Cdf5BtDwvSQyaPsnMP5lp4X1g1fm
         QZLhGBZxMfTd20Kstm1f76fxaSuOUanFJDoIB+PniVh74OO6IBiIu8daksLC1LSBVJgD
         ePe5APWLS19bglGFoLku4RWbaxeIISjEG+hoBOcqUt93rhVdGUwyQAWJzEB4n6l7WtYb
         cYxhVYUfQFGjHLq4wQr1EoS3KNWCNBGUJkvFGX0U09V0sTTNlcwGJp9PsgwEP4qgeRs2
         MrB0jYjggQ/z5e94We/WmtKmFb/b7E+BJLIKn8NFZVT6vM/WdCzdAiCxHk6++4JiREol
         2ZBw==
X-Gm-Message-State: APjAAAVTCReJYs5ixqdjJerfjFqXVngjwDUgBeTnt+3wLGIDlXHXkZIc
        DLZw5p6eJmgk9xIE4WzbBjlTgA==
X-Google-Smtp-Source: APXvYqyTF3UwEUnRZ2zGnpZH+GH4uJiTusVWscqsnpuIvu58nmhN0+RNzJTU+0Z2TxbUtiNECe8JDA==
X-Received: by 2002:a5d:4d51:: with SMTP id a17mr23198060wru.260.1558551352672;
        Wed, 22 May 2019 11:55:52 -0700 (PDT)
Received: from cbtest28.netronome.com ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id t12sm16328801wro.2.2019.05.22.11.55.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 22 May 2019 11:55:51 -0700 (PDT)
From:   Jiong Wang <jiong.wang@netronome.com>
To:     alexei.starovoitov@gmail.com, daniel@iogearbox.net
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com, davem@davemloft.net,
        paul.burton@mips.com, udknight@gmail.com, zlim.lnx@gmail.com,
        illusionist.neo@gmail.com, naveen.n.rao@linux.ibm.com,
        sandipan@linux.ibm.com, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, jakub.kicinski@netronome.com,
        Jiong Wang <jiong.wang@netronome.com>
Subject: [PATCH v7 bpf-next 03/16] bpf: introduce new mov32 variant for doing explicit zero extension
Date:   Wed, 22 May 2019 19:54:59 +0100
Message-Id: <1558551312-17081-4-git-send-email-jiong.wang@netronome.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1558551312-17081-1-git-send-email-jiong.wang@netronome.com>
References: <1558551312-17081-1-git-send-email-jiong.wang@netronome.com>
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

