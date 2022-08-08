Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A96A558C20F
	for <lists+netdev@lfdr.de>; Mon,  8 Aug 2022 05:31:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236048AbiHHDb0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Aug 2022 23:31:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231905AbiHHDbX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Aug 2022 23:31:23 -0400
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C722F6269;
        Sun,  7 Aug 2022 20:31:22 -0700 (PDT)
Received: by mail-oi1-x234.google.com with SMTP id n133so9168181oib.0;
        Sun, 07 Aug 2022 20:31:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sG4WSPOFSrB4BWd5XsDTyjpNIlzRx3yn9bSIEBRT+ro=;
        b=p0O3WYDz9TsVpfUf/P5hQei70HzQXV0cus/i4L6FRlYsGPzioGhL4/FeJ3IlcRi0lO
         iLaX0tpHLzHSOWOA8i5I7K7AqaN4syW3/ENaKAfuseh1HiQJJzX9EGef0nUR7sqhK8v4
         AlcchPRu9ZlCX2Kytk92NqKS0eSbixjdFXOQhOAQhLWgvt1JLvb+ukLUbovfjU709HuN
         nirFsxr4mCITqRuMcmjLxkwsj+UOAblursE9c/cwr8ozVCJ40FX0lLjNGpdCbre1GMnU
         ALViyEse39llD1YWv7xPuTEqm6yQPdxsbU7qdu+VxifihN5f7CqSs3kR0jNxg/fi3gvL
         Ij6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sG4WSPOFSrB4BWd5XsDTyjpNIlzRx3yn9bSIEBRT+ro=;
        b=2iCLqkS3Tj6knTTpASlVDSj5Gxp0mT7e6kXpza35oDLCokdhEeV7hxkzXoqbWsdoU+
         tC9J8zTYpTpNRRs5KH6yHB8XYjruju+vrWbKosSr8HfwNe2VLbkKHVuR0c1gTLFUIKML
         CxgDNQ/I8OVB8Nt2JEZpLdhv10FcP2brpGe3YE2RS5QFG4D7DC3Y3ZgK/+UZ0JLhJ8WL
         /xwRPZv88nhv6XVN4j1zxAbL2d7S6Vv20JykOnLbEjOW3Nsyjh4VRuU9YrUyDUWC81pC
         plM09VqeVGWj7SP6eDWTsSBEVG8PjfpK5QNIGnR5DsOABCmobEqSVketpufhkvTIb/PZ
         BFQw==
X-Gm-Message-State: ACgBeo2a2ir7XpMViFnA5TfmivO16QaqfmJcpADfGEpOtRHyxMOujjoa
        y0unmg5DNhH7zoaQR49z+WmFeJdrXLg=
X-Google-Smtp-Source: AA6agR4jSv0EeyG259uGDpwiSYDuxxGtY/LD/6ilxZXegTl4oB/p1TrN4iKGWrzMZUI4Eyj4xmPhsg==
X-Received: by 2002:a05:6808:1642:b0:331:567c:54e1 with SMTP id az2-20020a056808164200b00331567c54e1mr6825631oib.232.1659929481922;
        Sun, 07 Aug 2022 20:31:21 -0700 (PDT)
Received: from pop-os.attlocal.net ([2600:1700:65a0:ab60:ad03:d88f:99fe:9487])
        by smtp.gmail.com with ESMTPSA id k39-20020a4a94aa000000b00425806a20f5sm1945138ooi.3.2022.08.07.20.31.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Aug 2022 20:31:21 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>
Subject: [Patch net v2 0/4] tcp: some bug fixes for tcp_read_skb()
Date:   Sun,  7 Aug 2022 20:31:02 -0700
Message-Id: <20220808033106.130263-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.34.1
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

From: Cong Wang <cong.wang@bytedance.com>

This patchset contains 3 bug fixes and 1 minor refactor patch for
tcp_read_skb(). V1 only had the first patch, as Eric prefers to fix all
of them together, I have to group them together. Please see each patch
description for more details.

---

Cong Wang (4):
  tcp: fix sock skb accounting in tcp_read_skb()
  tcp: fix tcp_cleanup_rbuf() for tcp_read_skb()
  tcp: refactor tcp_read_skb() a bit
  tcp: handle pure FIN case correctly

 net/core/skmsg.c |  5 +++--
 net/ipv4/tcp.c   | 46 +++++++++++++++++++++-------------------------
 2 files changed, 24 insertions(+), 27 deletions(-)

-- 
2.34.1

