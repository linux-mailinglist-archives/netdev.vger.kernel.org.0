Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5975313AFCF
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 17:47:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728992AbgANQqp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 11:46:45 -0500
Received: from mail-pl1-f201.google.com ([209.85.214.201]:50739 "EHLO
        mail-pl1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728983AbgANQqp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 11:46:45 -0500
Received: by mail-pl1-f201.google.com with SMTP id g5so2052006plq.17
        for <netdev@vger.kernel.org>; Tue, 14 Jan 2020 08:46:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=bTzv6GNpgfrRZmeHOV0jVc+oFdZ9HuTWtPYHIUcg/W4=;
        b=QNnMhi1W2Lwr9MiJV1KUIy84wUVGideJuBgoE8jzj7ATu3d+8Iej5m7jE4wEyrUloG
         PmCzBN3Y/FcSXfgNrjtdeca6SP75c21ZSFxwQ33whfSl8Llc/Tfs931jR7JFlKvtpL7R
         OVQD2+sf7pxwqUSXltEoe9xWiW8qtliCn4a6dmeqj6LHT9vtAQItMQikhZnofmzBG3ZN
         SY4j+4f9chtw5cTVKbA+v/YxZpuJTUPdcuSaDlkWIegcBGwvg2oifZEqpMBK4bDDbS8f
         oJPCU+5ZciMpiDheJSoUQnu4UnxzEBByQdSSTGsNpWfzD/C9yoO51HaQXhDAknnJLTT/
         RP5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=bTzv6GNpgfrRZmeHOV0jVc+oFdZ9HuTWtPYHIUcg/W4=;
        b=RQSFV01J7ZF9AadjOnPSaU83gdSRglnl6ThrNWDEc3BCaluDiTs6IUTKaacjXB4lhB
         w0SqHIi3SrQgLiP8ciu4yKwATYJ0KRO8Z5g8ajp1dkpYrEQi+zbEmLGZ4LDe7pH21AV7
         ZXfR5vjYxtFw9pgwbJynwngsDXgwn71GxVeQZ3vtzE3m2wBZL1v5SOfZ04Wj/B9rYCkQ
         SqYjAGXmhm/9Mmdu4vqZVyg1iNYKQ/vtELpOvqQfw8CwaKgvUnjwx85C1QBFTff3F7XZ
         lmlhXE5T9gyhEBAoRIKgIYwrG/sk9aIhS4WnajXJDpDd7LKTofAJ60x7fGm0mgziHno+
         XK+A==
X-Gm-Message-State: APjAAAXnKHjE0AdpUVH8tOaJb499VsN4BgAqjjxlPATHBETAS1EBSlVf
        +PpmhptdNr1485uTxqlAfQuQ5FVXOkBM
X-Google-Smtp-Source: APXvYqwNlRjnwBABlatph1aPgTiQJF+O6lc81rsDh02aseJJD5vR/jzq0Fjyes0uwdcfrH/meeLDOMTraN4R
X-Received: by 2002:a63:7843:: with SMTP id t64mr27824323pgc.144.1579020404127;
 Tue, 14 Jan 2020 08:46:44 -0800 (PST)
Date:   Tue, 14 Jan 2020 08:46:08 -0800
In-Reply-To: <20200114164614.47029-1-brianvv@google.com>
Message-Id: <20200114164614.47029-5-brianvv@google.com>
Mime-Version: 1.0
References: <20200114164614.47029-1-brianvv@google.com>
X-Mailer: git-send-email 2.25.0.rc1.283.g88dfdc4193-goog
Subject: [PATCH v4 bpf-next 4/9] bpf: add lookup and update batch ops to arraymap
From:   Brian Vazquez <brianvv@google.com>
To:     Brian Vazquez <brianvv.kernel@gmail.com>,
        Brian Vazquez <brianvv@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Stanislav Fomichev <sdf@google.com>,
        Petar Penkov <ppenkov@google.com>,
        Willem de Bruijn <willemb@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds the generic batch ops functionality to bpf arraymap, note that
since deletion is not a valid operation for arraymap, only batch and
lookup are added.

Signed-off-by: Brian Vazquez <brianvv@google.com>
Acked-by: Yonghong Song <yhs@fb.com>
---
 kernel/bpf/arraymap.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
index f0d19bbb9211e..95d77770353c9 100644
--- a/kernel/bpf/arraymap.c
+++ b/kernel/bpf/arraymap.c
@@ -503,6 +503,8 @@ const struct bpf_map_ops array_map_ops = {
 	.map_mmap = array_map_mmap,
 	.map_seq_show_elem = array_map_seq_show_elem,
 	.map_check_btf = array_map_check_btf,
+	.map_lookup_batch = generic_map_lookup_batch,
+	.map_update_batch = generic_map_update_batch,
 };
 
 const struct bpf_map_ops percpu_array_map_ops = {
-- 
2.25.0.rc1.283.g88dfdc4193-goog

