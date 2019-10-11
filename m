Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 944A1D49E2
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 23:29:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728547AbfJKV3X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 17:29:23 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:58605 "EHLO
        smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726255AbfJKV3X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 17:29:23 -0400
Received: from cpe-2606-a000-111b-43ee-0-0-0-115f.dyn6.twc.com ([2606:a000:111b:43ee::115f] helo=localhost)
        by smtp.tuxdriver.com with esmtpsa (TLSv1:AES256-SHA:256)
        (Exim 4.63)
        (envelope-from <nhorman@tuxdriver.com>)
        id 1iJ2TF-00034Z-9e; Fri, 11 Oct 2019 17:29:16 -0400
Date:   Fri, 11 Oct 2019 17:29:04 -0400
From:   Neil Horman <nhorman@tuxdriver.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     David Laight <David.Laight@aculab.com>,
        network dev <netdev@vger.kernel.org>,
        "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCHv2 net-next 3/5] sctp: add
 SCTP_EXPOSE_POTENTIALLY_FAILED_STATE sockopt
Message-ID: <20191011212904.GB16269@hmswarspite.think-freely.org>
References: <cover.1570533716.git.lucien.xin@gmail.com>
 <066605f2269d5d92bc3fefebf33c6943579d8764.1570533716.git.lucien.xin@gmail.com>
 <60a7f76bd5f743dd8d057b32a4456ebd@AcuMS.aculab.com>
 <CADvbK_cFCuHAwxGAdY0BevrrAd6pQRP2tW_ej9mM3G4Aog3qpg@mail.gmail.com>
 <20191009161508.GB25555@hmswarspite.think-freely.org>
 <CADvbK_eJh0ghjrrqcx7mygEY94QsxxbV=om8BqWPEcXxUHFmHw@mail.gmail.com>
 <20191010124045.GA29895@hmswarspite.think-freely.org>
 <CADvbK_d-djw00DBTmu7XCpxrfNvCF-xksWT9gV_VP_-zLv=NkA@mail.gmail.com>
 <CADvbK_eZcNd8Xy-q5SWS2CzD1SdMqzU05_mGkmh5-iLtOdRCCw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADvbK_eZcNd8Xy-q5SWS2CzD1SdMqzU05_mGkmh5-iLtOdRCCw@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Spam-Score: -2.9 (--)
X-Spam-Status: No
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 12, 2019 at 12:25:27AM +0800, Xin Long wrote:
> On Fri, Oct 11, 2019 at 11:57 PM Xin Long <lucien.xin@gmail.com> wrote:
> >
> > On Thu, Oct 10, 2019 at 8:40 PM Neil Horman <nhorman@tuxdriver.com> wrote:
> > >
> > > On Thu, Oct 10, 2019 at 05:28:34PM +0800, Xin Long wrote:
> > > > On Thu, Oct 10, 2019 at 12:18 AM Neil Horman <nhorman@tuxdriver.com> wrote:
> > > > >
> > > > > On Tue, Oct 08, 2019 at 11:28:32PM +0800, Xin Long wrote:
> > > > > > On Tue, Oct 8, 2019 at 9:02 PM David Laight <David.Laight@aculab.com> wrote:
> > > > > > >
> > > > > > > From: Xin Long
> > > > > > > > Sent: 08 October 2019 12:25
> > > > > > > >
> > > > > > > > This is a sockopt defined in section 7.3 of rfc7829: "Exposing
> > > > > > > > the Potentially Failed Path State", by which users can change
> > > > > > > > pf_expose per sock and asoc.
> > > > > > >
> > > > > > > If I read these patches correctly the default for this sockopt in 'enabled'.
> > > > > > > Doesn't this mean that old application binaries will receive notifications
> > > > > > > that they aren't expecting?
> > > > > > >
> > > > > > > I'd have thought that applications would be required to enable it.
> > > > > > If we do that, sctp_getsockopt_peer_addr_info() in patch 2/5 breaks.
> > > > > >
> > > > > I don't think we can safely do either of these things.  Older
> > > > > applications still need to behave as they did prior to the introduction
> > > > > of this notification, and we shouldn't allow unexpected notifications to
> > > > > be sent.
> > > > >
> > > > > What if you added a check in get_peer_addr_info to only return -EACCESS
> > > > > if pf_expose is 0 and the application isn't subscribed to the PF event?
> > > > We can't subscribe to PF event only, but all the SCTP_PEER_ADDR_CHANGE
> > > > events.
> > > >
> > > > Now I'm thinking both PF event and "return -EACCES" in get_peer_addr_info
> > > > are new, we should give 'expose' a default value that would disable both.
> > > > How do think if we set 'pf_expose = -1' by default. We send the pf event
> > > > only if (asoc->pf_expose > 0) in sctp_assoc_control_transport().
> > > >
> > > And if pf_expose = 0, we send the event, and return -EACCESS if we call
> > > the socket option and find a PF assoc?  If so, yes, I think that makes
> > > sense.
> > pf_expose:
> > -1: compatible with old application (by default)
> > 0: not expose PF to user
> > 1: expose PF to user
> >
> > So it should be:
> > if pf_expose == -1:  not send event, not return -EACCESS
> > if pf_expose == 0: not send event, return -EACCESS
> > if pf_expose > 0: sent event, not return -EACCESS
> >
> > makes sense?
> Oh, sorry, pf_expose is 1 bit only now in asoc/ep.
> Maybe we should use 2 bits, and values could be:
> 2: compatible with old application (by default)
> 0: not expose PF to user
> 1: expose PF to user
> 
Yes, this version makes sense to me
Best
Neil

> >
> > >
> > > Neil
> > >
> > > > >
> > > > > Neil
> > > > >
> > > > > > >
> > > > > > >         David
> > > > > > >
> > > > > > > -
> > > > > > > Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> > > > > > > Registration No: 1397386 (Wales)
> > > > > > >
> > > > > >
> > > >
> 
