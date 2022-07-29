Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB9EE584DE6
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 11:12:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234942AbiG2JMj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 05:12:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbiG2JMi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 05:12:38 -0400
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D00637AC2E
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 02:12:37 -0700 (PDT)
Received: by mail-qv1-xf4a.google.com with SMTP id q1-20020a056214018100b0047464a85fc4so2872492qvr.7
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 02:12:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=y76LSQxConD0f1Q0A9uia7xcbSlFUgl9V489/GJLb3M=;
        b=mFuo+zJUJVhRFl48yyojGWacaHRMCxv1C+sV30/UYsQi1TxueTFAQRXS7eKKiuWmrj
         HYMA+xu9gCjoEAtgd4cgIgop3UmCoipk2BB3prV3v4wzhqKbZjEoDHEYzGA9R+GnOJOm
         5esnqkxY86+m8LSBPH6xqUQpYkxb8XX3ogsLfWUrWVtej1cC3jg5Vx1dg+vmYBWtrOL8
         /kQdOnmWS9Ggl0YiLp9Hq6HFbaNwqqCTrYP551F3StKXWMthpmG8ccieSojZQCDkNNJ5
         YOh3xXPSoR0P3lj+FWXJvNTboCMiGvynpmKhtsOtItrvBaprvadswciKeiSBH5AfbC34
         6qhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=y76LSQxConD0f1Q0A9uia7xcbSlFUgl9V489/GJLb3M=;
        b=NlUYVEHsgM+ZdPSb4vJq5k05p/3Lxz276uEzJK09FxlFt2ZfKmV2enQKvbMaZTxHuy
         MQUShsRYDuDwUXmmlr2R227GtdRAsYA4MKvjlm5Kd8SYvtW0E/FdpwFoE7Bw9oS2WyJf
         VB/T2KM4JzfvA7IA2ngJ6VZwBm2y+w2OFt/S9L+mxQ1uWcN2GzS/urFlxKlh14p4dWj7
         u6SpZt865hxcFkukxpgshKcwV44VDRl4cscCEPAbNwAYb4pA2qGsyowSr8MYTZdtu6e/
         LfM9xT2Vl29v8DFWgyuhm66dA21cLhPuLQCv9OzBFt+K7hEXp4SAmAOV+O8YxveJnB0o
         /9GA==
X-Gm-Message-State: AJIora//bpK5rIGEKvNk/67kL4o0kpndKzuXdyeucwEJyHtW2B6gAAr4
        ViCiBpIdWcCZvR+F3GLGJnyWidbahIfqEg==
X-Google-Smtp-Source: AGRyM1vPetb8t7s8ecOs/UCDrkmtZ5hbDxWPo/z6MFwii8w35CTXOl0JAksOb74fiYbkg/zAAan8PFgPYftHIA==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a05:620a:244d:b0:6b2:538f:ffda with SMTP
 id h13-20020a05620a244d00b006b2538fffdamr1940155qkn.218.1659085957070; Fri,
 29 Jul 2022 02:12:37 -0700 (PDT)
Date:   Fri, 29 Jul 2022 09:12:31 +0000
Message-Id: <20220729091233.1030680-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.1.455.g008518b4e5-goog
Subject: [PATCH net-next 0/2] net: rose: fix module unload issues
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Bernard Pidoux <f6bvp@free.fr>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bernard Pidoux reported that unloading rose module could lead
to infamous "unregistered_netdevice:" issues.

First patch is the fix, stable candidate.
Second patch is adding netdev ref tracker to af_rose.

I chose net-next to not inflict merge conflicts, because
Jakub changed dev_put_track() to netdev_put_track() in net-next.

Eric Dumazet (2):
  net: rose: fix netdev reference changes
  net: rose: add netdev ref tracker to 'struct rose_sock'

 include/net/rose.h    |  3 ++-
 net/rose/af_rose.c    | 17 +++++++++++++++--
 net/rose/rose_route.c |  2 ++
 3 files changed, 19 insertions(+), 3 deletions(-)

-- 
2.37.1.455.g008518b4e5-goog

