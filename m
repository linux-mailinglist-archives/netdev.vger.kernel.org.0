Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D26A96BE092
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 06:26:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229923AbjCQF0X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 01:26:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjCQF0W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 01:26:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B1908C5AA;
        Thu, 16 Mar 2023 22:26:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D3B99621AD;
        Fri, 17 Mar 2023 05:26:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6508DC433EF;
        Fri, 17 Mar 2023 05:26:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679030777;
        bh=91ql8DhWlt0+bx8+WmyJZqX4qLO+KJ0hyv2IMk0xLek=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=rrax3MGVjXtyvm38OlVfNuGiu4WTeJLLUNK7hWtgX95xZeI4V7xSW0b++JNQlx4+a
         bErqMbfckH0cpl0Zr6ms2Y2fMSPFmYO9z28rANobZSoSdbNOvG+QU7t4r5FMkQdRf+
         D5OwusCqNINaZSYlS7gZePyQ8/GB8mnkSyxMMkJuyISsPNWnGYnzniehSW9DoituhG
         686EDU/X8Z/wlE7gyWs6ftBiKuBKOx8iwLiWUoRXQFY0anXcfhMGUH3+HUsAyTfMU0
         6t3e4SUhyUbtOoS41O0qWrMa+RNygy84ONUgvFgwDzePkl1eOmGeAyB0rLILmZoz6/
         vQ80X6RTesHng==
From:   Kalle Valo <kvalo@kernel.org>
To:     Fedor Pchelkin <pchelkin@ispras.ru>
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
Subject: Re: [PATCH 1/3] wifi: ath9k: avoid referencing uninit memory in ath9k_wmi_ctrl_rx
References: <20230315202112.163012-1-pchelkin@ispras.ru>
        <20230315202112.163012-2-pchelkin@ispras.ru>
Date:   Fri, 17 Mar 2023 07:26:11 +0200
In-Reply-To: <20230315202112.163012-2-pchelkin@ispras.ru> (Fedor Pchelkin's
        message of "Wed, 15 Mar 2023 23:21:10 +0300")
Message-ID: <871qlovtho.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fedor Pchelkin <pchelkin@ispras.ru> writes:

> For the reasons described in commit b383e8abed41 ("wifi: ath9k: avoid
> uninit memory read in ath9k_htc_rx_msg()"), ath9k_htc_rx_msg() should
> validate pkt_len before accessing the SKB. For example, the obtained SKB
> may have uninitialized memory in the case of
> ioctl(USB_RAW_IOCTL_EP_WRITE).
>
> Implement sanity checking inside the corresponding endpoint RX handlers:
> ath9k_wmi_ctrl_rx() and ath9k_htc_rxep(). Otherwise, uninit memory can
> be referenced.
>
> Add comments briefly describing the issue.
>
> Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

It would be also nice to know how you have tested these. Syzkaller is no
substitute for testing on a real hardware.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
