Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13B1F6CF63E
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 00:17:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230302AbjC2WQ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 18:16:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjC2WQ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 18:16:58 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C7264ED5
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 15:16:57 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id e23-20020a25e717000000b00b66ab374ba1so16974308ybh.22
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 15:16:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680128216;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=DyxIIff8enn78/pNtAopvsqeiDyCq6YphL15U+xOR4Q=;
        b=gKHqKLOKAEMsJfW4hrrRwWVBezoc7NUP5Z8erU7YhXGWa79ek9A9BiYuk6BO8s1FzP
         ZGX0Asoo2ZwppVpetC5RU7IP5ony09dBmnnUuqIoJPNwbOaJ8ZvLlmtLq/vBGNWLYUT9
         c3+8IRiXatyH4MACAA9IH7avNk9XgOkMNvjsRkSK6PvW/XG92ehHDjyl0xt0QxjdTbBN
         JmCuL2ZzNaua9LxqTF2r6J72ga7Ra9Q7adIu6X1bRbDuSDI6hJ/JKTbCOTZCKNMEitrM
         1vxuM728A5/3bEvJXQIsptmiHSMhJDnhyE/eO9GDjftfcI4Kab88F0i1BS4QSvK79tgG
         WcUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680128216;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DyxIIff8enn78/pNtAopvsqeiDyCq6YphL15U+xOR4Q=;
        b=mfmXGhalpiQR43DI/Cw5Hg6K7uiMwPGzjEx4BVHPWQPPwHSjfktLwb8szJ7/jfHgGh
         +sY2H1Z/oVFRSvTxfCzQ43ZAm1DuGvUz8m/oswcg9NR9EnoeL+N0CTmDvi0922nMBrCH
         Cc6S3JyMoRmsM+qFywp6pazeKtZ4VWIRzSuXfPD82a1bX33XtQ9eNTwod6wpa03gQz5l
         +zWnGW1UOXt79jJyI8NpjvWlGhAXRVHRMxrziowocmYitT1wibpnbsV8ueYbvpDqE8fH
         szdA3sKO8z0bsHpOBTXnDeHGCP2qqmwq1QdFWWizu9vawNAjnoemsoYCDIXdpRD5MGgV
         A/5A==
X-Gm-Message-State: AAQBX9fqGESbAAmDEDBquzzG1szVAX9p9ycKjrgQqd+08N4s14aD9gc4
        fnX5MUshbrmeuYsg77yaSzMh4AqiaktFvPp6DVmfkEmgQrnA/ZK9djJp2cQD1zRpVXDZz91cD8G
        ECtEfvYHPfq57dNfKOveyCJatAi3qwhyhNhgnj+ZnDHTZLsa/QJkTrA==
X-Google-Smtp-Source: AKy350bdfXJrLetDQeVgQo3zyf8Z6K4/5tQtggPdNCoyIRfv99g2KewlMgssxkIV7ASRSVpYQ3+qgQU=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a05:6902:168d:b0:b78:3a15:e704 with SMTP id
 bx13-20020a056902168d00b00b783a15e704mr12894392ybb.10.1680128216687; Wed, 29
 Mar 2023 15:16:56 -0700 (PDT)
Date:   Wed, 29 Mar 2023 15:16:51 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230329221655.708489-1-sdf@google.com>
Subject: [PATCH net-next v3 0/4] tools: ynl: fill in some gaps of ethtool spec
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I was trying to fill in the spec while exploring ethtool API for some
related work. I don't think I'll have the patience to fill in the rest,
so decided to share whatever I currently have.

Patches 1-2 add the be16 + spec.
Patches 3-4 implement an ethtool-like python tool to test the spec.

Patches 3-4 are there because it felt more fun do the tool instead
of writing the actual tests; feel free to drop it; sharing mostly
to show that the spec is not a complete nonsense.

The spec is not 100% complete, see patch 2 for what's missing.
I was hoping to finish the stats-get message, but I'm too dump
to implement bitmask marshaling (multi-attr).

Note, this is on top of net-next plus the following patch:
[PATCH net-next v4] tools: ynl: Add missing types to encode/decode

v3:
- reindent ethtool to 4 spaces
- byte_order=None to keep existing callers as is
- byte_order to SpecAttr

v2:
- be16 -> byte-order
- remove header in ethtool, not the lib
- NlError two spaces after
- s/_/-/ in ethtool spec
- add missing - for s32-array
- remove "value: 13" hard-code for features-ntf (empty reply instead)
- updated output of the sample run in the last patch (I was actually
  using real ethtool, lol)

Stanislav Fomichev (4):
  tools: ynl: support byte-order in cli
  tools: ynl: populate most of the ethtool spec
  tools: ynl: replace print with NlError
  tools: ynl: ethtool testing tool

 Documentation/netlink/specs/ethtool.yaml | 1480 ++++++++++++++++++++--
 tools/net/ynl/ethtool                    |  424 +++++++
 tools/net/ynl/lib/nlspec.py              |   10 +
 tools/net/ynl/lib/ynl.py                 |   58 +-
 4 files changed, 1844 insertions(+), 128 deletions(-)
 create mode 100755 tools/net/ynl/ethtool

-- 
2.40.0.348.gf938b09366-goog

