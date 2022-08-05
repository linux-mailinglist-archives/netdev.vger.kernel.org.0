Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A636158A85A
	for <lists+netdev@lfdr.de>; Fri,  5 Aug 2022 10:57:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240183AbiHEI42 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Aug 2022 04:56:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234856AbiHEI41 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Aug 2022 04:56:27 -0400
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABA896AA3C;
        Fri,  5 Aug 2022 01:56:25 -0700 (PDT)
Received: from [192.168.31.174] (unknown [95.31.173.239])
        by mail.ispras.ru (Postfix) with ESMTPSA id BBDCD40737C5;
        Fri,  5 Aug 2022 08:56:19 +0000 (UTC)
Message-ID: <18aa0617-0afe-2543-89cf-2f04c682ea88@ispras.ru>
Date:   Fri, 5 Aug 2022 11:56:18 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH] can: j1939: fix memory leak of skbs
Content-Language: en-US
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Robin van der Gracht <robin@protonic.nl>,
        Oleksij Rempel <linux@rempel-privat.de>, kernel@pengutronix.de,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldv-project@linuxtesting.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>
References: <20220708175949.539064-1-pchelkin@ispras.ru>
 <20220729042244.GC30201@pengutronix.de>
From:   Fedor Pchelkin <pchelkin@ispras.ru>
In-Reply-To: <20220729042244.GC30201@pengutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Oleksij,

On 29.07.2022 07:22, Oleksij Rempel wrote:
> Initial issue can be reproduced by using real (slow) CAN with j1939cat[1]
> tool. Both parts should be started to make sure the j1939_session_tx_dat() will
> actually start using the queue. After pushing about 100K of data, application
> will try to close the socket and exit. After socket is closed, all skb related
> to this socket will be freed and j1939_session_tx_dat() will use freed skbs.

Ok, the patch I suggested was a kind of a guess, now I understand that
it breaks important logic.

On 29.07.2022 07:22, Oleksij Rempel wrote:
 > This skb_get() is counter part of skb_unref()
 > j1939_session_skb_drop_old().

However, we have a case [1] where j1939_session_skb_queue() is called
but the corresponding j1939_session_skb_drop_old() is not called and it
causes a memory leak.

I tried to investigate it a little bit: the thing is that
j1939_session_skb_drop_old() can be called only when processing
J1939_ETP_CMD_CTS. On the contrary, as I can see,
j1939_session_skb_queue() can be called independently from
J1939_ETP_CMD_CTS so the two functions obviously do not correspond to
each other.

In reproducer case there is a J1939_ETP_CMD_RTS processing, then
we send some messages (where j1939_session_skb_queue() is called) and
after that J1939_ETP_CMD_ABORT is processed and we lose those skbs.

[1] https://forge.ispras.ru/issues/11743
