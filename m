Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF74C5E5ABE
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 07:33:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229617AbiIVFdG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 01:33:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbiIVFdF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 01:33:05 -0400
Received: from mail-oa1-x31.google.com (mail-oa1-x31.google.com [IPv6:2001:4860:4864:20::31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8450B14C4;
        Wed, 21 Sep 2022 22:33:02 -0700 (PDT)
Received: by mail-oa1-x31.google.com with SMTP id 586e51a60fabf-11e9a7135easo12354984fac.6;
        Wed, 21 Sep 2022 22:33:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=Cr+lhKoa1/RCYgs+Y9U2WLt656Ff7zE1WKtXSiWMat0=;
        b=H+paTSKl8zCtzEtK3CpI3psgNOrgGDNoo027c7R5GW+sLfFsIMAvvGYMR2YVjkHLYe
         IZDXi0qJ4rp7siQNICVlveK2jRbqusznVPHzguFvTS1jz3e6vcCTko1+UpGLjt77vpmk
         4Gcq0q3j4A5lJmYajDn7+obY2oQfBSQECsb/blcNrn8dHGeui+a+UWy2VC2hgLc9jWYN
         BlCzmSqGbMR7GlcTZIWOFScM5MXR5MmuIvgR764gKjVslWvPr7a8Kutgyzy3Pa1Fsv2B
         OS4bPQO7xuS1QbZpny+iR+vIgNf3Q8iUlm+/y6BSsP/PnUMyJT8aLL33ROc6ZfVI5ApM
         KH0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=Cr+lhKoa1/RCYgs+Y9U2WLt656Ff7zE1WKtXSiWMat0=;
        b=YFEusOV1aBiZUK7bush953kAicQuI7qFHEQEl04ch6VsjeLpd64YO7euC6PWI4ORrq
         +Klegkq2oy4a8S/B+Mw1sLM4tmrxy9XfpfaBRuS7yWh7L13Nic07sQVnSUngJrcAumUT
         gn6UggFOFWSY7+66SHObvnvc9MoBYdt7ydaTSgbJ20Y9mIF8duhRQ85WEJWEEILy/q7M
         SB+rtTMaMv4ZaItzwt1qaGKApXYbpvVfPp6dxWBNeDJxzpoyrElk607NrQzOb0w10DLQ
         nKmoQ/LcAN4eLBPN3AKyw7BCWGYeqYHwX4egWRQHfrMKUVgqptFT1r9o9jkhLEAPhUqC
         2tpw==
X-Gm-Message-State: ACrzQf2hL3xb3C33QBP8WGecsc6NZ1RLPmNjWMDkpOBa06ht17e0/USn
        zjKWd7KGafvy3YAv0ggQh54=
X-Google-Smtp-Source: AMsMyM7Th+t24SiZh4wPKWWQOLIn72n6fgZUNAPeC/0PZw7tzRDKt0AtuFx9rRw1tSMuaUBd6D8Blg==
X-Received: by 2002:a05:6870:6125:b0:126:c619:2b68 with SMTP id s37-20020a056870612500b00126c6192b68mr934055oae.284.1663824781648;
        Wed, 21 Sep 2022 22:33:01 -0700 (PDT)
Received: from macondo.. ([2804:431:e7cc:3499:2e9e:5862:e0eb:f33b])
        by smtp.gmail.com with ESMTPSA id w19-20020a056870231300b00118281a1227sm2570957oao.39.2022.09.21.22.32.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Sep 2022 22:33:01 -0700 (PDT)
From:   Rafael Mendonca <rafaelmendsr@gmail.com>
To:     Raju Rangoju <rajur@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
Cc:     Rafael Mendonca <rafaelmendsr@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH net-next 0/1] cxgb4: fix missing unlock on ETHOFLD desc collect fail path
Date:   Thu, 22 Sep 2022 02:32:35 -0300
Message-Id: <20220922053237.750832-1-rafaelmendsr@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I'm sending this as a RFC because I'm not familiar with the chelsio
cxgb4 code, sorry if this is nonsense.

I noticed that the 'out' label is passed to the QDESC_GET for the
ETHOFLD TXQ, RXQ, and FLQ, which skips the 'out_unlock' label on error,
and thus doesn't unlock the 'uld_mutex' before returning.

I was thinking the solution would be to simply change the label to
'out_unlock'. However, since commit 5148e5950c67 ("cxgb4: add EOTID
tracking and software context dump"), I was wondering if the access to
these ETHOFLD hardware queues should be protected by the 'mqprio_mutex'
instead of the 'uld_mutex'.

Rafael Mendonca (1):
  cxgb4: fix missing unlock on ETHOFLD desc collect fail path

 .../net/ethernet/chelsio/cxgb4/cudbg_lib.c    | 28 +++++++++++++------
 1 file changed, 19 insertions(+), 9 deletions(-)

-- 
2.34.1

