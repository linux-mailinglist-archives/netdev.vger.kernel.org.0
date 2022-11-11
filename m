Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DED6C625F95
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 17:35:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234103AbiKKQf3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 11:35:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234237AbiKKQf0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 11:35:26 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C700C836A9
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 08:35:24 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id z19-20020a056a001d9300b0056df4b6f421so2982592pfw.4
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 08:35:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=21Ap/1LyO+oL3Gkj0lTDm7V8pEXRuSe9NFvfS6x2ut4=;
        b=ZhKLqeDSF1cGzLV0kTQEqgG1iaYs87hmXoP47x3xYSaraM3jkJzYDH6+/x6mGZs0K9
         +7m5ELyzw+XEEjPI1XlmSgG+yZGxIfVdEY8gHRHnLFHDJ8t1kK4pyqZ02WCCcPhStN3s
         JVfsyCzs8ALbAF8gGqHAm0fdHaRCnxFD02ocjWl2rT31qCqjB3NbnerOBq1owDYpos8F
         AlEh6fSeDep3lGbZrbwJLXplpYLNYBN0/Ap6YBxfrd2dKheYtGyL8Rz0Ezgzm0feiGEE
         z8gXQe52v+TTJlBRQbbXlG+npEBiK8h3LlQbwr4pE4VOpBkGDb8Jd8Gyv7nh/9k/v17W
         d1Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=21Ap/1LyO+oL3Gkj0lTDm7V8pEXRuSe9NFvfS6x2ut4=;
        b=yQIwoMUiscBnQN7AF+p21GMgGzZBdjMvGz7v1r82GtEn1KzaWCbGjo81AkMDmUsAwe
         5kcUZ07Wy3x7Sw+q1fNIqipCAxz6WLkI/mHJkYgOuP34sg54IgIqpSK0IbKRQEdgiy30
         pMzPnSaG+jLejeZshUyX3U3LeNzsQE1AViJ+V3awR3rwXlmttQ4AonhnO0ltaCfTkykJ
         yWe+SVMvLFng1pzpM5DDwZUK8DGJqDM9otUhsnEzXof+47i2c5ajoTskLz0n2380keHL
         67kMm+sESELjG8p9Jow8pFyiz5QLGozMWEGlION+OiyfigIxcPAhn735k/fXh0bnWmPq
         azCA==
X-Gm-Message-State: ANoB5pllH6Slyk2h6xZf1PTKmTPwPfoLzTVtmnf24sYA2jYOVw18wz35
        c9/OhAO8hNbxLc7GTnv7lK74t1PCWOoYg+auR7kj/YZf0au+BbzVAvnGn55Cal6GxBVw18WaP1i
        MM0n+mJw+LAmTusr+puCDqcV5ac8eipYtXQTukBlitBSdC4Z8trEL+D6QDiszToJBNDw=
X-Google-Smtp-Source: AA0mqf4AmvsTR2EMPP37gMYfIklBEQ3Cb3kmVfHQ6sSigltujx1zJuRSP2Iy91Ikk2zo51lAoPFQKLe4X3f/DA==
X-Received: from jeroendb9128802.sea.corp.google.com ([2620:15c:100:202:6a9:95e0:4212:73d])
 (user=jeroendb job=sendgmr) by 2002:a17:902:9a82:b0:186:b46d:da5f with SMTP
 id w2-20020a1709029a8200b00186b46dda5fmr3017331plp.107.1668184524192; Fri, 11
 Nov 2022 08:35:24 -0800 (PST)
Date:   Fri, 11 Nov 2022 08:35:19 -0800
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221111163521.1373687-1-jeroendb@google.com>
Subject: [PATCH net-next v2 0/2] gve: Handle alternate miss-completions
From:   Jeroen de Borst <jeroendb@google.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Jeroen de Borst <jeroendb@google.com>
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

Some versions of the virtual NIC present miss-completions in
an alternative way. This patchset lets the diver handle these
alternate completions and announce this capability to the device.

Changes in v2:
- Changed the subject to include 'gve:'

Jeroen de Borst (2):
  gve: Adding a new AdminQ command to verify driver
  gve: Handle alternate miss completions

 drivers/net/ethernet/google/gve/gve.h         |  1 +
 drivers/net/ethernet/google/gve/gve_adminq.c  | 19 +++++++
 drivers/net/ethernet/google/gve/gve_adminq.h  | 51 ++++++++++++++++++
 .../net/ethernet/google/gve/gve_desc_dqo.h    |  5 ++
 drivers/net/ethernet/google/gve/gve_main.c    | 52 +++++++++++++++++++
 drivers/net/ethernet/google/gve/gve_tx_dqo.c  | 18 ++++---
 6 files changed, 140 insertions(+), 6 deletions(-)

-- 
2.38.1.431.g37b22c650d-goog

