Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 497DA41ED9B
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 14:36:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353898AbhJAMhw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 08:37:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:55388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231352AbhJAMhv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Oct 2021 08:37:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DED5A61A8B;
        Fri,  1 Oct 2021 12:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633091767;
        bh=4n6FROUAmxcbTg/roy1p496VFp3nU8QQo8Jp8WUJ5wI=;
        h=Date:From:To:Cc:Subject:From;
        b=eb8bfBHSSpETWEgA3oa8OPg39Wub9Pzm1NGQCLsK5bF/dPh+U1Rz0FFJ68RZzQEsj
         h2+BdSP6ZlqxTxVS5Vp4qn80NYrjkyR1q6flWN1fm9XjT9mkRI33ydQthJf2J5bWDb
         22Jdus8dmGGnRyU1s3Mr/V3cy97aX1xpYxqYz5HQFfEqhvMDkewWetsGGSYgtHknPu
         DBLeJL4HiUztPdrD4sCe2ScUOyiYudxc3yZLOnfDKTooBNtoMTyrLB+Y6GYbw49xLd
         jyKkoYdb20XhFhCb23K6cqcWonUocx9Uh9oAJodLDZ70SCNpsHaaeTdj9NsjTrdpjq
         L+jreN3PPTXeA==
Date:   Fri, 1 Oct 2021 14:36:01 +0200
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Pavel Machek <pavel@ucw.cz>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Rob Herring <robh+dt@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: lets settle the LED `function` property regarding the netdev
 trigger
Message-ID: <20211001143601.5f57eb1a@thinkpad>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Pavel, Jacek, Rob and others,

I'd like to settle DT binding for the LED function property regarding
the netdev LED trigger.

Currently we have, in include/dt-bindings/leds/common.h, the following
functions defined that could be interpreted as request to enable netdev
trigger on given LEDs:
  activity
  lan
  rx tx
  wan
  wlan

The "activity" function was originally meant to imply the CPU
activity trigger, while "rx" and "tx" are AFAIK meant as UART indicators
(tty LED trigger), see
https://lore.kernel.org/linux-leds/20190609190803.14815-27-jacek.anaszewski@gmail.com/

The netdev trigger supports different settings:
- indicate link
- blink on rx, blink on tx, blink on both

The current scheme does not allow for implying these.

I therefore propose that when a LED has a network device handle in the
trigger-sources property, the "rx", "tx" and "activity" functions
should also imply netdev trigger (with the corresponding setting).
A "link" function should be added, also implying netdev trigger.

What about if a LED is meant by the device vendor to indicate both link
(on) and activity (blink)?
The function property is currently a string. This could be changed to
array of strings, and then we can have
  function = "link", "activity";
Since the function property is also used for composing LED classdev
names, I think only the first member should be used for that.

This would allow for ethernet LEDs with names
  ethphy-0:green:link
  ethphy-0:yellow:activity
to be controlled by netdev trigger in a specific setting without the
need to set the trigger in /sys/class/leds.

Opinions?

Marek
