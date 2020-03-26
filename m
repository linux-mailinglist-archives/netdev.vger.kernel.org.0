Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 769CD1946C7
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 19:49:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbgCZStj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 14:49:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:44688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725994AbgCZSti (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Mar 2020 14:49:38 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 97C7520714;
        Thu, 26 Mar 2020 18:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585248578;
        bh=fQSeaG7HJEhFR28TdvJvvUxw8rg/7HSJEcZM+/90BtA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HTGIeHxj+ZaPCId/iRC7ZiHRb+5CKhR2cPJ33TnPVlOSynA00Z7VJZ8xOVS+e9BCU
         UXqt1IbkpZEpug1D/RNO378HZ4VBmk051EeYNrg0jCeQqFdeUPyfgKtTuPzCA/cfqk
         PDDDEk1aq1sLEqt3ptttInmxnyEJoxn5akggKkfI=
Date:   Thu, 26 Mar 2020 11:49:35 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Ido Schimmel <idosch@idosch.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        murali.policharla@broadcom.com,
        Stephen Hemminger <stephen@networkplumber.org>,
        Jiri Pirko <jiri@resnulli.us>, netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 net-next 10/10] net: bridge: implement
 auto-normalization of MTU for hardware datapath
Message-ID: <20200326114935.22885985@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <e68cbeb2-f8db-319c-9c4c-32eb3b91a7b9@cumulusnetworks.com>
References: <20200325152209.3428-1-olteanv@gmail.com>
        <20200325152209.3428-11-olteanv@gmail.com>
        <20200326101752.GA1362955@splinter>
        <CA+h21hq2K__kY9Pi4-23x7aA+4TPXAV4evfi1tR=0bZRcZDiQA@mail.gmail.com>
        <20200326113542.GA1383155@splinter>
        <83375385-7881-53b7-c685-e166c8bdeba4@cumulusnetworks.com>
        <CA+h21hoYUqWxVTHKixOKvtOebjC84AxcjoiDHXK75n+TpTL3Mw@mail.gmail.com>
        <25bc3bf2-0dea-5667-8aae-c57a2a693bec@cumulusnetworks.com>
        <CA+h21hp3LWA79WwAGhrL_SiaqZ=81=1P6HVO2a3WeLjcaTFgAg@mail.gmail.com>
        <e68cbeb2-f8db-319c-9c4c-32eb3b91a7b9@cumulusnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 26 Mar 2020 14:38:57 +0200 Nikolay Aleksandrov wrote:
> On 26/03/2020 14:25, Vladimir Oltean wrote:
> > On Thu, 26 Mar 2020 at 14:19, Nikolay Aleksandrov
> > <nikolay@cumulusnetworks.com> wrote:  
> >>
> >> On 26/03/2020 14:18, Vladimir Oltean wrote:  
> >>> On Thu, 26 Mar 2020 at 14:06, Nikolay Aleksandrov
> >>> <nikolay@cumulusnetworks.com> wrote:  
> >>>>
> >>>> On 26/03/2020 13:35, Ido Schimmel wrote:  
> >>>>> On Thu, Mar 26, 2020 at 12:25:20PM +0200, Vladimir Oltean wrote:  
> >>>>>> Hi Ido,
> >>>>>>
> >>>>>> On Thu, 26 Mar 2020 at 12:17, Ido Schimmel <idosch@idosch.org> wrote:  
> >>>>>>>  
> >>> [snip]  
> >>>>>
> >>>>> I think you should be more explicit about it. Did you consider listening
> >>>>> to 'NETDEV_PRECHANGEMTU' notifications in relevant drivers and vetoing
> >>>>> unsupported configurations with an appropriate extack message? If you
> >>>>> can't veto (in order not to break user space), you can still emit an
> >>>>> extack message.
> >>>>>  
> >>>>
> >>>> +1, this sounds more appropriate IMO
> >>>>  
> >>>
> >>> And what does vetoing gain me exactly? The practical inability to
> >>> change the MTU of any interface that is already bridged and applies
> >>> length check on RX?
> >>>  
> >>
> >> I was referring to moving the logic to NETDEV_PRECHANGEMTU, the rest is up to you.
> >>  
> > 
> > If I'm not going to veto, then I don't see a lot of sense in listening
> > on this particular notifier either. I can do the normalization just
> > fine on NETDEV_CHANGEMTU.
> 
> I should've been more explicit - I meant I agree that this change doesn't belong in
> the bridge, and handling it in a notifier in the driver seems like a better place.
> Yes - if it's not going to be a vetto, then CHANGEMTU is fine.

I'm not sure pushing behavior decisions like that out to the drivers 
is ever a good idea. Linux should abstract HW differences after all,
we don't want different drivers to perform different magic behind
user's back. 

I'd think if HW is unable to apply given configuration vetoing is both
correct and expected..
