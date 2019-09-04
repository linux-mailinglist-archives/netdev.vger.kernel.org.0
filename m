Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F75FA7CEE
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 09:40:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729060AbfIDHkv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 03:40:51 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:44049 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725267AbfIDHku (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Sep 2019 03:40:50 -0400
Received: by mail-wr1-f66.google.com with SMTP id 30so9105445wrk.11
        for <netdev@vger.kernel.org>; Wed, 04 Sep 2019 00:40:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5b6TPM5eiQFK15d5tzfX/l4e96iBteUT3XLgPo6At4M=;
        b=RR6HwOd2T0Te9CgD9h+Cg/EyogNJfyKCMP4gIxREW/AqqhfMDN8UcmCcs7Lqi7cHZb
         Lhf2ZrtOsGNEzV02EJ6LR33Rn+MzLKsynTUF/Y8nkHPwun4AoFG/2mv4p1GTT6OykeJk
         kKVyZruoz08ZV1NhDSLN4MqR0pOZIbeymzwnPKVlGU+KATmdru7gUirlmpRE0Ix5IXmi
         Utl9mRN0jgaJAM/5FWxXmjEZKEr/rQsacsuxX+eD6SIFk17EMxZZsP4iEKswY6gvOHpB
         kZxxyrS8u4d22WpblMCjkXT4DXG+sG740vE7JW4XLT/moDlLyzfnqSlV/t+RTSUG1QhF
         yidA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5b6TPM5eiQFK15d5tzfX/l4e96iBteUT3XLgPo6At4M=;
        b=qYtqBaErBVWCQQuOHrhtldI9Lp7wAGemBZxf1rYEkQ0EvU7T4lf6NvUAQ9xDoVMDhN
         z/DeVA1VUt9IMkVGjJouGGxkR4eU/cYdn+UIwElw/i7rD7hkDT2YOgBu56G6zzphN6HV
         x3cfQJgee4rl/EUYuLjq+f2Pdb9J6EqZv7jWoRmPujiE/3hxV/BO5+xonlhkcI0PpFC0
         g+gtmeuUePgH6kgceP4sNVgfsZ94AWboLxP/7cSZS5ZJInIcAGPsRTuGpdipucA+h6nm
         /qbwHjvHva3hdQoUtLPY5yrI3lZ4h7o087yFa23grcFaaiGS4/gy0HYNX9tt5El8i+Uf
         TyZQ==
X-Gm-Message-State: APjAAAW1AF7Gfi8RipOj7VizZsBT3HU8JFrelWZVsYdwe4Lgqj0bp2xG
        XVCI5c7ztf17oQtdFix+eJXhMkAE9w0=
X-Google-Smtp-Source: APXvYqysQ6z6G9rSZJ4NppyNNQ2HFdIpeMWDXKTvkxOamjTo3LNgroWxJt3xjDgkwsC2Lw7/nPIYSw==
X-Received: by 2002:adf:fc8a:: with SMTP id g10mr36764693wrr.354.1567582848663;
        Wed, 04 Sep 2019 00:40:48 -0700 (PDT)
Received: from localhost (ip-78-45-163-186.net.upcbroadband.cz. [78.45.163.186])
        by smtp.gmail.com with ESMTPSA id a130sm4286160wmf.48.2019.09.04.00.40.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Sep 2019 00:40:48 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, mlxsw@mellanox.com
Subject: [patch net-next] rocker: add missing init_net check in FIB notifier
Date:   Wed,  4 Sep 2019 09:40:47 +0200
Message-Id: <20190904074047.840-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Take only FIB events that are happening in init_net into account. No other
namespaces are supported.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/rocker/rocker_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/rocker/rocker_main.c b/drivers/net/ethernet/rocker/rocker_main.c
index 2c5d3f5b84dd..786b158bd305 100644
--- a/drivers/net/ethernet/rocker/rocker_main.c
+++ b/drivers/net/ethernet/rocker/rocker_main.c
@@ -2189,6 +2189,9 @@ static int rocker_router_fib_event(struct notifier_block *nb,
 	struct rocker_fib_event_work *fib_work;
 	struct fib_notifier_info *info = ptr;
 
+	if (!net_eq(info->net, &init_net))
+		return NOTIFY_DONE;
+
 	if (info->family != AF_INET)
 		return NOTIFY_DONE;
 
-- 
2.21.0

