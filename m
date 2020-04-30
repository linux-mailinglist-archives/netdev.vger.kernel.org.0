Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 114221C0429
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 19:48:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726380AbgD3RsR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 13:48:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726285AbgD3RsR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 13:48:17 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8687C035494
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 10:48:16 -0700 (PDT)
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 30FA422F43;
        Thu, 30 Apr 2020 19:48:13 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1588268894;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JuW5UAYoNPzsFHWib5oi9JBwlDANMV54A3WbLhXj/MY=;
        b=kQtiqNakQmr4mOYsvyb7PXLUxEfeTRQXzIK/R3tim/i4u2Ua0UzvehFZUVBOMVSZlcaVEp
        26yO/CMCtBD0+4oluTfBDR78nE7l+MAGDkp02MnF86f/OjYk3F1HtSczyOdO8/blf/uZ6/
        lg9PL/SlnX0NtIfWycThhbBEs+/gte8=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 30 Apr 2020 19:48:13 +0200
From:   Michael Walle <michael@walle.cc>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     cphealy@gmail.com, davem@davemloft.net, f.fainelli@gmail.com,
        hkallweit1@gmail.com, mkubecek@suse.cz, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v1 0/9] Ethernet Cable test support
In-Reply-To: <20200429163247.GC66424@lunn.ch>
References: <20200425180621.1140452-1-andrew@lunn.ch>
 <20200429160213.21777-1-michael@walle.cc> <20200429163247.GC66424@lunn.ch>
Message-ID: <c4363f2888192efc692e08cc1a4a9a57@walle.cc>
X-Sender: michael@walle.cc
User-Agent: Roundcube Webmail/1.3.10
X-Spamd-Bar: +
X-Spam-Level: *
X-Rspamd-Server: web
X-Spam-Status: No, score=1.40
X-Spam-Score: 1.40
X-Rspamd-Queue-Id: 30FA422F43
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

Hi Andrew,

Am 2020-04-29 18:32, schrieb Andrew Lunn:
> On Wed, Apr 29, 2020 at 06:02:13PM +0200, Michael Walle wrote:
>> Hi Andrew,
>> 
>> > Add infrastructure in ethtool and phylib support for triggering a
>> > cable test and reporting the results. The Marvell 1G PHY driver is
>> > then extended to make use of this infrastructure.
>> 
>> I'm currently trying this with the AR8031 PHY. With this PHY, you
>> have to select the pair which you want to start the test on. So
>> you'd have to start the test four times in a row for a normal
>> gigabit cable. Right now, I don't see a way how to do that
>> efficiently if there is no interrupt. One could start another test
>> in the get_status() polling if the former was completed
>> successfully. But then you'd have to wait at least four polling
>> intervals to get the final result (given a cable with four pairs).
>> 
>> Any other ideas?
> 
> Hi Michael
> 
> Nice to see some more PHYs getting support for this.
> 
> It is important that the start function returns quickly. However, the
> get status function can block. So you could do all the work in the
> first call to get status, polling for completion at a faster rate,
> etc.

Ok. I do have one problem. TDR works fine for the AR8031 and the
BCM54140 as long as there is no link partner, i.e. open cable,
shorted pairs etc. But as soon as there is a link partner and a
link, both PHYs return garbage. As far as I understand TDR, there
must not be a link, correct? The link partner may send data or
link pulses. No how do you silence the local NIC or even the peer?

-michael
