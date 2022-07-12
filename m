Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0092570E91
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 02:05:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229876AbiGLAFh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 20:05:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbiGLAFg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 20:05:36 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0622B61
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 17:05:35 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id x17-20020a631711000000b0041240801d34so2497588pgl.17
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 17:05:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=7pRcKQvplvk+c/6T4qCwYQ+E8JeXHTzT5CjY5ICtDRU=;
        b=LJ92TWKPK1Ti9qon9DuojYRugnPUDYH3RJ75V7CRHCiGzLOh4zAfnKonocmcq9NHdd
         7A8itnb4LohQCdVahBk5dRc5D04R8Uaxyhu0fKl3VsuceZdM2sBHZQPMd0lnOQYv4t5T
         nBOxajZX7F5ytj0UYRgVDzQkDb8OOv2G3AMQUM+l6Oqu4GU0nfqn2wJXq3mSWBtoOvUP
         ISFqxsz+kZubmDA6VEqiih3wLZaa4X3ctfLIPEU78Mq6m1bzDbAX1rrDew/ECep9B4iG
         ezTShUe+Tr+X3MtV8cwe6mRC1HoYN1LqQK7gGiSpeSAWWWAERaYjRsa1BddPvMZTpSZH
         9B8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=7pRcKQvplvk+c/6T4qCwYQ+E8JeXHTzT5CjY5ICtDRU=;
        b=frsfBQtW+QT8GUg1pda+xasZo86fpmKGRaHx8mTlb92SJYMOC6sxHlCfmxb8kUsVI9
         QJcOciq7CK5avxQeOdXh3EjcNC3O55KsWbQBBcesRcKOk9p4jHrUSZSAf/Pdm7kQrvho
         vRtlihkaUyHoizLVy9jxdkVeoBVMiEuCrm6H7hoB8CGRwY/zs5p6sw+Nzhr7TU3l7Lpg
         9kOT5gZHD9lmWl3vNCFGJsg+n5jfsZEAODgPjSOIBABIH1ByiRDx9AXTulvyg2AA35b3
         eYlmVhzHpGt39CwLKJbETG4hDP8azIOJsgrROQZIy65BRjwi1/GwZNHpRJzxoWJvP65V
         RtSQ==
X-Gm-Message-State: AJIora9MS/3D8EVdskxVAmIRjtikzl3rZZqXbQVlTlpEb5zgcCqun6Ff
        6h7dizYkwUnBcbZq5+aRLogAD+GB11cD
X-Google-Smtp-Source: AGRyM1u3ET1rSKHzcNdt9tvyqZM1qA7VGjsU2pvLjXXUiHEEaE3+zyqxN5YrkcEB3vn36nQWHAts+qDbNBEN
X-Received: from jiangzp-glinux-dev.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:4c52])
 (user=jiangzp job=sendgmr) by 2002:a05:6a00:1312:b0:528:2ed8:7e35 with SMTP
 id j18-20020a056a00131200b005282ed87e35mr20569454pfu.13.1657584335470; Mon,
 11 Jul 2022 17:05:35 -0700 (PDT)
Date:   Mon, 11 Jul 2022 17:05:29 -0700
Message-Id: <20220712000530.2531197-1-jiangzp@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.0.144.g8ac04bfd2-goog
Subject: [kernel PATCH v2 0/1] Bluetooth: hci_sync: Fix resuming scan after
 suspend resume
From:   Zhengping Jiang <jiangzp@google.com>
To:     linux-bluetooth@vger.kernel.org, marcel@holtmann.org
Cc:     Zhengping Jiang <jiangzp@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


This patch fixes a previous patch which did not remove setting
scanning_paused to false after resuming. So after setting the value,
the function to update scan will always quit.
Also need to set the value first before updating passive scan.

BUG=b:236868580,b:236340454
TEST=verified suspend is fixed in volteer with LE mouse
TEST=bluetooth_AdapterSRHealth.sr_peer_wake_le_hid
TEST=bluetooth_AdapterCLHealth.cl_adapter_pairing_suspend_resume_test


Changes in v2:
- Reduce title length

Changes in v1:
- Fix updating passive scan after suspend resume

Zhengping Jiang (1):
  Bluetooth: hci_sync: Fix resuming scan after suspend resume

 net/bluetooth/hci_sync.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

-- 
2.37.0.144.g8ac04bfd2-goog

