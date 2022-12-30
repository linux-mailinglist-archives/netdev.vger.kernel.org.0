Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3285659E09
	for <lists+netdev@lfdr.de>; Sat, 31 Dec 2022 00:22:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235646AbiL3XWh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Dec 2022 18:22:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235598AbiL3XWg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Dec 2022 18:22:36 -0500
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 393691D0F5
        for <netdev@vger.kernel.org>; Fri, 30 Dec 2022 15:22:34 -0800 (PST)
Received: by mail-il1-x12b.google.com with SMTP id o8so12082256ilq.6
        for <netdev@vger.kernel.org>; Fri, 30 Dec 2022 15:22:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+oKPI+GG7LV+5ker6SpVDvok6IOfz+fQVlv3SCDlsGw=;
        b=YWWV20CIDksjI20pOro7F/XRxjMqUml933uy20TBvHTsnEI67L4JUlGC6PJAX9bvno
         B0TccC9Xo/D96QK609oruLvJIEwYVXw8w52O2087nmDdVzNX+ZVeQ/f0yzddJCukL8nG
         c6DryLooOWJIBHvpUiqJBMaNEuPiY4P8hyhGWHTzXYw4j80r+16Dk10u3uglFr+bJJdJ
         JWw0zUd+sdHMsQ3gqSt8Cb19yfx4QCSZjbSEmEQhe+q4zwj0wEFIHIsnzj9c7DY+BnzR
         rwQFzYE606esR4rNR8PX6TXqfE7m2su1YNst24WD/kr5RNPXkoVa7fFJ+4dzZ9rA6bc1
         D0BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+oKPI+GG7LV+5ker6SpVDvok6IOfz+fQVlv3SCDlsGw=;
        b=C25RKS8WPkMmi1TN526sT8sonP9WBpYBWdurdxfEEqfW+ugjCJzrtkcFfw9Bn8A8s5
         Xde+g9sVdrAl/FOhXDzCPmX+qS9MMum3POd+pplk6X8iSQlRR8vr8DgWh3r2e1WEbUJF
         oz/3UwxqfR6T0fYi3kxSfBlMReramVonMlVq+rQZThMBQBsXDzKfIrxw/Ac6Q9FYPxZG
         Nn8pg9rsC32JPE1TEGM/7s/k6EOcjXTM0jcFQi9u72B8rBhcvNOE9itx5CiZnnThLYV6
         sC3EfuUqNSAbEN/9CH2Im+Kqg6cZTkXP0QRN/QtiNoHnkIvOBPlHQOrQMlNv5pERMyoR
         onAA==
X-Gm-Message-State: AFqh2kqalA/0fPYwZpgYEWd+5pmPKGzMlmndQp8ZLkFjQlgrMLi3DSAS
        07sxx3k6aPe1A3WWylf+f2mGow==
X-Google-Smtp-Source: AMrXdXsgYpdKOANIDkZGeVmRnpjgVxflAOqBOyKPxSzHqI3b6x3GQUoH5nruLqKItoXdjThwnd1r5Q==
X-Received: by 2002:a92:d684:0:b0:30b:e8a6:2772 with SMTP id p4-20020a92d684000000b0030be8a62772mr23566226iln.24.1672442553564;
        Fri, 30 Dec 2022 15:22:33 -0800 (PST)
Received: from presto.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id co18-20020a0566383e1200b0038a53fb3911sm7170558jab.97.2022.12.30.15.22.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Dec 2022 15:22:32 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     caleb.connolly@linaro.org, mka@chromium.org, evgreen@chromium.org,
        andersson@kernel.org, quic_cpratapa@quicinc.com,
        quic_avuyyuru@quicinc.com, quic_jponduru@quicinc.com,
        quic_subashab@quicinc.com, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/6] net: ipa: simplify IPA interrupt handling
Date:   Fri, 30 Dec 2022 17:22:24 -0600
Message-Id: <20221230232230.2348757-1-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

One of the IPA's two IRQs fires when data on a suspended channel is
available (to request that the channel--or system--be resumed to
recieve the pending data).  This interrupt also handles a few
conditions signaled by the embedded microcontroller.

For this "IPA interrupt", the current code requires a handler to be
dynamically registered for each interrupt condition.  Any condition
that has no registered handler is quietly ignored.  This design is
derived from the downstream IPA driver implementation.

There isn't any need for this complexity.  Even in the downstream
code, only four of the available 30 or so IPA interrupt conditions
are ever handled.  So these handlers can pretty easily just be
called directly in the main IRQ handler function.

This series simplifies the interrupt handling code by having the
small number of IPA interrupt handlers be called directly, rather
than having them be registered dynamically.

					-Alex

Alex Elder (6):
  net: ipa: introduce a common microcontroller interrupt handler
  net: ipa: introduce ipa_interrupt_enable()
  net: ipa: enable IPA interrupt handlers separate from registration
  net: ipa: register IPA interrupt handlers directly
  net: ipa: kill ipa_interrupt_add()
  net: ipa: don't maintain IPA interrupt handler array

 drivers/net/ipa/ipa_interrupt.c | 103 ++++++++++++++------------------
 drivers/net/ipa/ipa_interrupt.h |  47 +++++----------
 drivers/net/ipa/ipa_power.c     |  19 ++----
 drivers/net/ipa/ipa_power.h     |  12 ++++
 drivers/net/ipa/ipa_uc.c        |  21 +++++--
 drivers/net/ipa/ipa_uc.h        |   8 +++
 6 files changed, 98 insertions(+), 112 deletions(-)

-- 
2.34.1

