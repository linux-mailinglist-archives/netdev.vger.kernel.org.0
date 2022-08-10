Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 333F958E533
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 05:11:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230060AbiHJDLq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 23:11:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230040AbiHJDLl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 23:11:41 -0400
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BC8F80F77;
        Tue,  9 Aug 2022 20:11:40 -0700 (PDT)
Received: by mail-qk1-x72b.google.com with SMTP id c28so1156499qko.9;
        Tue, 09 Aug 2022 20:11:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=Qsaks7TDshu/iK351NtgsaMj5QdevHA6XP1FxmCgHpM=;
        b=prA8AdKyGpyxCd8Aos45URzvOY5yjVOK3DMwVJn4Uyj6A9PHRoPL8JiQJOeze0vVH1
         IymCOhC3puc17K5WM58lCpsEP+oWXmVcoQRE9PrPlxaHxsNfRv2oW+sEYwuMHbcSzJvT
         QICYi5m9/jfaan/f4/MNKyZ/LM9l29ejjs3YAuHaZ20kJTOrlwEcUe3hUKhBYG6PDaA7
         FU1gIjwleabfvG//4FVXGxTvOPROTeeL/vDrYHuxPTq0fyJkeyruwg6zr6dnGtJdrGSj
         c7dWFpmRGGF8pIYDr6i4nJ96ey9CCNsrhkBfsmBn+Rbqa27+5lPmy8DJ9juOPhhgogoa
         57og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=Qsaks7TDshu/iK351NtgsaMj5QdevHA6XP1FxmCgHpM=;
        b=f7cKUof73RxRb+qFkabDviaCTxE8ZwG+VSEVxU9qkG0esuzXioQegbEUjm2fjzqLNK
         AJ33oIdCgtiTsXELY3N6qCX4Sg/LB6R0FyVr2bfiKFdvBt1ewtMPpOq8tKR4MLmQxbi5
         P9ZUXWKhQb00FoghIF+Kq1m3BAXtx/UeRu4yEr2mRi4dJ9WBdBkiH5eNVYFmFalVPcRc
         Yln2UcO0pSdCGTa53Lzy9yrgbPWUpBRpes2C0kNE9kaX0xGkOOHY3TV03fLqkd8oz3iB
         NdTeYTuY7WejqtgNRWkGxlTF64f9qstsq7L1lW3e2YnoZzYBPtMaAVeawZgwKUp5iX9m
         niXw==
X-Gm-Message-State: ACgBeo3KRdx2weGGJmiPiar8c5moFMOgWpS/N0UXSSgFPRCUkNJYJfZ0
        EeClCiC4J8SzO93Jvn4yE/E=
X-Google-Smtp-Source: AA6agR5RJo1Lm57r4mzN/1g7ozgvtSDEiiMrkxKg25ahnu1rHmeYaW1sO0yWoCAVxyWIbLwsyWKnIA==
X-Received: by 2002:a05:620a:2455:b0:6b9:8fd7:7da1 with SMTP id h21-20020a05620a245500b006b98fd77da1mr3014232qkn.178.1660101099745;
        Tue, 09 Aug 2022 20:11:39 -0700 (PDT)
Received: from euclid ([71.58.109.160])
        by smtp.gmail.com with ESMTPSA id d16-20020a05620a241000b006b893d135basm13379899qkn.86.2022.08.09.20.11.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Aug 2022 20:11:38 -0700 (PDT)
From:   Sevinj Aghayeva <sevinj.aghayeva@gmail.com>
To:     netdev@vger.kernel.org
Cc:     aroulin@nvidia.com, sbrivio@redhat.com, roopa@nvidia.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org,
        Sevinj Aghayeva <sevinj.aghayeva@gmail.com>
Subject: [PATCH RFC net-next 0/3] net: vlan: fix bridge binding behavior and add selftests
Date:   Tue,  9 Aug 2022 23:11:18 -0400
Message-Id: <cover.1660100506.git.sevinj.aghayeva@gmail.com>
X-Mailer: git-send-email 2.25.1
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

When bridge binding is enabled for a vlan interface, it is expected
that the link state of the vlan interface will track the subset of the
ports that are also members of the corresponding vlan, rather than
that of all ports.

Currently, this feature works as expected when a vlan interface is
created with bridge binding enabled:

  ip link add link br name vlan10 type vlan id 10 protocol 802.1q \
        bridge_binding on

However, the feature does not work when a vlan interface is created
with bridge binding disabled, and then enabled later:

  ip link add link br name vlan10 type vlan id 10 protocol 802.1q \
        bridge_binding off
  ip link set vlan10 type vlan bridge_binding on

After these two commands, the link state of the vlan interface
continues to track that of all ports, which is inconsistent and
confusing to users. This series fixes this bug and introduces two
tests for the valid behavior.

Sevinj Aghayeva (3):
  net: core: export call_netdevice_notifiers_info
  net: 8021q: fix bridge binding behavior for vlan interfaces
  selftests: net: tests for bridge binding behavior

 include/linux/netdevice.h                     |   2 +
 net/8021q/vlan.h                              |   2 +-
 net/8021q/vlan_dev.c                          |  25 ++-
 net/core/dev.c                                |   7 +-
 tools/testing/selftests/net/Makefile          |   1 +
 .../selftests/net/bridge_vlan_binding_test.sh | 143 ++++++++++++++++++
 6 files changed, 172 insertions(+), 8 deletions(-)
 create mode 100755 tools/testing/selftests/net/bridge_vlan_binding_test.sh

-- 
2.25.1

