Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E45E517677
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 20:24:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386849AbiEBS13 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 14:27:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386845AbiEBS12 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 14:27:28 -0400
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9920C767C;
        Mon,  2 May 2022 11:23:59 -0700 (PDT)
Received: by mail-oi1-x22f.google.com with SMTP id r8so16021557oib.5;
        Mon, 02 May 2022 11:23:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CIKlVh6mnUyfsOqRQ2kIhsJu4jFvVs2VDKayVzJu+lc=;
        b=f+c4B4Wqp0S7YwBNrJEU3lp1S2NNBaIb7vlOUnHmDC1cMmWcRz6C/xb7lxTXxxxeUK
         WVYDhVsP+rV+daDONBh9O7gx+suVi1B4mSPTmxZ9sQfKkIDkOyXwjptb3OtMCmYO+zSb
         ftFxtas9Jje6DKwTUd1apE4UD6qM+Qtvr2R1oMZ4ifTag4wZ6j86nQ8yDggTpsVx79wr
         dEq7lfZUrTw+6/tzWoMceUDuNAODfIPuOOfjOf2e+W+xqc6rzOMIRW4dC/m09VzaODFb
         7IaD9iftPRIrqVzXvIFn9AtbBdJvIB9tSnzdrnQHsbaOfmkrghu46QpMCfjGtJ9joBPk
         YTqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CIKlVh6mnUyfsOqRQ2kIhsJu4jFvVs2VDKayVzJu+lc=;
        b=7JvYTAGM8jqZ8L7ck44oXs46lYcTPfa8aoV6BN7CUXEyMmMGXliCa0OD2Kn1Pfl8rR
         AOSy2/ImeZVc3Dqj6l0hFLsqLxyFoQ/XIt2JDsVxsrpwLUqXz9O6Feuc1fwoAXYWfPoO
         14eoxhBk5kYrUlRB9y1sQjwS2aVuiS/xNHu/vags5OnFfaNA/7g+FZ8yIw8G9GZObXVO
         4M6U+QNzZrp8NCzN6OPxpGFVMc8Vuy96NP8WENvZbF5/NJmbuwLDBZkRssljN7RUVx22
         TmLtvaBL2l1TWtzLwQndfZBVImVny5GXhBmQB7YFnHYdADP7S1PKBmWCqnxSP2KwSCWg
         11Fw==
X-Gm-Message-State: AOAM5324qrgT05KtBOTfgVdskQsfroqmU6p8R7pUXV9/dMwvb4Pc01T/
        ni2x9KVGZJmZ1bJVing1NE4ICxYvz/A=
X-Google-Smtp-Source: ABdhPJwKV/8vc3t34AWmp2BdchBf5Cn9mhYX2kJrNTAQwE+b2EPx7tYDS8bBp9HRG+VGgHv25XVgxQ==
X-Received: by 2002:a54:468f:0:b0:322:5226:598e with SMTP id k15-20020a54468f000000b003225226598emr194274oic.213.1651515838766;
        Mon, 02 May 2022 11:23:58 -0700 (PDT)
Received: from pop-os.attlocal.net ([2600:1700:65a0:ab60:7340:5d9f:8575:d25d])
        by smtp.gmail.com with ESMTPSA id t13-20020a05683014cd00b0060603221245sm3129915otq.21.2022.05.02.11.23.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 May 2022 11:23:58 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>
Subject: [Patch bpf-next v2 0/4] sockmap: some performance optimizations
Date:   Mon,  2 May 2022 11:23:41 -0700
Message-Id: <20220502182345.306970-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.32.0
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

This patchset contains two optimizations for sockmap. The first one
eliminates a skb_clone() and the second one eliminates a memset(). After
this patchset, the throughput of UDP transmission via sockmap gets
improved by 61%.

v2: clean up coding style for tcp_read_skb()
    get rid of some redundant variables
    add a comment for ->read_skb()

Cong Wang (4):
  tcp: introduce tcp_read_skb()
  net: introduce a new proto_ops ->read_skb()
  skmsg: get rid of skb_clone()
  skmsg: get rid of unncessary memset()

 include/linux/net.h |  4 +++
 include/net/tcp.h   |  1 +
 include/net/udp.h   |  3 +--
 net/core/skmsg.c    | 48 ++++++++++++++----------------------
 net/ipv4/af_inet.c  |  3 ++-
 net/ipv4/tcp.c      | 60 +++++++++++++++++++++++++++++++++++++++------
 net/ipv4/udp.c      | 11 ++++-----
 net/ipv6/af_inet6.c |  3 ++-
 net/unix/af_unix.c  | 23 +++++++----------
 9 files changed, 94 insertions(+), 62 deletions(-)

-- 
2.32.0

