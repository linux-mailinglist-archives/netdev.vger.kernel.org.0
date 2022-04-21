Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA7EA509473
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 02:58:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383514AbiDUAog (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 20:44:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383512AbiDUAmW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 20:42:22 -0400
Received: from mail-4316.protonmail.ch (mail-4316.protonmail.ch [185.70.43.16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FC0627B23;
        Wed, 20 Apr 2022 17:39:34 -0700 (PDT)
Date:   Thu, 21 Apr 2022 00:39:27 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
        s=protonmail2; t=1650501572;
        bh=v6gaFkC1lQ5OvOGA5jP895MtmOBP8Tdf6LrASizShuo=;
        h=Date:To:From:Cc:Reply-To:Subject:Message-ID:In-Reply-To:
         References:Feedback-ID:From:To:Cc:Date:Subject:Reply-To:
         Feedback-ID:Message-ID;
        b=PFdTuOoCFpxSp4uLdYHgSLDaZVZwi7hatwlWmCfdP56Da7ptv/UBE8hO/VLSl1xAn
         lOkh92ooqW1lM/YySkpa4nxE/nsmnRPHmkW/Rhd1ZuDTDvT2o5k0hmI+E1/DsA+O7O
         TDyzviRTM4/nByU25Ar99spr1lC7wo7phHzCAeKvcKcgpNBojGFUJqhalRb0WyzN6l
         oIRGiLBv5xH0tkPZJxCTDur070BWsA3iRt0dAYOOwnHlItFmjiGlkAbG5h7KcS05nB
         zkV9ViBIHO//ZKcyS+V2Q7NsHosR/zRyXrk/0VNx9rggxhcHxfwXC6BRowRIcFARbS
         mezfQjhZThggg==
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Alexander Lobakin <alobakin@pm.me>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Song Liu <songliubraving@fb.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH v2 bpf 06/11] samples/bpf: use host bpftool to generate vmlinux.h, not target
Message-ID: <20220421003152.339542-7-alobakin@pm.me>
In-Reply-To: <20220421003152.339542-1-alobakin@pm.me>
References: <20220421003152.339542-1-alobakin@pm.me>
Feedback-ID: 22809121:user:proton
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the host build of bpftool (bootstrap) instead of the target one
to generate vmlinux.h/skeletons for the BPF samples. Otherwise, when
host !=3D target, samples compilation fails with:

/bin/sh: line 1: samples/bpf/bpftool/bpftool: failed to exec: Exec
format error

Fixes: 384b6b3bbf0d ("samples: bpf: Add vmlinux.h generation support")
Acked-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Acked-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 samples/bpf/Makefile | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index 70323ac1114f..2bb9088a8d91 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -291,12 +291,13 @@ $(LIBBPF): $(wildcard $(LIBBPF_SRC)/*.[ch] $(LIBBPF_S=
RC)/Makefile) | $(LIBBPF_OU

 BPFTOOLDIR :=3D $(TOOLS_PATH)/bpf/bpftool
 BPFTOOL_OUTPUT :=3D $(abspath $(BPF_SAMPLES_PATH))/bpftool
-BPFTOOL :=3D $(BPFTOOL_OUTPUT)/bpftool
+BPFTOOL :=3D $(BPFTOOL_OUTPUT)/bootstrap/bpftool
 $(BPFTOOL): $(LIBBPF) $(wildcard $(BPFTOOLDIR)/*.[ch] $(BPFTOOLDIR)/Makefi=
le) | $(BPFTOOL_OUTPUT)
 =09    $(MAKE) -C $(BPFTOOLDIR) srctree=3D$(BPF_SAMPLES_PATH)/../../ \
 =09=09OUTPUT=3D$(BPFTOOL_OUTPUT)/ \
 =09=09LIBBPF_OUTPUT=3D$(LIBBPF_OUTPUT)/ \
-=09=09LIBBPF_DESTDIR=3D$(LIBBPF_DESTDIR)/
+=09=09LIBBPF_DESTDIR=3D$(LIBBPF_DESTDIR)/ \
+=09=09bootstrap

 $(LIBBPF_OUTPUT) $(BPFTOOL_OUTPUT):
 =09$(call msg,MKDIR,$@)
--
2.36.0


