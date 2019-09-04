Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71C91A8176
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 13:52:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729749AbfIDLth (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 07:49:37 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:41397 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725829AbfIDLtg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Sep 2019 07:49:36 -0400
Received: by mail-pf1-f194.google.com with SMTP id b13so6451366pfo.8;
        Wed, 04 Sep 2019 04:49:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PhC+V7Rf7TTz8H2JUPUgYNKFdLz/YcQTKpjwR+VAvpI=;
        b=oNK7pr2bi47NmjHoVwWKbZbff0GNxRWL7NmJXJtp85NZuHJV3lwwNElFpeQmMM0LUQ
         tSHM+KzJVbrHgYnAFRf2+xNkNlUrjQDC1MAkviOVTUz2PiNbmclhQmKNpZnLeCAoMFQT
         RAg+ynuDpEsTrYCqAprXqN8eIdVxsA1Fk54gaLvkVbjmwFJxWVxEao+JVF9QNMKRSN/i
         VCD54K+aiehraCgJvt9a+cich2NAichMwsMQr5WdyboZl2Kbg43uhqCDGVnqVexdpDMs
         qHfhU2qJ+CwlPjkL5dDBVddEQdwe/qCOGs39kc69MWx+Zr1Y4FfzAhmp3SUwOfxluIgO
         cgpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PhC+V7Rf7TTz8H2JUPUgYNKFdLz/YcQTKpjwR+VAvpI=;
        b=j+SIHAQsgqBZ2twOfj23dPyylA8Ga5VSOKx8FbvDGCk4mxya1JivnI67k9s64YL66g
         QvHWfw+YuEV6P4lnfMjWsH6gvPIJop79cZNd6fn+z5ffGmJsQWPPq7fkHOecBbB1go36
         H3gF0pCiEvjIJvuvweO3r5b2XW1z3JP+02Vl3Luwjkx6Zy1PcOM5e148AiWtVM1+L3i5
         Iyaw6QEQn/UKgJNm0LVGiBoynroCrWh2zxQh0zYUHBhbvSVqb/MC7Z6QzkYOyaHqlGHQ
         B8NZR2TnVxci/cGfcCJV1IgLgX7Ulw/cin8nRun/rE5s515mDSzjzhBn5eDiptGgVGqw
         WDVQ==
X-Gm-Message-State: APjAAAWznMttF/CQn59EpwjYqEgrfMlNuGp+gdUxnL3XQE73QJSZH+IC
        HBRbA2IcG/SNPRNS1zOG/pE=
X-Google-Smtp-Source: APXvYqwOQ4P62a/xI+2UdjN0O8uzgO3mZqsWPPmRZTNaKmZBYzdpb9u4kAkg8Xolr2XRfOn/v4PqIA==
X-Received: by 2002:aa7:9190:: with SMTP id x16mr15892340pfa.132.1567597776255;
        Wed, 04 Sep 2019 04:49:36 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com (fmdmzpr04-ext.fm.intel.com. [192.55.54.39])
        by smtp.gmail.com with ESMTPSA id b126sm48257008pfa.177.2019.09.04.04.49.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Sep 2019 04:49:35 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, magnus.karlsson@gmail.com,
        bpf@vger.kernel.org, jonathan.lemon@gmail.com,
        syzbot+c82697e3043781e08802@syzkaller.appspotmail.com,
        hdanton@sina.com, i.maximets@samsung.com
Subject: [PATCH bpf-next v3 2/4] xsk: avoid store-tearing when assigning umem
Date:   Wed,  4 Sep 2019 13:49:11 +0200
Message-Id: <20190904114913.17217-3-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190904114913.17217-1-bjorn.topel@gmail.com>
References: <20190904114913.17217-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

The umem member of struct xdp_sock is read outside of the control
mutex, in the mmap implementation, and needs a WRITE_ONCE to avoid
potential store-tearing.

Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
Fixes: 423f38329d26 ("xsk: add umem fill queue support and mmap")
Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 net/xdp/xsk.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 271d8d3fb11e..8c9056f06989 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -644,7 +644,7 @@ static int xsk_bind(struct socket *sock, struct sockaddr *addr, int addr_len)
 		}
 
 		xdp_get_umem(umem_xs->umem);
-		xs->umem = umem_xs->umem;
+		WRITE_ONCE(xs->umem, umem_xs->umem);
 		sockfd_put(sock);
 	} else if (!xs->umem || !xdp_umem_validate_queues(xs->umem)) {
 		err = -EINVAL;
@@ -751,7 +751,7 @@ static int xsk_setsockopt(struct socket *sock, int level, int optname,
 
 		/* Make sure umem is ready before it can be seen by others */
 		smp_wmb();
-		xs->umem = umem;
+		WRITE_ONCE(xs->umem, umem);
 		mutex_unlock(&xs->mutex);
 		return 0;
 	}
-- 
2.20.1

