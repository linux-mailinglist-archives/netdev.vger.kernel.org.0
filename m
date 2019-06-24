Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB00151BC5
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 21:54:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731187AbfFXTyv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 15:54:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59406 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726774AbfFXTyv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jun 2019 15:54:51 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A453D3078AB7;
        Mon, 24 Jun 2019 19:54:38 +0000 (UTC)
Received: from ovpn-112-53.rdu2.redhat.com (ovpn-112-53.rdu2.redhat.com [10.10.112.53])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BFA0D5D70D;
        Mon, 24 Jun 2019 19:54:31 +0000 (UTC)
Message-ID: <f0fcee096d779837abc46e7badae9105ee8aaecf.camel@redhat.com>
Subject: Re: WWAN Controller Framework (was IPA [PATCH v2 00/17])
From:   Dan Williams <dcbw@redhat.com>
To:     Alex Elder <elder@linaro.org>, davem@davemloft.net, arnd@arndb.de,
        bjorn.andersson@linaro.org, ilias.apalodimas@linaro.org
Cc:     evgreen@chromium.org, benchan@google.com, ejcaruso@google.com,
        cpratapa@codeaurora.org, syadagir@codeaurora.org,
        subashab@codeaurora.org, abhishek.esse@gmail.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org
Date:   Mon, 24 Jun 2019 14:54:30 -0500
In-Reply-To: <23ff4cce-1fee-98ab-3608-1fd09c2d97f1@linaro.org>
References: <20190531035348.7194-1-elder@linaro.org>
         <23ff4cce-1fee-98ab-3608-1fd09c2d97f1@linaro.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Mon, 24 Jun 2019 19:54:51 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2019-06-24 at 11:30 -0500, Alex Elder wrote:
> OK I want to try to organize a little more concisely some of the
> discussion on this, because there is a very large amount of volume
> to date and I think we need to try to narrow the focus back down
> again.
> 
> I'm going to use a few terms here.  Some of these I really don't
> like, but I want to be unambiguous *and* (at least for now) I want
> to avoid the very overloaded term "device".
> 
> I have lots more to say, but let's start with a top-level picture,
> to make sure we're all on the same page.
> 
>          WWAN Communication
>          Channel (Physical)
>                  |     ------------------------
> ------------     v     |           :+ Control |  \
> >          |-----------|           :+ Data    |  |
> >    AP    |           | WWAN unit :+ Voice   |   > Functions
> >          |===========|           :+ GPS     |  |
> ------------     ^     |           :+ ...     |  /
>                  |     -------------------------
>           Multiplexed WWAN
>            Communication
>          Channel (Physical)
> 
> - The *AP* is the main CPU complex that's running Linux on one or
>   more CPU cores.
> - A *WWAN unit* is an entity that shares one or more physical
>   *WWAN communication channels* with the AP.

You could just say "WWAN modem" here.

> - A *WWAN communication channel* is a bidirectional means of
>   carrying data between the AP and WWAN unit.
> - A WWAN communication channel carries data using a *WWAN protocol*.
> - A WWAN unit implements one or more *WWAN functions*, such as
>   5G data, LTE voice, GPS, and so on.

Go more generic here. Not just 5G data but any WWAN IP-based data
(GPRS, EDGE, CDMA, UMTS, EVDO, LTE, 5G, etc). And not just LTE voice
but any voice data; plenty of devices don't support LTE but still have
"WWAN logical communication channels"

> - A WWAN unit shall implement a *WWAN control function*, used to
>   manage the use of other WWAN functions, as well as the WWAN unit
>   itself.
> - The AP communicates with a WWAN function using a WWAN protocol.
> - A WWAN physical channel can be *multiplexed*, in which case it
>   carries the data for one or more *WWAN logical channels*.

It's unclear to me what "physical" means here. USB Interface or
Endpoint or PCI Function or SMD channel? Or kernel TTY device?

For example on Qualcomm-based USB dongles a given USB Interface's
Endpoint represents a QMAP "IP data" channel which itself could be
multiplexed into separate "IP data" channels.  Or that USB Endpoint(s)
could be exposed as a TTY which itself can be MUX-ed dynamically using
GSM 07.10.

To me "physical" usually means the bus type (PCI, USB, SMD, whatever).
A Linux hardware driver (IPA, qmi_wwan, option, sierra, etc) binds to
that physical entity using hardware IDs (USB or PCI VID/PID, devicetree
properties) and exposes some "WWAN logical communication channels".
Those logical channels might be multiplexed and another driver (rmnet)
could handle exposing the de-muxed logical channels that the muxed
logical channel carries.

> - A multiplexed WWAN communication channel uses a *WWAN wultiplexing
>   protocol*, which is used to separate independent data streams
>   carrying other WWAN protocols.
> - A WWAN logical channel carries a bidirectional stream of WWAN
>   protocol data between an entity on the AP and a WWAN function.

It *usually* is bidirectional. For example some GPS logical
communication channels just start spitting out NMEA when you give the
control function a command. The NMEA ports themselves don't accept any
input.

> Does that adequately represent a very high-level picture of what
> we're trying to manage?

Yes, pretty well. Thanks for trying to specify it all.

> And if I understand it right, the purpose of the generic framework
> being discussed is to define a common mechanism for managing (i.e.,
> discovering, creating, destroying, querying, configuring, enabling,
> disabling, etc.) WWAN units and the functions they implement, along
> with the communication and logical channels used to communicate with
> them.

Yes.

Dan

> Comments?
> 
> 					-Alex

