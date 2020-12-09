Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF0402D3F05
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 10:44:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729026AbgLIJmz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 04:42:55 -0500
Received: from mxout70.expurgate.net ([91.198.224.70]:30637 "EHLO
        mxout70.expurgate.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728509AbgLIJmz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 04:42:55 -0500
Received: from [127.0.0.1] (helo=localhost)
        by relay.expurgate.net with smtp (Exim 4.92)
        (envelope-from <ms@dev.tdt.de>)
        id 1kmvy1-000Ksk-Tg; Wed, 09 Dec 2020 10:41:01 +0100
Received: from [195.243.126.94] (helo=securemail.tdt.de)
        by relay.expurgate.net with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ms@dev.tdt.de>)
        id 1kmvy1-000XDP-1s; Wed, 09 Dec 2020 10:41:01 +0100
Received: from securemail.tdt.de (localhost [127.0.0.1])
        by securemail.tdt.de (Postfix) with ESMTP id 961A5240041;
        Wed,  9 Dec 2020 10:41:00 +0100 (CET)
Received: from mail.dev.tdt.de (unknown [10.2.4.42])
        by securemail.tdt.de (Postfix) with ESMTP id 18B8A240040;
        Wed,  9 Dec 2020 10:41:00 +0100 (CET)
Received: from mail.dev.tdt.de (localhost [IPv6:::1])
        by mail.dev.tdt.de (Postfix) with ESMTP id B4BE020897;
        Wed,  9 Dec 2020 10:40:59 +0100 (CET)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 09 Dec 2020 10:40:59 +0100
From:   Martin Schiller <ms@dev.tdt.de>
To:     Xie He <xie.he.0141@gmail.com>
Cc:     Andrew Hendry <andrew.hendry@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux X25 <linux-x25@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v7 4/5] net/x25: fix restart request/confirm
 handling
Organization: TDT AG
In-Reply-To: <CAJht_ENukJrnh6m8FLrHBwnKKyZpzk6uGWhS4_eUCyDzrCG3eA@mail.gmail.com>
References: <20201126063557.1283-1-ms@dev.tdt.de>
 <20201126063557.1283-5-ms@dev.tdt.de>
 <CAJht_EMZqcPdE5n3Vp+jJa1sVk9+vbwd-Gbi8Xqy19bEdbNNuA@mail.gmail.com>
 <CAJht_ENukJrnh6m8FLrHBwnKKyZpzk6uGWhS4_eUCyDzrCG3eA@mail.gmail.com>
Message-ID: <3e314d2786857cbd5aaee8b83a0e6daa@dev.tdt.de>
X-Sender: ms@dev.tdt.de
User-Agent: Roundcube Webmail/1.3.15
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dev.tdt.de
X-purgate-type: clean
X-purgate: clean
X-purgate-ID: 151534::1607506861-00001F6B-18FBB75D/0/0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-12-09 10:17, Xie He wrote:
> On Wed, Dec 9, 2020 at 1:01 AM Xie He <xie.he.0141@gmail.com> wrote:
>> 
>> On Wed, Nov 25, 2020 at 10:36 PM Martin Schiller <ms@dev.tdt.de> 
>> wrote:
>> >
>> >         switch (nb->state) {
>> >         case X25_LINK_STATE_0:
>> > -               nb->state = X25_LINK_STATE_2;
>> > -               break;
>> >         case X25_LINK_STATE_1:
>> >                 x25_transmit_restart_request(nb);
>> >                 nb->state = X25_LINK_STATE_2;
>> 
>> What is the reason for this change? Originally only the connecting
>> side will transmit a Restart Request; the connected side will not and
>> will only wait for the Restart Request to come. Now both sides will
>> transmit Restart Requests at the same time. I think we should better
>> avoid collision situations like this.
> 
> Oh. I see. Because in other patches we are giving L2 the ability to
> connect by itself, both sides can now appear here to be the
> "connected" side. So we can't make the "connected" side wait as we did
> before.

Right.
By the way: A "Restart Collision" is in practice a very common event to
establish the Layer 3.
