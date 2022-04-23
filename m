Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EB6050CAF4
	for <lists+netdev@lfdr.de>; Sat, 23 Apr 2022 16:02:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235937AbiDWOFF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Apr 2022 10:05:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235911AbiDWOE5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Apr 2022 10:04:57 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8B0A10C;
        Sat, 23 Apr 2022 07:02:00 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id u7so1598187plg.13;
        Sat, 23 Apr 2022 07:02:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nv+zD0rHK5KxlC4ygaPSMiCd7q/JByuB/Tk+f/zok3M=;
        b=nr/P+nLlgPzIYoP/QM0K3VQ758zlvXZ3M5mvM273Wd309DXQDjYgQad+urHAR/j3Bp
         pg04tWcu7G+fqdguP/XSumKbic4BHIk8NN8P/tGVhOItiAesdWA8WFv+nOJDGp2pVLqJ
         t/PldjM6w83wx/L0fKhQsG791D9yeMZ/Vt++FNmspGQIrBvJDxUqJgLdnBYP1NXvCg6E
         RR9e4dXcYgILtcY8OC1AHulZMDQcyG11x5TSnLbEeifEL+OsZhYxD4OsHqN5f8rUSipB
         o995ibYbnF2Yr5ZoCsWys7ZXdxbO1g54pAgW63F6OzY1Xlr/HBOAOdjJL460hoF9G5bi
         rVUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nv+zD0rHK5KxlC4ygaPSMiCd7q/JByuB/Tk+f/zok3M=;
        b=yFaQMJHIy6hBqVFGcI5Ih8+RNwDfVJOh82no6ivfLBSBA5XwkEXMddlyYSWUlr8VI1
         LBBC9rrUrXuTHFWJwtpKz3hjJqCkUUNrTDxDckYWgwKQ2XKkWyopoL+X8o0ShDqdXZYU
         xqy5AmY1v8TxHceh+yUKcThbegap3EY2lksF+NzKJPbKFJQxVZDk1TfOAUHxnOd8vbPS
         M+0Nuj2L/ZYmBdxviUrGXiRofl3XygjrRb26ZY3JOlXfHQ4APBe5LUgxo70KV+eM+KK4
         lxRi5UE3/E7w6vkFLZQGmBYN+cLH6Ei+WlKz/wS35ipKBMaOXlhwdByta7PtxOfXQEWC
         gCfw==
X-Gm-Message-State: AOAM5313BtVm6wCesrTl487f1sEffEWgg8EJMpltxGL+hlF7DX7NpVej
        dGpmV11asv0y5wXvRQNzyak=
X-Google-Smtp-Source: ABdhPJwtIW6TPyGitonFzUusubkUbxLRafPOWEM+Gdq1lisjHUiYMH0pLNiOpuCFaMzft7Whq/Etfw==
X-Received: by 2002:a17:902:eb84:b0:158:8a72:bbdd with SMTP id q4-20020a170902eb8400b001588a72bbddmr9478977plg.117.1650722519743;
        Sat, 23 Apr 2022 07:01:59 -0700 (PDT)
Received: from vultr.guest ([2001:19f0:6001:1e2f:5400:3ff:fef5:fd57])
        by smtp.gmail.com with ESMTPSA id e6-20020a17090a77c600b001cd4989fedcsm9282071pjs.40.2022.04.23.07.01.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Apr 2022 07:01:59 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH bpf-next 4/4] bpftool: Generate helpers for pinning prog through bpf object skeleton
Date:   Sat, 23 Apr 2022 14:00:58 +0000
Message-Id: <20220423140058.54414-5-laoar.shao@gmail.com>
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

After this change, with command 'bpftool gen skeleton XXX.bpf.o', the
helpers for pinning BPF prog will be generated in BPF object skeleton. It
could simplify userspace code which wants to pin bpf progs in bpffs.

The new helpers are named with __{pin, unpin}_prog, because it only pins
bpf progs. If the user also wants to pin bpf maps in bpffs, he can use
LIBBPF_PIN_BY_NAME.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 tools/bpf/bpftool/gen.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/tools/bpf/bpftool/gen.c b/tools/bpf/bpftool/gen.c
index 8f76d8d9996c..1d06ebde723b 100644
--- a/tools/bpf/bpftool/gen.c
+++ b/tools/bpf/bpftool/gen.c
@@ -1087,6 +1087,8 @@ static int do_skeleton(int argc, char **argv)
 			static inline int load(struct %1$s *skel);	    \n\
 			static inline int attach(struct %1$s *skel);	    \n\
 			static inline void detach(struct %1$s *skel);	    \n\
+			static inline int pin_prog(struct %1$s *skel, const char *path);\n\
+			static inline void unpin_prog(struct %1$s *skel);   \n\
 			static inline void destroy(struct %1$s *skel);	    \n\
 			static inline const void *elf_bytes(size_t *sz);    \n\
 		#endif /* __cplusplus */				    \n\
@@ -1172,6 +1174,18 @@ static int do_skeleton(int argc, char **argv)
 		%1$s__detach(struct %1$s *obj)				    \n\
 		{							    \n\
 			bpf_object__detach_skeleton(obj->skeleton);	    \n\
+		}							    \n\
+									    \n\
+		static inline int					    \n\
+		%1$s__pin_prog(struct %1$s *obj, const char *path)	    \n\
+		{							    \n\
+			return bpf_object__pin_skeleton_prog(obj->skeleton, path);\n\
+		}							    \n\
+									    \n\
+		static inline void					    \n\
+		%1$s__unpin_prog(struct %1$s *obj)			    \n\
+		{							    \n\
+			bpf_object__unpin_skeleton_prog(obj->skeleton);	    \n\
 		}							    \n\
 		",
 		obj_name
@@ -1237,6 +1251,8 @@ static int do_skeleton(int argc, char **argv)
 		int %1$s::load(struct %1$s *skel) { return %1$s__load(skel); }		\n\
 		int %1$s::attach(struct %1$s *skel) { return %1$s__attach(skel); }	\n\
 		void %1$s::detach(struct %1$s *skel) { %1$s__detach(skel); }		\n\
+		int %1$s::pin_prog(struct %1$s *skel, const char *path) { return %1$s__pin_prog(skel, path); }\n\
+		void %1$s::unpin_prog(struct %1$s *skel) { %1$s__unpin_prog(skel); }	\n\
 		void %1$s::destroy(struct %1$s *skel) { %1$s__destroy(skel); }		\n\
 		const void *%1$s::elf_bytes(size_t *sz) { return %1$s__elf_bytes(sz); } \n\
 		#endif /* __cplusplus */				    \n\
-- 
2.17.1

