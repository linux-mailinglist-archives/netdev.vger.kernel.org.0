Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08F48364857
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 18:37:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232690AbhDSQhj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 12:37:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230063AbhDSQhh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 12:37:37 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CA67C06174A;
        Mon, 19 Apr 2021 09:37:06 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id y3so5235266eds.5;
        Mon, 19 Apr 2021 09:37:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RKVgXAX0mREX8Z0MCpmywkdwIZCixUAvYUJ20KmIUmM=;
        b=HQe4hHu3jDM3VMM9bgAAJO7LJ1nuzE2Zlm+7CJbv/ZQT+d3t5c8GKY1wiK0P/d8sER
         a3YCO30m7N+/NsNvJzeRpjp0sdsPecqrjP0KqkOsxjX2tdc+g14KTOmn5H7oI6l8TWyv
         dby33R1hSpDmVfW2JNU/Im6NwYKXLANxpwarInv//7qs4r5cSz69DvJ3SF2grgW0RE5r
         LXSAhroeOwlMllkLcfxytfjHUV38DdEsd6EJo7nb/rnkjgE7MEwm6oZkgX/dtAtnabf5
         KaH8SR5JV2vOehwvD8JS9jtDjCMtaciFE+cMZqFSSRbiqoWoQQQkkkCP9cmggTld2IqI
         oibQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=RKVgXAX0mREX8Z0MCpmywkdwIZCixUAvYUJ20KmIUmM=;
        b=pj8yvU3YrArr/nAQ21nuvClngXEH5CqhMoKvlOKClc60fUnNCPjkybbo59SU2UsuxM
         Ak2VW6CUVM7kkckuLkvPoD4RTHtEC/461tu6OW53u9WP6hk3c8X7DT5L5yC80LCkoD3P
         Y/WRyBJFiB4UZRrX6zHkVsYWzGIfb+XPWn8+UIqG/epGpCD3WQfCtYxUYChfyV6BWssw
         9erVNKlCC8kC1COdnqX81zZbXG6QR/boKREdUtjtYhXBfGWtD0sxtdnRHpwaTb4vAdrf
         AhlxNlxXcNGF4k9U+q3ePTiu7meocCgZup60vRPkACM818aZqd2QJk/w2knBXeTQ6Kgl
         c73Q==
X-Gm-Message-State: AOAM533VgjplroIgJGn5rDxaToX9qz9fl7OsE2aKl6L+gAo/JrIsYvxh
        mBiO+6M2mCsziafoSNwh4tI=
X-Google-Smtp-Source: ABdhPJxlHE+uN0letZMKdjr+iTxf5YPKEy4uushblsmHr3m3aO5AO/Mjig0xXV/5WRJKl1OWM2qRQQ==
X-Received: by 2002:a05:6402:cbb:: with SMTP id cn27mr12958654edb.222.1618850225382;
        Mon, 19 Apr 2021 09:37:05 -0700 (PDT)
Received: from localhost.localdomain ([185.58.55.85])
        by smtp.gmail.com with ESMTPSA id c19sm13196792edu.20.2021.04.19.09.36.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 09:37:04 -0700 (PDT)
From:   Kurt Manucredo <fuzzybritches0@gmail.com>
To:     trond.myklebust@hammerspace.com, anna.schumaker@netapp.com,
        bfields@fieldses.org, chuck.lever@oracle.com, davem@davemloft.net,
        kuba@kernel.org, skhan@linuxfoundation.org
Cc:     Kurt Manucredo <fuzzybritches0@gmail.com>,
        linux-nfs@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        syzbot+ba2e91df8f74809417fa@syzkaller.appspotmail.com,
        gregkh@linuxfoundation.org
Subject: [PATCH] net: sunrpc: xprt.c: fix shift-out-of-bounds in xprt_calc_majortimeo
Date:   Mon, 19 Apr 2021 16:36:03 +0000
Message-Id: <20210419163603.7-1-fuzzybritches0@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix shift-out-of-bounds in xprt_calc_majortimeo().

UBSAN: shift-out-of-bounds in net/sunrpc/xprt.c:658:14
shift exponent 536871232 is too large for 64-bit type 'long u

Reported-by: syzbot+ba2e91df8f74809417fa@syzkaller.appspotmail.com
Signed-off-by: Kurt Manucredo <fuzzybritches0@gmail.com>
---
 net/sunrpc/xprt.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/sunrpc/xprt.c b/net/sunrpc/xprt.c
index 691ccf8049a4..07128ac3d51d 100644
--- a/net/sunrpc/xprt.c
+++ b/net/sunrpc/xprt.c
@@ -655,7 +655,10 @@ static unsigned long xprt_calc_majortimeo(struct rpc_rqst *req)
 	unsigned long majortimeo = req->rq_timeout;
 
 	if (to->to_exponential)
-		majortimeo <<= to->to_retries;
+		if (to->to_retries >= sizeof(majortimeo) * 8)
+			majortimeo = to->to_maxval;
+		else
+			majortimeo <<= to->to_retries;
 	else
 		majortimeo += to->to_increment * to->to_retries;
 	if (majortimeo > to->to_maxval || majortimeo == 0)
-- 
2.30.2

