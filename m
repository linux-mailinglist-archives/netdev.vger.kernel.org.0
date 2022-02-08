Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 402644AD230
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 08:29:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348034AbiBHH3A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 02:29:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242843AbiBHH27 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 02:28:59 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88427C0401EF;
        Mon,  7 Feb 2022 23:28:59 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id g8so7542381pfq.9;
        Mon, 07 Feb 2022 23:28:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZpefNqf0BicbbFRRkSIzvUz/ffY2S1XepRcls6JuRXc=;
        b=jZRLSfpQJjrp5QXKiKDZACKE7HLZrL+BC1EbWDMnJYLSYKSf1RBPkveyvUbRj+BRBr
         u3en7OgrlA0ebUsZFz/9zPLCAxFCON1qFPlMHzmjy7El4pC8HyrFx+don82kT8j2OZLw
         Z5pMINOSlJx9HPzBdQCTwTH2CRHxqctE+uSbkJiKebzg79hnpB/dLB4R5qnM7DizMoRV
         u8VwU9Zre406YE7pv6dPSNtXps5fnh4aTYyzW8YD9TedPI3GVnwkM/flF2WloXpszQcO
         O/MApFze0xI+RsTCrZfTX5EREH+Uvlb3ooxMgatkx6xOtb3PAcaMUtssbftFvdrMkc3x
         uxiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZpefNqf0BicbbFRRkSIzvUz/ffY2S1XepRcls6JuRXc=;
        b=km3Z9smSINra5nP1qkGTF4IUwBH8eM959tOQxTdehv78mMNVo7EiLKHO/B1GHCK6/w
         utRoRX97WDTwRh/VE9OuA96PalyKSRH6i+vCEsH4yFeMgwuln6MsQk/2qYzJ+Zb2Cno4
         zStODQsJqWCBbr+R2Q3B1gnio78jQ/EeEPFqADRTxNM5ouDOrDh96j6MvFQdgwCp89b5
         LeaTIfU7MZmS6Ek7ZuCKb3i88ttINTEYpMwVoO7smmVkAhV8/7ApqJBQ18c7bsbmQb92
         TCtovleOHikTPgVJCoTCFil2ORFAMQlXcqQroIJnqA4A/q1UgmWRpB9t4IsGdzYhXC9i
         ItVw==
X-Gm-Message-State: AOAM531mNbOMY47mE1DUdMyI8H7GeMKdnV3Q7fs2Wn+PdRkwYcVSUa/u
        t8Wy8vCUosO/Jh9MCqMaNKs=
X-Google-Smtp-Source: ABdhPJyT/z+dPLJrYDrDt8q6hhklHGOM7Si53aN12vPdqfIj/whBJFBPBwQamiypt+LcZRTyTXJ5yw==
X-Received: by 2002:aa7:8484:: with SMTP id u4mr3104192pfn.70.1644305339002;
        Mon, 07 Feb 2022 23:28:59 -0800 (PST)
Received: from localhost.localdomain ([43.132.141.8])
        by smtp.gmail.com with ESMTPSA id n37sm435675pgl.48.2022.02.07.23.28.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 23:28:58 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     rostedt@goodmis.org, idosch@idosch.org
Cc:     mingo@redhat.com, nhorman@tuxdriver.com, davem@davemloft.net,
        kuba@kernel.org, imagedong@tencent.com, dsahern@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next 0/2] net: drop_monitor: support drop reason
Date:   Tue,  8 Feb 2022 15:28:34 +0800
Message-Id: <20220208072836.3540192-1-imagedong@tencent.com>
X-Mailer: git-send-email 2.27.0
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

From: Menglong Dong <imagedong@tencent.com>

This series patches is to make drop monitor supporting drop reason
and report it to user space.

In the first patch, we define the macro 'SKB_DR_MAX_LEN', which is
the max string length of drop reasons. We introduce this macro as
drop_monitor need to know the memory allocated for NET_DM_ATTR_REASON
in the second patch.

In the second patch, we report drop reasons as string to user space
in drop_monitor.


Menglong Dong (2):
  net: skb: introduce SKB_DR_MAX_LEN
  net: drop_monitor: support drop reason

 include/trace/events/skb.h       |  5 +++++
 include/uapi/linux/net_dropmon.h |  1 +
 net/core/drop_monitor.c          | 34 ++++++++++++++++++++++++++++----
 3 files changed, 36 insertions(+), 4 deletions(-)

-- 
2.27.0

