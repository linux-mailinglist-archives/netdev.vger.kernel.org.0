Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D38665F426
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 20:14:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233074AbjAETOD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 14:14:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231845AbjAETOB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 14:14:01 -0500
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACF1B5F90A
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 11:14:00 -0800 (PST)
Received: by mail-qt1-x833.google.com with SMTP id h26so30762070qtu.2
        for <netdev@vger.kernel.org>; Thu, 05 Jan 2023 11:14:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=jx8wWSmdZF46fLp2xJQ84d9FbvxNjuK6kzk2sE4jYw8=;
        b=eH3PNrd0uCMDPFSSjUzShwPRuK5k8B/5za5aKsc+4wWYH5tD0yV2oZ8ZocIqZ3Y/Bd
         xxMSEm1ECa5E9yhiMjlIdetsRnA9mqwDiLNFg3n9FxZ2ygLNxdlLXEmeWKe9LBfsCpvH
         s+IATvyka7DZULkRY9jQPj7eJe+Fdcxl61vT3lC9H0tXlomKoHoa1vr7v4F6l0U8tpTj
         8VAhheOYYxvY/C0qe11O6LwYviWLJv0eBBaBv0K5bojgHr1OS36yUE2LswC6hAe6M3Vm
         JqGLN/g9zsedhgnXSxBzCJg7c7yVJXDIEuocGGC+GyKxreGtABrftEtTFiz6AN9qX+7q
         XkLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jx8wWSmdZF46fLp2xJQ84d9FbvxNjuK6kzk2sE4jYw8=;
        b=FDEPtp08HmDjy/7fBn9JPw6vDr8KeqtL1DyVBrVKPy1va5vINjBIoVlpU2WX3lTX3Y
         R5CD4NW8lpC6aRAgFnfIOIj/7eZW6dZ8V7QQxoMB+qfsefqOeNdYjing3H7PDxl8OTj+
         iWoHkjDda5T+ygmNE3irGUXEjF0+tNzYnsw4vx7RqzkxMc6eNqnG4BucrNoszFgCCC3i
         cYCrMo05UStqLo7si0IRBwSUnGTrwnrTRKk8QXrJC/3lcj5v3IryFwCDTvLmyISwX8D/
         mxPkZZ6byYRzPoT+yJJSbTQ6RUMXDh1HAKKgC/Gd71G50PXWQn+yyFNsGBCwSxHbdQEB
         SOYA==
X-Gm-Message-State: AFqh2koMPWGmXtDEVOLBZ/R14gXpHPMsqBhUTenW/Ov2tmFE8+S0lSmU
        Y1zKdi3nNgvO1qV2mh2Uw0ol0Eop0Bk=
X-Google-Smtp-Source: AMrXdXsFvG4oCM38gMNbjq49LYfLNzsBPRWQ6U4U/KevRRUPC3AhzrJ/xQhdxboCNXIHsPNht94UHw==
X-Received: by 2002:ac8:6742:0:b0:3a8:5d1:aac0 with SMTP id n2-20020ac86742000000b003a805d1aac0mr73101574qtp.16.1672946039535;
        Thu, 05 Jan 2023 11:13:59 -0800 (PST)
Received: from pop-os.attlocal.net ([2600:1700:65a0:ab60:2455:1dfe:a46b:fd61])
        by smtp.gmail.com with ESMTPSA id 195-20020a370ccc000000b006fec1c0754csm25721804qkm.87.2023.01.05.11.13.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jan 2023 11:13:58 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     g.nault@alphalink.fr, Cong Wang <cong.wang@bytedance.com>
Subject: [Patch net 0/2] l2tp: fix race conditions in l2tp_tunnel_register()
Date:   Thu,  5 Jan 2023 11:13:37 -0800
Message-Id: <20230105191339.506839-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

This patchset contains two patches, the first one is a preparation for
the second one. Please find more details in each patch description.

I have ran the l2tp test (https://github.com/katalix/l2tp-ktest),
all test cases are passed.

---
Cong Wang (2):
  l2tp: convert l2tp_tunnel_list to idr
  l2tp: close all race conditions in l2tp_tunnel_register()

 net/l2tp/l2tp_core.c    | 116 +++++++++++++++++++++-------------------
 net/l2tp/l2tp_core.h    |   3 +-
 net/l2tp/l2tp_netlink.c |   3 +-
 net/l2tp/l2tp_ppp.c     |   3 +-
 4 files changed, 68 insertions(+), 57 deletions(-)

-- 
2.34.1

