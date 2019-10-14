Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AFB0D62D3
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 14:42:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730931AbfJNMl7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 08:41:59 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42133 "EHLO
        smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730908AbfJNMl7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Oct 2019 08:41:59 -0400
Received: from cpe-2606-a000-111b-43ee-0-0-0-115f.dyn6.twc.com ([2606:a000:111b:43ee::115f] helo=localhost)
        by smtp.tuxdriver.com with esmtpsa (TLSv1:AES256-SHA:256)
        (Exim 4.63)
        (envelope-from <nhorman@tuxdriver.com>)
        id 1iJzfY-0004xT-1o; Mon, 14 Oct 2019 08:41:55 -0400
Date:   Mon, 14 Oct 2019 08:41:43 -0400
From:   Neil Horman <nhorman@tuxdriver.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     David Laight <David.Laight@aculab.com>,
        network dev <netdev@vger.kernel.org>,
        "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCHv2 net-next 3/5] sctp: add
 SCTP_EXPOSE_POTENTIALLY_FAILED_STATE sockopt
Message-ID: <20191014124143.GA11844@hmswarspite.think-freely.org>
References: <cover.1570533716.git.lucien.xin@gmail.com>
 <066605f2269d5d92bc3fefebf33c6943579d8764.1570533716.git.lucien.xin@gmail.com>
 <60a7f76bd5f743dd8d057b32a4456ebd@AcuMS.aculab.com>
 <CADvbK_cFCuHAwxGAdY0BevrrAd6pQRP2tW_ej9mM3G4Aog3qpg@mail.gmail.com>
 <20191009161508.GB25555@hmswarspite.think-freely.org>
 <CADvbK_fb9jjm-h-XyVci971Uu=YuwMsUjWEcv9ehUv9Q6W_VxQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADvbK_fb9jjm-h-XyVci971Uu=YuwMsUjWEcv9ehUv9Q6W_VxQ@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Spam-Score: -2.9 (--)
X-Spam-Status: No
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 14, 2019 at 04:36:34PM +0800, Xin Long wrote:
> On Thu, Oct 10, 2019 at 12:18 AM Neil Horman <nhorman@tuxdriver.com> wrote:
> >
> > On Tue, Oct 08, 2019 at 11:28:32PM +0800, Xin Long wrote:
> > > On Tue, Oct 8, 2019 at 9:02 PM David Laight <David.Laight@aculab.com> wrote:
> > > >
> > > > From: Xin Long
> > > > > Sent: 08 October 2019 12:25
> > > > >
> > > > > This is a sockopt defined in section 7.3 of rfc7829: "Exposing
> > > > > the Potentially Failed Path State", by which users can change
> > > > > pf_expose per sock and asoc.
> > > >
> > > > If I read these patches correctly the default for this sockopt in 'enabled'.
> > > > Doesn't this mean that old application binaries will receive notifications
> > > > that they aren't expecting?
> > > >
> > > > I'd have thought that applications would be required to enable it.
> > > If we do that, sctp_getsockopt_peer_addr_info() in patch 2/5 breaks.
> > >
> > I don't think we can safely do either of these things.  Older
> > applications still need to behave as they did prior to the introduction
> > of this notification, and we shouldn't allow unexpected notifications to
> > be sent.
> Hi, Neil
> 
> I think about again, and also talked with QE, we think to get unexpected
> notifications shouldn't be a problem for user's applications.
> 
On principle, I disagree.  Regardless of what the RFC does, we shouldn't
send notifications that an application aren't subscribed to.  Just
because QE doesn't think it should be a problem (and for their uses it
may well not be an issue), we can't make that general assumption.

> RFC actually keeps adding new notifications, and a user shouldn't expect
> the specific notifications coming in some exact orders. They should just
> ignore it and wait until the ones they expect. I don't think some users
> would abort its application when getting an unexpected notification.
> 
To make that assertion is to discount the purpose of the SCTP_EVENTS
sockopt entirely.  the SCTP_EVENTS option is a whitelist operation, so
they expect to get what they subscribe to, and no more.

> We should NACK patchset v3 and go with v2. What do you think?
> 
No, we need to go with an option that maintains backwards compatibility
without relying on the assumption that applications will just ignore
events they didn't subscribe to.  Davids example is a case in point.

Neil

> >
> > What if you added a check in get_peer_addr_info to only return -EACCESS
> > if pf_expose is 0 and the application isn't subscribed to the PF event?
> >
> > Neil
> >
> > > >
> > > >         David
> > > >
> > > > -
> > > > Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> > > > Registration No: 1397386 (Wales)
> > > >
> > >
> 
