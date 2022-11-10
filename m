Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBD1762485A
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 18:28:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230078AbiKJR2h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 12:28:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231499AbiKJR2c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 12:28:32 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65524F40
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 09:28:28 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id z19-20020a056a001d9300b0056df4b6f421so1361075pfw.4
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 09:28:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=pHIYn4Zg5LDKvEPYO7EDkqfjkni4Sv4USWbGYwqmJ34=;
        b=g7zfJRipOIKx6cSt56hsT7joW0yM2z0/0QADmCdAo+uZUSTvxOhLm62waucKWF7TMU
         t4MklEOXicg6iHEyAOHRj3fUg/fY4wDf5rOhxGOIVJyJpimy8P4A39FfMuK0MDzyYdfx
         raOfz1uTNjT+oqHbLCm3g4WorirlN/ld2cHITJhLsoD6KFxM1+iFHdMeKk4pms8mKYsW
         OogeGJ0EMWM9H4sVdDOq8lrV9N+M4T/EKGgnxk3Q0EvrZUEobjf5sS2ELWy5+B8TC316
         qIe3hVe8dEdl2azRQAeH0CbF7A9azfauIiv0thM1Yau8iQRh7VnI3Z7Afjc5IMqpXx4q
         YM6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pHIYn4Zg5LDKvEPYO7EDkqfjkni4Sv4USWbGYwqmJ34=;
        b=BwMyTSO2UpcIBQfB6fam6CXUgvyAye14Inzv3jBD3bUn0iKNVKLpLvMm8Lnu/VeV9P
         wN0g877g0NRvKormFzNTJ8C0dY2wT/JDyhTbViJf3qw/Aaie28BRzcIRkoVksaZTwb4l
         uRgX/StvoEzeRuPiXojD0yjKFECFQHSPHLiLJ5MChYnWOkLb8ZLY7eghAewrs8kcgNEz
         8HM6zDW8MyW4Yhknm1y/5iVak3xfDWZoQ1DnQf/K5PWPxhkw2JkYnqYmy/wq1vvAerWF
         3q43aNJKsw6kcSrtQPlyDrlwT83YgooAHjNBpwvN0RgeJwk8Re6nkZRlrB/nWxbRNHRD
         6NPA==
X-Gm-Message-State: ANoB5pl1N1UTDu/j3Pzxaj/Ea37zv0gsfG0h1fYdqS3aECVS51IA/93o
        m6RzdPNH6ZnZSVhxvTkRGsVF6FJjr2LFwhSkDb8GiREJIAw8CHRunczFg1K2aOyeYIVdJ2YoqOg
        0ZE4FlqAbvNOhtcdB5EBmWGVKuHFT2NK7CwbYApx1MC6BkfEKricl2f+TGqJnSW/AB4I=
X-Google-Smtp-Source: AA0mqf6YIfELNVxVZSJtIdUZfTeZpMnWUbR8Rr4Rr6FiWyrXWfdePljE72aFZ3AM7ORWEqASDwRDMuGPys224w==
X-Received: from jeroendb9128802.sea.corp.google.com ([2620:15c:100:202:6a9:95e0:4212:73d])
 (user=jeroendb job=sendgmr) by 2002:a17:90b:4003:b0:20a:fee1:8f69 with SMTP
 id ie3-20020a17090b400300b0020afee18f69mr105672pjb.0.1668101307470; Thu, 10
 Nov 2022 09:28:27 -0800 (PST)
Date:   Thu, 10 Nov 2022 09:27:58 -0800
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221110172800.1228118-1-jeroendb@google.com>
Subject: [PATCH net-next 0/2] Handle alternate miss-completions
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
an alternative way. This patch-set lets the diver handle these
alternate completions and announce this capability to the device.

Jeroen de Borst (2):
  Adding a new AdminQ command to verify driver
  Handle alternate miss completions

 drivers/net/ethernet/google/gve/gve.h         |  1 +
 drivers/net/ethernet/google/gve/gve_adminq.c  | 19 +++++++
 drivers/net/ethernet/google/gve/gve_adminq.h  | 51 ++++++++++++++++++
 .../net/ethernet/google/gve/gve_desc_dqo.h    |  5 ++
 drivers/net/ethernet/google/gve/gve_main.c    | 52 +++++++++++++++++++
 drivers/net/ethernet/google/gve/gve_tx_dqo.c  | 18 ++++---
 6 files changed, 140 insertions(+), 6 deletions(-)

-- 
2.38.1.431.g37b22c650d-goog

