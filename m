Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9069F53B12F
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 03:23:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233029AbiFBBVP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 21:21:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232994AbiFBBVO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 21:21:14 -0400
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7317FDFF4E;
        Wed,  1 Jun 2022 18:21:13 -0700 (PDT)
Received: by mail-qt1-x82f.google.com with SMTP id 2so2522000qtw.0;
        Wed, 01 Jun 2022 18:21:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=i4/k1Y4z6iW3+036x59e6AS3ioClOeFXBzlJvKGBQ3c=;
        b=jrdxIqCPMAS5AKPWNk3ElBCyxonj7tx2wMI0kqIaOnW6VkK5mHS+8Zzc586voz68z1
         5MN5ExcQxJtGH9m1OQMKHXHDSA63RAeUGMYRzRfrb0U7+wZzyVwvXNLs2us9638C5nL5
         4ZVpqYnzqRNill5xzL+XfZ3inBRKeePdTeqoNkAoDT358Y6h6IlWu40/PzA3ELWPuEP+
         CaMswKMQ+laJh3aE/QyFZWx9/by/v669d33JhDSegHW35FrnsHkaLaUDd3vCDqhDb7TQ
         6t1BUTzs+1p27dBjUShBmQtfQA2HIgiLyc8ed/A3rH7JxOuU74+XI9PEmzl6mAiOkhgU
         yZiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=i4/k1Y4z6iW3+036x59e6AS3ioClOeFXBzlJvKGBQ3c=;
        b=Fgg4V3sfq30RUMM91RnRxu2UVwuEoBBdam+y5saCo423MmZtxRcMh+waZrrh4rNu5Z
         /fIYzteeTWREpMe29zqZnam0C4AyarFcLq9NrHWlnWP3RM396kbHvqxmZUkvtwa8D5x+
         hkvxpJmDGJb6E7Q08FkNOIv03g5WQV1T5BXwqkEbMM32KXNuIEJquKULSwBtz8KCRfYZ
         MIjBCN08M3/R04Cxpll+fhkQRl9smJFd0dOwfZ52vUvnCNOejC4QtdWEOBh8ePHwkJbj
         38mY93HWAmHlzhymiab6PoXGXctdyAmMEz09fCBbtqkHihh9b0eZ4TXz9rvBQES00aFQ
         7JOw==
X-Gm-Message-State: AOAM533vxCepxpZfXV7TlNC2JG5SektinR8drtpxKuFbYy6rC/0cW1Y8
        rql5MbrCds/egYjP/6Ah5HN8m4+si2M=
X-Google-Smtp-Source: ABdhPJyjncl9xSre/rCq9ixVwTU9kJ5mvulcYk8HMViPVD4aSsyydkJ4xtbkho7VIburuPpUOGi5DA==
X-Received: by 2002:ac8:590a:0:b0:304:b5f4:941e with SMTP id 10-20020ac8590a000000b00304b5f4941emr2134024qty.46.1654132872409;
        Wed, 01 Jun 2022 18:21:12 -0700 (PDT)
Received: from pop-os.attlocal.net ([2600:1700:65a0:ab60:a168:6dba:43b7:3240])
        by smtp.gmail.com with ESMTPSA id x4-20020ac87304000000b002f39b99f670sm2077654qto.10.2022.06.01.18.21.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jun 2022 18:21:11 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>
Subject: [Patch bpf-next v3 0/4] sockmap: some performance optimizations
Date:   Wed,  1 Jun 2022 18:21:01 -0700
Message-Id: <20220602012105.58853-1-xiyou.wangcong@gmail.com>
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

This patchset contains two optimizations for sockmap. The first one
eliminates a skb_clone() and the second one eliminates a memset(). With 
this patchset, the throughput of UDP transmission via sockmap gets
improved by 61%.

v3: avoid touching tcp_recv_skb()

v2: clean up coding style for tcp_read_skb()
    get rid of some redundant variables
    add a comment for ->read_skb()

---

Cong Wang (4):
  tcp: introduce tcp_read_skb()
  net: introduce a new proto_ops ->read_skb()
  skmsg: get rid of skb_clone()
  skmsg: get rid of unncessary memset()

 include/linux/net.h |  4 ++++
 include/net/tcp.h   |  1 +
 include/net/udp.h   |  3 +--
 net/core/skmsg.c    | 48 +++++++++++++++++----------------------------
 net/ipv4/af_inet.c  |  3 ++-
 net/ipv4/tcp.c      | 44 +++++++++++++++++++++++++++++++++++++++++
 net/ipv4/udp.c      | 11 +++++------
 net/ipv6/af_inet6.c |  3 ++-
 net/unix/af_unix.c  | 23 +++++++++-------------
 9 files changed, 86 insertions(+), 54 deletions(-)

-- 
2.34.1

