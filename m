Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3ED2664C90E
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 13:30:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238423AbiLNMas (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 07:30:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238397AbiLNMaV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 07:30:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6388C2C;
        Wed, 14 Dec 2022 04:27:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4756CB81691;
        Wed, 14 Dec 2022 12:27:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D8FAC433EF;
        Wed, 14 Dec 2022 12:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671020852;
        bh=HeAZVr7r27+SXeqKlVEg5HRRIB4/H7DJN3CiF79gjYU=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=bbL65vbLuxFG1NrUBBBFKZps2Wpi/OHNkbzoE2upKS71umqwFn5nw6HnL3baBzaab
         o4OUPLbeemwZFSgOekzhczbNK6bUXuJluKWD1R++LCr5k5epvmsZLq5l6zAAo+yg5p
         Uzf3UyVbHWzhEA5Jm9sN7YKJ1T0hoVVG7sp2imGr7b0nn64JdNLCU7ULHvNmzho8ls
         3WJsrxwvdjxpFc2Sp0hgQZ+gtePTrbc48fX8JOuZ2qmijO44cqXbISSfGOU9UA/X2K
         Bhne2QLPso96Y8oy5zVjh4DCNQoDd3NVD5qolgcy2tdZTNUn4qaVBMp0CvPZ8xA8pm
         abF7nIGeKxxnQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v4] wifi: rtlwifi: Fix global-out-of-bounds bug in
 _rtl8812ae_phy_set_txpower_limit()
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20221212025812.1541311-1-lizetao1@huawei.com>
References: <20221212025812.1541311-1-lizetao1@huawei.com>
To:     Li Zetao <lizetao1@huawei.com>
Cc:     <pkshih@realtek.com>, <Larry.Finger@lwfinger.net>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
        <linville@tuxdriver.com>, <lizetao1@huawei.com>,
        <netdev@vger.kernel.org>, <pabeni@redhat.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <167102084873.7997.7208445829168605177.kvalo@kernel.org>
Date:   Wed, 14 Dec 2022 12:27:30 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Li Zetao <lizetao1@huawei.com> wrote:

> There is a global-out-of-bounds reported by KASAN:
> 
>   BUG: KASAN: global-out-of-bounds in
>   _rtl8812ae_eq_n_byte.part.0+0x3d/0x84 [rtl8821ae]
>   Read of size 1 at addr ffffffffa0773c43 by task NetworkManager/411
> 
>   CPU: 6 PID: 411 Comm: NetworkManager Tainted: G      D
>   6.1.0-rc8+ #144 e15588508517267d37
>   Hardware name: QEMU Standard PC (Q35 + ICH9, 2009),
>   Call Trace:
>    <TASK>
>    ...
>    kasan_report+0xbb/0x1c0
>    _rtl8812ae_eq_n_byte.part.0+0x3d/0x84 [rtl8821ae]
>    rtl8821ae_phy_bb_config.cold+0x346/0x641 [rtl8821ae]
>    rtl8821ae_hw_init+0x1f5e/0x79b0 [rtl8821ae]
>    ...
>    </TASK>
> 
> The root cause of the problem is that the comparison order of
> "prate_section" in _rtl8812ae_phy_set_txpower_limit() is wrong. The
> _rtl8812ae_eq_n_byte() is used to compare the first n bytes of the two
> strings from tail to head, which causes the problem. In the
> _rtl8812ae_phy_set_txpower_limit(), it was originally intended to meet
> this requirement by carefully designing the comparison order.
> For example, "pregulation" and "pbandwidth" are compared in order of
> length from small to large, first is 3 and last is 4. However, the
> comparison order of "prate_section" dose not obey such order requirement,
> therefore when "prate_section" is "HT", when comparing from tail to head,
> it will lead to access out of bounds in _rtl8812ae_eq_n_byte(). As
> mentioned above, the _rtl8812ae_eq_n_byte() has the same function as
> strcmp(), so just strcmp() is enough.
> 
> Fix it by removing _rtl8812ae_eq_n_byte() and use strcmp() barely.
> Although it can be fixed by adjusting the comparison order of
> "prate_section", this may cause the value of "rate_section" to not be
> from 0 to 5. In addition, commit "21e4b0726dc6" not only moved driver
> from staging to regular tree, but also added setting txpower limit
> function during the driver config phase, so the problem was introduced
> by this commit.
> 
> Fixes: 21e4b0726dc6 ("rtlwifi: rtl8821ae: Move driver from staging to regular tree")
> Signed-off-by: Li Zetao <lizetao1@huawei.com>
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>

Patch applied to wireless-next.git, thanks.

117dbeda22ec wifi: rtlwifi: Fix global-out-of-bounds bug in _rtl8812ae_phy_set_txpower_limit()

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20221212025812.1541311-1-lizetao1@huawei.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

