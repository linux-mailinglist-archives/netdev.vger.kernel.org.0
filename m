Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA3C044055C
	for <lists+netdev@lfdr.de>; Sat, 30 Oct 2021 00:19:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231563AbhJ2WVd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 18:21:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231569AbhJ2WV2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Oct 2021 18:21:28 -0400
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CD4FC061714
        for <netdev@vger.kernel.org>; Fri, 29 Oct 2021 15:18:59 -0700 (PDT)
Received: by mail-qk1-x735.google.com with SMTP id bl14so10811968qkb.4
        for <netdev@vger.kernel.org>; Fri, 29 Oct 2021 15:18:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=O93JhHz7dL8HV068W5SFXezG8oDF5b3ADAXpF6LNIhw=;
        b=OosnwlLAZ1c6WO8qcMtn1TEbEZzKXxxeu0YhFXglCXUxRFzeL+ehyy96YZs2n/6MDJ
         llz0GVq0dYE3P+tuJWKlsIxy/J08k8FTwY8wrquIXr2yjeFNqiRAnt3HdqPWWgXZznoG
         0wtaDtlltGtarclhSFlLcVD/SGOc/bJaea2TWnRvxrBnTOQPvxCBuThRHvQGQxvV59PG
         NwxjzO51GPRyHYEJFm1Plk7A/K5kjcfQqeUF91ZsjGJFJQG+8o/p37ydbcCzvQXfBx6+
         7dwG5vdRh8Dr5Z0CQosQDA0sujjV7kLfK8GYqQhhyjQzZ14d6zffhVx6ABFS/vZQCUjp
         bEmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=O93JhHz7dL8HV068W5SFXezG8oDF5b3ADAXpF6LNIhw=;
        b=TgghvGT4n/qeWnWjqhWdbQByLHxTxq6SWVIYnHF6KsuWF5Z8v/ftak7r50ktdQiYnj
         PPGieaLRuXvawnyNSN4w0lrKmIUeVfzbWIVtnm0lUE2gY10PVBlkkvRTO5THVi3NL/K8
         4meuvlkkeCltUidJEMcZwHiOAr77fgpeMWaGUlPvY+S3NaFKXU2F1Kspmr/EswOfsAka
         QqrsOfsI9mxMuqMcRkikFQ6LMbwbz5cmE1ubpabdHJA1klgAFTFyXZEzY6B7YqQ8AlgJ
         +KuizpL0/j7kHjra7nCzf4rPwEWVIwSiRsVwiVSnlhIy8KPx1KYj3wBlnYryjanZ6f7O
         +5PQ==
X-Gm-Message-State: AOAM531dRlbxhtW9gbpnKOf8R/Pedk+TmOvyTqszDun1tprHRe5TUm40
        ZPs1uISux6RqMfMANAJ56yA=
X-Google-Smtp-Source: ABdhPJzzKs5nXmD1erAbNrbXGyi5sANy66BZsedrqS43PKj++lMMCJjFITArRSMywYXU2QJ9CvbRpg==
X-Received: by 2002:a05:620a:146:: with SMTP id e6mr11300430qkn.124.1635545938369;
        Fri, 29 Oct 2021 15:18:58 -0700 (PDT)
Received: from talalahmad1.nyc.corp.google.com ([2620:0:1003:317:25ce:101f:81db:24e8])
        by smtp.gmail.com with ESMTPSA id p15sm4931730qti.70.2021.10.29.15.18.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Oct 2021 15:18:57 -0700 (PDT)
From:   Talal Ahmad <mailtalalahmad@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     arjunroy@google.com, edumazet@google.com, soheil@google.com,
        willemb@google.com, Talal Ahmad <talalahmad@google.com>
Subject: [PATCH net-next 0/2] Accurate Memory Charging For MSG_ZEROCOPY
Date:   Fri, 29 Oct 2021 18:18:28 -0400
Message-Id: <20211029221830.3608066-1-mailtalalahmad@gmail.com>
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Talal Ahmad <talalahmad@google.com>

This series improves the accuracy of msg_zerocopy memory accounting.
At present, when msg_zerocopy is used memory is charged twice for the
data - once when user space allocates it, and then again within
__zerocopy_sg_from_iter. The memory charging in the kernel is excessive
because data is held in user pages and is never actually copied to skb
fragments. This leads to incorrectly inflated memory statistics for
programs passing MSG_ZEROCOPY.

We reduce this inaccuracy by introducing the notion of "pure" zerocopy
SKBs - where all the frags in the SKB are backed by pinned userspace
pages, and none are backed by copied pages. For such SKBs, tracked via
the new SKBFL_PURE_ZEROCOPY flag, we elide sk_mem_charge/uncharge
calls, leading to more accurate accounting.

However, SKBs can also be coalesced by the stack at present,
potentially leading to "impure" SKBs. We restrict this coalescing so
it can only happen within the sendmsg() system call itself, for the
most recently allocated SKB. While this can lead to a small degree of
double-charging of memory, this case does not arise often in practice
for workloads that set MSG_ZEROCOPY.

Testing verified that memory usage in the kernel is lowered.
Instrumentation with counters also showed that accounting at time
charging and uncharging is balanced.

Talal Ahmad (2):
  tcp: rename sk_wmem_free_skb
  net: avoid double accounting for pure zerocopy skbs

 include/linux/skbuff.h | 19 ++++++++++++++++++-
 include/net/sock.h     |  7 -------
 include/net/tcp.h      | 15 +++++++++++++--
 net/core/datagram.c    |  3 ++-
 net/core/skbuff.c      |  3 ++-
 net/ipv4/tcp.c         | 28 +++++++++++++++++++++++-----
 net/ipv4/tcp_output.c  |  9 ++++++---
 7 files changed, 64 insertions(+), 20 deletions(-)

-- 
2.33.1.1089.g2158813163f-goog

