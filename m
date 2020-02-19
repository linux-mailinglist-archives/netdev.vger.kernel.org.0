Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 120E7163936
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 02:19:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727915AbgBSBTn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 20:19:43 -0500
Received: from forward500o.mail.yandex.net ([37.140.190.195]:43267 "EHLO
        forward500o.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726939AbgBSBTm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 20:19:42 -0500
Received: from mxback1j.mail.yandex.net (mxback1j.mail.yandex.net [IPv6:2a02:6b8:0:1619::10a])
        by forward500o.mail.yandex.net (Yandex) with ESMTP id 140CD60197;
        Wed, 19 Feb 2020 04:19:37 +0300 (MSK)
Received: from localhost (localhost [::1])
        by mxback1j.mail.yandex.net (mxback/Yandex) with ESMTP id YL0iA9Gz0m-JaSGc8gP;
        Wed, 19 Feb 2020 04:19:36 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail; t=1582075176;
        bh=dhzg+9rEG0nYcIh4AOwylZPaZZyNGN2eZQsA5FMtWoE=;
        h=Message-Id:Cc:Subject:In-Reply-To:Date:References:To:From;
        b=si75TmNCnigp1gijVvAyW6PptfGedGlHvhQvaznvclILqwVmsEXMjhsvM8pOngavb
         Awj/YjLvQWi/LfWq1YiF/eSwIPvCjX62UR+pjVc7UqIixpYJCGoPfgNbc5M/RU/MFQ
         cFJqE+n49y9mC7oNMfz74gz5sg5jpfPbDHN2AUX4=
Authentication-Results: mxback1j.mail.yandex.net; dkim=pass header.i=@yandex.ru
Received: by myt2-508c8f44300a.qloud-c.yandex.net with HTTP;
        Wed, 19 Feb 2020 04:19:36 +0300
From:   Evgeniy Polyakov <zbr@ioremap.net>
Envelope-From: drustafa@yandex.ru
To:     "Daniel Walker (danielwa)" <danielwa@cisco.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20200218205441.GA24043@zorba>
References: <20200217175209.GM24152@zorba>
         <20200217.185235.495219494110132658.davem@davemloft.net>
         <20200218163030.GR24152@zorba>
         <20200218.123546.666027846950664712.davem@davemloft.net> <20200218205441.GA24043@zorba>
Subject: Re: [PATCH] drivers: connector: cn_proc: allow limiting certain messages
MIME-Version: 1.0
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date:   Wed, 19 Feb 2020 04:19:36 +0300
Message-Id: <17008791582075176@myt2-508c8f44300a.qloud-c.yandex.net>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=utf-8
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

18.02.2020, 23:55, "Daniel Walker (danielwa)" <danielwa@cisco.com>:
>>  > I think I would agree with you if this was unicast, and each listener could tailor
>>  > what messages they want to get. However, this interface isn't that, and it would
>>  > be considerable work to convert to that.
>>
>>  You filter at recvmsg() on the specific socket, multicast or not, I
>>  don't understand what the issue is.
>
> Cisco tried something like this (I don't know if it was exactly what your referring to),
> and it was messy and fairly complicated for a simple interface. In fact it was
> the first thing I suggested for Cisco.
>
> I'm not sure why Connector has to supply an exact set of messages, one could
> just make a whole new kernel module hooked into netlink sending a different
> subset of connector messages. The interface eats up CPU and slows the
> system if it's sending messages your just going to ignore. I'm sure the
> filtering would also slows down the system.

Connector has unicast interface and multicast-like 'subscription', but sending system-wide messages
implies using broadcast interface, since you can not hold per-user/per-socket information about particular
event mask, instead you have channels in connector each one could have been used for specific message type,
but it looks overkill for simple process mask changes.

And in fact, now I do not understand your point.
I thought you have been concerned about receiving too many messages from particular connector module because
there are, for example, too many 'fork/signal' events. And now you want to limit them to 'fork' events only.
Even if there could be other users who wanted to receive 'signal' and other events.

And you blame connector - basically a network media, call it TCP if you like - for not filtering this for you?
And after you have been told to use connector channels - let's call them TCP ports -
which requires quite a bit of work - you do not want to do this (also, this will break backward compatibility for everyone
else including (!) Cisco (!!)). I'm a little bit lost here.

As a side and more practical way - do we want to have a global switch for particular process state changes broadcasting?
