Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A5FFE8392
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 09:54:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730057AbfJ2Iya (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 04:54:30 -0400
Received: from ni.piap.pl ([195.187.100.5]:58338 "EHLO ni.piap.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729992AbfJ2Iya (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Oct 2019 04:54:30 -0400
Received: from t19.piap.pl (OSB1819.piap.pl [10.0.9.19])
        (using TLSv1.2 with cipher AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ni.piap.pl (Postfix) with ESMTPSA id 6DA7D442258;
        Tue, 29 Oct 2019 09:54:24 +0100 (CET)
DKIM-Filter: OpenDKIM Filter v2.11.0 ni.piap.pl 6DA7D442258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=piap.pl; s=mail;
        t=1572339264; bh=TU9ebFgfanQ7Z4iTqUkUU2jipaToSz+RUzToxJpmr6s=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=KQJnu8OO87rgTKcwqeO2VfIMekcbwGawgFrZFaEjV2fRRy55gzo2McuRNLzH92jr5
         jK1sCYGsI7f3ncJ42fAuSZAdgoEeRQ7Sqm9C4xMXPSWOZ6rbEYBoSp8KVCCYz+yedZ
         x4M+UFyvwnBQQfMDU0wgJLEMSIiTg3ruAlYb9p2g=
From:   khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] 802.11n IBSS: wlan0 stops receiving packets due to aggregation after sender reboot
References: <m34l02mh71.fsf@t19.piap.pl> <m37e4tjfbu.fsf@t19.piap.pl>
        <e5b07b4ce51f806ce79b1ae06ff3cbabbaa4873d.camel@sipsolutions.net>
Date:   Tue, 29 Oct 2019 09:54:24 +0100
In-Reply-To: <e5b07b4ce51f806ce79b1ae06ff3cbabbaa4873d.camel@sipsolutions.net>
        (Johannes Berg's message of "Mon, 28 Oct 2019 13:21:15 +0100")
Message-ID: <m37e4orkxr.fsf@t19.piap.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-KLMS-Rule-ID: 4
X-KLMS-Message-Action: skipped
X-KLMS-AntiSpam-Status: not scanned, whitelist
X-KLMS-AntiPhishing: not scanned, whitelist
X-KLMS-AntiVirus: Kaspersky Security 8.0 for Linux Mail Server, version 8.0.1.721, not scanned, whitelist
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Johannes Berg <johannes@sipsolutions.net> writes:

> I think you just got very lucky (or unlucky) to have the same dialog
> token, because we start from 0

Right, it seems to be the case.

> - maybe we should initialize it to a
> random value to flush out such issues.

The problem I can see is that the dialog_tokens are 8-bit, way too small
to eliminate conflicts.

> Really what I think probably happened is that one of your stations lost
> the connection to the other, and didn't tell it about it in any way - so
> the other kept all the status alive.

You must have missed my previous mail - I simply rebooted that station,
and alternatively rmmoded/modprobed ath9k. But the problem originated in
a station going out of and back in range, in fact.

> I suspect to make all this work well we need to not only have the fixes
> I made recently to actually send and parse deauth frames, but also to
> even send an auth and reset the state when we receive that, so if we
> move out of range and even the deauth frame is lost, we can still reset
> properly.

That's one thing. The other is a station trying ADDBA for the first time
after boot (while the local station has seen it before that reboot).

> In any case, this is not the right approach - we need to handle the
> "lost connection" case better I suspect, but since you don't say what
> really happened I don't really know that that's what you're seeing.

I guess we need to identify "new connection" reliably. Otherwise,
the new connections are treated as old ones and it doesn't work.

Now how can it be fixed?
--=20
Krzysztof Halasa

=C5=81UKASIEWICZ Research Network
Industrial Research Institute for Automation and Measurements PIAP
Al. Jerozolimskie 202, 02-486 Warsaw, Poland
