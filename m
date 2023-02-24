Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DD156A213A
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 19:11:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229739AbjBXSLr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 13:11:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229738AbjBXSLo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 13:11:44 -0500
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A8B767E37
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 10:11:43 -0800 (PST)
Received: by mail-ot1-x32f.google.com with SMTP id q11-20020a056830440b00b00693c1a62101so140247otv.0
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 10:11:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=6TN2Vq7Nx89GGqysvUFb0B4jQFFteKk5MBEsgfPPHBY=;
        b=3PkRgxQxw7ty6a8AayBrlQA9yXcw5Gy2X2IsOzvfk+T6itq8fc7eT1cK9sdWoEXU14
         rYs/EuzBTVWcO0A7g9i09QCiDnsGwzgjlcISjp63YaS0mzNS5Df3BTUkccK8DBbvxnDr
         wm2jaJ4QJoKdbsT3/djmNia2kEQ1r9ferw+fuIwl0cjiQzCmTxI40h1e7ou5rRCxfbmC
         YRXChrtLSTyIV5McowwtpjxsbKPZG9YkFlGg81Fy2rcmENP+gnIpSZESD/MloUasvCRe
         vglOmlkzhHsVMhXc5l5/5rDg8TkZDobqpSzOaK1R7Pil1yuZDW6TO0o3QAmR1fptisHt
         WsQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6TN2Vq7Nx89GGqysvUFb0B4jQFFteKk5MBEsgfPPHBY=;
        b=8BRa9erF8eJi7gVmfzDTKpFbkME//4Z01LaE08OaW3Js6WFqAZuexb28d2iVOdvXs1
         HoQvGWPOLAOrcEzxdR1himCi5EYSS+kOVhK6YJFQ/j3MVGbwJPTMupj1YYPo4mUCOIqX
         dXG9PhnW6gdyNqImhtxuqoGyXRI51UJFFeV1QVmcLt9XgxHGLkDECYhIUYofS0r76nDl
         yAg/qSE/i+GclL8noq8XyTFn0EG03ZWjcNQpGXE8kufTtPpjgeYLFL6IsC+QvBWOl0pV
         0DINfWwfpyASENd4mu6wElYb19XaqJGolMcZh3ZBF9o4/h3fx1qDd1kwwpVX9X8Iq2HU
         Wyzg==
X-Gm-Message-State: AO0yUKUZPwvTsl1XHJZ384BKyRWafAvmietp7Kb+auoOxkSxS13byHDi
        CABA+FrMvAeNGAMrlv1guTnZQlaEAcwokDVZ
X-Google-Smtp-Source: AK7set9BCepOM3B1yHhS2ShUdy4EDGODuz5uwI0IIjTUHXmx8IIweUdDU5qxTX22M0CkU2t7rkxCyg==
X-Received: by 2002:a05:6830:3896:b0:690:d198:4d1e with SMTP id bq22-20020a056830389600b00690d1984d1emr292336otb.8.1677262302826;
        Fri, 24 Feb 2023 10:11:42 -0800 (PST)
Received: from localhost.localdomain ([2804:14d:5c5e:4698:aecd:86a3:8e0c:a9df])
        by smtp.gmail.com with ESMTPSA id y7-20020a9d5187000000b0068bb7bd2668sm4040827otg.73.2023.02.24.10.11.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Feb 2023 10:11:42 -0800 (PST)
From:   Pedro Tammela <pctammela@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH iproute2 0/3] tc: parse index argument correctly
Date:   Fri, 24 Feb 2023 15:11:27 -0300
Message-Id: <20230224181130.187328-1-pctammela@mojatatu.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Following the kernel side series, we fix the iproute2 side to parse the
index argument correctly.
It's valid in the TC architecture to pass to create a filter that
references an action object:
"tc filter ... action csum index 1"

Pedro Tammela (3):
  tc: m_csum: parse index argument correctly
  tc: m_mpls: parse index argument correctly
  tc: m_nat: parse index argument correctly

 tc/m_csum.c | 5 ++++-
 tc/m_mpls.c | 4 ++++
 tc/m_nat.c  | 5 ++++-
 3 files changed, 12 insertions(+), 2 deletions(-)

-- 
2.34.1

