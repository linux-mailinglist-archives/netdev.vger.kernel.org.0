Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76E123E0167
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 14:46:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238258AbhHDMqc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 08:46:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238242AbhHDMqY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Aug 2021 08:46:24 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 803A7C0617B0;
        Wed,  4 Aug 2021 05:45:52 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id l34-20020a05600c1d22b02902573c214807so3839332wms.2;
        Wed, 04 Aug 2021 05:45:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=iKwt2CNIQOHR6e39/4WlE1XM4D8qqPBdFFLhXvUbs2c=;
        b=boG4J51h4t/f1s3OiPbetfQ7OhQlL6uGY30SuA7uQXq1kOHGWxqVuYizPCrX0o5OhP
         DmFPyy3YCgvhkva15Qn5pPRtfw8XWlJBqHy80yLsgeMZewm9uKhtrOY69kbiez7Aumqc
         Alns+Jo+W04lqYqindQKriNvDMKhIX+/C7bSSUSdkMpIvxOVbnt8jMxP6fmZbsJGevRY
         yywFw84Agp8xdf32zsbPYySgxxF+jb+MlHEPvlu4UYPPqoumpSj5KGCQHNKXxZB27Wsg
         neOaR+hA/WJs8hk4chwrCg+1SG5otVJzEzyC6OzboCks9av5AZew7gK5F3Xbcy//HCxB
         kFLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=iKwt2CNIQOHR6e39/4WlE1XM4D8qqPBdFFLhXvUbs2c=;
        b=g70sShYCpW70GLEy36tJEucDLoLFlND2PiI0auPLAFD5NysAqt1t/dkh5/PCn+3hn8
         ly23WLRI+yV0TA6E0CmlM1aFHUXhQbCLVrT9tjO+hQQj57mgXJLyEj0v3/36oUc5JzSF
         wBCWULW3ON0P7Rd1tnY41iJ0Kue9XpH8XfWsdgODRpwt2i0ZkKROcZnunV0vYOG1HMQL
         sKYpJEXk9tFOfdq62MXhV4oomuJfqSMlWxDzrAhRMvKYCFXDtsQnwnnSYXCPLE9bUNTg
         vxaqu94TPcDKEfn3DaIGTP6DQCrDqHS/R0S//k9AAm5d/z33RTxPxpmHeUYupxgDqa5b
         /erg==
X-Gm-Message-State: AOAM531y8gGvHVOAv58NIJSW7nRqZI+3yUjMgLpRNq8ne+bYFwdmRaHV
        K6oCCEl2HkdmUmDu9NPg10CiTuEQDJVffKc=
X-Google-Smtp-Source: ABdhPJwRgeMhf3YyaXeKxcn8edAsZHYnpsHC9QuXSvNw1VQjSQm5ByyDzree3KSzSKZgg+Btk8lthQ==
X-Received: by 2002:a05:600c:ad6:: with SMTP id c22mr27774930wmr.114.1628081150838;
        Wed, 04 Aug 2021 05:45:50 -0700 (PDT)
Received: from localhost.localdomain ([77.109.191.101])
        by smtp.gmail.com with ESMTPSA id y4sm2257923wmi.22.2021.08.04.05.45.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Aug 2021 05:45:50 -0700 (PDT)
From:   Jussi Maki <joamaki@gmail.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, daniel@iogearbox.net, j.vosburgh@gmail.com,
        andy@greyhouse.net, vfalico@gmail.com, andrii@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        Jussi Maki <joamaki@gmail.com>
Subject: [PATCH bpf-next v5 5/7] net: core: Allow netdev_lower_get_next_private_rcu in bh context
Date:   Fri, 30 Jul 2021 06:18:20 +0000
Message-Id: <20210730061822.6600-6-joamaki@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210730061822.6600-1-joamaki@gmail.com>
References: <20210609135537.1460244-1-joamaki@gmail.com>
 <20210730061822.6600-1-joamaki@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For the XDP bonding slave lookup to work in the NAPI poll context
in which the redudant rcu_read_lock() has been removed we have to
follow the same approach as in [1] and modify the WARN_ON to also
check rcu_read_lock_bh_held().

[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=694cea395fded425008e93cd90cfdf7a451674af

Signed-off-by: Jussi Maki <joamaki@gmail.com>
---
 net/core/dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 27023ea933dd..ae1aecf97b58 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -7588,7 +7588,7 @@ void *netdev_lower_get_next_private_rcu(struct net_device *dev,
 {
 	struct netdev_adjacent *lower;
 
-	WARN_ON_ONCE(!rcu_read_lock_held());
+	WARN_ON_ONCE(!rcu_read_lock_held() && !rcu_read_lock_bh_held());
 
 	lower = list_entry_rcu((*iter)->next, struct netdev_adjacent, list);
 
-- 
2.17.1

