Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F6814B14BD
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 18:58:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245398AbiBJR5M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 12:57:12 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243640AbiBJR5M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 12:57:12 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 456131A8
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 09:57:13 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id y8so8867327pfa.11
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 09:57:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=brZ7E8bWkXQsWSbcGS1/eXgCwN8cUBy7+41KZe2l7Mw=;
        b=VC7TEU/PevAB5bECNHH6JfN0kpRV6OymHR78fbOoxIuGL8kkvwjn1UvrKeLLftl3uZ
         Thj97E0q0V3sWDZAG11azXV9IAT9m+DDw0yc1D2747ys60qwZTMUnlKX9SHx1U3ywypG
         S2ZbAWrVRbQyVbKhHmoPWFMQ9sdnRKJ46UC4JQwvytaoL56pJUT6Ro0LIwyskOF+YXk7
         NoTkTlMYA/9Y4SNdj0MQRVhBw3//NMvwEmD7aBYey9zjaSTO/1sNkEeQ4iuz0KL+Z9tf
         RMLLQu9TLVCAOICQL6tdnIV43l042Zsq3+GVW9fJi+fPXNRuFR5FxQ5cmFlWPJr6RT7m
         DWxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=brZ7E8bWkXQsWSbcGS1/eXgCwN8cUBy7+41KZe2l7Mw=;
        b=NuPdJO0DRRk3I8kOP9LCbkdyC3CipdYJij9Z7DVOt7TU6cvZze3gZOY1xjzpGxKYPU
         F8aifbMqfWZ87UhepDYs+jJ4Lmd3gVhN63MExElFU30m+kw7c4RoV+mUUxoUYsd1EZRj
         ccTcB+ydqSlZfJJbiRTTg0n4dutLJylHwECmJQufRxKOIAVAd9p3QU2tsJ+btBtvceun
         XBKAeRyOiIQVJ0xFDP7k98Q2z5+7u4NKiw4kOmAtjxE3gpZSuZ2ewM09IGN8chbCeGKg
         EiGu+6hFeBapoNRLmASR3rPT7B+CWqjSzU+e50PwafLzFLV4HX+wJ88qWqDQSUNjpqPB
         r/TQ==
X-Gm-Message-State: AOAM531qYjjb5bw4K4QW2NqOdnHsj7CU7LrKCZWQQJzAfXn4MCy20yeN
        gfYJQTnqawq5dCRvWHmakAdmn69oAag=
X-Google-Smtp-Source: ABdhPJwi1XYEpuTT4T439QlXkqniXR29O0zaY/bvqsovswEM5vJJTbJZJhYeuT+7JHBhGTfSSHVoKQ==
X-Received: by 2002:a05:6a00:1253:: with SMTP id u19mr8686369pfi.8.1644515832843;
        Thu, 10 Feb 2022 09:57:12 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:c3d8:67ff:656a:cfd9])
        by smtp.gmail.com with ESMTPSA id t3sm26230634pfg.28.2022.02.10.09.57.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Feb 2022 09:57:12 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Coco Li <lixiaoyan@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 0/4] net: make MAX_SKB_FRAGS configurable
Date:   Thu, 10 Feb 2022 09:55:53 -0800
Message-Id: <20220210175557.1843151-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.1.265.g69c8d7142f-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Increasing MAX_SKB_FRAGS was a patch in BIG TCP v1 submission.

It appears this might take time to validate that all drivers
are ready for this change.

I have removed from BIG TCP series this patch, and made
a separate series.

MAX_SKB_FRAGS is now configurable (from 17 to 45),
and the default is 17.

Eric Dumazet (4):
  af_packet: do not assume MAX_SKB_FRAGS is unsigned long
  scsi: iscsi: do not assume MAX_SKB_FRAGS is unsigned long
  net: mvpp2: get rid of hard coded assumptions
  net: introduce a config option to tweak MAX_SKB_FRAGS

 drivers/net/ethernet/marvell/mvpp2/mvpp2.h |  6 +++---
 drivers/scsi/cxgbi/libcxgbi.h              |  2 +-
 include/linux/skbuff.h                     | 14 ++------------
 net/Kconfig                                | 12 ++++++++++++
 net/packet/af_packet.c                     |  4 ++--
 5 files changed, 20 insertions(+), 18 deletions(-)

-- 
2.35.1.265.g69c8d7142f-goog

