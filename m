Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECF4D6F2B72
	for <lists+netdev@lfdr.de>; Mon,  1 May 2023 00:51:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232131AbjD3Wvd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Apr 2023 18:51:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbjD3Wvc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Apr 2023 18:51:32 -0400
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D58191BF
        for <netdev@vger.kernel.org>; Sun, 30 Apr 2023 15:51:31 -0700 (PDT)
Received: by mail-qk1-x72e.google.com with SMTP id af79cd13be357-74de7182043so80263485a.3
        for <netdev@vger.kernel.org>; Sun, 30 Apr 2023 15:51:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682895091; x=1685487091;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=OrAsa+ID2gAFMV7KZ165YTTGAl7/KcUJNVqnJa+1Nlg=;
        b=bqrlnwZDMwS1N3YKKFdrTao7Me2nIBNv7KRcw88UYSRd0v77TkZWJitkMuROibfZcy
         Tt1G4zP8n5JrGBceavx01QfNF6qEL92nf6XTolYwLgDYkBFzxXXyRCuHiUgu7Lhjv8RV
         joyVG/kbtZXhte2PBqLqR6rEvWWDf3fKj2ToZBUNKkJ+fdADgJb3NA2WbrvAs+53gKSc
         ezZyscH6uHbn2EfgYmOwrznzYSKasiA6cQjNQuF9FUXKArtWdzKvMrIbgLSllD9SEQIF
         mu3yZbyBPyJRhSG/ZJy/eFgusqAecx8MrenVZnWQV9Ndxa1GhUpbxMmpbZba5ulOD717
         eKgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682895091; x=1685487091;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OrAsa+ID2gAFMV7KZ165YTTGAl7/KcUJNVqnJa+1Nlg=;
        b=QJprVgNRHIQM6U+vjm9Y459CV1QQa5Amtu5BksKkBKL1b/d4ZZndp8UptU7E2Y1KFo
         Y8K1budC++W7pDlVeG0MaC7+J8bdOD6bUrbSGOmAr0u1Jzi28x35Yz2Avlm4LX5Cr5Wn
         oGAGn8LDIj5RRAvG/F2TgcDjzNXYHT7KUDX3IEtkOvx5XSSawNvq2LA4MEldRmilFht5
         1cz69+prc+ad6mcICl4IU9JcL5iIDAniIfoiF4ICj1GoSfbOd6xUDzrumPa6oXJAwfRK
         HIuqBite2bOzR4uewEOWsU7NxEcu9bndbgg72a1Re0BdRKmHBfYdHxF8cT5Zws3OEx4g
         M+8w==
X-Gm-Message-State: AC+VfDxLhPtbwB4f1OcdMFqmXf52SuaV1Mh3fKoKH1dqBSux2d1vuDUs
        W3iR70pum5fgOf2ksGkuYsJ6edmuLBI=
X-Google-Smtp-Source: ACHHUZ74XtZxpRvNn1w2ueciqf6EdJyVWKI6bIsX5YO5yWIfcC0/dNe+wlLSWz8SJe9iTQo9iK3PHg==
X-Received: by 2002:a05:6214:1c86:b0:5fa:2ae4:4203 with SMTP id ib6-20020a0562141c8600b005fa2ae44203mr16021258qvb.37.1682895090915;
        Sun, 30 Apr 2023 15:51:30 -0700 (PDT)
Received: from localhost.localdomain ([2602:47:d92c:4400:e747:e271:3de5:4c78])
        by smtp.googlemail.com with ESMTPSA id i5-20020a0cf105000000b0061b5a3d1d54sm189310qvl.87.2023.04.30.15.51.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Apr 2023 15:51:30 -0700 (PDT)
From:   Nicholas Vinson <nvinson234@gmail.com>
To:     mkubecek@suse.cz
Cc:     Nicholas Vinson <nvinson234@gmail.com>, netdev@vger.kernel.org
Subject: [PATCH ethtool 0/3] Fix issues found by gcc -fanalyze
Date:   Sun, 30 Apr 2023 18:50:49 -0400
Message-Id: <cover.1682894692.git.nvinson234@gmail.com>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series provides updates to correct issues found by gcc -fanalyze. The
issues were found by specifying the following flags when building:

CFLAGS="-march=native -O2 -pipe -fanalyzer -Werror=analyzer-va-arg-type-mismatch
            -Werror=analyzer-va-list-exhausted -Werror=analyzer-va-list-leak
            -Werror=analyzer-va-list-use-after-va-end"

CXXCFLAGS="-march=native -O2 -pipe -fanalyzer
            -Werror=analyzer-va-arg-type-mismatch
            -Werror=analyzer-va-list-exhausted
            -Werror=analyzer-va-list-leak
            -Werror=analyzer-va-list-use-after-va-end"

LDFLAGS="-Wl,-O1 -Wl,--as-needed"

GCC version is gcc (Gentoo 13.1.0-r1 p1) 13.1.0

Nicholas Vinson (3):
  Update FAM syntax to conform to std C.
  Fix reported memory leak.
  Fix potentinal null-pointer derference issues.

 ethtool.c          | 24 +++++++++++++-----------
 netlink/features.c | 24 ++++++++++++++++++------
 2 files changed, 31 insertions(+), 17 deletions(-)

-- 
2.40.1

