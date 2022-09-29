Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 536525EEEF8
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 09:29:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233495AbiI2H3I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 03:29:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232519AbiI2H3G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 03:29:06 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A20BF12E426
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 00:29:05 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id l18so734076wrw.9
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 00:29:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=guFK+fRZB7attecE+hOArvpRDVx/SvNZRY94QUAAkQc=;
        b=ZB6mbeSOoN8kN9WbsbzW0qoVHUpggpEr7V72WLk7CXqoH5SqezIH2xDqU4g00BR3xI
         HmfgcZXULvAmKqGC61/yNMFrFc6RFkqDfgoLc5X68cAeQ/nm1dCdJSVQ4ZfaSqRUroWI
         QpkXG3mraZuL5uYtroQopS4TioLDvzEDXYKraou9pZvPw2fEZCI+3rUDDyxG5UqFCwaP
         wn/rsnaE7rhdBb/6WFWT7btbGtbppDOjWoBkJ3wXse1r5Wg9rTWcVoC2x7MF/evLVCJ3
         A0Z8AgBjF9wJ/rp/i78XHJxJXoFoQC+NKIBmIBG8S3LPpZv13FOEiTbgzmJ+08xZvbdw
         JdNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=guFK+fRZB7attecE+hOArvpRDVx/SvNZRY94QUAAkQc=;
        b=GNhNROvu/rTauJVbjwq8NAh2Ysw92bMLOJuk5tzENoKPeSODW+stEytpmwZ1LuD2DG
         CxtEzjP+7kbtDx2sbbYBaymfcVv6Tbd09J5JHCkDquWFUnH6RdDjoGKcfB4QZvFqiNcx
         J46Fb2lCbB5ldummwPbvxyXQjJtH4d80cklmC0WvhNjhmVmhK9pykFUCJrNBdO75bAAl
         3n7iFZOiSUJMgJEuR60Q61uYT/3AtOfbHa7JouBfiqyW3W6g1AssfMUWzC682z6lbvuJ
         HxYd0TGtQx/1I9WuIUPzP73MMDKu/Q+lSJ3D8T2xXWd251Di0+gEZC5flRIdZE96XOxH
         7TWQ==
X-Gm-Message-State: ACrzQf2dki4bi6in349HC8v5RN42UKGDDdM/Ppph3s5sl8pAhhLtHCr3
        4/nKaeUplmJqUZZjmbS9kuHR8O8xsoC3gaLx
X-Google-Smtp-Source: AMsMyM4IpSPvEvUeefig2aJvvNlnC+Y5qDXgB2QqcwQa3yFikg6SceRGj28ngLqljRFJcB+Agvokfw==
X-Received: by 2002:adf:e6cd:0:b0:22c:c554:5ba4 with SMTP id y13-20020adfe6cd000000b0022cc5545ba4mr1176921wrm.12.1664436543933;
        Thu, 29 Sep 2022 00:29:03 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id t3-20020a7bc3c3000000b003b4868eb6bbsm4234052wmj.23.2022.09.29.00.29.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Sep 2022 00:29:03 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, tariqt@nvidia.com,
        moshe@nvidia.com, saeedm@nvidia.com
Subject: [patch net-next v3 0/7] devlink: sanitize per-port region creation/destruction
Date:   Thu, 29 Sep 2022 09:28:55 +0200
Message-Id: <20220929072902.2986539-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Currently the only user of per-port devlink regions is DSA. All drivers
that use regions register them before devlink registration. For DSA,
this was not possible as the internals of struct devlink_port needed for
region creation are initialized during port registration.

This introduced a mismatch in creation flow of devlink and devlink port
regions. As you can see, it causes the DSA driver to make the port
init/exit flow a bit cumbersome.

Fix this by introducing port_init/fini() which could be optionally
called by drivers like DSA, to prepare struct devlink_port to be used
for region creation purposes before devlink port register is called.

Tested by Vladimir on his setup.

---
v2->v3:
- fixed patch description of patch #3

v1->v2:
- Netdevsim patch removed and also the patch forcing region creation
  before register was removed.
- Two Vladimir's patches were added.

Jiri Pirko (5):
  net: devlink: introduce port registered assert helper and use it
  net: devlink: introduce a flag to indicate devlink port being
    registered
  net: devlink: add port_init/fini() helpers to allow
    pre-register/post-unregister functions
  net: dsa: move port_setup/teardown to be called outside devlink port
    registered area
  net: dsa: don't do devlink port setup early

Vladimir Oltean (2):
  net: dsa: don't leave dangling pointers in dp->pl when failing
  net: dsa: remove bool devlink_port_setup

 include/net/devlink.h |   7 +-
 include/net/dsa.h     |   2 -
 net/core/devlink.c    |  80 ++++++++++++++----
 net/dsa/dsa2.c        | 184 ++++++++++++++++++------------------------
 net/dsa/dsa_priv.h    |   1 +
 net/dsa/port.c        |  22 +++--
 net/dsa/slave.c       |   6 +-
 7 files changed, 166 insertions(+), 136 deletions(-)

-- 
2.37.1

