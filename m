Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6E00100FD0
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 01:20:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726961AbfKSAUA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 19:20:00 -0500
Received: from mail-pg1-f201.google.com ([209.85.215.201]:51989 "EHLO
        mail-pg1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726809AbfKSAUA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 19:20:00 -0500
Received: by mail-pg1-f201.google.com with SMTP id f18so2191215pgh.18
        for <netdev@vger.kernel.org>; Mon, 18 Nov 2019 16:19:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=VvQgGDe+hmOgI9C/B8EM+92sDwQj4yhDGdjV423Q5zg=;
        b=aYz6/cd5U1jOehyCj/fikIRi6p8WiCTQL+oh3HLi3qqDa2r/hLN9twQdlXIxCAxAd9
         JdmNp5tL5IT1ghbfN5HsiHrlr6Xu1w+3AUXlf/dYTl1xXgELVdJXA0GooWc+C5T5at0m
         lZlIxmnim6FS+r+M1wF4Z4cvHmMkx4fu1ZwNz+f/GoBJg4JoCi9PcdIA2QRM/NygS/DI
         ecddcZ0ZmFSrpwoLCl4x7YQd4PRlOLVxIOIta0iOdLUO6K0ILKTpH/ty+NuM1ZPHgBSp
         5sn6WNdfrXwAQZFTYI6Wys7C+emme/vdIGdLIxEqYTjGCyiGH8GPMmsI9Qhw95D7PgrN
         Evbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=VvQgGDe+hmOgI9C/B8EM+92sDwQj4yhDGdjV423Q5zg=;
        b=HYsf5VFT/NH6dW9K6+U+HbOXDvq47+xXrQxdwauP4uKSldlugmaGNFn6fRdC6RbBGe
         oT6idi7iqriwuXWFQJtF6IjG9EProO0P/U97q1KMRIG6HVygQs2e6zraw0w3nrbLx5OT
         fiv2eNc6RPpFXIoFAWuI/NMc1qi12tk4G3Cn6BHU4kUDFOlz9I19xjdTw7SSc6Cu7jqc
         cduP5KMk8vC+06CIDFEhmSSbgyakFfR+Bw74+SC1RHKO25s4cUyM1lpSYKOVL92MYSgT
         uGKKM1sj2IywMAiSDDDMRV/f6fK2GYJmn7PmBOpUvN7DfUlQI92PgQg+dFDmpTu4e4Zb
         SI5Q==
X-Gm-Message-State: APjAAAU+yK0xUyC8fllPHjpLkEWU+9DXxJysJFxjVNIxz5jr0wuP+RAv
        fFc3j1GSCHO7m4e89GOocaGx0jftwiw=
X-Google-Smtp-Source: APXvYqyhqWBjwyTEBEnIiu55yVgbyYn9icIGoCmfZtWwtVHC4gvJnfqcHVnVV+EIVPy2EXEMMWo/onBCKd4=
X-Received: by 2002:a63:b047:: with SMTP id z7mr2251683pgo.224.1574122798219;
 Mon, 18 Nov 2019 16:19:58 -0800 (PST)
Date:   Mon, 18 Nov 2019 16:19:51 -0800
Message-Id: <20191119001951.92930-1-lrizzo@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.0.432.g9d3f5f5b63-goog
Subject: [PATCH v2] net-af_xdp: use correct number of channels from ethtool
From:   Luigi Rizzo <lrizzo@google.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com,
        jonathan.lemon@gmail.com, netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, rizzo@iet.unipi.it,
        Luigi Rizzo <lrizzo@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Drivers use different fields to report the number of channels, so take
the maximum of all data channels (rx, tx, combined) when determining the
size of the xsk map. The current code used only 'combined' which was set
to 0 in some drivers e.g. mlx4.

Tested: compiled and run xdpsock -q 3 -r -S on mlx4
Signed-off-by: Luigi Rizzo <lrizzo@google.com>
---
 tools/lib/bpf/xsk.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
index 74d84f36a5b24..37921375f4d45 100644
--- a/tools/lib/bpf/xsk.c
+++ b/tools/lib/bpf/xsk.c
@@ -431,13 +431,18 @@ static int xsk_get_max_queues(struct xsk_socket *xsk)
 		goto out;
 	}
 
-	if (err || channels.max_combined == 0)
+	if (err) {
 		/* If the device says it has no channels, then all traffic
 		 * is sent to a single stream, so max queues = 1.
 		 */
 		ret = 1;
-	else
-		ret = channels.max_combined;
+	} else {
+		/* Take the max of rx, tx, combined. Drivers return
+		 * the number of channels in different ways.
+		 */
+		ret = max(channels.max_rx, channels.max_tx);
+		ret = max(ret, (int)channels.max_combined);
+	}
 
 out:
 	close(fd);
-- 
2.24.0.432.g9d3f5f5b63-goog

