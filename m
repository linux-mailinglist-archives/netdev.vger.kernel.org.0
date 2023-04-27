Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2581C6EFFE5
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 05:39:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242790AbjD0DjU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 23:39:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231883AbjD0DjT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 23:39:19 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E23E9212D
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 20:39:16 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id d2e1a72fcca58-63b5ce4f069so9636452b3a.1
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 20:39:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682566756; x=1685158756;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=shEVZ7ebhKqP6PSbAcF7Z1c08YZqH/QGyblCfvtTjYA=;
        b=W2I2BIsn7LEbpd78+pPDu6QsLuE3C9YvxmE16Z645J1M+cRWm529nGDyisdSy49nkE
         EM+8Cb/07qvzaHu1FoIoA8cWF9ooXD6aP9xu7o/FDx5EGFahePfOgLFlW32oyW4lFQcW
         /IZagpdGDULjRkHIAK7aK8SN26TwuHlqwnNH4a02A1MTe+fogA+XontVTRkCSm0qosVI
         CJAs1Yr0Dvxm2UIsD7bTGzwmHaxJGru01B6pWbU/qEdZxHKG1Dg2uwEDac6N0PXArqib
         hmMjskoWlEg2WLADMxh4LutqWc1bZC9AM2tGLn4rQblgoVXoGGdmHKupyTHWdubozXbL
         +PjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682566756; x=1685158756;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=shEVZ7ebhKqP6PSbAcF7Z1c08YZqH/QGyblCfvtTjYA=;
        b=QJXUkIu/s08iMmR3zClH6sVT8rYNdc2CoaEkiazYH57hX0HdjLH2YLSS+QwTBaM8yK
         utnHX8Kzo/Hz71vPf1kKXtYxrc9iwuo+POHOpPOdqnK6yLWAN7B9h/AuHCdRyrwufeNP
         wHHtYOh3lyzh0w8GsI1SLenp2nFlasX9MJbosafed5fbDaUhYx/0K4VzhkPOXV/pULdG
         YWriq9IgrNp+/uY8ZBBP3hynjff6qFQBBq3h6rLxH+pBhTyqOakv44guNawNqJxLnnGf
         CmKlC+3Lgc6RxMr7ovOBdkAkKRMGfimCj/OBlGT+C1Yfl/U/b4wuqPr9c1MIm6nqm+Wl
         AZeQ==
X-Gm-Message-State: AC+VfDxn3TqloWV73SwIyW5pmpu4WZpGPLozWDyXkmhIRCRghaNDXUn2
        tHRZ2pHMWsbYJvSyNJzIU70ODi9FFidwVIj7
X-Google-Smtp-Source: ACHHUZ4OfJ4TZl5s7b2tGKgy3Tw3srv/ZaHdqvl3H8zE42gtlyBcDS+g/UKAeT3PG48mzOeMmLgVKA==
X-Received: by 2002:a05:6a00:138c:b0:63d:24d0:2c32 with SMTP id t12-20020a056a00138c00b0063d24d02c32mr321405pfg.33.1682566755885;
        Wed, 26 Apr 2023 20:39:15 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id h17-20020a056a001a5100b005abc30d9445sm12017743pfv.180.2023.04.26.20.39.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Apr 2023 20:39:15 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Liang Li <liali@redhat.com>,
        Vincent Bernat <vincent@bernat.ch>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv2 net 0/4] bonding: fix send_peer_notif overflow
Date:   Thu, 27 Apr 2023 11:39:05 +0800
Message-Id: <20230427033909.4109569-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.38.1
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

Bonding send_peer_notif was defined as u8. But the value is
num_peer_notif multiplied by peer_notif_delay, which is u8 * u32.
This would cause the send_peer_notif overflow.

Before the fix:
TEST: num_grat_arp (active-backup miimon num_grat_arp 10)           [ OK ]
TEST: num_grat_arp (active-backup miimon num_grat_arp 20)           [ OK ]
4 garp packets sent on active slave eth1
TEST: num_grat_arp (active-backup miimon num_grat_arp 30)           [FAIL]
24 garp packets sent on active slave eth1
TEST: num_grat_arp (active-backup miimon num_grat_arp 50)           [FAIL]

After the fix:
TEST: num_grat_arp (active-backup miimon num_grat_arp 10)           [ OK ]
TEST: num_grat_arp (active-backup miimon num_grat_arp 20)           [ OK ]
TEST: num_grat_arp (active-backup miimon num_grat_arp 30)           [ OK ]
TEST: num_grat_arp (active-backup miimon num_grat_arp 50)           [ OK ]

Hangbin Liu (4):
  bonding: fix send_peer_notif overflow
  Documentation: bonding: fix the doc of peer_notif_delay
  selftests: forwarding: lib: add netns support for tc rule handle stats
    get
  kselftest: bonding: add num_grat_arp test

 Documentation/networking/bonding.rst          |  9 ++--
 drivers/net/bonding/bond_netlink.c            |  6 +++
 drivers/net/bonding/bond_options.c            |  8 ++-
 include/net/bonding.h                         |  2 +-
 .../drivers/net/bonding/bond_options.sh       | 50 +++++++++++++++++++
 .../drivers/net/bonding/bond_topo_3d1c.sh     |  2 +
 tools/testing/selftests/net/forwarding/lib.sh |  3 +-
 7 files changed, 73 insertions(+), 7 deletions(-)

-- 
2.38.1

