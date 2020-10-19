Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1080A2925B0
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 12:23:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726672AbgJSKXe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 06:23:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726631AbgJSKXd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 06:23:33 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF696C0613CE;
        Mon, 19 Oct 2020 03:23:32 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id b19so4770999pld.0;
        Mon, 19 Oct 2020 03:23:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=O9u6k2TfEL/4hP9vuI592zN8XtX6YQkUwjCMOzjCYf8=;
        b=CvwNHbj+f8OGBTCRUzYkuBGXNm5/44IQh62vL+UwNEUosgMYbrIEfZt8HQmNIX+sbW
         fl/p5p0e7pNAsfDoAmwrbK6cgSgBBReMwbAs0kMBb2apCGfPUE3q5nQOyhfXP3yukCoG
         VgWsR6ZZ/JgA8PinegNOjehvQuZk7zs7j4dDoiaEatbZh0uTgUNAY/piInZ6L7MnNNnQ
         PZzraRjYee3kJxnZhkWyCrStgVVsk4VwsoDvJHE6dG+HfcNtdwZZZ59SEyXGfqj6GyPk
         sCj/Q7mZlRaLBKgcNzii6OpgUt0k9+UMlxJfbrWomxyKKtEtAOgCkDUxm0+GMRXFhPhB
         6L/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=O9u6k2TfEL/4hP9vuI592zN8XtX6YQkUwjCMOzjCYf8=;
        b=DEqy6679xMwMtFomD31qTm+aKHb1OLE8oCHyZ+MK4i4J9PZdrwRXeyTy8Cw1ylWjsZ
         ijd8GpXqGMeGDwTbsWcs0GyJbEiQmepduaPrTlFK//BLmfh+546bZRreYalUkkMid26t
         r97kXbWBywjBilEPFfFaeQf26dD1KVQE7NA7e5jEuH6S6zd6EAEk9zh76PFdBLQ485bz
         pr4k4BEcs7nvBaiaI3jmI9xqa2fIQZloZT6IGXi91SK+Amxw1WGYIjYbY1RJSTwrcbaf
         qZX0lJSkJY+n02GVf48/TeO8DwaCXSavupFS7cKesoxlulo1Ir2+We2/B06Mmr1/NQUX
         tQzA==
X-Gm-Message-State: AOAM531TrcQU0OlQQYrV4IC/pT+nFhfngUaeLg9A1emC59K2uIB3Hsb7
        OWTOGvxQBDDlObbZF2cwPB8=
X-Google-Smtp-Source: ABdhPJzdIPoTO8Z2U9ffG3k5Vhfzluy91VbWsEhq+S73T4TufdB3qtNW0/KLOkFM2pi+bvJBrWoHug==
X-Received: by 2002:a17:90a:b30b:: with SMTP id d11mr5207378pjr.163.1603103012487;
        Mon, 19 Oct 2020 03:23:32 -0700 (PDT)
Received: from localhost ([2400:8800:300:11c:6776:f262:d64f:e94d])
        by smtp.gmail.com with ESMTPSA id i30sm11405472pgb.81.2020.10.19.03.23.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2020 03:23:31 -0700 (PDT)
From:   Geliang Tang <geliangtang@gmail.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Peter Krystad <peter.krystad@linux.intel.com>
Cc:     Geliang Tang <geliangtang@gmail.com>, netdev@vger.kernel.org,
        mptcp@lists.01.org, linux-kernel@vger.kernel.org
Subject: [MPTCP][PATCH net-next 1/2] mptcp: initialize mptcp_options_received's ahmac
Date:   Mon, 19 Oct 2020 18:23:15 +0800
Message-Id: <3ae4089622f9933c18f474e6ee954f39a40bfec3.1603102503.git.geliangtang@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1603102503.git.geliangtang@gmail.com>
References: <cover.1603102503.git.geliangtang@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch initialize mptcp_options_received's ahmac to zero, otherwise it
will be a random number when receiving ADD_ADDR suboption with echo-flag=1.

Fixes: 3df523ab582c5 ("mptcp: Add ADD_ADDR handling")
Signed-off-by: Geliang Tang <geliangtang@gmail.com>
---
 net/mptcp/options.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index 092a2d48bfd3..1ff3469938b6 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -297,6 +297,7 @@ void mptcp_get_options(const struct sk_buff *skb,
 	mp_opt->mp_capable = 0;
 	mp_opt->mp_join = 0;
 	mp_opt->add_addr = 0;
+	mp_opt->ahmac = 0;
 	mp_opt->rm_addr = 0;
 	mp_opt->dss = 0;
 
-- 
2.26.2

