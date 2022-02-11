Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 491FD4B315C
	for <lists+netdev@lfdr.de>; Sat, 12 Feb 2022 00:39:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354219AbiBKXiy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 18:38:54 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245003AbiBKXix (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 18:38:53 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 252B1CFE;
        Fri, 11 Feb 2022 15:38:51 -0800 (PST)
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1644622727;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=W5M7ql07yQWYHKSb7prxi1WVArVxTUKiB6k0gKJBj48=;
        b=xFfIRusrlGnxMwknxZazpKRcaZaFH7OpX7G+Txw7KmBtopCmis4xVZ1mcSYnmACHL4du99
        NzL/dezy+ob3wJOCOLY5uHXPPgQ5Pa0hvO4cLJYUcVcX2BfGHGbzGTtmvacGh8olyB4kcE
        4N5JqkxL4hiBP6aN1Wlv+wwnGbP5yto1dBip491cB1iCndNOL7GEo9+uV+PsQ1IzMFJAHL
        uHDWDBEKRr9viB3um+JTgrKBpUQ3dZFl115n6aG0N1BMS0FPQnqItcpL7J7YnyntVzdNEh
        5HlETSUhASZApq5jg0JeQdgPTzPnJ2tmXGlMhLjfL7voo4XKSKViDPZadAQ6nQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1644622727;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=W5M7ql07yQWYHKSb7prxi1WVArVxTUKiB6k0gKJBj48=;
        b=4gjHOZiyhvDJC789sOGV/Emk1CuynXrKnzscJNPGgMu0HB2uDh93pEz/AZn/SCDaW18WQT
        Bo+/bF8tSZyhJ8CQ==
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Subject: [PATCH net-next v3 0/3] net: dev: PREEMPT_RT fixups.
Date:   Sat, 12 Feb 2022 00:38:36 +0100
Message-Id: <20220211233839.2280731-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

this series removes or replaces preempt_disable() and local_irq_save()
sections which are problematic on PREEMPT_RT.
Patch 2 makes netif_rx() work from any context after I found suggestions
for it in an old thread. Should that work, then the context-specific
variants could be removed.

v2=E2=80=A6v3:
   - #2
     - Export __netif_rx() so it can be used by everyone.
     - Add a lockdep assert to check for interrupt context.
     - Update the kernel doc and mention that the skb is posted to
       backlog NAPI.
     - Use __netif_rx() also in drivers/net/*.c.
     - Added Toke''s review tag and kept Eric's desptite the changes
       made.

v1=E2=80=A6v2:
  - #1 and #2
    - merge patch 1 und 2 from the series (as per Toke).
    - updated patch description and corrected the first commit number (as
      per Eric).
   - #2
     - Provide netif_rx() as in v1 and additionally __netif_rx() without
       local_bh disable()+enable() for the loopback driver. __netif_rx() is
       not exported (loopback is built-in only) so it won't be used
       drivers. If this doesn't work then we can still export/ define a
       wrapper as Eric suggested.
     - Added a comment that netif_rx() considered legacy.
   - #3
     - Moved ____napi_schedule() into rps_ipi_queued() and
       renamed it napi_schedule_rps().
   https://lore.kernel.org/all/20220204201259.1095226-1-bigeasy@linutronix.=
de/

v1:
   https://lore.kernel.org/all/20220202122848.647635-1-bigeasy@linutronix.de


