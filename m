Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4EED128D4B
	for <lists+netdev@lfdr.de>; Sun, 22 Dec 2019 10:44:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726057AbfLVJnQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Dec 2019 04:43:16 -0500
Received: from guitar.tcltek.co.il ([192.115.133.116]:37068 "EHLO
        mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725899AbfLVJnQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 22 Dec 2019 04:43:16 -0500
Received: from tarshish (unknown [10.0.8.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.tkos.co.il (Postfix) with ESMTPS id 852F544030A;
        Sun, 22 Dec 2019 11:43:12 +0200 (IST)
References: <dd029665fdacef34a17f4fb8c5db4584211eacf6.1576748902.git.baruch@tkos.co.il> <20191220142725.GB2458874@t480s.localdomain>
User-agent: mu4e 1.2.0; emacs 26.1
From:   Baruch Siach <baruch@tkos.co.il>
To:     Vivien Didelot <vivien.didelot@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Marek =?utf-8?Q?Beh=C3=BAn?= <marek.behun@nic.cz>,
        netdev@vger.kernel.org,
        Denis Odintsov <d.odintsov@traviangames.com>
Subject: Re: [PATCH] net: dsa: mv88e6xxx: force cmode write on 6141/6341
In-reply-to: <20191220142725.GB2458874@t480s.localdomain>
Date:   Sun, 22 Dec 2019 11:43:12 +0200
Message-ID: <87r20w4rwv.fsf@tarshish>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vivien,

On Fri, Dec 20 2019, Vivien Didelot wrote:
> On Thu, 19 Dec 2019 11:48:22 +0200, Baruch Siach <baruch@tkos.co.il> wrote:
>> mv88e6xxx_port_set_cmode() relies on cmode stored in struct
>> mv88e6xxx_port to skip cmode update when the requested value matches the
>> cached value. It turns out that mv88e6xxx_port_hidden_write() might
>> change the port cmode setting as a side effect, so we can't rely on the
>> cached value to determine that cmode update in not necessary.
>> 
>> Force cmode update in mv88e6341_port_set_cmode(), to make
>> serdes configuration work again. Other mv88e6xxx_port_set_cmode()
>> callers keep the current behaviour.
>> 
>> This fixes serdes configuration of the 6141 switch on SolidRun Clearfog
>> GT-8K.
>> 
>> Fixes: 7a3007d22e8 ("net: dsa: mv88e6xxx: fully support SERDES on Topaz family")
>> Reported-by: Denis Odintsov <d.odintsov@traviangames.com>
>> Signed-off-by: Baruch Siach <baruch@tkos.co.il>
>
> Andrew,
>
> We tend to avoid caching values in the mv88e6xxx driver the more we can and
> query the hardware instead to avoid errors like this. We can consider calling a
> new mv88e6xxx_port_get_cmode() helper when needed (e.g. in higher level callers
> like mv88e6xxx_serdes_power() and mv88e6xxx_serdes_irq_thread_fn()) and pass
> the value down to the routines previously accessing chip->ports[port].cmode,
> as a new argument. I can prepare a patch doing this. What do you think?

I'm not sure that cmode read would always give a valid value. On 6141 I
see an invalid 0x6 value after mv88e6xxx_port_hidden_write().

As I understand, this cache elimination work would target v5.6+. Would
you ack this patch for v5.5-rc to fix currently broken setup?

Thanks,
baruch

-- 
     http://baruch.siach.name/blog/                  ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.52.368.4656, http://www.tkos.co.il -
