Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A37515A0F67
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 13:37:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240358AbiHYLhQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 07:37:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239855AbiHYLgx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 07:36:53 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D30827B00
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 04:36:52 -0700 (PDT)
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1661427410;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=h4kzA+dERGMGw6X9A5u9u29JIwSzTPgES+FI+Ekq8i4=;
        b=lRlfedPeCJwHsplqOOf6MDtmDaI3JCWyYlYY6FTT/xXWoOJfmnvlSejPgpPhsXnVqulHjs
        y3QHAl87v/DfTjpL81jX88Ty3Z2BsM3jqNn0hcIY3OuVJWE0W+m70AuDmbdpob5bfApJTe
        Rrl2RfLG6iAG5ZtN1EyxNsanez7q3q8CyJCeIM/Nc655P37k8/DPpHmJjn+tdDrEvGRcnt
        kr1fNLJoGrGkbHqiRxknxlmztkXgQPfoUXOLjB/aFarOxqYy6PJDpC0F0Zk1vCdnFBQ2+F
        7+rVFC8JrQNo3tnyYLe3q6ikUvdmCNCDa2GVLVeFeVG14GR8uDjenoR/kn8mmQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1661427410;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=h4kzA+dERGMGw6X9A5u9u29JIwSzTPgES+FI+Ekq8i4=;
        b=slEVHIM23ceFGdNEleehCkuWtJBncRtOpRIbDm6c4jlpKAbSx1RguGsP8yU0YZcMtuavsB
        kArxvgYxOIO8bWCA==
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH net 0/2] net: u64_stats fixups for 32bit.
Date:   Thu, 25 Aug 2022 13:36:43 +0200
Message-Id: <20220825113645.212996-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

while looking at the u64-stats patch
	https://lore.kernel.org/all/20220817162703.728679-10-bigeasy@linutronix.de

I noticed that u64_stats_fetch_begin() is used. That suspicious thing
about it is that network processing, including stats update, is
performed in NAPI and so I would expect to see
u64_stats_fetch_begin_irq() in order to avoid updates from NAPI during
the read. This is only needed on 32bit-UP where the seqcount is not
used. This is address in 2/2. The remaining user take some kind of
precaution and may use u64_stats_fetch_begin().

I updated the previously mentioned patch to get rid of
u64_stats_fetch_begin_irq(). If this is not considered stable patch
worthy then it can be ignored and considred fixed by the other series
which removes the special 32bit cases.

The xrs700x driver reads and writes the counter from preemptible context
so the only missing piece here is at least disable preemption on the
writer side to avoid preemption while the writer is in progress. The
possible reader would spin then until the writer completes its write
critical section which is considered bad. This is addressed in 1/2 by
using u64_stats_update_begin_irqsave() and so disable interrupts during
the write critical section.
The other closet resemblance I found is mdio_bus.c::mdiobus_stats_acct()
where preemtion is disabled unconditionally. This is something I want to
avoid since it also affects 64bit.

Sebastian


