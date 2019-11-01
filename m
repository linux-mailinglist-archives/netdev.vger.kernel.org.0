Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF7C1EC184
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 12:04:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730225AbfKALER (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 07:04:17 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:46117 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729855AbfKALEQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 07:04:16 -0400
Received: by mail-pl1-f196.google.com with SMTP id q21so4193757plr.13;
        Fri, 01 Nov 2019 04:04:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vpL6A9iSpaiVu9K/Ydykbbj+FJTOWF+NCihHj3G48Fg=;
        b=PugDTr4gbcC43ga1VZ6V8lfKcyNivv/gwFWWISYdKB94J1wMfghpoR8EJvxUYCAAxx
         K/1sNQU7unnOX6zhxWALhvs2PbH+X1I0ZAraAiXubWdA1REbSE5Y69j11h37Z0hPoomY
         kErYiYnJ8s9XJk3+f8jH5Mq7+4WhireKiA5FEPi+1H1tt9f3cEHsOrUgSXgvBgOyGSxc
         MBRIDTdDBstul1mOReN7vziOpW5y766DmcnyhcQL/JWZp1LWwT5SxnowKGhyQJktsZss
         eaQlj4E/gfQhBDjGAv9CgC5iK06uPgRwyK69aT5bog/i+n8gvkW/kiEjs3z4XfNKMuEZ
         Y3xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vpL6A9iSpaiVu9K/Ydykbbj+FJTOWF+NCihHj3G48Fg=;
        b=iO8AAUlkWmxg/Zkr9MoyXH88MYRo+IgSblpNUJ91GS18/TLHB6+7we1ahBjx3kqVxC
         P1YqOEWfJODTHBo87HVqV37AH+B3gXRvkXE+e5bwueF7Z3ImWrWZS/bs7jod7OJ70IBl
         OwcN1IFxKmULy/T9eIL/aUXUqBlq0gmOZUy8vk3MxY0HbNFblVNujiSO5VVdeRj34CK2
         1BrC/95PUum3dvWlXzFA2LWz9k/4BDPLXuKze/OltlGaGc0QneN9434yD5kuJmChMIT3
         mZLA0uwY6D/t439Fc0rMHDaz9CpFq6dmWAXx8iWXPwNNI69Ce3S+6nUz4imjtKdPNL8x
         /Meg==
X-Gm-Message-State: APjAAAUyKFneBGm1R5DMxrPIyKhoNcpvEXOMeASf9ulWb+EtNZfKBKcG
        d8mB+K3TegDE0V8cRo/IjMaC47ba1yBcVw==
X-Google-Smtp-Source: APXvYqwxi00fTZvgyVME31PXNOehI/GzNS4cLfdYWQq+qgV76mkiahqO5tBkq9+NbuJSAdjs77GfwQ==
X-Received: by 2002:a17:902:8c8e:: with SMTP id t14mr11844165plo.334.1572606255848;
        Fri, 01 Nov 2019 04:04:15 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com (jfdmzpr04-ext.jf.intel.com. [134.134.137.73])
        by smtp.gmail.com with ESMTPSA id c6sm6939767pfj.59.2019.11.01.04.04.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Nov 2019 04:04:15 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        jakub.kicinski@netronome.com
Cc:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        bpf@vger.kernel.org, magnus.karlsson@gmail.com,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        toke@redhat.com
Subject: [PATCH bpf-next v5 2/3] bpf: implement map_gen_lookup() callback for XSKMAP
Date:   Fri,  1 Nov 2019 12:03:45 +0100
Message-Id: <20191101110346.15004-3-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191101110346.15004-1-bjorn.topel@gmail.com>
References: <20191101110346.15004-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

Inline the xsk_map_lookup_elem() via implementing the map_gen_lookup()
callback. This results in emitting the bpf instructions in place of
bpf_map_lookup_elem() helper call and better performance of bpf
programs.

Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 kernel/bpf/xskmap.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/kernel/bpf/xskmap.c b/kernel/bpf/xskmap.c
index edcbd863650e..554939f78b83 100644
--- a/kernel/bpf/xskmap.c
+++ b/kernel/bpf/xskmap.c
@@ -163,6 +163,22 @@ struct xdp_sock *__xsk_map_lookup_elem(struct bpf_map *map, u32 key)
 	return xs;
 }
 
+static u32 xsk_map_gen_lookup(struct bpf_map *map, struct bpf_insn *insn_buf)
+{
+	const int ret = BPF_REG_0, mp = BPF_REG_1, index = BPF_REG_2;
+	struct bpf_insn *insn = insn_buf;
+
+	*insn++ = BPF_LDX_MEM(BPF_W, ret, index, 0);
+	*insn++ = BPF_JMP_IMM(BPF_JGE, ret, map->max_entries, 5);
+	*insn++ = BPF_ALU64_IMM(BPF_LSH, ret, ilog2(sizeof(struct xsk_sock *)));
+	*insn++ = BPF_ALU64_IMM(BPF_ADD, mp, offsetof(struct xsk_map, xsk_map));
+	*insn++ = BPF_ALU64_REG(BPF_ADD, ret, mp);
+	*insn++ = BPF_LDX_MEM(BPF_SIZEOF(struct xsk_sock *), ret, ret, 0);
+	*insn++ = BPF_JMP_IMM(BPF_JA, 0, 0, 1);
+	*insn++ = BPF_MOV64_IMM(ret, 0);
+	return insn - insn_buf;
+}
+
 int __xsk_map_redirect(struct bpf_map *map, struct xdp_buff *xdp,
 		       struct xdp_sock *xs)
 {
@@ -303,6 +319,7 @@ const struct bpf_map_ops xsk_map_ops = {
 	.map_free = xsk_map_free,
 	.map_get_next_key = xsk_map_get_next_key,
 	.map_lookup_elem = xsk_map_lookup_elem,
+	.map_gen_lookup = xsk_map_gen_lookup,
 	.map_lookup_elem_sys_only = xsk_map_lookup_elem_sys_only,
 	.map_update_elem = xsk_map_update_elem,
 	.map_delete_elem = xsk_map_delete_elem,
-- 
2.20.1

