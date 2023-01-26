Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A70D67C9B6
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 12:21:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237000AbjAZLVh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 06:21:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237018AbjAZLVh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 06:21:37 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 921443F28D
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 03:21:35 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5066df312d7so16750037b3.0
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 03:21:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=8aWP/7KYMIETYbUMU1ygsbxjshGSg3ribsaCBcGYIkg=;
        b=srL1uhXPMefNESm2C20SMpk/qXi7voi2HrSbxgGso/VmI/xpbtvWQzuvbVoUztM3gU
         iXesmkARKJeb0PqdNHUsHys0uM0m6G/WfaV703UVzgl5dClvjzIrGjK7jpMfiQ15M+lU
         7+cLC4ti2m+3TU2m7FU/AaUXINDOc+CfAgCClQvYygxRDmLwl7Zn1yCINjz5yjnrLwET
         nvfm1dAY/5wK8UDqptyks9BHsestamH/aiC4DdMWF1R1w9uPuarwR9lFzgPik7aG5obI
         UTIQqi/EvWfbGm4HX4dydQq2U2WqM4zdPOh1q04RcM894MYTDuL4eLKjulncvze97GyQ
         r2Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8aWP/7KYMIETYbUMU1ygsbxjshGSg3ribsaCBcGYIkg=;
        b=IjceKTgZReWCyRLR+xkqcxjT2moNFMPDemzCH7x3ATgDmXXQtjTjfFjV/9QL5R/GbB
         C5Or3EpfEUTX2P8yRChGTr3EfHR0Q/dXgrRCxO4WTVkTaH890f6kRFJsC5pjHYQjv6zW
         dRmMmEr2bAEXLjCO1gkOtHeRej0ZJk4qLuAY6iH5xLoeTKjAT+2jzpcErxLSXpxDbk+t
         bFheaH9YREcqw5QYp61w6tCXp7JRR/yCQ969aY7VbsZ6n205TZiB2+En0B7JoHhTy9RY
         W/TLywsalVf2PLauuO43sNCU/+LZWrLcq2zLcxZM2J06aJa0kE5+gz0iG+tGC0ieKCny
         oncA==
X-Gm-Message-State: AO0yUKUexArjF4kWVZAZldOW7Oiv4UMESx9XS5tQ3mFXZCq6dojh36PM
        LovOVekIAc8faaoRJL6u02XojVnNYLLEgg==
X-Google-Smtp-Source: AK7set9Q/zWyOmK5024Il2Nxk8cpG01WF6mjl9fAXtkhsOQ9yNOdBL8i3zKwH+tSxYD3DilbRMQvUWe6l6fESQ==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a05:6902:1506:b0:80b:b89d:95c2 with SMTP
 id q6-20020a056902150600b0080bb89d95c2mr431363ybu.40.1674732094075; Thu, 26
 Jan 2023 03:21:34 -0800 (PST)
Date:   Thu, 26 Jan 2023 11:21:28 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.1.456.gfc5497dd1b-goog
Message-ID: <20230126112130.2341075-1-edumazet@google.com>
Subject: [PATCH net 0/2] xfrm: two fixes around use_time
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Steffen Klassert <steffen.klassert@secunet.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
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

First patch fixes a long/time64_t mismatch,
found while addressing a syzbot report.

Second patch adds annotations to reads and
writes of (struct xfrm_lifetime_cur)->use_time field.

Eric Dumazet (2):
  xfrm: consistently use time64_t in xfrm_timer_handler()
  xfrm: annotate data-race around use_time

 net/xfrm/xfrm_policy.c | 11 +++++++----
 net/xfrm/xfrm_state.c  | 18 +++++++++---------
 2 files changed, 16 insertions(+), 13 deletions(-)

-- 
2.39.1.456.gfc5497dd1b-goog

