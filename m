Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B6D5632B62
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 18:46:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230191AbiKURqR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 12:46:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229961AbiKURqN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 12:46:13 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D845942F74
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 09:46:12 -0800 (PST)
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1669052770;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=xwnGP3FQh4JCjmuGogKE4+zXNKKzbajFnkjz7nFZRKA=;
        b=olq9Hfgo/3eaoOu1FS9W6T5sN3z0ilJnVZUha2IRxN3R7CS/gxTa+XR1qtgcpsQ1HJ+2fk
        u9IEfD4yi+pl04wdtqknqqRVTcRG3myodTJ4QvcLSxKWon5ztDDgHAH2lzD9mRGJMZp3d6
        gBE7AU3+Cw/6qy68q3rneiITVi4BIJl6yv1q9+21vyzUlujTUGRGURYyzN4110Hl95gkS1
        4/IsbjwukIUCM7WgDyDyYjIhfeXjE+lsIYJRcmdyGDO/omSkzzLwxhcDF8lMqZDH1GdaJa
        E4DgytwNUdpqzbfNRlKFKEfvwvuETJwkwW0i7f3BpIZuXqLE3WRwJ1TT6lM2ig==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1669052770;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=xwnGP3FQh4JCjmuGogKE4+zXNKKzbajFnkjz7nFZRKA=;
        b=UVDxXeDcEga7/RVUeyXVHOTbKpfjd21EAKISib1mz7roK9Lsld5nGqcQog/xxdrlCmB4Ns
        rHPamxiyHDQkmcBQ==
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH v2 net] hsr: HSR send/recv fixes
Date:   Mon, 21 Nov 2022 18:45:58 +0100
Message-Id: <20221121174605.2456845-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I started playing with HSR and run into a problem. Tested latest
upstream -rc and noticed more problems. Now it appears to work.
For testing I have a small three node setup with iperf and ping. While
iperf doesn't complain ping reports missing packets and duplicates.

v1=E2=80=A6v2:
- Replaced cmpxchg() from patch #6 with lock because RiscV does not provide
  cmpxchg() for 16bit.
- Added patch #3 which fixes the random crashes I observed on latest rc5 wh=
ile
  testing.

Sebastian


