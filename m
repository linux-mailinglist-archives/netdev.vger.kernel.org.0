Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E98266DCDA
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 12:52:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236416AbjAQLwz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 06:52:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236058AbjAQLwy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 06:52:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 583DF233CF;
        Tue, 17 Jan 2023 03:52:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 07FD5B815AA;
        Tue, 17 Jan 2023 11:52:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F245EC433D2;
        Tue, 17 Jan 2023 11:52:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673956370;
        bh=+fBuNs29t8yNPv6q51lyGENRRsy/0iZMXu1O4lAOniQ=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=Dix/JRvzda3WspkxvRp3kxxnBmsIoxY2NgLSprROHZ0qlxGw7s/fUzJ6BB0AsmhAi
         LDhkNPFamjnwUqZndKAWqtN+NWeazr3C0tgpwfbRycye0X+SSJYz6AW/LAxKMo9P0M
         3ltjdPBkrnSa5/f86OYQX3l9mlyGeTD6RafI61+QmsapV2/OkPtGk1Y2U7/DbZdyr6
         uUI8RyjQdgYqmYhh/1/Fi8KYz7RM4ZuKW61y/o9g+tRmVelUvaGL5wvt5PHC7GtrkM
         c7hIaNX9RpQCTWhVO5ithzfwSbj9cap7IM24/IO/k9ynW6fyiiS5mboZFuGiJFeOVs
         B+W8SirZu/7Gg==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v4] wifi: ath9k: htc_hst: free skb in ath9k_htc_rx_msg()
 if
 there is no callback function
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230104123546.51427-1-pchelkin@ispras.ru>
References: <20230104123546.51427-1-pchelkin@ispras.ru>
To:     Fedor Pchelkin <pchelkin@ispras.ru>
Cc:     =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Fedor Pchelkin <pchelkin@ispras.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sujith <Sujith.Manoharan@atheros.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Vasanthakumar Thiagarajan <vasanth@atheros.com>,
        Senthil Balasubramanian <senthilkumar@atheros.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        lvc-project@linuxtesting.org,
        syzbot+e008dccab31bd3647609@syzkaller.appspotmail.com,
        syzbot+6692c72009680f7c4eb2@syzkaller.appspotmail.com
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <167395636331.22891.14427855957409091076.kvalo@kernel.org>
Date:   Tue, 17 Jan 2023 11:52:46 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fedor Pchelkin <pchelkin@ispras.ru> wrote:

> It is stated that ath9k_htc_rx_msg() either frees the provided skb or
> passes its management to another callback function. However, the skb is
> not freed in case there is no another callback function, and Syzkaller was
> able to cause a memory leak. Also minor comment fix.
> 
> Found by Linux Verification Center (linuxtesting.org) with Syzkaller.
> 
> Fixes: fb9987d0f748 ("ath9k_htc: Support for AR9271 chipset.")
> Reported-by: syzbot+e008dccab31bd3647609@syzkaller.appspotmail.com
> Reported-by: syzbot+6692c72009680f7c4eb2@syzkaller.appspotmail.com
> Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
> Acked-by: Toke Høiland-Jørgensen <toke@toke.dk>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

9b25e3985477 wifi: ath9k: htc_hst: free skb in ath9k_htc_rx_msg() if there is no callback function

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230104123546.51427-1-pchelkin@ispras.ru/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

