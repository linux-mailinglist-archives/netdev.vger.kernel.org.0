Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC7EC557D88
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 16:08:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231454AbiFWOIa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 10:08:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231854AbiFWOI2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 10:08:28 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6DA440923
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 07:08:24 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id 7-20020a9d0107000000b00616935dd045so1863461otu.6
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 07:08:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kYiXwJu1PcNbNFmcQLg6x4MDnyhq9CHQJEk0yviFzM0=;
        b=yFNPNGkWBcBoTpdbOGmS9JYP0BHWEE7VX4iJjQeGXrLVR9LfKhle6nZw+prXSNvC+a
         J3z0h+bVfdnlgckmw+0YgnuZMxgwp1jzqLXL7Mc73FC23W8u0lSDLM5cvKO4NJ+MNbtM
         RmcLNmohERhZ9EiWrwIhz7VugCjO2Ius0mFb2klmtr9nfmZBATpkujurwxZ8SyEb7bBk
         VXLsH4QJs1cRFIDl5RWy8xARtyy2W6VdfsLUmSfYPlSR8Muf+fDRq0k9VBRv5TqdTcFZ
         BDEQ2NO5keIOwEWJnBTfx+PEyRWyojN+DGBMlvlBRRchBqJF5gi/elh5b/QtLV+n6TKk
         zqZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kYiXwJu1PcNbNFmcQLg6x4MDnyhq9CHQJEk0yviFzM0=;
        b=2rTpvFE/MQJ9lHnWFahA2WtcbAI2sS62iDZh6hrhIrjVhW9ckH3bydy/j75xPWUxkE
         qDPdWr+10P3iBQ7T/P6tJteazCcdWPPMaNiIzIC+uEZq8M9XvBESbcBlCYCr+KLj3UFJ
         ZJxvL9+6GUbLktPyT5fUuE/MAyZlnk3+fP8R3l+6bDiKyt9ikPjWv7QbpiqCCjXhQtfy
         az6fmjPxcfgueGU6SW+yo7yrFkAQIwUzkOSzh9sBsg0w8TCx41m4pWVCjbVYP5MsLkNy
         PnR9BsBn+jzPUFS9M470SvB0kwwQRstrrDC/k1QCAmxvu6lKy1S0sxstkEOLDX8QhZl6
         cA5g==
X-Gm-Message-State: AJIora+ggCeU6CJNTPIWIhBDMBMdQEQDdUH2a4XTBVjE7SYzl0yzalAc
        coGTiKI7gmUWspp1QB7JP1nOQw==
X-Google-Smtp-Source: AGRyM1udML7qXdnxtvG5SPwQWdwfh3b4JGDGMhQJH5t4M36425eILwpi0MCos7uqELsyuw8IdAKBxg==
X-Received: by 2002:a9d:71cc:0:b0:60c:ae:19ff with SMTP id z12-20020a9d71cc000000b0060c00ae19ffmr3742863otj.302.1655993304078;
        Thu, 23 Jun 2022 07:08:24 -0700 (PDT)
Received: from localhost.localdomain ([2804:1b3:7002:4b2f:1099:d9a9:ed70:bc8f])
        by smtp.gmail.com with ESMTPSA id c83-20020aca3556000000b0032b99637366sm12760903oia.25.2022.06.23.07.08.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jun 2022 07:08:22 -0700 (PDT)
From:   Victor Nogueira <victor@mojatatu.com>
To:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        jiri@resnulli.us, Victor Nogueira <victor@mojatatu.com>
Subject: [PATCH net 0/2] Notify user space if any actions were flushed before error
Date:   Thu, 23 Jun 2022 11:07:40 -0300
Message-Id: <20220623140742.684043-1-victor@mojatatu.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series fixes the behaviour of actions flush so that the
kernel always notifies user space whenever it deletes actions during a
flush operation, even if it didn't flush all the actions. This series
also introduces tdc tests to verify this new behaviour.

Victor Nogueira (2):
  net/sched: act_api: Notify user space if any actions were flushed
    before error
  selftests: tc-testing: Add testcases to test new flush behaviour

 net/sched/act_api.c                           | 22 ++++--
 .../tc-testing/tc-tests/actions/gact.json     | 77 +++++++++++++++++++
 2 files changed, 91 insertions(+), 8 deletions(-)

-- 
2.36.1

