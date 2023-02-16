Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D55C69A015
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 23:56:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229448AbjBPW4U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 17:56:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbjBPW4S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 17:56:18 -0500
Received: from 66-220-144-178.mail-mxout.facebook.com (66-220-144-178.mail-mxout.facebook.com [66.220.144.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD3E43A860
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 14:56:17 -0800 (PST)
Received: by devvm15675.prn0.facebook.com (Postfix, from userid 115148)
        id 57FCB6A5C815; Thu, 16 Feb 2023 14:56:05 -0800 (PST)
From:   Joanne Koong <joannelkoong@gmail.com>
To:     bpf@vger.kernel.org
Cc:     martin.lau@kernel.org, andrii@kernel.org, memxor@gmail.com,
        ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        kernel-team@fb.com, Joanne Koong <joannelkoong@gmail.com>
Subject: [PATCH v10 bpf-next 1/9] bpf: Support "sk_buff" and "xdp_buff" as valid kfunc arg types
Date:   Thu, 16 Feb 2023 14:55:16 -0800
Message-Id: <20230216225524.1192789-2-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230216225524.1192789-1-joannelkoong@gmail.com>
References: <20230216225524.1192789-1-joannelkoong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=1.6 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FROM,HELO_MISC_IP,NML_ADSP_CUSTOM_MED,
        RDNS_DYNAMIC,SPF_HELO_PASS,SPF_SOFTFAIL,TVD_RCVD_IP autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The bpf mirror of the in-kernel sk_buff and xdp_buff data structures are
__sk_buff and xdp_md. Currently, when we pass in the program ctx to a
kfunc where the program ctx is a skb or xdp buffer, we reject the
program if the in-kernel definition is sk_buff/xdp_buff instead of
__sk_buff/xdp_md.

This change allows "sk_buff <--> __sk_buff" and "xdp_buff <--> xdp_md"
to be recognized as valid matches. The user program may pass in their
program ctx as a __sk_buff or xdp_md, and the in-kernel definition
of the kfunc may define this arg as a sk_buff or xdp_buff.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 kernel/bpf/btf.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 6582735ef1fc..ae321c358699 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -5675,6 +5675,10 @@ btf_get_prog_ctx_type(struct bpf_verifier_log *log=
, const struct btf *btf,
 		bpf_log(log, "Please fix kernel include/linux/bpf_types.h\n");
 		return NULL;
 	}
+	if (strcmp(ctx_tname, "__sk_buff") =3D=3D 0 && strcmp(tname, "sk_buff")=
 =3D=3D 0)
+		return ctx_type;
+	if (strcmp(ctx_tname, "xdp_md") =3D=3D 0 && strcmp(tname, "xdp_buff") =3D=
=3D 0)
+		return ctx_type;
 	/* only compare that prog's ctx type name is the same as
 	 * kernel expects. No need to compare field by field.
 	 * It's ok for bpf prog to do:
--=20
2.30.2

