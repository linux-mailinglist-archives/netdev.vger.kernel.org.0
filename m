Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48B2B6ED520
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 21:12:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232549AbjDXTMK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 15:12:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232530AbjDXTMI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 15:12:08 -0400
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DA25E5D;
        Mon, 24 Apr 2023 12:12:05 -0700 (PDT)
Received: from fpc (unknown [46.242.14.200])
        by mail.ispras.ru (Postfix) with ESMTPSA id 3981940755C6;
        Mon, 24 Apr 2023 19:12:03 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru 3981940755C6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
        s=default; t=1682363523;
        bh=mS4Y7rIFdUwUfVv7Jse8uehF8rfPCZBGekclWUdo4Vo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=q9hl9BgwcJJoJgecJZ0W+IMwIrUWLGdHaIe02B0CvfgexxSQGiJwdLkycD09eDJI8
         jr+BkclsHR6JYN3x0LuD3NOEAY9LW4Soi/rvMnXIrYSCE+5OCwu0rZLTNiD08qThtp
         ayXgmBgz8Y5FOr+XLt/lqz8/qOeQaSxtzEMeIc70=
Date:   Mon, 24 Apr 2023 22:11:58 +0300
From:   Fedor Pchelkin <pchelkin@ispras.ru>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Kalle Valo <kvalo@kernel.org>
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
        lvc-project@linuxtesting.org,
        syzbot+df61b36319e045c00a08@syzkaller.appspotmail.com
Subject: Re: [PATCH 2/3] wifi: ath9k: fix races between ath9k_wmi_cmd and
 ath9k_wmi_ctrl_rx
Message-ID: <20230424191158.iebfqubeanurdabk@fpc>
References: <20230315202112.163012-1-pchelkin@ispras.ru>
 <20230315202112.163012-3-pchelkin@ispras.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230315202112.163012-3-pchelkin@ispras.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This problem is realy subtle, I suppose. In the v2 commit info, which I'll
send in the next mail, the race condition is described which can lead to
invalid behaviour.

Couldn't reproduce that particular problem on real hardware, but if
force timeouts to wmi cmd completions, local KMSan catches some uninit
values.

The synchronization between ath9k_wmi_cmd and ath9k_wmi_ctrl_rx on
timeouts is good, especially after 8a2f35b98306 ("wifi: ath9k: Fix
potential stack-out-of-bounds write in ath9k_wmi_rsp_callback()").

And I think the only place where the fuzzer can provoke failure is when
wmi->last_seq_id in callback is checked before it is assigned zero inside
ath9k_wmi_cmd() during timeout exit. This scenario is more thoroughly
described in patch v2.

Well, the issue seems to be rare and I don't know how to properly test it
on real hardware.

I've made some checks on a basic driver workflow, and there weren't any
stalls or explicit failures, and the patch seems to close that tiny race
condition window. But, anyway, it requires more discussion.
