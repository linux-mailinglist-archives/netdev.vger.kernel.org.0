Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AE895BBA41
	for <lists+netdev@lfdr.de>; Sat, 17 Sep 2022 22:18:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbiIQUSJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Sep 2022 16:18:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbiIQUSI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Sep 2022 16:18:08 -0400
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64FAF2E9EE;
        Sat, 17 Sep 2022 13:18:07 -0700 (PDT)
Received: by mail-qt1-x82c.google.com with SMTP id h21so18285162qta.3;
        Sat, 17 Sep 2022 13:18:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=EnLNkzzS7uvp8qzIOHofbmM/lr6EdUZwCfdgBKsBFIA=;
        b=WnJNpsrV7HdjGnzo2nkpOIxfT2GxSQjATwHQe5v3dxoDnhipC0pkWqvbDRaaAkHUQl
         BjuI5IHPTPKLxcBGbBky4ToOKprKzwbMjyJdETPc++bA6kflYiSa0oVI5YALYKtStEuX
         s1AF/+zVhqgaqkyDkFWxaQAq6J2FxoK8ra3/X/7zVu9rmMsb+T//OX3VmA7rJq+gLfEe
         gOxjRTSUCB8XAqhqASuiItzDRhGM19ybGOKOn2CR581W61gTdJ96XBxuQCX63STtniZn
         E1DEGEdZCY7FTpS43bWkkxm1MTCoN7tiTtmtCzJmyvIzjeVwjJ6IEahZE+9GSiOCGeZT
         m3uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=EnLNkzzS7uvp8qzIOHofbmM/lr6EdUZwCfdgBKsBFIA=;
        b=lAekH1cEknlXhiFVU/lH+nJOLa1g0+I537s6mOYY6iYHJx9wO4S5E0dbWc2IF9uwjs
         IeFFz2QscCkIAJ1Sq82+KowRaiwWBWtvH5dVr7/IoPtdG1W3+Q6gwPQ1TRZCO69Gsoap
         pyIAs/On0jeGTYTnu1Xe0PhzDsQQKQiuJl6GSRT/Sl1t9ss7yRM3RCQiD5WbILHIBn6O
         elg/gvgB5oreF5EI19+w1eKlRtNdZf5Hzoc2hHkJ0D/r0KKfDfRiAB2hkjRVEzdzZBHv
         P/foMGW7/wAeYZnW2FAHd7hPulyxxHGRn0kTNXGlOuYfLGbjdgLyTtmLeBpAYFTNDHkg
         PKCw==
X-Gm-Message-State: ACrzQf0d2jrCjT+lV4szkjenHSaImLP1xLuxxRR8kslTJo/XZvuqChKx
        wLT7OH2WXuHZUFO6bgWYI74=
X-Google-Smtp-Source: AMsMyM7cM/HW3xBioBWezl3X+3QEZQyJkj85m12XBnHv7oTpjrxgZgVMCPyE7emse7IXOB0C/oO1Kg==
X-Received: by 2002:ac8:57ca:0:b0:35b:b51f:94fc with SMTP id w10-20020ac857ca000000b0035bb51f94fcmr9524213qta.276.1663445886429;
        Sat, 17 Sep 2022 13:18:06 -0700 (PDT)
Received: from euclid ([71.58.109.160])
        by smtp.gmail.com with ESMTPSA id l2-20020a37f902000000b006b9c355ed75sm8826647qkj.70.2022.09.17.13.18.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Sep 2022 13:18:06 -0700 (PDT)
From:   Sevinj Aghayeva <sevinj.aghayeva@gmail.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>, aroulin@nvidia.com,
        sbrivio@redhat.com, roopa@nvidia.com,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org,
        Sevinj Aghayeva <sevinj.aghayeva@gmail.com>
Subject: [PATCH RFC net-next 0/5] net: vlan: fix bridge binding behavior and add selftests
Date:   Sat, 17 Sep 2022 16:17:56 -0400
Message-Id: <cover.1663445339.git.sevinj.aghayeva@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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

Sevinj Aghayeva (5):
  net: core: export call_netdevice_notifiers_info
  net: core: introduce a new notifier for link-type-specific changes
  net: 8021q: notify bridge module of bridge-binding flag change
  net: bridge: handle link-type-specific changes in the bridge module
  selftests: net: tests for bridge binding behavior

 include/linux/if_vlan.h                       |   4 +
 include/linux/netdevice.h                     |   3 +
 include/linux/notifier_info.h                 |  21 +++
 net/8021q/vlan.h                              |   2 +-
 net/8021q/vlan_dev.c                          |  20 ++-
 net/bridge/br.c                               |   5 +
 net/bridge/br_private.h                       |   7 +
 net/bridge/br_vlan.c                          |  18 +++
 net/core/dev.c                                |   7 +-
 tools/testing/selftests/net/Makefile          |   1 +
 .../selftests/net/bridge_vlan_binding_test.sh | 143 ++++++++++++++++++
 11 files changed, 223 insertions(+), 8 deletions(-)
 create mode 100644 include/linux/notifier_info.h
 create mode 100755 tools/testing/selftests/net/bridge_vlan_binding_test.sh

-- 
2.34.1

