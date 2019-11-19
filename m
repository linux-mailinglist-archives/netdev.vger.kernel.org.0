Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63AE31010FB
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 02:45:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727521AbfKSBpB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 20:45:01 -0500
Received: from mail-yb1-f202.google.com ([209.85.219.202]:45224 "EHLO
        mail-yb1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727004AbfKSBo0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 20:44:26 -0500
Received: by mail-yb1-f202.google.com with SMTP id b202so14917480yba.12
        for <netdev@vger.kernel.org>; Mon, 18 Nov 2019 17:44:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=+X4EfDiauElJOC7RvUHMTNrf0yIKJ6Yo/r1JySL4OmE=;
        b=XuRXY+Uojn4XMwzMfwawiXvnYay5fnux5+uJeb3ziZ3R5w/vbNhsqKzQ/EKcdHNva/
         bTVABpEbKe34fuMWa+rwVkf9oUB+ETllNbUdUuEV0kMV27/I5J46qEvTfjgr3geFNG+s
         VuSKrsE9MCPhH2N0/LwdjCjUe+e+7kT1wnb7rWBqjNaQZyzKPXI8ZtCdQjtjJ4NT+QVx
         GGYs8he60Apg56auefYNhlsWUk/3YYn80LCHN2SQIEPH+cUJtaYM/Gi894vrfxz39I65
         SfD/FmVf683ut0qb6rCIBdLpkfRwi72MeVlTL7TmwAh1xuxqQFLA90nnUry9c6MB5Zpy
         j0pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=+X4EfDiauElJOC7RvUHMTNrf0yIKJ6Yo/r1JySL4OmE=;
        b=F2Ub6TeIPH6jGX+lXf8gPbM3Oa2DXZcfaLO89X4KAeqvAMoGYkb/g65CDvPyZiThii
         Pw9gZyA1z9f7LtxatMeE2VL7sAFD6/VNpjd+GOZ7WwJwCC5RiEDoOqyjqZouEkey7BiM
         XUp4qiQg6a/nfeb4Gybti2QEcCCDijFC9m3b1YZo1offDBkN4iRHcv0LTmZbphQsdkRP
         lBOlAWYJ4Tjkkpe3Fmhdw8wXTCBeieoCVCJGhrrIjI9TrOQM666g87WDbUEtIrSadoI1
         yB6YzQ8jnhM2kPx2LZUiO0oFgt+c5IhhLALREsGE8Vvh89KckYHj2Vq9kxNK6wdMrELe
         61hQ==
X-Gm-Message-State: APjAAAVFgfbrNZon10EGW5EUmH7vaRXQ1wbe94EpBDjt8VLlQXV+phgO
        /FZFSwHGwah9ktPZqT9HP9Yd7u7uhm+v
X-Google-Smtp-Source: APXvYqyTrKX/xD95yspop64YmtLkkWhLlkti3RyghsE1x1RjvOga6zkHUJod3Kf+PT0x/rL4hhHXbqUl7AWp
X-Received: by 2002:a81:36c9:: with SMTP id d192mr10218854ywa.304.1574127863941;
 Mon, 18 Nov 2019 17:44:23 -0800 (PST)
Date:   Mon, 18 Nov 2019 17:43:52 -0800
In-Reply-To: <20191119014357.98465-1-brianvv@google.com>
Message-Id: <20191119014357.98465-5-brianvv@google.com>
Mime-Version: 1.0
References: <20191119014357.98465-1-brianvv@google.com>
X-Mailer: git-send-email 2.24.0.432.g9d3f5f5b63-goog
Subject: [PATCH bpf-next 4/9] bpf: add lookup and updated batch ops to arraymap
From:   Brian Vazquez <brianvv@google.com>
To:     Brian Vazquez <brianvv.kernel@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Yonghong Song <yhs@fb.com>, Stanislav Fomichev <sdf@google.com>,
        Petar Penkov <ppenkov@google.com>,
        Willem de Bruijn <willemb@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Brian Vazquez <brianvv@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds the generic batch ops functionality to bpf arraymap, note that
since deletion is not a valid operation for arraymap, only batch and
lookup are added.

Signed-off-by: Brian Vazquez <brianvv@google.com>
---
 kernel/bpf/arraymap.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
index 1c65ce0098a95..680d4e99ef583 100644
--- a/kernel/bpf/arraymap.c
+++ b/kernel/bpf/arraymap.c
@@ -457,6 +457,8 @@ const struct bpf_map_ops array_map_ops = {
 	.map_direct_value_meta = array_map_direct_value_meta,
 	.map_seq_show_elem = array_map_seq_show_elem,
 	.map_check_btf = array_map_check_btf,
+	.map_lookup_batch = generic_map_lookup_batch,
+	.map_update_batch = generic_map_update_batch,
 };
 
 const struct bpf_map_ops percpu_array_map_ops = {
-- 
2.24.0.432.g9d3f5f5b63-goog

