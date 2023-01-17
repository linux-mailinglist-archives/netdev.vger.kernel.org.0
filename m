Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 391B966DCE9
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 12:54:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236602AbjAQLy5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 06:54:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236927AbjAQLyf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 06:54:35 -0500
Received: from air.basealt.ru (air.basealt.ru [194.107.17.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A090635271;
        Tue, 17 Jan 2023 03:54:34 -0800 (PST)
Received: by air.basealt.ru (Postfix, from userid 490)
        id 4C3352F20231; Tue, 17 Jan 2023 11:54:33 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
Received: from localhost (broadband-188-32-10-232.ip.moscow.rt.ru [188.32.10.232])
        by air.basealt.ru (Postfix) with ESMTPSA id 5C8D62F2022A;
        Tue, 17 Jan 2023 11:54:30 +0000 (UTC)
Date:   Tue, 17 Jan 2023 14:54:30 +0300
From:   "Alexey V. Vissarionov" <gremlin@altlinux.org>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     "Alexey V. Vissarionov" <gremlin@altlinux.org>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Ahmad Fatoum <a.fatoum@pengutronix.de>,
        Wataru Gohda <wataru.gohda@cypress.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        lvc-project@linuxtesting.org
Subject: Re: [PATCH] wifi: brcmfmac: Fix allocation size
Message-ID: <20230117115430.GC15213@altlinux.org>
References: <20230117104508.GB12547@altlinux.org>
 <Y8aCwr0BEi6zZEwO@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Y8aCwr0BEi6zZEwO@corigine.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2023-01-17 12:13:06 +0100, Simon Horman wrote:

 >> buf_size = sizeof(*rfi);
 >> max_idx = reorder_data[BRCMF_RXREORDER_MAXIDX_OFFSET];
 >> - buf_size += (max_idx + 1) * sizeof(pkt);
 >> + buf_size += (max_idx + 1) * sizeof(struct sk_buff);

 > This is followed by:
 > rfi = kzalloc(buf_size, GFP_ATOMIC);
 > ...
 > rfi->pktslots = (struct sk_buff **)(rfi + 1);
 > The type of rfi is struct brcmf_ampdu_rx_reorder, which
 > looks like this:
 > struct brcmf_ampdu_rx_reorder
 > { struct sk_buff **pktslots; ... };
 > And it looks to me that pkt is used as an array of
 > (struct sk_buff *).
 > So in all, it seems to me that the current code is correct.

So, the buf_size is a sum of sizeof(struct brcmf_ampdu_rx_reorder)
and size of array of pointers... and yes, this array is filled with
pointers: rfi->pktslots[rfi->cur_idx] = pkt;

Hmmm... looks correct. Sorry for bothering.


-- 
Alexey V. Vissarionov
gremlin נעי altlinux פ‏כ org; +vii-cmiii-ccxxix-lxxix-xlii
GPG: 0D92F19E1C0DC36E27F61A29CD17E2B43D879005 @ hkp://keys.gnupg.net
