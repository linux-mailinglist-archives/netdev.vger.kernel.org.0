Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB7DC5A03CD
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 00:13:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229569AbiHXWNF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 18:13:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbiHXWND (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 18:13:03 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E52757A775
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 15:13:01 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id f1-20020a170902ce8100b001731029cd6bso2563886plg.1
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 15:13:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:mime-version
         :message-id:date:from:to:cc;
        bh=hQmc4PgfoBZuUJiJ0IVOAiQEcb4BKh3F2bD+rQlQmuo=;
        b=IvqJgqpBfprGjllTYSQBFMwS6iRLG3J4PFL/ixAtZlo6eMO9Sjgg9hbGMEPf/0VfG+
         xOiSjXMN1V36NS4Ff6HXISQpufFLcrRivthNrutgFLWGt4cg0jqUNlSmyFX1/KGTL7ff
         xeZZlDW0ScSXa93cZkQFeseOVdo3qVlMMW9xB7khZ3CZrOdizue6msVuFPIZ8WK+uHBd
         Jt66b7D3DK6PfcufnRsK4yfr55zFKxhnvg4tqAyOlxDs5dU+0e0/bgSL0mehbuaSkZz3
         EiPluNZoUh6IMMpd63aB47IPz2Wet//o1cHHY68H5y8X5V0ymJZgQEcZc21k5ZsxPISi
         YW5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:mime-version
         :message-id:date:x-gm-message-state:from:to:cc;
        bh=hQmc4PgfoBZuUJiJ0IVOAiQEcb4BKh3F2bD+rQlQmuo=;
        b=iIRUQPicIuEUzGUNnMznbet3PIGl1daL3FVwFb6fpOqMCl9lnM2IM1SyPa+gwZF1ZP
         uaMnF1Pw8xAgM9OD73QbV1Pjz8eFqgSmcK2+ppjvyPSXy48UYwV7aeQhWI/Bptmxhj5L
         NMcks4nBjkCxsu75Nvx55jQ9Q3OWBY9xp6FvPbG5LGCIu++x45fbOXEFiMpVpuq6Dk0F
         nLZmeoh4gSrPENeDDMxO6y3brbRhd5ehM3ekuD8NCs4aIIzHez7RUr5Sm2PUUw40llG7
         0h6TZVV1UtIObvv8UFvPpvOZ8VCsT+VKQjOI9m8rJ1wcuAUk9m67mqLIUlcibh+rDdtD
         vozA==
X-Gm-Message-State: ACgBeo0mbCrXpD1n030IBNqNCCW5MvTZaoWLXpa0Nf4DF+bkSIxm0uFZ
        xd7Sg/bCcITE2F7yrUl9yFa8qoRRYv5NYxE1WJM=
X-Google-Smtp-Source: AA6agR7yAqsbcCsz15TqPiTxe3C/l81w6WWwFSW/SfNmJ/AESTe/vBCgr3Bn7MN7DAHBibH5d2Tf+Fuvy/pSUwtQuoM=
X-Received: from obsessiveorange-c1.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3039])
 (user=benedictwong job=sendgmr) by 2002:a17:903:1c8:b0:173:c58:dc6d with SMTP
 id e8-20020a17090301c800b001730c58dc6dmr807381plh.105.1661379181421; Wed, 24
 Aug 2022 15:13:01 -0700 (PDT)
Date:   Wed, 24 Aug 2022 22:12:50 +0000
Message-Id: <20220824221252.4130836-1-benedictwong@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [PATCH v2 ipsec 0/2] xfrm: Fix bugs in stacked XFRM-I tunnels
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
before verifying the inner tunnel=E2=80=99s. This fixes this by caching the=
 list
of verified secpath entries, and skipping them upon future validation
runs.

PATCH 1/2 Makes template matching for previously verified entries in the
secpath an optional match. This ensures that lost context for previous
tunnel secpath entries does not trigger a template mismatch if it was
previously verified. This allows each tunnel layer to incrementally
verify only the secpath entries associated with it.

PATCH 2/2 Ensures that policies for nested tunnel mode transforms are
verified (and marked as such) before additional decapsulation. This
ensures that entries in the secpath are verified while the context
(intermediate IP addresses, marks, etc) can be appropriately matched.
Notably, unencapsulated ESP did not perform policy checks before handing
to the next protocol for processing.

v1 -> v2:
- Reordered and rescoped patches to make changes clearer; policy
    check in xfrm_input necessary due to the incremental-verification
    process.
- Code style updates to conform with networking code formatting
- No net functional changes across both patches.




