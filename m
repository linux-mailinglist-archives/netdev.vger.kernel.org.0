Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D012E6BBE1C
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 21:47:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232208AbjCOUr3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 16:47:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230036AbjCOUr2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 16:47:28 -0400
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E61594F4A;
        Wed, 15 Mar 2023 13:47:27 -0700 (PDT)
Received: from fpc (unknown [10.10.165.16])
        by mail.ispras.ru (Postfix) with ESMTPSA id A2CEB44C1026;
        Wed, 15 Mar 2023 20:47:25 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru A2CEB44C1026
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
        s=default; t=1678913245;
        bh=5toqmCiIAqbNxCU08LIwPBQntN6jaGooMIATHZvsRic=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eg/iE7rHi6lAmhDSLih8jK/C6wmD8HWtoFO1ZN57bSokCP02vPLQjSZznjmsb1aas
         JqIXQdh+AVbz3GqDtudKXprx7I2UostO3J34gTVfIdMwsNrQYlZzMAPM1deJvF+Ij4
         dXMWW4r0Y4i4Hp+LSSA6s4k9E0E60MO/knyvyYtA=
Date:   Wed, 15 Mar 2023 23:47:20 +0300
From:   Fedor Pchelkin <pchelkin@ispras.ru>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Cc:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Senthil Balasubramanian <senthilkumar@atheros.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Vasanthakumar Thiagarajan <vasanth@atheros.com>,
        Sujith <Sujith.Manoharan@atheros.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        lvc-project@linuxtesting.org
Subject: Re: [PATCH 0/3] wifi: ath9k: deal with uninit memory
Message-ID: <20230315204720.xtqik56r7ddbynho@fpc>
References: <20230315202112.163012-1-pchelkin@ispras.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230315202112.163012-1-pchelkin@ispras.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 15, 2023 at 11:21:09PM +0300, Fedor Pchelkin wrote:
> Syzkaller reports two cases ([1] and [2]) of uninitialized memory referencing in ath9k
> wmi functions. The following patch series is intended to fix them and related issues.
> 
> [1] https://syzkaller.appspot.com/bug?id=51d401326d8ee41859d68997acdd6f3b1b39f186
> [2] https://syzkaller.appspot.com/bug?id=fc54e8d79f5d5082c7867259d71b4e6618b69d25

During the patch development I observed that the return value of REG_READ
(ath9k_regread), REG_READ_MULTI (ath9k_multi_regread) and similar macros
is not checked in most places inside ath9k where they are called. That may
also potentially lead to incorrect behaviour. I wonder if it actually
poses a problem as the current implementation has been for a long time and
perhaps somebody has already addressed this.

In more details:
-- ath9k_regread returns -1 on error, and probably this is a predefined
   error state and doesn't need additional check. But, overall, it seems
   strange to me that the return value is not checked in places where it
   is used later (for example, in ath9k_reg_rmw or
   ath9k_hw_ani_read_counters).
-- ath9k_multi_regread fills 'val' buffer with undefined values on error
   case, that should definitely be fixed with initializing the local
   buffer to zero, I think.

Could you please say your opinion on this issue?

