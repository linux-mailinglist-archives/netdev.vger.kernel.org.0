Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08B7866A8CF
	for <lists+netdev@lfdr.de>; Sat, 14 Jan 2023 04:02:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbjANDBx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 22:01:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229793AbjANDBu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 22:01:50 -0500
Received: from mail-oa1-x2e.google.com (mail-oa1-x2e.google.com [IPv6:2001:4860:4864:20::2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 462EF101C6
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 19:01:50 -0800 (PST)
Received: by mail-oa1-x2e.google.com with SMTP id 586e51a60fabf-15ed38a9b04so5604624fac.8
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 19:01:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=dVWq87rw91Y1IoyX0wMlW/Bgjv7DOBMy4dg06FL2lj4=;
        b=dhg7oAlvOf0vYCqGoG5tpLpH66sgCFzgyxgmxl43GSQL/B8lqpNwf4eADgcHtgpV26
         tMtdW3SQerpFDb6y4PV7Omyt06n71qMe083UYf3H6jV/LXbukBZEkEiOa7fA7KvgcIOU
         YVY9yDN++cgTKTIneXxhfrTqSohKhXAkyeIlsN7zM3wGQXTPwUGaXG7M/3cZgdKUdWUt
         AIMCMtO4+V/aei3QpfKmTFjV5B+kzALRmDMQnN6nf/F1ZrbUFnyRb8wPYhi8NRe/2uaR
         d6+DopNL4VyMFj9DrYk0HDBq5pBMYA8EujfopMbXwLXnrb0CKNUnlcgb8+UEfSVKr/So
         lwbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dVWq87rw91Y1IoyX0wMlW/Bgjv7DOBMy4dg06FL2lj4=;
        b=LmvF0XFCGJanWzocVZMYbz5bLGAr5G+amzMYboLi/ZwzcSgd6qV7qxZDbyQMG4pcT5
         itVINlBIlmtpyh2jEm5sVAJ3nvLi1BHu9WcXeMrpnDU5sZqD+c0649RFTffLGFArIPhS
         auyoH9Lu/mCODmUxRLbD6tjiGR73JA7CGPTPFGcKi52JtlULc5YXD0KuiJGjb47PAzCn
         Y0loDESSuKlDGqJ6bXcWBzVuVykBBsY7/54NUKXra4wJasPU8CzOtdpYi6prLWHtBQIc
         QTMmFLddELBZJ9roEwOVDw8M8qhYNsxmTzjlj0YBVf3igla3XYG8WXBrFelPoQ/I2i2K
         FCmg==
X-Gm-Message-State: AFqh2kpxc62SUyLtb+oUu5yqTlFjqpx17eDqm1YMhUpybUychftBZPvx
        UIeHvnMlZbpmpCRB4hjhbzpq50kUH1I=
X-Google-Smtp-Source: AMrXdXvGp2Yl2xVs0PV8sCp8p16IcYFBiZF+ADnjjykdYv1TKr85nYdkpZs53YhZWKk7CtubdNOMAQ==
X-Received: by 2002:a05:6870:3c8a:b0:15b:9fb0:864c with SMTP id gl10-20020a0568703c8a00b0015b9fb0864cmr9032471oab.19.1673665309287;
        Fri, 13 Jan 2023 19:01:49 -0800 (PST)
Received: from pop-os.attlocal.net ([2600:1700:65a0:ab60:dacd:7392:c8c1:daec])
        by smtp.gmail.com with ESMTPSA id m34-20020a056870562200b00143ae7d4ccesm11445568oao.45.2023.01.13.19.01.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jan 2023 19:01:48 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     saeed@kernel.org, gnault@redhat.com, tparkin@katalix.com,
        Cong Wang <cong.wang@bytedance.com>
Subject: [Patch net v3 0/2] l2tp: fix race conditions in l2tp_tunnel_register()
Date:   Fri, 13 Jan 2023 19:01:35 -0800
Message-Id: <20230114030137.672706-1-xiyou.wangcong@gmail.com>
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
the second one which is the actual fix. Please find more details in
each patch description.

I have ran the l2tp test (https://github.com/katalix/l2tp-ktest),
all test cases are passed.

---
v3: preserve EEXIST errno for user-space
v2: move IDR allocation to l2tp_tunnel_register()

Cong Wang (2):
  l2tp: convert l2tp_tunnel_list to idr
  l2tp: close all race conditions in l2tp_tunnel_register()

 net/l2tp/l2tp_core.c | 105 +++++++++++++++++++++----------------------
 1 file changed, 52 insertions(+), 53 deletions(-)

-- 
2.34.1

