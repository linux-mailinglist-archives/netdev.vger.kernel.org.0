Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DD445780A6
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 13:22:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233516AbiGRLW3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 07:22:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230401AbiGRLW1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 07:22:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6924420F52;
        Mon, 18 Jul 2022 04:22:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 00BD861263;
        Mon, 18 Jul 2022 11:22:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19019C341C0;
        Mon, 18 Jul 2022 11:22:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658143346;
        bh=zl4uhvMK5ijsxafPJV04weeiNkBSHJF1ueGmZqItmD0=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=g4fk/CMOK9uwjh1k/yKO3I2gpV8VM5/+1IMXQS3SZvRm0yo1G20+oAQ6R1SUNJ1Q+
         PGD6uSTVB7xTUB4UFyFxaLqKmMZmamTrMBBsmyxAo6UL9XYCSo7hJCJYgUsqS4+35f
         Vd6H2i+wmCiXv8rkVpYl0n6jMZPOGEqJRHIL1X9fqONn8CbCB8T1nkhuYJoFEkp6K+
         Dfpn7khEfvgJ5Sk56eXT78vtohw/1PXnhv3b1REcF2bsuy654Gv4U6oRRJx2/DWvbG
         LyY25KOqgSLYmhUiDHVcguNL1i4djJR3KvlJ/CL82nzgJWl+QVwK2QbABp5FdsmNJi
         +PpNo0o0CAdXA==
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 54B9E4D9EC5; Mon, 18 Jul 2022 13:22:22 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@kernel.org>
To:     Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Johannes Berg <johannes@sipsolutions.net>,
        Felix Fietkau <nbd@nbd.name>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2] wifi: mac80211: do not abuse fq.lock in
 ieee80211_do_stop()
In-Reply-To: <9cc9b81d-75a3-3925-b612-9d0ad3cab82b@I-love.SAKURA.ne.jp>
References: <00000000000040bd4905e3c2c237@google.com>
 <81f3eeda-0888-2869-659e-dc38c0a9debf@I-love.SAKURA.ne.jp>
 <9cc9b81d-75a3-3925-b612-9d0ad3cab82b@I-love.SAKURA.ne.jp>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 18 Jul 2022 13:22:22 +0200
Message-ID: <874jzemzrl.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp> writes:

> lockdep complains use of uninitialized spinlock at ieee80211_do_stop() [1=
],
> for commit f856373e2f31ffd3 ("wifi: mac80211: do not wake queues on a vif
> that is being stopped") guards clear_bit() using fq.lock even before
> fq_init() from ieee80211_txq_setup_flows() initializes this spinlock.
>
> According to discussion [2], Toke was not happy with expanding usage of
> fq.lock. Since __ieee80211_wake_txqs() is called under RCU read lock, we
> can instead use synchronize_rcu() for flushing ieee80211_wake_txqs().

Ah, that's a neat solution! :)

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@kernel.org>
