Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D00245F17F8
	for <lists+netdev@lfdr.de>; Sat,  1 Oct 2022 03:07:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233129AbiJABHN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 21:07:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233165AbiJABGq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 21:06:46 -0400
Received: from mail-pf1-x462.google.com (mail-pf1-x462.google.com [IPv6:2607:f8b0:4864:20::462])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90E83141B13
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 18:02:39 -0700 (PDT)
Received: by mail-pf1-x462.google.com with SMTP id a80so5612881pfa.4
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 18:02:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:message-id:date:subject:cc:to:from
         :dkim-signature:x-gm-message-state:from:to:cc:subject:date;
        bh=975yxtLp4mG5EqALM6a2Zs4xoum0EiIXsp3+otaUT9U=;
        b=UuMxt0VyjhB+pwIgd9c739LGhTsPS8qhkHdjrxtNb+RK3S1zCWh80pbYSuiGBsYHTU
         pp3gRpSL6SRrnJvjAOzfG+XvaUNijrKsG15Pfo2RugNLxiKx1zkre0N8cK8s/4r+UR0Z
         qEP+xYVd9JQkNIfhGaT7+T4lE1YHROuoZ5jo7hW47VTmwN/L2WW/OzxXY8qLaMRQJdDB
         h45z/PyE048oy0X7yIFLLceGu8yzFhy0SjvHLdgM+naQNV9Jjt9GaehBgmwuReVHYOe4
         91/vlLp9iAxJ5AWVTbUBINC5eZBU25jaUB17U2306w5Fm4cY/bnC2MguOzIZ0E0rC9Yg
         Io/A==
X-Gm-Message-State: ACrzQf3lpCKaT8Pm/xPZKws0yw6LkbgPOCVj1tsijo/RtwSzSc18waGO
        IVN0b0z9GzqP96sZZfD7oRolQOLcRM/Xv2oR8vJi9d0df2Ic
X-Google-Smtp-Source: AMsMyM5a/0A2bZd6QBnYJlbBx+J+8VhIoDaOlNfiDFMXNOF/7V0AwiZwprR4k8pFIxGV9Yl7brdXnLZEFgXw
X-Received: by 2002:a05:6a00:1990:b0:545:aa9e:be3d with SMTP id d16-20020a056a00199000b00545aa9ebe3dmr11672411pfl.59.1664586123955;
        Fri, 30 Sep 2022 18:02:03 -0700 (PDT)
Received: from smtp.aristanetworks.com (smtp.aristanetworks.com. [54.193.82.35])
        by smtp-relay.gmail.com with ESMTPS id je17-20020a170903265100b00179fece74bdsm91369plb.61.2022.09.30.18.02.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 30 Sep 2022 18:02:03 -0700 (PDT)
X-Relaying-Domain: arista.com
Received: from chmeee (unknown [10.95.71.70])
        by smtp.aristanetworks.com (Postfix) with ESMTPS id 7BD81301BD60;
        Fri, 30 Sep 2022 18:02:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arista.com;
        s=Arista-B; t=1664586123;
        bh=975yxtLp4mG5EqALM6a2Zs4xoum0EiIXsp3+otaUT9U=;
        h=From:To:Cc:Subject:Date:From;
        b=X0XY1NcyoLDVDZoGtgkw3Tff5sOg7HOprbfAn6PdDYIzMclwC8uaBKHHevkhDzgf+
         jGYxz2vvib0towwM/ZBOsJ0A2j3vzaf5AmTUyYNnYnaAqvtxwqDcMu6wWjWiDexiEn
         ZbEdPdWbSUSKztjQaecNxMRlG175F1UscpOUJcj8=
Received: from kevmitch by chmeee with local (Exim 4.96)
        (envelope-from <kevmitch@chmeee>)
        id 1oeQtG-00180f-06;
        Fri, 30 Sep 2022 18:02:02 -0700
From:   Kevin Mitchell <kevmitch@arista.com>
Cc:     kevmitch@arista.com, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Antoine Tenart <atenart@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] netdevice: don't warn when capping txqueue 0
Date:   Fri, 30 Sep 2022 18:00:41 -0700
Message-Id: <20221001010039.269004-1-kevmitch@arista.com>
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With commit d7dac083414e ("net-sysfs: update the queue counts in the
unregistration path"), we started seeing the following warning message
during our stress test that streams packets out of a device while
registering and unregistering it:

et3_11_1 selects TX queue 0, but real number of TX queues is 0

The issue is that remove_queue_kobjects() is setting real_num_tx_queues
to 0 before the last few packets are queued. When netdev_cap_txqueue()
is called to cap queue = 0, it emits this message.

However, when queue == real_num_tx_queues == 0, this message doesn't
make much sense because 0 is the fallback value returned
anyway. Therefore, omit the warning when queue is already the fallback
value of 0.

Fixes: d7dac083414e ("net-sysfs: update the queue counts in the unregistration path")
Link: https://lore.kernel.org/r/YzOjEqBMtF+Ib72v@chmeee/
Signed-off-by: Kevin Mitchell <kevmitch@arista.com>
---
 include/linux/netdevice.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 05d6f3facd5a..3fd1e50b6bf5 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3493,7 +3493,7 @@ static inline void netdev_reset_queue(struct net_device *dev_queue)
  */
 static inline u16 netdev_cap_txqueue(struct net_device *dev, u16 queue_index)
 {
-	if (unlikely(queue_index >= dev->real_num_tx_queues)) {
+	if (unlikely(queue_index > 0 && queue_index >= dev->real_num_tx_queues)) {
 		net_warn_ratelimited("%s selects TX queue %d, but real number of TX queues is %d\n",
 				     dev->name, queue_index,
 				     dev->real_num_tx_queues);
-- 
2.37.2

