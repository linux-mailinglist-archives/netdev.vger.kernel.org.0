Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF3FB6914D2
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 00:44:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbjBIXoh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 18:44:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbjBIXoc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 18:44:32 -0500
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F06AC7A93
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 15:44:26 -0800 (PST)
Received: by mail-qt1-x82f.google.com with SMTP id cr22so4084361qtb.10
        for <netdev@vger.kernel.org>; Thu, 09 Feb 2023 15:44:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=l53p5P01ANnJfUYRvul6gmzJs5ytIghZ7TEeveoU6WA=;
        b=N/BmZFwHKy3Hk19SkAiJRW6v9YCe2gXCQJLsnS1jXMy8CSWpZrsf/dHCu2dRCyKuph
         pSExpkujW+PBPgoOoA6P6F8sLNMXa3vuBF5IpkZOE0dJS+fAJNoT77Iv8TV2dj9xBcIs
         av0ym18kPKiRthcV1swnW1S96OxuvEnkXTHXv47K+Fx6933zNXsOS4CvjaSzI88cjCVK
         M1UCiajjZcDXnK+RvptQNV89SGGG3JwtYSRRFouIOrRJw478HuDZL8/75oNUU+R4gNWW
         3ITAPzibFV3fWd5TW+gAP06ZUmxINnsQRNPUeEOcrmrEy//4H8SOVrzJT65mY+UZGPoG
         oa3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=l53p5P01ANnJfUYRvul6gmzJs5ytIghZ7TEeveoU6WA=;
        b=HcbAWjNexQW08xQquu3wpEUXauNsOzAXiG8RUrrjgQc/SGjWB2g7Drjv9T9t6OePek
         +SWkZMEY49bQws9GNDOHdhKWiQSL2D7RHuRaAsCwVi1ltmykE50Pfh63Q00+Zyq/QX4m
         4mhWVzDXYy+vr8TIM+YKp1yA+AcCAgjso0UQNTQtE7Wa4v0G44vuwQLJEwzOtEaXXVbw
         R4svj4asrJroKz9gvsP78eT7MYXSENnniCydP4+8sFXHUOzUXSpMGJEG+zYvBef9asRY
         vr0Ns21PLf/pmSFgRXy5xKXFAigV9t6vpPBXiN2LxrhUCyf4GFK76Nh1AJTXkYRCTVGz
         MRwg==
X-Gm-Message-State: AO0yUKWDorgCESLMgXekNsJCCEpXV8Abo+ejeAlkCNGQz5WxxNVWwkkD
        /+Kftc2FvLmpV0VirCnNw7MgEnl7qkY=
X-Google-Smtp-Source: AK7set8BGYpRLXjfl4HVIydSaM4jR3DV8QrZ+5nTqYfpYG4qzY3R55sCGizNjT3gd7QhPwNXSNDW5w==
X-Received: by 2002:a05:622a:d6:b0:3b6:2dc7:de7d with SMTP id p22-20020a05622a00d600b003b62dc7de7dmr23548149qtw.22.1675986265933;
        Thu, 09 Feb 2023 15:44:25 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id y19-20020a05622a121300b003bb822b0f35sm2197808qtx.71.2023.02.09.15.44.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Feb 2023 15:44:25 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, stephen@networkplumber.org
Cc:     kuba@kernel.org, Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH iproute2-next 0/2] iplink: support IPv4 BIG TCP
Date:   Thu,  9 Feb 2023 18:44:22 -0500
Message-Id: <cover.1675985919.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
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

Patch 1 fixes some typos in the documents, and Patch 2 adds two
attributes to allow userspace to enable IPv4 BIG TCP.

Xin Long (2):
  iplink: fix the gso and gro max_size names in documentation
  iplink: add gso and gro max_size attributes for ipv4

 ip/ipaddress.c        | 12 ++++++++++++
 ip/iplink.c           | 22 ++++++++++++++++++++--
 man/man8/ip-link.8.in | 36 ++++++++++++++++++++++++++++++------
 3 files changed, 62 insertions(+), 8 deletions(-)

-- 
2.31.1

