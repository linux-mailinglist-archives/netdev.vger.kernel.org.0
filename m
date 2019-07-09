Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A67B962E5A
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 04:54:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727329AbfGICxw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 22:53:52 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:41131 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727314AbfGICxw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 22:53:52 -0400
Received: by mail-qt1-f193.google.com with SMTP id d17so18785685qtj.8
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 19:53:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=buM4nX/lAX5LxNyvW/+RQDfle6M/6Mlaalt7mycbLBA=;
        b=YHKuApxl2XjEWZNdnUPesFqNeU+Lh2ry3OefsA0gzEL+/QiiUOW+k5q48nE0sYwayH
         SYHketr1Qcb4tSTL0/sUG4jrWxEiYZfqUKrgKQvohrLR3u4VnogCPmPc3FX2lpUwb3QA
         58zAuEw/qb/QZbZtMDESky7rQI4u7b0o/JBiaQGPqJ2C+bHMQsJkl3Y58hhZ/lL7AvyY
         C9qDOQYKFWshnKcuoAVwki1ZhqZNhlWrUpaq9x32+BPVgUFUuhJCt73dQPKFRMsQe+CB
         Du1bd536MUWcN2EfszKiDoY91sziVBcbgcJDAFg+9v/dky2J5zfp2OpGDVm6c5gorF3v
         1wJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=buM4nX/lAX5LxNyvW/+RQDfle6M/6Mlaalt7mycbLBA=;
        b=dIqL57699TErSNoxu6N7wM4CX61fijCxDJ/WelCoxBc7taYGwiFOqyiWY5OMD7jvpa
         9rVVOcwRQgQqZczezyOmJ+7dg/7Ae41COc4ROrL57pU33GnrfP2iPMGk19pVCD8yKZ77
         VWei0SlHyFJAOUqj1O12feBXOfh+KBAK+CD/4WroS4rFsnnRTOcx/HwnSBVjW/QGCIHj
         JPiXZKGIFlTdUIdUlwT86Ai0B15te48ohHfxE4HHr9SZa9rfSAPBW5tbanW+uWBUS5Ux
         2mpBmICcuXHzNMnX5ijtWG/+BDt5HU+xG2CeODxJSDkuFHYKqThack44vWPfSXvnlmLG
         zcKQ==
X-Gm-Message-State: APjAAAX2qF0YM1ePxWHgJR7In2IGsTEKpPwvZ3//3Xmftvw6wRK04KZB
        PY5E2yd07rSIE9xw/wtUa84J4pCttps=
X-Google-Smtp-Source: APXvYqzg0HTD5HcSUTNBJy6PicURlAVuKN4X3nvtJ9FyTLrM0EX3boVp5fLE+L8rm2BmwoMf0JVXag==
X-Received: by 2002:ac8:7104:: with SMTP id z4mr16592228qto.52.1562640831372;
        Mon, 08 Jul 2019 19:53:51 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id g13sm8148837qkm.17.2019.07.08.19.53.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Jul 2019 19:53:50 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        alexei.starovoitov@gmail.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Subject: [PATCH net-next 05/11] nfp: tls: count TSO segments separately for the TLS offload
Date:   Mon,  8 Jul 2019 19:53:12 -0700
Message-Id: <20190709025318.5534-6-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190709025318.5534-1-jakub.kicinski@netronome.com>
References: <20190709025318.5534-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Count the number of successfully submitted TLS segments,
not skbs. This will make it easier to compare the TLS
encryption count against other counters.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
---
 drivers/net/ethernet/netronome/nfp/nfp_net_common.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index 270334427448..9a4421df9be9 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -880,7 +880,10 @@ nfp_net_tls_tx(struct nfp_net_dp *dp, struct nfp_net_r_vector *r_vec,
 
 	if (datalen) {
 		u64_stats_update_begin(&r_vec->tx_sync);
-		r_vec->hw_tls_tx++;
+		if (!skb_is_gso(skb))
+			r_vec->hw_tls_tx++;
+		else
+			r_vec->hw_tls_tx += skb_shinfo(skb)->gso_segs;
 		u64_stats_update_end(&r_vec->tx_sync);
 	}
 
-- 
2.21.0

