Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 558892BAE75
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 16:23:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729431AbgKTPQP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 10:16:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729428AbgKTPQK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 10:16:10 -0500
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D305C0613CF;
        Fri, 20 Nov 2020 07:16:10 -0800 (PST)
Received: by mail-lj1-x242.google.com with SMTP id i17so10422149ljd.3;
        Fri, 20 Nov 2020 07:16:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lgmif6u43MAtUPx11iAmJ4jMILqfwgrZ8qigNmX0Wb0=;
        b=mRsXPlNKPFdxlpddui9KhKtdJ2CWaQS/jqeVuPtflGfzBKW+vUIc681/0XoO7gXFcN
         Y+EfiGhA6LDVLy9JMkLoJU92SR3l2hn1D4XIiaBGNaIFqnnbcmmUjNIYzr7IdjBb35WQ
         t7+b3ABKEyr0J/LfIy8ouI3bymr1iJIiTPgHYsNdnbNYYitkdBCtzgE0wW1GylcCK5g0
         /RdIuzcT6SuaNyYiXGsK6r0i00WUADfVrUvHN69ZzuivFeR5HHbOtW6KdlmvRIbiw9+7
         2efJMFr26EZizcFEGisZrF7kDT1L71VdNBVeiHVgBGOnt52XkeUq94ZyJmbyfYKL8r72
         RbKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lgmif6u43MAtUPx11iAmJ4jMILqfwgrZ8qigNmX0Wb0=;
        b=sm4Rj0zCx9zP1e2efcWGzxhjqlsuxGU8sUguT8qogWhoyjUILS+IUK28FN0Th9qCiC
         g05cxVdAwNFGjTe+Cqe3PCXiD7kYwJOAtyumA+4xbAxnFxAe5/M3pkIoH8DgMDWPcRIx
         re7eYvUgjGt4DtMUEMItrOHNppgdgUP2H5rUOxGHbvgx2ImDxHo3gpmBuUvoY1HeDA75
         bGCov+bRs01UKCYwNQDkU/gbHYOBpRdeJ+IN23eOTt6yDLslstI6EsXdk9ycTRr5UFiT
         iF8qDHDDTk4AkMxshUe3CI6mq0gLCo4Qkeqn05R16m6ges8QXODglpxMElB97uLDc1JS
         YFwQ==
X-Gm-Message-State: AOAM533yoa/ylh2q7q7tXEdJzgk2CG23gqZyeAhn93/i0dMBehYjoTET
        q+JXwVka7kTvaGA7109sekE=
X-Google-Smtp-Source: ABdhPJws/p1zTWwKaAb5WnFfRIxMjgH7iGps9ShmaJQslZVTbMJjfl+SSFiSSHD7Lrn9XCqmDgu74A==
X-Received: by 2002:a2e:1657:: with SMTP id 23mr8458950ljw.12.1605885368998;
        Fri, 20 Nov 2020 07:16:08 -0800 (PST)
Received: from localhost.localdomain (87-205-71-93.adsl.inetia.pl. [87.205.71.93])
        by smtp.gmail.com with ESMTPSA id 187sm377199lfl.117.2020.11.20.07.16.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2020 07:16:08 -0800 (PST)
From:   alardam@gmail.com
X-Google-Original-From: marekx.majtyka@intel.com
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com
Cc:     Marek Majtyka <marekx.majtyka@intel.com>, bpf@vger.kernel.org
Subject: [PATCH bpf] xsk: fix incorrect netdev reference count
Date:   Fri, 20 Nov 2020 16:14:43 +0100
Message-Id: <20201120151443.105903-1-marekx.majtyka@intel.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marek Majtyka <marekx.majtyka@intel.com>

Fix incorrect netdev reference count in xsk_bind operation. Incorrect
reference count of the device appears when a user calls bind with the
XDP_ZEROCOPY flag on an interface which does not support zero-copy.
In such a case, an error is returned but the reference count is not
decreased. This change fixes the fault, by decreasing the reference count
in case of such an error.

The problem being corrected appeared in '162c820ed896' for the first time,
and the code was moved to new file location over the time with commit
'c2d3d6a47462'. This specific patch applies to all version starting
from 'c2d3d6a47462'. The same solution should be applied but on different
file (net/xdp/xdp_umem.c) and function (xdp_umem_assign_dev) for versions
from '162c820ed896' to 'c2d3d6a47462' excluded.

Fixes: 162c820ed896 ("xdp: hold device for umem regardless of zero- ...")
Signed-off-by: Marek Majtyka <marekx.majtyka@intel.com>
---
 net/xdp/xsk_buff_pool.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
index 8a3bf4e1318e..46d09bfb1923 100644
--- a/net/xdp/xsk_buff_pool.c
+++ b/net/xdp/xsk_buff_pool.c
@@ -185,8 +185,10 @@ static int __xp_assign_dev(struct xsk_buff_pool *pool,
 err_unreg_pool:
 	if (!force_zc)
 		err = 0; /* fallback to copy mode */
-	if (err)
+	if (err) {
 		xsk_clear_pool_at_qid(netdev, queue_id);
+		dev_put(netdev);
+	}
 	return err;
 }
 
-- 
2.27.0

