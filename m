Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6A506134C4
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 12:44:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbiJaLor (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 07:44:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230519AbiJaLoS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 07:44:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75EA0E0ED;
        Mon, 31 Oct 2022 04:44:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2F4A1B815F0;
        Mon, 31 Oct 2022 11:44:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87A4FC433C1;
        Mon, 31 Oct 2022 11:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667216653;
        bh=EMzbD4B5bfnKfJkZGRgtgkLVwrwh+JQ4S/pXYPWRlME=;
        h=From:To:Cc:Subject:Date:From;
        b=kspjBtIZxgn6e+oCSNlrBpC6ANeXeD52Ho7ocYN0+kV6fQxetHIuKQc/M1v/0cTpy
         3f1MLE6hPHBhaedF0Pu90juiH6CMDTykij3hgMO3uO8pJTyTgy6PsbrsrPguHD5GJM
         RTWB8CWzYAeHJIr1KqyhVLczfKMIpch0ppFnjKSidpISMPKXYzL102sWdS4vscn1aZ
         dDWBmp0PlDZNAXZFwitGGAcktWiELRkp+rrY/MoAjUPYTjqBO1VnZ8Izeqx1ulYBF8
         kXwvw5npEUPA5Et3AJyj0Xeubtw4gN9l/hrGnNm3s8NNlQkZBI/nIFcKxT/HOKFaEv
         qMihU4G5jfBig==
From:   "Jiri Slaby (SUSE)" <jirislaby@kernel.org>
To:     j.vosburgh@gmail.com
Cc:     linux-kernel@vger.kernel.org,
        "Jiri Slaby (SUSE)" <jirislaby@kernel.org>,
        Martin Liska <mliska@suse.cz>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: [PATCH] bonding (gcc13): synchronize bond_{a,t}lb_xmit() types
Date:   Mon, 31 Oct 2022 12:44:09 +0100
Message-Id: <20221031114409.10417-1-jirislaby@kernel.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Both bond_alb_xmit() and bond_tlb_xmit() produce a valid warning with
gcc-13:
  drivers/net/bonding/bond_alb.c:1409:13: error: conflicting types for 'bond_tlb_xmit' due to enum/integer mismatch; have 'netdev_tx_t(struct sk_buff *, struct net_device *)' ...
  include/net/bond_alb.h:160:5: note: previous declaration of 'bond_tlb_xmit' with type 'int(struct sk_buff *, struct net_device *)'

  drivers/net/bonding/bond_alb.c:1523:13: error: conflicting types for 'bond_alb_xmit' due to enum/integer mismatch; have 'netdev_tx_t(struct sk_buff *, struct net_device *)' ...
  include/net/bond_alb.h:159:5: note: previous declaration of 'bond_alb_xmit' with type 'int(struct sk_buff *, struct net_device *)'

I.e. the return type of the declaration is int, while the definitions
spell netdev_tx_t. Synchronize both of them to the latter.

Cc: Martin Liska <mliska@suse.cz>
Cc: Jay Vosburgh <j.vosburgh@gmail.com>
Cc: Veaceslav Falico <vfalico@gmail.com>
Cc: Andy Gospodarek <andy@greyhouse.net>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org
Signed-off-by: Jiri Slaby (SUSE) <jirislaby@kernel.org>
---
 include/net/bond_alb.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/net/bond_alb.h b/include/net/bond_alb.h
index 191c36afa1f4..9dc082b2d543 100644
--- a/include/net/bond_alb.h
+++ b/include/net/bond_alb.h
@@ -156,8 +156,8 @@ int bond_alb_init_slave(struct bonding *bond, struct slave *slave);
 void bond_alb_deinit_slave(struct bonding *bond, struct slave *slave);
 void bond_alb_handle_link_change(struct bonding *bond, struct slave *slave, char link);
 void bond_alb_handle_active_change(struct bonding *bond, struct slave *new_slave);
-int bond_alb_xmit(struct sk_buff *skb, struct net_device *bond_dev);
-int bond_tlb_xmit(struct sk_buff *skb, struct net_device *bond_dev);
+netdev_tx_t bond_alb_xmit(struct sk_buff *skb, struct net_device *bond_dev);
+netdev_tx_t bond_tlb_xmit(struct sk_buff *skb, struct net_device *bond_dev);
 struct slave *bond_xmit_alb_slave_get(struct bonding *bond,
 				      struct sk_buff *skb);
 struct slave *bond_xmit_tlb_slave_get(struct bonding *bond,
-- 
2.38.1

