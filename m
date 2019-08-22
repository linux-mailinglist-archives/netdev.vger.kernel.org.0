Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D76939977E
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 16:57:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388809AbfHVO4t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 10:56:49 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:52170 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388781AbfHVO4t (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Aug 2019 10:56:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=4JPJSIY9S1fkzRfiRD9aQSHXtVNaroFXg5NauMj8mqQ=; b=dCJLDYcVl8Xyc0A8v7/ryHva9C
        xDCr2ruP3htcyjmYmgGAPMCq7GJ/8QupG26ww9b/6Gw61gDwy0kuXrKHn8gofPeI3hmNLtP+QTo3a
        e+xuqythvurJALSFAw1l4nx6GzNg0BmG6q9btfp1UoPRNLiZkdTsDnDHRwJfoUg8c9To=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1i0oW5-0004wI-Az; Thu, 22 Aug 2019 16:56:45 +0200
Date:   Thu, 22 Aug 2019 16:56:45 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Hubert Feurstein <h.feurstein@gmail.com>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-spi@vger.kernel.org, netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH spi for-5.4 0/5] Deterministic SPI latency with NXP DSPI
 driver
Message-ID: <20190822145645.GJ13020@lunn.ch>
References: <20190818182600.3047-1-olteanv@gmail.com>
 <CA+h21hr4UcoJK7upNJjG0ibtX7CkF=akxVdrb--1AJn6-z=sUQ@mail.gmail.com>
 <20190821043845.GB1332@localhost>
 <20190821140815.GA1447@localhost>
 <CA+h21hrtzU1XL-0m+BG5TYZvVh8WN6hgcM7CV5taHyq2MsR5dw@mail.gmail.com>
 <20190822141641.GB1437@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190822141641.GB1437@localhost>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Thinking back...
> 
> One problem is this.  PTP requires a delay measurement.  You can send
> a delay request from the host, but there will never be a reply.
> 
> Another problem is this.  A Sync message arriving on an external port
> is time stamped there, but then it is encapsulated as a tagged DSA
> management message and delivered out the CPU port.  At this point, it
> is no longer a PTP frame and will not be time stamped at the CPU port
> on egress.

I think so that both the host interface and the CPU port recognize the
frame and time stamp it, it needs to be untagged. Otherwise, as you
said, the hardware does not recognise it. I've never tried sending
untagged frames to the CPU port. I expect they are just dropped.

However, somebody might want to play with the TCAM. The TCAM can
redirect a packet out any port. I've no idea what the pipeline
ordering is, but it might be possible for the TCAM to redirect a frame
back to the host interface, before it gets dropped because it does not
have DSA tags?  But is the TCAM before or after PTP in the pipeline?
Could you then get 4 timestamps for the same frame?  Host egress,
switch ingress, switch egress, host ingress?

But how do you make this generic? Can other switches also loop a frame
back like this and do the same time stamping? How do you actually get
access to these time stamps split over two blocks of hardware?

So in theory, this might be possible, but in practice?

     Andrew
