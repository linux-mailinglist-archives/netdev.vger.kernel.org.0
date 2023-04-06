Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57A196D9169
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 10:24:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235723AbjDFIYD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 04:24:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235635AbjDFIYC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 04:24:02 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BF311BD
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 01:24:01 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id j13so36599970pjd.1
        for <netdev@vger.kernel.org>; Thu, 06 Apr 2023 01:24:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680769440;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=YH3xOLpflVPmMu+AgirU5uD1raWYKdof0TFOGyzZkL4=;
        b=YIMCHs8i/F1et+Yaz/PEOPaP0C6hzBa2IGS7lQ9ZxM5oejkEgHEBikzKDXnXywRABF
         +RpGxxYhi1FXY8eAS4Wuaz0Mpdmx/Bc2JMtkni5v1HxnEqhsHxL+UqTvhk8qJRJk+Ko1
         vSuN1Q7TV0fWTHmwxOD5KkkIAL7r0aOS7kg46qApLRUnFSGAc6ryw8XnTvHGz/dlcGUp
         TR1mx4w2z5gT2teYEfrrwvGIFzcQHTPFehk3yvptz36jM5hWl3oV1r7WgjURNKL7agAP
         ST5Wi5s3Hlv1AIejTs5fRlghMm1xS9tLSMoeYFF6eer15TYFxgH0g19eYxTzzC1C186y
         0KDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680769440;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YH3xOLpflVPmMu+AgirU5uD1raWYKdof0TFOGyzZkL4=;
        b=OmmhKprZJvDY3Ujgp6XR1LYKEb6ytXHharDHcn0Jl+LcIB8pYjLEKDnIfmzdesI6p9
         6yacX5hJkNo2SBgzeIgFSE/iYzpBHhxhfzz3Pgh3RxPosCpTBcFw7FamOEukhonLyQs4
         TkVwmB/t8Ffc2ct714s2I9oYswMvB9nfoYznZCmmkyDHa4voC0AVu7lAf9rBXmP0L5f8
         A6wsBZAVu3JdmoiyQxB6h6Xe74K57pjzGJTbcHkaHdR8qVhLF2NlGifUp9/hFoMPIKr6
         Lw/f58FCDYTLQl6fyCgtJhzDKqNQDTC363FpkRORu4MKP+SlMg9d2+k4At3E1wZ9wQbb
         9s3A==
X-Gm-Message-State: AAQBX9fsIKSg5Yx5Dx316Aj9OgyT28QmSBTt3lWTVlw3mbJyoP5FPd5C
        bDcg6aXRLXv0+Cn58rpH4a3yy7B1TuPSdg==
X-Google-Smtp-Source: AKy350YrN6Py8ZjNrnqzzJnJVTk2BVykcODrggNdxcIp2aE95yHN8UlRZAW9p6R5o/12Zxy5KPKXpg==
X-Received: by 2002:a17:90b:1e11:b0:23f:46a5:248e with SMTP id pg17-20020a17090b1e1100b0023f46a5248emr9980639pjb.44.1680769440420;
        Thu, 06 Apr 2023 01:24:00 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([2409:8a02:782e:a1c0:2082:5d32:9dce:4c17])
        by smtp.gmail.com with ESMTPSA id on13-20020a17090b1d0d00b0023493354f37sm2644433pjb.26.2023.04.06.01.23.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Apr 2023 01:23:59 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Liang Li <liali@redhat.com>, Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv2 net 0/3] bonding: fix ns validation on backup slaves
Date:   Thu,  6 Apr 2023 16:23:49 +0800
Message-Id: <20230406082352.986477-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The first patch fixed a ns validation issue on backup slaves. The second
patch re-format the bond option test and add a test lib file. The third
patch add the arp validate regression test for the kernel patch.

