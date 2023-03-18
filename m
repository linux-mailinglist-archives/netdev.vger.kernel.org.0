Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 757C26BFCB6
	for <lists+netdev@lfdr.de>; Sat, 18 Mar 2023 21:25:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229765AbjCRUZ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Mar 2023 16:25:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbjCRUZ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Mar 2023 16:25:27 -0400
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5516233CE;
        Sat, 18 Mar 2023 13:25:25 -0700 (PDT)
Received: from fpc (unknown [46.242.14.200])
        by mail.ispras.ru (Postfix) with ESMTPSA id 6B7B144C1023;
        Sat, 18 Mar 2023 20:25:20 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru 6B7B144C1023
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
        s=default; t=1679171120;
        bh=6V3Vbhrq5BYhBe6TJBntt2bA0uy7QayeFqJtV4fw6hg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=soQxhSvxWXuee3nKUyKkYgp6CetKvYpQINXItjNmJI2RZamrhgEhF1QaVlUy6i0Pd
         9v3mCHVdeAO1vejvn0x4hflG/BgeDuB9GwhGgNlSYFa4+eIf/Uv9F/zKKbmV5amFMN
         cmpudPAOc5UdYpN/2GbcEGlbvG8cFRHjCO+67G7o=
Date:   Sat, 18 Mar 2023 23:25:16 +0300
From:   Fedor Pchelkin <pchelkin@ispras.ru>
To:     Kalle Valo <kvalo@kernel.org>
Cc:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
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
        lvc-project@linuxtesting.org,
        syzbot+f2cb6e0ffdb961921e4d@syzkaller.appspotmail.com
Subject: Re: [PATCH 1/3] wifi: ath9k: avoid referencing uninit memory in
 ath9k_wmi_ctrl_rx
Message-ID: <20230318202516.2dpebysmo6uxilab@fpc>
References: <20230315202112.163012-1-pchelkin@ispras.ru>
 <20230315202112.163012-2-pchelkin@ispras.ru>
 <871qlovtho.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871qlovtho.fsf@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 17, 2023 at 07:26:11AM +0200, Kalle Valo wrote:
> 
> It would be also nice to know how you have tested these. Syzkaller is no
> substitute for testing on a real hardware.
> 

Unfortunately, currently I can't test this on real hardware so probably we
should postpone the patch discussion for some time. Roughly in a week or
two I'll be able to do some testing and try to reproduce the problem
there.

For sure this should be tested on real hardware as some issues may arise.
I sent the patch based on the commit b383e8abed41 ("wifi: ath9k: avoid
uninit memory read in ath9k_htc_rx_msg()") where it is explained
thoroughly what can lead to such behaviour. At the moment I don't see
anything in the code which can prevent that invalid scenario to happen for
endpoint callbacks path.

Actually, sanity checks for SKB length have been added everywhere inside
ath9k_htc_rx_msg() except where the endpoint callbacks are called. As for
the repro, the SKB inside ath9k_hif_usb_rx_stream() is allocated with
pkt_len=8 so it passes the 'htc_frame_hdr' check and processing in
ath9k_htc_rx_msg() but it obviously cannot be handled correctly in the
endpoint callbacks then.
