Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E275E58F23D
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 20:22:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231368AbiHJSWR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 14:22:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbiHJSWQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 14:22:16 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D340479A69
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 11:22:13 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id u10-20020a170903124a00b0016ec85be3b7so10150293plh.4
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 11:22:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:mime-version
         :message-id:date:reply-to:from:to:cc;
        bh=t/MlMpKWNhTXoa34NIKxzocBNPxfrVEWib0QBScFLsE=;
        b=gy9j3j1dJM+1Mj4qkQjTpU0K5DnBot/UpEqbAqh+War3pheRrI2tNhvv9uJX9NrXgo
         C5V116eYYmRMcFz7+wd4ks6D1NdaTqdmyisX8CATze5CIaCq8Ghw1rt1Qc4tP1ETljdL
         NbX9s+Li0D0GgCIipyVkoYIVIH8W87z7BitNr6Ab5PswMCpcqCR2i8vmwDKXwQkKeR8C
         Zap2M+wgSmJpzJbbpTIA7ZTVYWaJ76z2VhHaz9ISCmY788X2t1RT98IlFp9MchnreZbw
         hNeI/oc4/5xOzodK1k4T3W613suXwsoCZFBQ7zE5iBpvQBzkRJfZu9dq7FpoQZg1XZTf
         hubg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:mime-version
         :message-id:date:reply-to:x-gm-message-state:from:to:cc;
        bh=t/MlMpKWNhTXoa34NIKxzocBNPxfrVEWib0QBScFLsE=;
        b=Kwk2cDM7Lr2dZ17aJPkb2FeoluE7M+2PtmUK1TmCXJJNHLQr8L6BrdSdRzLgBVESZG
         B+EJqnkNI114zRQEIXH0gLKxunaO444kvSFp0B1mL7g7bQSCYmpPwcKzaSNBasqjTgGV
         XDN2Lr/78AHp4WlAD6Zz6hDPAIFnBu5vksqUMIrPC1UlL+QIgGHlmMdOW2XnLqXQdXYZ
         CuHHZngexKmb8GvbBqOB80IfXMA6/asCrNoVeWi/f7wx3dLa92JTl3zYJjJP8izkUp8O
         hs2oH+7fbwGchZR1t+ydjGlKDPOYhKFzCtsQWYxqILeP/Enp5Eots082jpWnLdzote/H
         aXiw==
X-Gm-Message-State: ACgBeo0mdK2ERyWYn8OQgu/Z+Led1i9sJuuQLapbrqGR8ozZ3DLPsWLM
        CsGkvSmk07oHAeOEOx7mQ997Tb4u2pVylTlFZsA=
X-Google-Smtp-Source: AA6agR7vdJKADtV8E1d4GlCkpP3SgU24dabgy3CowGagwMNdQwJOM+L9uT8FyXHya6S0AzVmRhJuNg5jw5pUQB154vc=
X-Received: from obsessiveorange-c1.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3039])
 (user=benedictwong job=sendgmr) by 2002:a17:90b:4c4b:b0:1f7:11f:8e8e with
 SMTP id np11-20020a17090b4c4b00b001f7011f8e8emr4906145pjb.98.1660155733388;
 Wed, 10 Aug 2022 11:22:13 -0700 (PDT)
Reply-To: Benedict Wong <benedictwong@google.com>
Date:   Wed, 10 Aug 2022 18:22:08 +0000
Message-Id: <20220810182210.721493-1-benedictwong@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [PATCH ipsec 0/2] xfrm: Fix bugs in stacked XFRM-I tunnels
From:   Benedict Wong <benedictwong@google.com>
To:     steffen.klassert@secunet.com, netdev@vger.kernel.org
Cc:     nharold@google.com, benedictwong@google.com, lorenzo@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set fixes bugs that prevent stacked IPsec tunnels (via XFRM
interfaces) from receiving packets properly. The apparent cause of the
issues is that the inner tunnel=E2=80=99s policy checks fail to validate th=
e
outer tunnel=E2=80=99s secpath entries (since it no longer has a reference =
to
the outer tunnel policies, and each call validates ALL secpath entries)
prior to verifying the inner tunnel=E2=80=99s. This patch set fixes this by
caching the list of verified secpath entries, and skipping them upon
future validation runs.

PATCH 1/2 Ensures that policies for nested tunnel mode transforms are
checked before additional decapsulation. This ensures that entries in
the secpath are verified while the context (intermediate IP addresses,
marks, etc) can be appropriately matched.

PATCH 2/2 Skips template matching for previously verified entries in
the secpath. This ensures that each tunnel is responsible for
incrementally verifying the secpath entries associated with it.



