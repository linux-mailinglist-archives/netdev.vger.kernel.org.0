Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D57731C073E
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 22:02:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726809AbgD3UB5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 16:01:57 -0400
Received: from ssl.serverraum.org ([176.9.125.105]:57147 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726272AbgD3UB4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 16:01:56 -0400
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 6E77822F43;
        Thu, 30 Apr 2020 22:01:55 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1588276915;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PWLKlvKK1yCDDWOFAZ3AMP0GNuGDzxMnHduleOdmvhs=;
        b=WOrKmCcWvz5Zw/C1WUK63aWUV7sIUWPRpmFx3XYJR2Z/aLNLvoJla4iQ89eYSHah4YUvT0
        drVM3OSGQOCMbW7isz9SNLcT2y/UojOolqC40xD32hcMEtA5ZVPA5KJZ2F2y6+cKOM+Sp/
        BGIftrvydxv4JzlbgYjoeBfou9Xqybw=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 30 Apr 2020 22:01:55 +0200
From:   Michael Walle <michael@walle.cc>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, cphealy@gmail.com,
        davem@davemloft.net, hkallweit1@gmail.com, mkubecek@suse.cz,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v1 0/9] Ethernet Cable test support
In-Reply-To: <20200430194143.GF107658@lunn.ch>
References: <20200425180621.1140452-1-andrew@lunn.ch>
 <20200429160213.21777-1-michael@walle.cc> <20200429163247.GC66424@lunn.ch>
 <c4363f2888192efc692e08cc1a4a9a57@walle.cc>
 <61eb35f8-3264-117d-59c2-22f0fdc36e96@gmail.com>
 <9caef9bbfaed5c75e72e083db8a552fd@walle.cc>
 <20200430194143.GF107658@lunn.ch>
Message-ID: <4cae330197a5bdd1559dcea3482f0732@walle.cc>
X-Sender: michael@walle.cc
User-Agent: Roundcube Webmail/1.3.10
X-Spamd-Bar: +
X-Spam-Level: *
X-Rspamd-Server: web
X-Spam-Status: No, score=1.40
X-Spam-Score: 1.40
X-Rspamd-Queue-Id: 6E77822F43
X-Spamd-Result: default: False [1.40 / 15.00];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         FREEMAIL_ENVRCPT(0.00)[gmail.com];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         TAGGED_RCPT(0.00)[];
         MIME_GOOD(-0.10)[text/plain];
         DKIM_SIGNED(0.00)[];
         RCPT_COUNT_SEVEN(0.00)[7];
         RCVD_COUNT_ZERO(0.00)[0];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         FREEMAIL_CC(0.00)[gmail.com,davemloft.net,suse.cz,vger.kernel.org];
         MID_RHS_MATCH_FROM(0.00)[];
         SUSPICIOUS_RECIPS(1.50)[]
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2020-04-30 21:41, schrieb Andrew Lunn:
>> ECD. The registers looks exactly like the one from the Marvell PHYs,
>> which makes me wonder if both have the same building block or if one
>> imitated the registers of the other. There are subtle differences
>> like one bit in the broadcom PHY is "break link" and is self-clearing,
>> while the bit on the Marvell PHY is described as "perform diagnostics
>> on link break".
> 
> Should we be sharing code between the two drivers?

If they are indeed the same sure, but it doesn't look like that the
marvell procedure works for the broadcom PHY.

>> What do you mean by calibrate it?
> 
> Some of the Marvell documentation talks about calibrating for losses
> on the PCB. Run a diagnostics with no cable plugged in, and get the
> cable length to the 'fault'. This gives you the distance to the RJ45
> socket. You should then subtract that from all subsequent results.
> But since this is board design specific, i decided to ignore it. I
> suppose it could be stuffed into a DT property, but i got the feeling
> it is not worth it, given the measurement granularity of 80cm.

Oh so, the time delta counter of the Marvell PHY also runs at 125MHz? ;)

        /* Accoring to the datasheet the distance to the fault is
         * DELTA_TIME * 0.824 meters.
         *
         * The author suspect the correct formula is:
         *  distance in meters = (c * VF) / (2 * 125MHz)
         * where c is the speed of light, VF is the velocity factor of
         * the twisted pair cable, 125MHz the counter frequency and
         * the factor 2 because the hardware will measure the round
         * trip time.
         * With a VF of 0.69 we get the factor 0.824 mentioned in the
         * datasheet.
         */


-michael
