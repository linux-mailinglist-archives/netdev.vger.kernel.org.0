Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C16641FFC20
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 22:00:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730603AbgFRUAN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 16:00:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728960AbgFRUAM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 16:00:12 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC61EC06174E;
        Thu, 18 Jun 2020 13:00:12 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id 64so3280333pfv.11;
        Thu, 18 Jun 2020 13:00:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BBg1omQmY70sbVnTfrqZN99BMK4tyyYN7aijNl9ncAo=;
        b=qHVOKZnnbDYvxGXWkUgUv/OJykwW4Rv0tiuG0AlmkHqfD36iP4x7BR2Py5GFqACRDm
         5i3ifH5S1NN8V9CxJc4PaVmgovpghtY+nVQClp56dFJGJzQQ9riV5153DTb9uaaYCcXn
         zKSIcsaAL9Q/Xd4Ml4cS0scZDEzGaEn7Pn9HA6i/TpI8l6UiOsikREy1z1OShIzot3XJ
         tsbfdY9L9LKvv4B76PSu+Qs/yHrHoCwUVuKbjZOyCrVrhVWKboeQm1iRxPuxkDLis3b7
         PHb0W+fdBBwNgmviD+SKTBLX4wRmnwqNSEdm8tM2U50nY/KyfFaUmFom+xEIr573l11V
         Rs2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BBg1omQmY70sbVnTfrqZN99BMK4tyyYN7aijNl9ncAo=;
        b=YSqDrYwXDP46vvwrlxU7mA5j/v1AYLXUfwoUYbnMnlURx2ErXXtvm1QduzHIcSAdcZ
         J4EUpqxlMSHvxA6quPP3JW9nFYHRIvoQDQ6caevvRS0/11yaGEVovBzoARfXL2TDx4kZ
         3wZadcc60Vl472HZvzDbkXSdxs2FNBsCVdLzjLxYXt4M0Gl02oGaDCPWlB0FrCXNG9pL
         qcmAIVvG6vZviXUkeKY9Do3dpKp5y++OWq41M6ufHg1UmBH5gkeOqKDyDIKuFhJsAOgA
         vy2LpixOpvqM28peTm28uEcenNjtuzPKsz8Wv6z9zcYyZAEoqEJUUoaWggDZ9dZ0uzv2
         3Jbw==
X-Gm-Message-State: AOAM530hAs+uVixS/Gxlprd53ekdRgfFNxjSSxs9MfxMS+wzs7jW3GiE
        UIRckiEGJq3QeWxBqiBUGL0=
X-Google-Smtp-Source: ABdhPJyK2nA2OlbqWp0JXDCxkOcdEg9DLXJnM7Eeefe6ew+V+/Ftk/5LqOSfW2woQbAIHrltBEwUqQ==
X-Received: by 2002:a63:4b51:: with SMTP id k17mr176046pgl.177.1592510412155;
        Thu, 18 Jun 2020 13:00:12 -0700 (PDT)
Received: from athina.mtv.corp.google.com ([2620:15c:211:0:c786:d9fd:ab91:6283])
        by smtp.gmail.com with ESMTPSA id 1sm3625046pfx.210.2020.06.18.13.00.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jun 2020 13:00:11 -0700 (PDT)
From:   =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
To:     =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Linux Network Development Mailing List <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        BPF Mailing List <bpf@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH] restore behaviour of CAP_SYS_ADMIN allowing the loading of net bpf program
Date:   Thu, 18 Jun 2020 12:59:56 -0700
Message-Id: <20200618195956.73967-1-zenczykowski@gmail.com>
X-Mailer: git-send-email 2.27.0.290.gba653c62da-goog
In-Reply-To: <CAHo-OoyU5OHQuqpTEo-uAQcwcLpzkXezFY6Re-Hv6jGM9aSFSA@mail.gmail.com>
References: <CAHo-OoyU5OHQuqpTEo-uAQcwcLpzkXezFY6Re-Hv6jGM9aSFSA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Żenczykowski <maze@google.com>

This is a 5.8-rc1 regression.

Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Fixes: 2c78ee898d8f ("bpf: Implement CAP_BPF")
Signed-off-by: Maciej Żenczykowski <maze@google.com>
---
 kernel/bpf/syscall.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 8da159936bab..7d946435587d 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2121,7 +2121,7 @@ static int bpf_prog_load(union bpf_attr *attr, union bpf_attr __user *uattr)
 	    !bpf_capable())
 		return -EPERM;
 
-	if (is_net_admin_prog_type(type) && !capable(CAP_NET_ADMIN))
+	if (is_net_admin_prog_type(type) && !capable(CAP_NET_ADMIN) && !capable(CAP_SYS_ADMIN))
 		return -EPERM;
 	if (is_perfmon_prog_type(type) && !perfmon_capable())
 		return -EPERM;
-- 
2.27.0.290.gba653c62da-goog

