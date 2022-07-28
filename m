Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 377DC5843FE
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 18:15:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233271AbiG1QPN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 12:15:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232868AbiG1QOu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 12:14:50 -0400
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C01176E2F8;
        Thu, 28 Jul 2022 09:14:47 -0700 (PDT)
Received: from [10.10.132.125] (unknown [83.149.199.65])
        by mail.ispras.ru (Postfix) with ESMTPSA id A658240737CF;
        Thu, 28 Jul 2022 16:14:43 +0000 (UTC)
Message-ID: <7ea40c0e-e696-3537-c2a4-a8eccf4695d0@ispras.ru>
Date:   Thu, 28 Jul 2022 19:14:43 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] can: j1939: Remove unnecessary WARN_ON_ONCE in
 j1939_sk_queue_activate_next_locked()
Content-Language: en-US
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Robin van der Gracht <robin@protonic.nl>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Elenita Hinds <ecathinds@gmail.com>,
        Kurt Van Dijck <dev.kurt@vandijck-laurijssen.be>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        ldv-project@linuxtesting.org
References: <20220720110645.519601-1-pchelkin@ispras.ru>
 <20220720191357.GB5600@pengutronix.de>
From:   Fedor Pchelkin <pchelkin@ispras.ru>
In-Reply-To: <20220720191357.GB5600@pengutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Oleksij,

I'm sorry for late answering.

On 20.07.2022 22:13, Oleksij Rempel wrote:
>> Are you working on some system where this use case is valid?

No, we are fuzzing the kernel and analyzing different warnings and
crashes.

On 20.07.2022 22:13, Oleksij Rempel wrote:
 > yes

Well, there is a long story about where and for which purposes the
kernel warning macros should be correctly used and, overall,
WARN_ON_ONCE is not intended for user-space notification.

Linus Torvalds wrote:
 > WARN_ON() should only be used for "This cannot happen, but if it does,
 > I want to know how we got here".
 >
 > So if that j1939 thing is something that can be triggered by a user,
 > then the backtrace should be reported to the driver maintainer, and
 > then either
 >
 > (a) the WARN_ON_ONCE() should just be removed ("ok, this can happen,
 > we understand why it can happen, and it's fine")
 >
 > (b) the problem the WARN_ON_ONCE() reports about should be made
 > impossible some way
 >
 > (c) it might be downgraded to a pr_warn() if people really want to
 > tell user space that "guys, you're doing something wrong" and it's
 > considered a useful warning.

So WARN_ON_ONCE should be replaced with a more gentle variant - I think
pr_warn_once would suit this case. I've prepared a new patch for that,
it will follow this email.

Could you also look at the patch - [PATCH] can: j1939: fix memory leak 
of skbs - which I sent you on 08.07.2022, please?
