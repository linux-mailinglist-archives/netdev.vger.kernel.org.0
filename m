Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D702565F5C2
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 22:28:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235831AbjAEV2d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 16:28:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235837AbjAEV23 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 16:28:29 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C974A63F65
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 13:28:27 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id y2-20020a17090a784200b00225c0839b80so13084019pjl.5
        for <netdev@vger.kernel.org>; Thu, 05 Jan 2023 13:28:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=HAqltNVdmzidGonaxz9mBRIXWaB/TvzkjWkFa3HryMQ=;
        b=SzqalLHaVV0ROgy38uGYl66C/CN7x18Mb1BNbstEdlU0dZHFrSLzfP+E7wsRK+MmXS
         ujOftHBNr6Ye1Q8ldAPGChhKTgXfXccwmFpmMxjBEGH2xn/kWtGEpMcfukMAEjmheKQF
         lKO/pfBq1u/TT8h+rpXeV+fgY9dFjenQ/ca4gpCBOb22rIVRLu44PAJGXfY/CmMr/3JE
         T2UfmylBtZCODR5+LkQoJoNrqkq6rd9tnA2/4mloKV4FBkNxcakwzB0SIZoRteajqR37
         rKLBQ5o+tx4okFRlZ0ur58X8qTAWpmXeZZvhqCYSO/zFsLs7sPY0cqFoMESvqXVpof6z
         OuLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HAqltNVdmzidGonaxz9mBRIXWaB/TvzkjWkFa3HryMQ=;
        b=w4/H0TI7OOeBNZ41A5Haz0ethry5/41/jHuPzNsIHpbkAsuy++q5bM0u0UV/K9/Qia
         UbSVhjmN/7GqP9QS7SSwaWqz6serw7Iryn3u/arwFr9btaCwj9S79cMG0EsP/IsyOKSe
         PKS382H7MGEPry2KEu8dgTE7aN5kTpAgiNHGqZ+vDHpTeCt+Cg6yLQo8xJ1AX2QpN+1T
         fjOklGFuHm3Wnvbku2iy44IRh22xb6AiByf+8b7n12/HZN+i8neIzKoZt9A5LeMJew3t
         aSv2eMvOnLFLspXxxyyfmm1O23qJ42ELUO5rdDTvxQ+HkNTLyjbYoJGdy98pw8YdH5Rh
         CdtA==
X-Gm-Message-State: AFqh2kqrTsCeqBY/pbngvECiSwMGDxuSFW77qOxa0kXmgQwkV0BfVAD1
        ByEiQMJ+cIkFB5BRDPPZbJHV9gSvHkBbDgNu+/yX/3Cq35kNfCFRYPI50mLLFKNwvf+v6Ss94mZ
        m+83m6RsFYQXioop88deOUzeot8FU50ToahennkPRXOaQEvkpj2rIM7rYtZGKxKwrwYshIm06/F
        LMwg==
X-Google-Smtp-Source: AMrXdXsuKZ9C1gDn2BToxMbPC8YDoaI7DujZ84aPgEDY66b4g/9Y71Uq1gFH6TCJAz4gK7ERGUkyECuU8jbPCuqLfoA=
X-Received: from obsessiveorange-c1.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3039])
 (user=benedictwong job=sendgmr) by 2002:a05:6a00:72b:b0:576:22e9:2024 with
 SMTP id 11-20020a056a00072b00b0057622e92024mr4395860pfm.65.1672954107082;
 Thu, 05 Jan 2023 13:28:27 -0800 (PST)
Date:   Thu,  5 Jan 2023 21:28:11 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20230105212812.2028732-1-benedictwong@google.com>
Subject: [PATCH v3 ipsec] Fixing support for nested XFRM-I tunnels
From:   Benedict Wong <benedictwong@google.com>
To:     netdev@vger.kernel.org
Cc:     nharold@google.com, benedictwong@google.com, lorenzo@google.com,
        steffen.klassert@secunet.com
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

v1 -> v2: Rebased; reference to xi removed, updated patch to check if_id
v2 -> v3: Rebased; xfrm_interface.c moved to xfrm_interface_core.c



