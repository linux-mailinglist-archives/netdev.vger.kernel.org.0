Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E43969FD5E
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 22:04:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbjBVVEC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 16:04:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjBVVEB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 16:04:01 -0500
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D5FE3D092;
        Wed, 22 Feb 2023 13:04:00 -0800 (PST)
Received: by mail-qt1-x830.google.com with SMTP id d5so8820198qtn.13;
        Wed, 22 Feb 2023 13:04:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Fvn3QQ9V02Oy3TGH14mCesnluJYmeBDJkA+N7X4hMrg=;
        b=mkxbgEPZzsyNlsH6aQ/fiWc38plfe9hD+Z+7NFM4x2IDt5j3R6fyED8+prGdncmAXl
         HLaxPSeNfCsmt4smGH9XtsH3BPhF2ZiNGhKC89zF0J8R1SOS0v3gSchYPW1bn65SDCRP
         ySQ1F8rZCYM/J9H0yyfEQR915qtbl35i7DUjxMM9by6EtbfDzRURnBkIlaoH679UsqQW
         xCQuRD3AbxmX4urR09ze4wwRNEnsUNKq7ZJbHl+Apq2YzhPAhk9/a+AASqZH0rS/JcLy
         tlojtor/i0ij9xD1vEDMeVsUKzMKgruWb8HikR9sWdHla+ZX8HMg7wW/ZM9IiRpfK+7C
         j+xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Fvn3QQ9V02Oy3TGH14mCesnluJYmeBDJkA+N7X4hMrg=;
        b=x6+lEeWdcfx88pX/WGEUOMOIp7y4DNj2T30/Teex2OvFH99Xuz2qK8gmYywMlPTCj0
         B5q2eL/U3oYM/Sbmkd1NSOOLkwXmehhLg/y7Kl1agGzdjpSGq6EzQqVmWDSlLCL7FQTk
         uPI4AuXsFQDJ7AdA9uRIQX83bBoKODqsNstYjlXWHL14qPLssgDIYMAr+/WI3R0Kr8S2
         Tk9s2/iAFu9RwFpMHPgkkXBqXI1WsK3bcmqCVTPg48P6cWsCRraA3pZ/3IU7CKfMmWei
         CvFdoIVG4H+eQARpjmiSxQRGKE1n+Yl5UShA44hx2u/2AeuzcdUwDBOcJctXFNtCTqqs
         E81w==
X-Gm-Message-State: AO0yUKV3NHg0fivEDucGOFTmVjSYa5Jr39AXHDkW2fPjis0EtuwAZsm6
        P+tvzt2pUp/BPk3Or1qT/Uo=
X-Google-Smtp-Source: AK7set9NgzX2t9X22DSfqHGPipCfuR4ANHFna7nxs8/D3wpNoscsdXi5y5zSSxwjJ0FD2+7vTmLcUA==
X-Received: by 2002:a05:622a:10e:b0:3ba:2d84:27a3 with SMTP id u14-20020a05622a010e00b003ba2d8427a3mr16199342qtw.65.1677099839024;
        Wed, 22 Feb 2023 13:03:59 -0800 (PST)
Received: from localhost (pool-173-73-95-180.washdc.fios.verizon.net. [173.73.95.180])
        by smtp.gmail.com with UTF8SMTPSA id b20-20020a05620a271400b007402504c6desm5789080qkp.41.2023.02.22.13.03.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Feb 2023 13:03:58 -0800 (PST)
From:   Sean Anderson <seanga2@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Sean Anderson <seanga2@gmail.com>,
        debian-sparc@lists.debian.org, rescue@sunhelp.org, sparc@gentoo.org
Subject: [RFC PATCH net-next 0/7] net: sunhme: Probe/IRQ cleanups
Date:   Wed, 22 Feb 2023 16:03:48 -0500
Message-Id: <20230222210355.2741485-1-seanga2@gmail.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Well, I've had these patches kicking around in my tree since last October, so I
guess I had better get around to posting them. This series is mainly a
cleanup/consolidation of the probe process, with some interrupt changes as well.
Some of these changes are SBUS- (AKA SPARC-) specific, so this should really get
some testing there as well to ensure nothing breaks. I've CC'd a few SPARC
mailing lists in hopes that someone there can try this out. I also have an SBUS
card I ordered by mistake if anyone has a SPARC computer but lacks this card.

I had originally planned on adding phylib support to this driver in the hopes of
being able to use real phy drivers, but I don't think I'm going to end up doing
that. I wanted to be able to use an external (homegrown) phy, but as it turns
out you can't buy MII cables in $CURRENTYEAR for under $250 a pop, and even if
you could get them you can't buy the connectors either. Oh well...

This series is not actually RFC, but I don't want to forget to post this in
another month.


Sean Anderson (7):
  net: sunhme: Just restart autonegotiation if we can't bring the link
    up
  net: sunhme: Remove residual polling code
  net: sunhme: Unify IRQ requesting
  net: sunhme: Alphabetize includes
  net: sunhme: Switch SBUS to devres
  net: sunhme: Consolidate mac address initialization
  net: sunhme: Consolidate common probe tasks

 drivers/net/ethernet/sun/sunhme.c | 891 ++++++++++--------------------
 drivers/net/ethernet/sun/sunhme.h |   6 +-
 2 files changed, 288 insertions(+), 609 deletions(-)

-- 
2.37.1

