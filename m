Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B4DA48F765
	for <lists+netdev@lfdr.de>; Sat, 15 Jan 2022 16:14:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232893AbiAOPOk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jan 2022 10:14:40 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:39016 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231273AbiAOPOj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 15 Jan 2022 10:14:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=xGr08XPKwyFXRJKwn2VM5E/mdA9lmAdWUbfidSQCm68=; b=EiAyme0Hw6uiYWpJm8r6dJ2u7T
        W3VF/eqFGEFPRHw9NK/64laZLl7kPcfHRAbvHPtYEcWw/+mustkqRrpJzhL9pQPq8OUnkrBzmDQ8m
        oC10hnpw08SShXZcmoNaX+0mDrzZg5pVw+h/2wLujw8NIIz293feSr3w9VGbFK6iF1p0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1n8klJ-001UeQ-K3; Sat, 15 Jan 2022 16:14:37 +0100
Date:   Sat, 15 Jan 2022 16:14:37 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alex Elder <elder@linaro.org>
Cc:     Network Development <netdev@vger.kernel.org>,
        "bjorn.andersson@linaro.org" <bjorn.andersson@linaro.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: Port mirroring, v2 (RFC)
Message-ID: <YeLk3STfx2DO4+FO@lunn.ch>
References: <384e168b-8266-cb9b-196b-347a513c0d36@linaro.org>
 <e666e0cb-5b65-1fe9-61ae-a3a3cea54ea0@linaro.org>
 <9da2f1f6-fc7c-e131-400d-97ac3b8cdadc@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9da2f1f6-fc7c-e131-400d-97ac3b8cdadc@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Below I will describe two possible implementations I'm considering.
> I would like to know which approach makes the most sense (or if
> neither does, what alternative would be better).

Hi Alex

Another corner of the kernel you could look for inspiration is usbmon.

https://www.kernel.org/doc/html/latest/usb/usbmon.html

This is similar to your misc char device, but it is actually
implemented as a pseudo filesystem. It is intended for libpcap based
applications and i've used it with tcpdump and wireshark. So exactly
your use cases.

Because it is not a network device, the extra header does not cause
problems, and there is no confusion about what the 'monitoring' netdevs
are good for.

Since you are talking 5G and WiFi, you have a lot of packets
here. Being able to use BPF with libpcap is probably useful to allow
filtering of what packets are passed to user space. I've never looked
at how the BPF core is attached to a netdev. But i suspect your extra
header could be an issue. So you are going to need some custom code to
give it an offset into the packet to the Ethernet header?

Humm, actually, you called the IPA the IP accelerator. Are these L2
frames or L3 packets? Do you see 3 or even 4 MAC addresses in an
802.11 header? Two MAC addresses in an 802.3 header? etc.

       Andrew
