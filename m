Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6EB0E861E
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 11:51:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731109AbfJ2Kvo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 06:51:44 -0400
Received: from ni.piap.pl ([195.187.100.5]:47280 "EHLO ni.piap.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726175AbfJ2Kvn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Oct 2019 06:51:43 -0400
Received: from t19.piap.pl (OSB1819.piap.pl [10.0.9.19])
        (using TLSv1.2 with cipher AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ni.piap.pl (Postfix) with ESMTPSA id CA06E4435C4;
        Tue, 29 Oct 2019 11:51:40 +0100 (CET)
DKIM-Filter: OpenDKIM Filter v2.11.0 ni.piap.pl CA06E4435C4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=piap.pl; s=mail;
        t=1572346301; bh=k5T289OuUG6VXWcIiryuoMqmX23h/XJduJPMuCqgoOg=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=KZ14oEaCQzQoroOWAQHrUaDc1v7cetvPs+6k+L+Z5bv3NE0kS334kY5zO01YjYgvf
         L+nOcLqWocanrPNwzJp2x8D4mHfWLJ/8AdV/n0P3U1Y7XPk0x+kUucW2E0jIgN4A8C
         llNJLqB9f4pJF1nEgII9vfQMtQo4a4Yl98Op4rP8=
From:   khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] 802.11n IBSS: wlan0 stops receiving packets due to aggregation after sender reboot
References: <m34l02mh71.fsf@t19.piap.pl> <m37e4tjfbu.fsf@t19.piap.pl>
        <e5b07b4ce51f806ce79b1ae06ff3cbabbaa4873d.camel@sipsolutions.net>
        <m37e4orkxr.fsf@t19.piap.pl>
        <4725dcbd6297c74bf949671e7ad48eeeb0ceb0d0.camel@sipsolutions.net>
Date:   Tue, 29 Oct 2019 11:51:40 +0100
In-Reply-To: <4725dcbd6297c74bf949671e7ad48eeeb0ceb0d0.camel@sipsolutions.net>
        (Johannes Berg's message of "Tue, 29 Oct 2019 10:07:30 +0100")
Message-ID: <m336fbsu2r.fsf@t19.piap.pl>
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

>> The problem I can see is that the dialog_tokens are 8-bit, way too small
>> to eliminate conflicts.
>
> Well, they're also per station, we could just randomize the start and
> then we'd delete the old session and start a new one, on the receiver.
>
> So that would improve robustness somewhat (down to a 1/256 chance to hit
> this problem).

That was what I meant. Still, 1/256 seems hardly acceptable to me -
unless there is some work around (a short timeout or something similar).
Remember that when it doesn't work, it doesn't work - it won't recover
until the sequence catches up, which may mean basically forever.

Or, maybe the remote station can request de-aggregation first, so the
subsequent aggregation request is always treated as new?

Alternatively, perhaps the remote can signal that it's a new request and
not merely an existing session?

> That's the situation though - the local station needs to know that it
> has in fact *not* seen the same instance of the station, but that the
> station has reset and needs to be removed & re-added.

Precisely. And it seems to me that the first time the local station
learns of this is when a new, regular, non-aggregated packet arrives.
Or, when a new aggregation request arrives.
--=20
Krzysztof Halasa

=C5=81UKASIEWICZ Research Network
Industrial Research Institute for Automation and Measurements PIAP
Al. Jerozolimskie 202, 02-486 Warsaw, Poland
