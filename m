Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15EDB16F410
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 01:07:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729379AbgBZAHb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 19:07:31 -0500
Received: from ssl.serverraum.org ([176.9.125.105]:33905 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729109AbgBZAHb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 19:07:31 -0500
Received: from [IPv6:2a02:810c:c200:2e91:7951:d18b:d929:3d06] (unknown [IPv6:2a02:810c:c200:2e91:7951:d18b:d929:3d06])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id E87B322FE5;
        Wed, 26 Feb 2020 01:07:27 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1582675648;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I1Ufd+2Ua1U1WJuN/kF2qgL25Y9aNipnoSIbHw5lIjo=;
        b=LzFHury67GW4beCNPb/DHJ5q90nsoeqaphdoMVHKmVIgMSeEJ+MSpfwMT0664Am48PH/4Q
        wKC6fMXQ8JJKD4GT8byLJOPygjfvaMTWAXQmeaDCFtwBQXx4s+ytnwrFO9lRPoZEiknArJ
        KnqtJmaNjImHhr3Wq58P3MiYtI17GUo=
Date:   Wed, 26 Feb 2020 01:07:26 +0100
User-Agent: K-9 Mail for Android
In-Reply-To: <20200225235040.GF9749@lunn.ch>
References: <20200225230819.7325-1-michael@walle.cc> <20200225235040.GF9749@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [RFC PATCH 0/2] AT8031 PHY timestamping support
To:     Andrew Lunn <andrew@lunn.ch>
CC:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>
From:   Michael Walle <michael@walle.cc>
Message-ID: <9955C44A-8105-4087-8555-BAC5AE4AF25D@walle.cc>
X-Spamd-Bar: +
X-Spam-Level: *
X-Rspamd-Server: web
X-Spam-Status: No, score=1.40
X-Spam-Score: 1.40
X-Rspamd-Queue-Id: E87B322FE5
X-Spamd-Result: default: False [1.40 / 15.00];
         MID_RHS_MATCH_FROM(0.00)[];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         FREEMAIL_ENVRCPT(0.00)[gmail.com];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         TAGGED_RCPT(0.00)[];
         MIME_GOOD(-0.10)[text/plain];
         DKIM_SIGNED(0.00)[];
         RCPT_COUNT_SEVEN(0.00)[8];
         NEURAL_HAM(-0.00)[-0.432];
         RCVD_COUNT_ZERO(0.00)[0];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         ASN(0.00)[asn:31334, ipnet:2a02:810c::/31, country:DE];
         FREEMAIL_CC(0.00)[vger.kernel.org,gmail.com,armlinux.org.uk,davemloft.net];
         SUSPICIOUS_RECIPS(1.50)[]
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 26=2E Februar 2020 00:50:40 MEZ schrieb Andrew Lunn <andrew@lunn=2Ech>:
>On Wed, Feb 26, 2020 at 12:08:17AM +0100, Michael Walle wrote:
>> This patchset is the current state of my work for adding PHY
>timestamping
>> support=2E I just wanted to post this to the mailinglist before I never
>do
>> it=2E Maybe its a starting point for other people=2E That being said, I
>> wouldn't mind comments ;) The code basically works but there are
>three
>> major caveats:
>>=20
>>  (1) The reading of timestamps via MDIO sometimes return wrong
>values=2E What
>>      I see is that a part of the timestamp corresponds to the new
>timestamp
>> 	 while another part still contains old values=2E Thus at the moment,
>I'm
>> 	 reading the registers twice=2E I don't know if the reading actually
>> 	 affects the update of the timestamp or the different timing (my
>MDIO
>> 	 bus is rather slow, so reading the timestamp a second time take
>some
>> 	 amount of time; but I've also tested with some delays and it didn't
>> 	 had any effects)=2E There is also no possibility to read the
>timestamp
>> 	 atomically :(
>
>Hi Michael
>
>That sounds fundamentally broken=2E Which would be odd=2E Sometimes there
>is a way to take a snapshot of the value=2E Reading the first word could
>trigger this snapshot=2E Or the last word, or some status register=2E One
>would hope the datasheet would talk about this=2E

Hi Andrew

This might be the case, but the datasheet (some older revision can be foun=
d on the internet, maybe you find something) doesn't mention it=2E Nor does=
 the PTP "guide" (I don't know the exact name, I'd have to check at work) o=
f this PHY=2E Besides the timestamp there's also the sequence number and th=
e source port id which would need to be read atomically together with the t=
imestamp=2E=20

I might give it a try reading the whole tx or rx block (sequenceId, source=
PortId, timestamp) sequentially=2E=20

-michael

