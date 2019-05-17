Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE62A21BB1
	for <lists+netdev@lfdr.de>; Fri, 17 May 2019 18:36:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726901AbfEQQgv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 May 2019 12:36:51 -0400
Received: from alln-iport-6.cisco.com ([173.37.142.93]:22096 "EHLO
        alln-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725932AbfEQQgv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 May 2019 12:36:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=4235; q=dns/txt; s=iport;
  t=1558111011; x=1559320611;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=MRsfiVUXzKrb3WUopDCNh+ul+4ofhNdmm2stHa5/lDY=;
  b=i50W31UvbkmiKJUAjsRVRV87pCW7QhfHOW9+ehjKKGXFQtOZyHH3u3Kr
   etqH9d+pujggwDN5tK4sKKrq7+s0uaRWOnZck8Yq9edlMmq9nQH9sgOMO
   eD8vhfkl6J/L+I2s57DyqZkXRiCRKGPO4M78EcOj3nYUliukMpyzRCFv+
   g=;
X-IronPort-AV: E=Sophos;i="5.60,480,1549929600"; 
   d="scan'208";a="277494728"
Received: from alln-core-7.cisco.com ([173.36.13.140])
  by alln-iport-6.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 17 May 2019 16:36:51 +0000
Received: from zorba ([10.24.25.58])
        by alln-core-7.cisco.com (8.15.2/8.15.2) with ESMTPS id x4HGamkm004388
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Fri, 17 May 2019 16:36:50 GMT
Date:   Fri, 17 May 2019 09:36:43 -0700
From:   Daniel Walker <danielwa@cisco.com>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        "Nikunj Kela (nkela)" <nkela@cisco.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "xe-linux-external(mailer list)" <xe-linux-external@cisco.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [Intel-wired-lan] [PATCH] igb: add parameter to ignore nvm
 checksum validation
Message-ID: <20190517163643.7tlch7xqplxohoq7@zorba>
References: <1557357269-9498-1-git-send-email-nkela@cisco.com>
 <9be117dc6e818ab83376cd8e0f79dbfaaf193aa9.camel@intel.com>
 <76B41175-0CEE-466C-91BF-89A1CA857061@cisco.com>
 <4469196a-0705-5459-8aca-3f08e9889d61@gmail.com>
 <20190517010330.2wynopuhsqycqzuq@zorba>
 <bd9e6a93-c8e8-a90e-25b0-26ccbf65b7c4@gmail.com>
 <CAKgT0Uev7sfpOOhusAg9jFLkFeE9JtTntyTd0aAHz2db69L13g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKgT0Uev7sfpOOhusAg9jFLkFeE9JtTntyTd0aAHz2db69L13g@mail.gmail.com>
User-Agent: NeoMutt/20170609 (1.8.3)
X-Auto-Response-Suppress: DR, OOF, AutoReply
X-Outbound-SMTP-Client: 10.24.25.58, [10.24.25.58]
X-Outbound-Node: alln-core-7.cisco.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 17, 2019 at 08:16:34AM -0700, Alexander Duyck wrote:
> On Thu, May 16, 2019 at 6:48 PM Florian Fainelli <f.fainelli@gmail.com> wrote:
> >
> >
> >
> > On 5/16/2019 6:03 PM, Daniel Walker wrote:
> > > On Thu, May 16, 2019 at 03:02:18PM -0700, Florian Fainelli wrote:
> > >> On 5/16/19 12:55 PM, Nikunj Kela (nkela) wrote:
> > >>>
> > >>>
> > >>> On 5/16/19, 12:35 PM, "Jeff Kirsher" <jeffrey.t.kirsher@intel.com> wrote:
> > >>>
> > >>>     On Wed, 2019-05-08 at 23:14 +0000, Nikunj Kela wrote:
> > >>>    >> Some of the broken NICs don't have EEPROM programmed correctly. It
> > >>>    >> results
> > >>>    >> in probe to fail. This change adds a module parameter that can be
> > >>>    >> used to
> > >>>    >> ignore nvm checksum validation.
> > >>>    >>
> > >>>    >> Cc: xe-linux-external@cisco.com
> > >>>    >> Signed-off-by: Nikunj Kela <nkela@cisco.com>
> > >>>    >> ---
> > >>>    >>  drivers/net/ethernet/intel/igb/igb_main.c | 28
> > >>>    >> ++++++++++++++++++++++------
> > >>>    >>  1 file changed, 22 insertions(+), 6 deletions(-)
> > >>>
> > >>>     >NAK for two reasons.  First, module parameters are not desirable
> > >>>     >because their individual to one driver and a global solution should be
> > >>>     >found so that all networking device drivers can use the solution.  This
> > >>>     >will keep the interface to change/setup/modify networking drivers
> > >>>     >consistent for all drivers.
> > >>>
> > >>>
> > >>>     >Second and more importantly, if your NIC is broken, fix it.  Do not try
> > >>>     >and create a software workaround so that you can continue to use a
> > >>>     >broken NIC.  There are methods/tools available to properly reprogram
> > >>>     >the EEPROM on a NIC, which is the right solution for your issue.
> > >>>
> > >>> I am proposing this as a debug parameter. Obviously, we need to fix EEPROM but this helps us continuing the development while manufacturing fixes NIC.
> > >>
> > >> Then why even bother with sending this upstream?
> > >
> > > It seems rather drastic to disable the entire driver because the checksum
> > > doesn't match. It really should be a warning, even a big warning, to let people
> > > know something is wrong, but disabling the whole driver doesn't make sense.
> >
> > You could generate a random Ethernet MAC address if you don't have a
> > valid one, a lot of drivers do that, and that's a fairly reasonable
> > behavior. At some point in your product development someone will
> > certainly verify that the provisioned MAC address matches the network
> > interface's MAC address.
> > --
> > Florian
> 
> The thing is the EEPROM contains much more than just the MAC address.
> There ends up being configuration for some of the PCIe interface in
> the hardware as well as PHY configuration. If that is somehow mangled
> we shouldn't be bringing up the part because there are one or more
> pieces of the device configuration that are likely wrong.
> 
> The checksum is being used to make sure the EEPROM is valid, without
> that we would need to go through and validate each individual section
> of the EEPROM before enabling the the portions of the device related
> to it. The concern is that this will become a slippery slope where we
> eventually have to code all the configuration of the EEPROM into the
> driver itself.
 

I don't think you can say because the checksum is valid that all data contained
inside is also valid. You can have a valid checksum , and someone screwed up the
data prior to the checksum getting computed.


> We need to make the checksum a hard stop. If the part is broken then
> it needs to be addressed. Workarounds just end up being used and
> forgotten, which makes it that much harder to support the product.
> Better to mark the part as being broken, and get it fixed now, than to
> have parts start shipping that require workarounds in order to
> function.o

I don't think it's realistic to define the development process for large
corporations like Cisco, or like what your doing , to define the development
process for all corporations and products which may use intel parts. It's better
to be flexible.

Daniel
