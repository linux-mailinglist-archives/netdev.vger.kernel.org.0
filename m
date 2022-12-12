Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79B2C6497B2
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 02:37:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231136AbiLLBhV convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 11 Dec 2022 20:37:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiLLBhU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Dec 2022 20:37:20 -0500
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BC409B1F8;
        Sun, 11 Dec 2022 17:37:18 -0800 (PST)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 2BC1YSTx8023772, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36506.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 2BC1YSTx8023772
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=FAIL);
        Mon, 12 Dec 2022 09:34:28 +0800
Received: from RTEXDAG02.realtek.com.tw (172.21.6.101) by
 RTEXH36506.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.9; Mon, 12 Dec 2022 09:35:16 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXDAG02.realtek.com.tw (172.21.6.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Mon, 12 Dec 2022 09:35:16 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b]) by
 RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b%5]) with mapi id
 15.01.2375.007; Mon, 12 Dec 2022 09:35:16 +0800
From:   Ping-Ke Shih <pkshih@realtek.com>
To:     Li Zetao <lizetao1@huawei.com>
CC:     "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "kvalo@kernel.org" <kvalo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linville@tuxdriver.com" <linville@tuxdriver.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>
Subject: RE: [PATCH v3] rtlwifi: rtl8821ae: Fix global-out-of-bounds bug in _rtl8812ae_phy_set_txpower_limit()
Thread-Topic: [PATCH v3] rtlwifi: rtl8821ae: Fix global-out-of-bounds bug in
 _rtl8812ae_phy_set_txpower_limit()
Thread-Index: AQHZDcmQLIWDqWxK5UWgWwHLimkfx65pd+Xg
Date:   Mon, 12 Dec 2022 01:35:16 +0000
Message-ID: <b94b47f851fb4bba84e6c6aca4bf4ee0@realtek.com>
References: <66c119cc4e184a36d525a07f2fbd092348839610.camel@realtek.com>
 <20221212023540.1540147-1-lizetao1@huawei.com>
In-Reply-To: <20221212023540.1540147-1-lizetao1@huawei.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXDAG02.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?us-ascii?Q?Clean,_bases:_2022/12/11_=3F=3F_10:00:00?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Li Zetao <lizetao1@huawei.com>
> Sent: Monday, December 12, 2022 10:36 AM
> To: Ping-Ke Shih <pkshih@realtek.com>
> Cc: Larry.Finger@lwfinger.net; davem@davemloft.net; edumazet@google.com; kuba@kernel.org;
> kvalo@kernel.org; linux-kernel@vger.kernel.org; linux-wireless@vger.kernel.org; linville@tuxdriver.com;
> lizetao1@huawei.com; netdev@vger.kernel.org; pabeni@redhat.com
> Subject: [PATCH v3] rtlwifi: rtl8821ae: Fix global-out-of-bounds bug in _rtl8812ae_phy_set_txpower_limit()
> 
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

Thanks for your fix.

Acked-by: Ping-Ke Shih <pkshih@realtek.com>

> ---
> v1 -> v2: delete the third parameter of _rtl8812ae_eq_n_byte() and use
> strcmp to replace loop comparison.
> v2 -> v3: remove _rtl8812ae_eq_n_byte() and use strcmp() barely.
> 
>  .../wireless/realtek/rtlwifi/rtl8821ae/phy.c  | 52 +++++++------------
>  1 file changed, 20 insertions(+), 32 deletions(-)
> 

[...]