Here is the new bonding option test without the kernel fix:

]# ./bond_options.sh
TEST: prio (active-backup miimon primary_reselect 0)           [ OK ]
TEST: prio (active-backup miimon primary_reselect 1)           [ OK ]
TEST: prio (active-backup miimon primary_reselect 2)           [ OK ]
TEST: prio (active-backup arp_ip_target primary_reselect 0)    [ OK ]
TEST: prio (active-backup arp_ip_target primary_reselect 1)    [ OK ]
TEST: prio (active-backup arp_ip_target primary_reselect 2)    [ OK ]
TEST: prio (active-backup ns_ip6_target primary_reselect 0)    [ OK ]
TEST: prio (active-backup ns_ip6_target primary_reselect 1)    [ OK ]
TEST: prio (active-backup ns_ip6_target primary_reselect 2)    [ OK ]
TEST: prio (balance-tlb miimon primary_reselect 0)             [ OK ]
TEST: prio (balance-tlb miimon primary_reselect 1)             [ OK ]
TEST: prio (balance-tlb miimon primary_reselect 2)             [ OK ]
TEST: prio (balance-tlb arp_ip_target primary_reselect 0)      [ OK ]
TEST: prio (balance-tlb arp_ip_target primary_reselect 1)      [ OK ]
TEST: prio (balance-tlb arp_ip_target primary_reselect 2)      [ OK ]
TEST: prio (balance-tlb ns_ip6_target primary_reselect 0)      [ OK ]
TEST: prio (balance-tlb ns_ip6_target primary_reselect 1)      [ OK ]
TEST: prio (balance-tlb ns_ip6_target primary_reselect 2)      [ OK ]
TEST: prio (balance-alb miimon primary_reselect 0)             [ OK ]
TEST: prio (balance-alb miimon primary_reselect 1)             [ OK ]
TEST: prio (balance-alb miimon primary_reselect 2)             [ OK ]
TEST: prio (balance-alb arp_ip_target primary_reselect 0)      [ OK ]
TEST: prio (balance-alb arp_ip_target primary_reselect 1)      [ OK ]
TEST: prio (balance-alb arp_ip_target primary_reselect 2)      [ OK ]
TEST: prio (balance-alb ns_ip6_target primary_reselect 0)      [ OK ]
TEST: prio (balance-alb ns_ip6_target primary_reselect 1)      [ OK ]
TEST: prio (balance-alb ns_ip6_target primary_reselect 2)      [ OK ]
TEST: arp_validate (active-backup arp_ip_target arp_validate 0)  [ OK ]
TEST: arp_validate (active-backup arp_ip_target arp_validate 1)  [ OK ]
TEST: arp_validate (active-backup arp_ip_target arp_validate 2)  [ OK ]
TEST: arp_validate (active-backup arp_ip_target arp_validate 3)  [ OK ]
TEST: arp_validate (active-backup arp_ip_target arp_validate 4)  [ OK ]
TEST: arp_validate (active-backup arp_ip_target arp_validate 5)  [ OK ]
TEST: arp_validate (active-backup arp_ip_target arp_validate 6)  [ OK ]
TEST: arp_validate (active-backup ns_ip6_target arp_validate 0)  [ OK ]
TEST: arp_validate (active-backup ns_ip6_target arp_validate 1)  [ OK ]
TEST: arp_validate (interface eth1 mii_status DOWN)                 [FAIL]
TEST: arp_validate (interface eth2 mii_status DOWN)                 [FAIL]
TEST: arp_validate (active-backup ns_ip6_target arp_validate 2)  [FAIL]
TEST: arp_validate (interface eth1 mii_status DOWN)                 [FAIL]
TEST: arp_validate (interface eth2 mii_status DOWN)                 [FAIL]
TEST: arp_validate (active-backup ns_ip6_target arp_validate 3)  [FAIL]
TEST: arp_validate (active-backup ns_ip6_target arp_validate 4)  [ OK ]
TEST: arp_validate (active-backup ns_ip6_target arp_validate 5)  [ OK ]
TEST: arp_validate (interface eth1 mii_status DOWN)                 [FAIL]
TEST: arp_validate (interface eth2 mii_status DOWN)                 [FAIL]
TEST: arp_validate (active-backup ns_ip6_target arp_validate 6)  [FAIL]

Here is the test result after the kernel fix:
TEST: arp_validate (active-backup arp_ip_target arp_validate 0)  [ OK ]
TEST: arp_validate (active-backup arp_ip_target arp_validate 1)  [ OK ]
TEST: arp_validate (active-backup arp_ip_target arp_validate 2)  [ OK ]
TEST: arp_validate (active-backup arp_ip_target arp_validate 3)  [ OK ]
TEST: arp_validate (active-backup arp_ip_target arp_validate 4)  [ OK ]
TEST: arp_validate (active-backup arp_ip_target arp_validate 5)  [ OK ]
TEST: arp_validate (active-backup arp_ip_target arp_validate 6)  [ OK ]
TEST: arp_validate (active-backup ns_ip6_target arp_validate 0)  [ OK ]
TEST: arp_validate (active-backup ns_ip6_target arp_validate 1)  [ OK ]
TEST: arp_validate (active-backup ns_ip6_target arp_validate 2)  [ OK ]
TEST: arp_validate (active-backup ns_ip6_target arp_validate 3)  [ OK ]
TEST: arp_validate (active-backup ns_ip6_target arp_validate 4)  [ OK ]
TEST: arp_validate (active-backup ns_ip6_target arp_validate 5)  [ OK ]
TEST: arp_validate (active-backup ns_ip6_target arp_validate 6)  [ OK ]

Hangbin Liu (3):
  bonding: fix ns validation on backup slaves
  selftests: bonding: re-format bond option tests
  selftests: bonding: add arp validate test

 drivers/net/bonding/bond_main.c               |   5 +-
 include/net/bonding.h                         |   8 +-
 .../selftests/drivers/net/bonding/Makefile    |   3 +-
 .../drivers/net/bonding/bond_options.sh       | 264 ++++++++++++++++++
 .../drivers/net/bonding/bond_topo_3d1c.sh     | 143 ++++++++++
 .../drivers/net/bonding/option_prio.sh        | 245 ----------------
 6 files changed, 418 insertions(+), 250 deletions(-)
 create mode 100755 tools/testing/selftests/drivers/net/bonding/bond_options.sh
 create mode 100644 tools/testing/selftests/drivers/net/bonding/bond_topo_3d1c.sh
 delete mode 100755 tools/testing/selftests/drivers/net/bonding/option_prio.sh

-- 
2.38.1

