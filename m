Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A097C13CC58
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 19:45:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729346AbgAOSng (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 13:43:36 -0500
Received: from mail-pf1-f202.google.com ([209.85.210.202]:55708 "EHLO
        mail-pf1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729268AbgAOSnc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 13:43:32 -0500
Received: by mail-pf1-f202.google.com with SMTP id 8so11442012pfb.22
        for <netdev@vger.kernel.org>; Wed, 15 Jan 2020 10:43:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=bTzv6GNpgfrRZmeHOV0jVc+oFdZ9HuTWtPYHIUcg/W4=;
        b=u6yLAPqVa3ro09ZQhcPDbZBH6GA5ByMOsoiAYioTquy1hYzT8AeaEuB4kL/6IqUBPx
         0AqW1RIVD5mdOKoW9TemSg0AcKRhjLT3fUbCuIyhuy1yWsB7VlhrjwJkPRNshtCrszdb
         F/1Pk3RRjKtgGFtVaKh/hwIV28EmWUB8esDtd+10tZGMRs2tIXL1Eh8Dl72vyVMDfkgn
         Vl1LasdRigJ4pIrOOmCVj6GfgOZDFO2RQX1Gqxv2zrTraGVkFdNO+Iv+F+YDswQTy/dz
         MtqEXUYbt2z18+QEjMLnKygiEOVfMNunMnm29fORAte0NRZSBRmHgylNnqlh76NQSB7G
         GH9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=bTzv6GNpgfrRZmeHOV0jVc+oFdZ9HuTWtPYHIUcg/W4=;
        b=jHIf4H2jOIv3nXVktAiZyONQs7h3qngyNq0LBPs3YXFjDS1DF89qhBnkKbz6GrbVVh
         ZA7GfcPnpddDzyn+bU35DzOy+1OAiN+ndR5L2Skj3kamqK8Gn1NM0Cvh19jTiYSOKug0
         QALllLtFLEqI7f0K4GJ/gH3aHDtl8aJ1AlJ5AcojsUGijx6LQhmaeOHXUuN02zT9nB5N
         em2+Qcec7MFFAJhYhsXvGSVgJxgxcrrhglLanS3ERWdaZ13bwUopZ039ek61xdU1C6xw
         YQoA0ChUSkaDJQp7OAQxOLqaHVci2AYRoJjPYdimX7g1ZKfgpWderzElyUpitkMb3E7v
         cmnw==
X-Gm-Message-State: APjAAAWM1xBw7fPQi2FIErH46R7dbIfXZtefnZNTRF7AHu//kERDWOjG
        H4uaayxcqoG7jMYBcv507jhELRvU9rkb
X-Google-Smtp-Source: APXvYqxTfe7jLbFuDD+gZt1hs9KW/RLDoX7XAgEuKsCqDnYZQRqqvUy6B5pjHryPABA00K3D9D/UlRd4jAFC
X-Received: by 2002:a65:578e:: with SMTP id b14mr34722927pgr.444.1579113811637;
 Wed, 15 Jan 2020 10:43:31 -0800 (PST)
Date:   Wed, 15 Jan 2020 10:43:03 -0800
In-Reply-To: <20200115184308.162644-1-brianvv@google.com>
Message-Id: <20200115184308.162644-5-brianvv@google.com>
Mime-Version: 1.0
References: <20200115184308.162644-1-brianvv@google.com>
X-Mailer: git-send-email 2.25.0.rc1.283.g88dfdc4193-goog
Subject: [PATCH v5 bpf-next 4/9] bpf: add lookup and update batch ops to arraymap
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

