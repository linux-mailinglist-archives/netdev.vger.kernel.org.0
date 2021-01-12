Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D12242F35C7
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 17:29:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392628AbhALQ3N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 11:29:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392580AbhALQ3M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 11:29:12 -0500
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BD8DC061794
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 08:28:32 -0800 (PST)
Received: by mail-qk1-x749.google.com with SMTP id q3so1914007qkq.21
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 08:28:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=mWcf/+iFwpreBNElvxMjcceqxx7yuNB9Ov/Q1i5x95c=;
        b=GtbUADTogOQ/ogEKQtWG8v5LTG+fN37POyE1dZSnbv0gP+hOo5hgjsZsc85mKhIYX0
         hb7/fOogYbJykyHNMEowmiR1JlKSKPLvU1cr0bjgdL8IB+ZWBZl9BJP+Ob4FRTrMA58G
         07eOIGDFGX9n2vdkjjC2X7MsZ2VXqzVSIQHUI+ETEIC20eIsjWmWTRpZClCAXFlvBcR0
         XGfQ+eNq8qBpnxrcbXBUXg9OArGD0piKiggHQBkDEgASpAswHK8wyoHUWFhO1u5jDOPz
         BPN2cVdRnrWDbBsjHIVXX/AsF0tOQqNkArhkzV9RvOBWN0ehop1O6Ruvq3BMRgncr3YC
         /Ihw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=mWcf/+iFwpreBNElvxMjcceqxx7yuNB9Ov/Q1i5x95c=;
        b=WCO/BY6Ac+7zvSafhmugmsxS3ilJHdyh3M/RSipOjFsZldAgvLIBMMUzCD3mTxBR9d
         JXB+FJnxTMg1tcXU6uTsDlbSkZjJo2RiS1+Axj5Jyvx6WaZcojVPwEw7uDRHBj/bHez6
         6/FD5qTdssZG8MiIVBDraufKERxMqZRglbnYw9uPQZ0DZT7u0XTwkvwu3fnn5LMQTucg
         644KhgtPI/95URDNEfsMF+SutI4Iztt1bBvW9W8LH2iKp7QefWCew32AEbeT6/xt1U6+
         x5BJifcnG3QkO1394T3QKnVx3WAWtekLQq7iLelgIxBy4faS5FYZjgTec+8nO4uTfSIN
         WtSA==
X-Gm-Message-State: AOAM532UhFp6OapSseirhjr/iDQs3pN/MLxQEEey6oNdR4ZMj2supb1F
        02qsRYtHkYRDfLN81CCdIZ+HGeH1JP5JPIEgo5xl2VnMplexuYKsSc7SKPylW8lHkn3k2gMBmFN
        AnyYc7laVabObPIDxS/N++8AGTKI7fUvSkWwFECVAXk8S0bXvnXm1dQ==
X-Google-Smtp-Source: ABdhPJzNYjN/PhOiSRUE+jMM4Yn5u04yvHhluC6A2cuHl4benPwxniuxname9VeK/WdxPK0tgjeZR+g=
Sender: "sdf via sendgmr" <sdf@sdf2.svl.corp.google.com>
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:1:7220:84ff:fe09:7732])
 (user=sdf job=sendgmr) by 2002:ad4:4f4a:: with SMTP id eu10mr5576394qvb.17.1610468911514;
 Tue, 12 Jan 2021 08:28:31 -0800 (PST)
Date:   Tue, 12 Jan 2021 08:28:29 -0800
Message-Id: <20210112162829.775079-1-sdf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.0.284.gd98b1dd5eaa7-goog
Subject: [PATCH bpf v2] bpf: don't leak memory in bpf getsockopt when optlen
 == 0
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>,
        Martin KaFai Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

optlen == 0 indicates that the kernel should ignore BPF buffer
and use the original one from the user. We, however, forget
to free the temporary buffer that we've allocated for BPF.

Reported-by: Martin KaFai Lau <kafai@fb.com>
Fixes: d8fe449a9c51 ("bpf: Don't return EINVAL from {get,set}sockopt when optlen > PAGE_SIZE")
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 kernel/bpf/cgroup.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index 6ec088a96302..96555a8a2c54 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -1391,12 +1391,13 @@ int __cgroup_bpf_run_filter_setsockopt(struct sock *sk, int *level,
 		if (ctx.optlen != 0) {
 			*optlen = ctx.optlen;
 			*kernel_optval = ctx.optval;
+			/* export and don't free sockopt buf */
+			return 0;
 		}
 	}
 
 out:
-	if (ret)
-		sockopt_free_buf(&ctx);
+	sockopt_free_buf(&ctx);
 	return ret;
 }
 
-- 
2.30.0.284.gd98b1dd5eaa7-goog

