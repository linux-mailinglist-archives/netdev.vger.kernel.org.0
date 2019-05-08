Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C99081827A
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 00:56:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727964AbfEHW4T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 18:56:19 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:41803 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727900AbfEHW4T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 May 2019 18:56:19 -0400
Received: by mail-qt1-f195.google.com with SMTP id c13so393545qtn.8
        for <netdev@vger.kernel.org>; Wed, 08 May 2019 15:56:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=h8amcR6f4wfxDDcwB9RdEAyFJJNj4SnHvd64KFD2gYE=;
        b=qRt6pf/Ko/Dzrx1cS3adcx9liRlm5r8Rasnj1vhD7YtxQiJL8ji3G1zRxxUvKny10C
         hTs1vprBqJ5ZOXpk/dQGAhoEjBrzJfyWXfx2XIKLQVMoSXGoVHzIuPmv3KsR0ygvzjXK
         oBev6oO+BVFbitfEy5lyE5v0q5qIjv0/+Q8l6b9T9X3hHX0A6iTwl+zZ6Svd/X3dtpMC
         v/kzHQeAbYwG+9hNAQxf+/C+9abS/bqtjBLMTbgA0ShUYZK0jvlSrsDYUmXOfaDst553
         4k/c/94lsg5oq6xwUG4n0h1J9Fy5UA23aRs9FMlU4UKeNMkTgby+G5sAzjITZHPV9S8p
         ra6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=h8amcR6f4wfxDDcwB9RdEAyFJJNj4SnHvd64KFD2gYE=;
        b=S7yuBMCHorg/x1lA0o/80WWNv9opzfniKUd80c/rA/1AoOVgRMmciXpeSMWEcKFNV8
         oWewPbAcjpDA8+8MLLqJ/oZ6e/RpWge6DTWr/+ppYIg0sUnwjY5mLOCYlpun+IvipwgA
         m1D67/8u9c4kOaEK7FuRIoln3AuuOifhTFmgWuIyy3OidoKLCUpcM2yXSXjlbPZClDaL
         T8xtzSciv4cJC3B8KkRQ1EnNA89lhTqCJiNWRObzbPhu65wXGYk9uDLmISHBc7SdgL8u
         Vg/s3sVz010MakG2E2tdZHQ1XzldqyHUA6R3nJvwS+lTlrCdfWXHX6nH2M2wBkMErxlr
         xDtw==
X-Gm-Message-State: APjAAAWYpo6Eb1JryjGfUdjSSc+8hmvA5SyVmqUUdltgyPztRcK3Fc4a
        keXwoXM7hDlYNxRgRV9mPoYOwg==
X-Google-Smtp-Source: APXvYqx5kNqcTDNaKURCQHkgbE8SwRJtAjsXIMUm2+laLG44NMy5fxvuftnlkpKKcdc/KkZi+FvWMA==
X-Received: by 2002:a0c:d015:: with SMTP id u21mr686566qvg.94.1557356178826;
        Wed, 08 May 2019 15:56:18 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id z8sm104429qth.62.2019.05.08.15.56.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 08 May 2019 15:56:17 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        jiri@resnulli.us, xiyou.wangcong@gmail.com,
        Pieter Jansen van Vuuren 
        <pieter.jansenvanvuuren@netronome.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH net] net/sched: avoid double free on matchall reoffload
Date:   Wed,  8 May 2019 15:56:07 -0700
Message-Id: <20190508225607.26052-1-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pieter Jansen van Vuuren <pieter.jansenvanvuuren@netronome.com>

Avoid freeing cls_mall.rule twice when failing to setup flow_action
offload used in the hardware intermediate representation. This is
achieved by returning 0 when the setup fails but the skip software
flag has not been set.

Fixes: f00cbf196814 ("net/sched: use the hardware intermediate representation for matchall")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Pieter Jansen van Vuuren <pieter.jansenvanvuuren@netronome.com>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 net/sched/cls_matchall.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sched/cls_matchall.c b/net/sched/cls_matchall.c
index 1e98a517fb0b..db42d97a2006 100644
--- a/net/sched/cls_matchall.c
+++ b/net/sched/cls_matchall.c
@@ -308,6 +308,7 @@ static int mall_reoffload(struct tcf_proto *tp, bool add, tc_setup_cb_t *cb,
 			NL_SET_ERR_MSG_MOD(extack, "Failed to setup flow action");
 			return err;
 		}
+		return 0;
 	}
 
 	err = cb(TC_SETUP_CLSMATCHALL, &cls_mall, cb_priv);
-- 
2.21.0

