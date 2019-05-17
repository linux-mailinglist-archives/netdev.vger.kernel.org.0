Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 352202119F
	for <lists+netdev@lfdr.de>; Fri, 17 May 2019 03:10:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726454AbfEQBKm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 21:10:42 -0400
Received: from alln-iport-3.cisco.com ([173.37.142.90]:29054 "EHLO
        alln-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725929AbfEQBKl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 May 2019 21:10:41 -0400
X-Greylist: delayed 427 seconds by postgrey-1.27 at vger.kernel.org; Thu, 16 May 2019 21:10:40 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=1954; q=dns/txt; s=iport;
  t=1558055440; x=1559265040;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=CdtFlPdIxBflewxo8eZNJ3cZUeGIx4ZiQQJbr+jUzY4=;
  b=MceW4XnmB1ay+HdRTwqFEDWmfPqAWu2W2AyGtD1iK893bX8AwH1WyEUf
   P6h9GSmP6+tvlpm4Lpve/frfOI9eLsX1ETBOU9T9f1jyQuybz0R1lH6J8
   GGBPt6DTLRTetgAc25jTB54Hs496j00hguRi4pR0+LK7J2Ko/swGF2SYC
   Q=;
X-IronPort-AV: E=Sophos;i="5.60,477,1549929600"; 
   d="scan'208";a="277980231"
Received: from alln-core-11.cisco.com ([173.36.13.133])
  by alln-iport-3.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 17 May 2019 01:03:33 +0000
Received: from zorba ([10.24.21.190])
        by alln-core-11.cisco.com (8.15.2/8.15.2) with ESMTPS id x4H13VMX014537
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Fri, 17 May 2019 01:03:32 GMT
Date:   Thu, 16 May 2019 18:03:30 -0700
From:   Daniel Walker <danielwa@cisco.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     "Nikunj Kela (nkela)" <nkela@cisco.com>,
        "jeffrey.t.kirsher@intel.com" <jeffrey.t.kirsher@intel.com>,
        "xe-linux-external(mailer list)" <xe-linux-external@cisco.com>,
        "David S. Miller" <davem@davemloft.net>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] igb: add parameter to ignore nvm checksum validation
Message-ID: <20190517010330.2wynopuhsqycqzuq@zorba>
References: <1557357269-9498-1-git-send-email-nkela@cisco.com>
 <9be117dc6e818ab83376cd8e0f79dbfaaf193aa9.camel@intel.com>
 <76B41175-0CEE-466C-91BF-89A1CA857061@cisco.com>
 <4469196a-0705-5459-8aca-3f08e9889d61@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4469196a-0705-5459-8aca-3f08e9889d61@gmail.com>
User-Agent: NeoMutt/20170609 (1.8.3)
X-Auto-Response-Suppress: DR, OOF, AutoReply
X-Outbound-SMTP-Client: 10.24.21.190, [10.24.21.190]
X-Outbound-Node: alln-core-11.cisco.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 16, 2019 at 03:02:18PM -0700, Florian Fainelli wrote:
> On 5/16/19 12:55 PM, Nikunj Kela (nkela) wrote:
> > 
> > 
> > On 5/16/19, 12:35 PM, "Jeff Kirsher" <jeffrey.t.kirsher@intel.com> wrote:
> > 
> >     On Wed, 2019-05-08 at 23:14 +0000, Nikunj Kela wrote:
> >    >> Some of the broken NICs don't have EEPROM programmed correctly. It
> >    >> results
> >    >> in probe to fail. This change adds a module parameter that can be
> >    >> used to
> >    >> ignore nvm checksum validation.
> >    >> 
> >    >> Cc: xe-linux-external@cisco.com
> >    >> Signed-off-by: Nikunj Kela <nkela@cisco.com>
> >    >> ---
> >    >>  drivers/net/ethernet/intel/igb/igb_main.c | 28
> >    >> ++++++++++++++++++++++------
> >    >>  1 file changed, 22 insertions(+), 6 deletions(-)
> >     
> >     >NAK for two reasons.  First, module parameters are not desirable
> >     >because their individual to one driver and a global solution should be
> >     >found so that all networking device drivers can use the solution.  This
> >     >will keep the interface to change/setup/modify networking drivers
> >     >consistent for all drivers.
> > 
> >     
> >     >Second and more importantly, if your NIC is broken, fix it.  Do not try
> >     >and create a software workaround so that you can continue to use a
> >     >broken NIC.  There are methods/tools available to properly reprogram
> >     >the EEPROM on a NIC, which is the right solution for your issue.
> > 
> > I am proposing this as a debug parameter. Obviously, we need to fix EEPROM but this helps us continuing the development while manufacturing fixes NIC.
> 
> Then why even bother with sending this upstream?

It seems rather drastic to disable the entire driver because the checksum
doesn't match. It really should be a warning, even a big warning, to let people
know something is wrong, but disabling the whole driver doesn't make sense.

Daniel
