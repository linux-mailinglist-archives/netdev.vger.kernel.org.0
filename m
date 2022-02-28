Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 032734C7E3D
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 00:23:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229737AbiB1XYR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 18:24:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229718AbiB1XYQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 18:24:16 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7671C3311
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 15:23:35 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-2d81518795fso113011407b3.0
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 15:23:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=Hl63cIacA+y8aLzzmyl5L8wBUuBQ1b/3yZnRLsIwylg=;
        b=jAao/jq5jMxA2ELK6SgJRtpeoq77RDQVN5qgI/4Us4sP+jmjp40jD1IcRJsmh1EHgx
         m9uinNqt+dCTNXJgv1g9mue+wlv2xsOmn2+hn/I+GKLGFjBSRF7mb4sZH3jN+qPE+Mou
         wXqXDTkNDTuDftbBr11MTViCPhi8+SojdV8qj8PgIAzn2pPH3L4Pk5H62KzxUEzHu0nz
         441hsoGUHQrt/4i3cJGuIsOFKvGXiGLq7SYLJ6H/rMgo7fj/BuUAGDZbiJkI0aceAEYT
         EnNLRB+7T0ofLtJ/9wdtnqiW7cXoeOo1vd6+i+E+E6O07NDWW3a/OOIMUIghVBhV3o4f
         uwBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=Hl63cIacA+y8aLzzmyl5L8wBUuBQ1b/3yZnRLsIwylg=;
        b=dgXDKmMJ1u8MRcqjBgtYW8WZCd1sn0GYMNWks4ugneDXWFaGn9c6bvZ7XFrue9Ky2w
         pg/w4LX43XGllJ4/GGFzpmAMmpgnSWcH5GMpH+Cep9EL+ufqm8SmjeW+YBELKSvngOPN
         A0c9SWpw/WpF9n1Ro5E/Aq48uW8fQjL9Ip57jaCOoCt2a2TCKLenjYxrytboqWUSk8XW
         IlLuG3puBKkHmCizhEvAIKzMSlA/LpQxMAt3I51dH23wDVrt4nslX6E2fHPb7ZKUUDPp
         nlSGe3j7WptKGH/kgZebXIVSD3Fh45oQSQ1UhsgqppR62/9j3kXun+lt6XiavWHYxkdg
         o6bw==
X-Gm-Message-State: AOAM532FUy5qnGYSZJLKaaqpKd4XCrJRrRjnzNgf4hU07YGumH6G2QyV
        x7jWkvSfBKPjKMz2S/4NtBX6VKFmGysvUQA6f/8pNWYDGPHRs95Z/Lv0xwE2Ibc6yeqyNvTTnDe
        AqnXTvwzt86vd3DANwcTUF2ZEKetTOqPWlsn9dOw03f15gk6/TfGC1A==
X-Google-Smtp-Source: ABdhPJxkvsVPqRd5oHsNWX9wqjTUm1s4KG2y4Uox79pr8SwtrF8i4tR0F5IMf9kU59L2I+KVXzj+lKI=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:201:e0d9:4eba:c433:775d])
 (user=sdf job=sendgmr) by 2002:a25:296:0:b0:623:a267:ab94 with SMTP id
 144-20020a250296000000b00623a267ab94mr21495769ybc.430.1646090615042; Mon, 28
 Feb 2022 15:23:35 -0800 (PST)
Date:   Mon, 28 Feb 2022 15:23:32 -0800
Message-Id: <20220228232332.458871-1-sdf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
Subject: [PATCH bpf-next] bpf: test_run: Fix overflow in xdp frags bpf_test_finish
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        Stanislav Fomichev <sdf@google.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-10.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Syzkaller reports another issue:
WARNING: CPU: 0 PID: 10775 at include/linux/thread_info.h:230
check_copy_size include/linux/thread_info.h:230 [inline]
WARNING: CPU: 0 PID: 10775 at include/linux/thread_info.h:230
copy_to_user include/linux/uaccess.h:199 [inline]
WARNING: CPU: 0 PID: 10775 at include/linux/thread_info.h:230
bpf_test_finish.isra.0+0x4b2/0x680 net/bpf/test_run.c:171

This can happen when the userspace buffer is smaller than head+frags.
Return ENOSPC in this case.

Fixes: 7855e0db150a ("bpf: test_run: add xdp_shared_info pointer in bpf_test_finish signature")
Cc: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 net/bpf/test_run.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index f08034500813..eb129e48f90b 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -150,6 +150,11 @@ static int bpf_test_finish(const union bpf_attr *kattr,
 	if (data_out) {
 		int len = sinfo ? copy_size - sinfo->xdp_frags_size : copy_size;
 
+		if (len < 0) {
+			err = -ENOSPC;
+			goto out;
+		}
+
 		if (copy_to_user(data_out, data, len))
 			goto out;
 
-- 
2.35.1.574.g5d30c73bfb-goog

