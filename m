Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 940DF45764
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 10:20:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726707AbfFNIUn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 04:20:43 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:37156 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726381AbfFNIUe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 04:20:34 -0400
Received: by mail-pf1-f193.google.com with SMTP id 19so981845pfa.4;
        Fri, 14 Jun 2019 01:20:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5LHylaY5VKPZD8rk+dF82kF3y58VI8JtEPT7IjoFkYs=;
        b=INj7VTjh3UTvSvxSx+pQ06pJ/yxS6auA5JKxKdwHU+yiSupWy2K7gWenphYxz2nZWa
         QMnxaThrYyvM53OGFZOd0PVfpexaKA2VuPACNb3lKsxydEEKSMOWaopApsqPkH9HVnSZ
         FI1hcVQRQh+lbnpQSF9g0LkAtM1J/nWQFiK3i5JLwWs+vsEfGK5O5Ef3WZBvdjBKpQvl
         cg1CjuuSxKVG7uNdaQu9ElE4Cn0O7ep46+xjHrGV4TIZYTh+xctO+xf6bXY67gpagydl
         FNfmnvZz/aLFkCjBJ58fMRvWRS43kycgGl6w8YkiGxAc4/fBKqwHSqTvbppDd4DoR5Hi
         TiyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5LHylaY5VKPZD8rk+dF82kF3y58VI8JtEPT7IjoFkYs=;
        b=OkqvGOfbY7EprX5xCU5cDGDKTbpZCrt1POT4Cp3e2rX4b3qWnSJm2P+b54X8HCyHLz
         19OYP674pRxDw150RHxUFGt06Q8af9g/CBfqnCip7jo0oRtEsIop4kupvJf1aGEJAxJr
         wvJhZRDvzJuvLXFU77RWnBZ+Wl+gQJA69umpuopCOximjYuIkcshNmKHZvDSBK0GT2iM
         yZS4hLY3q2MBw+zHHROXutqGBlSG34hUDeDWMak2kWrKvheqEw2xf8WdzoNdCw9RvY56
         hNorSsYxELPzocvG+2KS78T8RWMxdodLigRGr+NpGl9No8olpCr93WpALTeusmwn6Tr9
         tcjQ==
X-Gm-Message-State: APjAAAVQw9kBMUYXeE7avLzU2B7VYWtG/hDNYCwhTfs0rukh23TXvOwf
        /Fd8YxqkFgKIwIXBtSBz8Ic=
X-Google-Smtp-Source: APXvYqz5h5VV5pjR5GJn8yTxx0bgbqWpaEQEsO1nMwrUZ50IACJBVvB2jvjVMCUMRyJ3vQezC8VwTA==
X-Received: by 2002:a17:90a:fa07:: with SMTP id cm7mr9493891pjb.138.1560500433731;
        Fri, 14 Jun 2019 01:20:33 -0700 (PDT)
Received: from z400-fedora29.kern.oss.ntt.co.jp ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id t18sm3352343pgm.69.2019.06.14.01.20.30
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 14 Jun 2019 01:20:33 -0700 (PDT)
From:   Toshiaki Makita <toshiaki.makita1@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Toshiaki Makita <toshiaki.makita1@gmail.com>,
        netdev@vger.kernel.org, xdp-newbies@vger.kernel.org,
        bpf@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH bpf 2/3] devmap: Add missing bulk queue free
Date:   Fri, 14 Jun 2019 17:20:14 +0900
Message-Id: <20190614082015.23336-3-toshiaki.makita1@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190614082015.23336-1-toshiaki.makita1@gmail.com>
References: <20190614082015.23336-1-toshiaki.makita1@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

dev_map_free() forgot to free bulk queue when freeing its entries.

Fixes: 5d053f9da431 ("bpf: devmap prepare xdp frames for bulking")
Signed-off-by: Toshiaki Makita <toshiaki.makita1@gmail.com>
---
 kernel/bpf/devmap.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index e001fb1..a126d95 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -186,6 +186,7 @@ static void dev_map_free(struct bpf_map *map)
 		if (!dev)
 			continue;
 
+		free_percpu(dev->bulkq);
 		dev_put(dev->dev);
 		kfree(dev);
 	}
-- 
1.8.3.1

