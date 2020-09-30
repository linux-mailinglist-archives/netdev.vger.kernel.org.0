Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47CED27E827
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 14:02:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729767AbgI3MCb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 08:02:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:55860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729663AbgI3MCa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Sep 2020 08:02:30 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C5DD2076B;
        Wed, 30 Sep 2020 12:02:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601467349;
        bh=LXc8rSzLCZ2piLrvbN25CFl0fgDHgAWL3l/NbQfAKsc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UP8dvsg4qBD44E14JXr2HtzQtIHKJVxpSqhqvI8/NNBrs/8SQQyCFL0/iQ4yd8iPK
         4gIyTy18NSJEv/FeAKozUgyjemqqW7MJiF+LvEFYt7smkE9DHpOvxlCyujNIu7yNUB
         y0yBhfiQ2IHp4S6QlRQQcuq6C7p9SNUyb9CfSz/I=
Date:   Wed, 30 Sep 2020 14:02:33 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Pavel Machek <pavel@ucw.cz>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Sebastian Reichel <sre@kernel.org>,
        David Heidelberg <david@ixit.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Removal of HCI commands, userspace bluetooth regression?
Message-ID: <20200930120233.GA1613482@kroah.com>
References: <20200808132747.4byefjg5ysddgkel@pali>
 <20200929213254.difivzrhapk766xp@pali>
 <20200930080205.GA1571308@kroah.com>
 <20200930082534.rrck6qb3fntm25wz@pali>
 <20200930092043.GB1580803@kroah.com>
 <20200930094616.qmpophucxwpgu7tz@pali>
 <20200930105434.GB1592367@kroah.com>
 <20200930110013.rjejmjcsgfhdqa6l@pali>
 <20200930112006.GA1598131@kroah.com>
 <20200930115132.fscfugzvf6nqtglc@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200930115132.fscfugzvf6nqtglc@pali>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 30, 2020 at 01:51:32PM +0200, Pali Rohár wrote:
> On Wednesday 30 September 2020 13:20:06 Greg Kroah-Hartman wrote:
> > On Wed, Sep 30, 2020 at 01:00:13PM +0200, Pali Rohár wrote:
> > > On Wednesday 30 September 2020 12:54:34 Greg Kroah-Hartman wrote:
> > > > On Wed, Sep 30, 2020 at 11:46:16AM +0200, Pali Rohár wrote:
> > > > > On Wednesday 30 September 2020 11:20:43 Greg Kroah-Hartman wrote:
> > > > > > On Wed, Sep 30, 2020 at 10:25:34AM +0200, Pali Rohár wrote:
> > > > > > > On Wednesday 30 September 2020 10:02:05 Greg Kroah-Hartman wrote:
> > > > > > > > On Tue, Sep 29, 2020 at 11:32:54PM +0200, Pali Rohár wrote:
> > > > > > > > > CCing other lists and maintainers, hopefully, somebody would have a time to look at it...
> > > > > > > > > 
> > > > > > > > > On Saturday 08 August 2020 15:27:47 Pali Rohár wrote:
> > > > > > > > > > On Wednesday 15 April 2020 00:56:18 Pali Rohár wrote:
> > > > > > > > > > > On Sunday 09 February 2020 14:21:37 Pali Rohár wrote:
> > > > > > > > > > > > On Saturday 04 January 2020 11:24:36 Pali Rohár wrote:
> > > > > > > > > > > > > On Saturday 04 January 2020 10:44:52 Marcel Holtmann wrote:
> > > > > > > > > > > > > > Hi Pali,
> > > > > > > > > > > > > > 
> > > > > > > > > > > > > > > I wrote a simple script "sco_features.pl" which show all supported
> > > > > > > > > > > > > > > codecs by local HCI bluetooth adapter. Script is available at:
> > > > > > > > > > > > > > > 
> > > > > > > > > > > > > > > https://github.com/pali/hsphfpd-prototype/blob/prototype/sco_features.pl
> > > > > > > > > > > > > > > 
> > > > > > > > > > > > > > > And I found out that OCF_READ_LOCAL_CODECS HCI command cannot be send by
> > > > > > > > > > > > > > > non-root user. Kernel returns "Operation not permitted" error.
> > > > > > > > > > > > > > > 
> > > > > > > > > > > > > > > What is reason that kernel blocks OCF_READ_LOCAL_CODECS command for
> > > > > > > > > > > > > > > non-root users? Without it (audio) application does not know which
> > > > > > > > > > > > > > > codecs local bluetooth adapter supports.
> > > > > > > > > > > > > > > 
> > > > > > > > > > > > > > > E.g. OCF_READ_LOCAL_EXT_FEATURES or OCF_READ_VOICE_SETTING commands can
> > > > > > > > > > > > > > > be send also by non-root user and kernel does not block them.
> > > > > > > > > > > > > > 
> > > > > > > > > > > > > > actually the direct access to HCI commands is being removed. So we have no plans to add new commands into the list since that it what the kernel is suppose to handle. If we wanted to expose this, then it has to be via mgmt.
> > > > > > > > > > > > > 
> > > > > > > > > > > > > Hi Marcel! Thank you for information. I have not know that this API is
> > > > > > > > > > > > > "deprecated" and is going to be removed. But userspace audio
> > > > > > > > > > > > > applications need to know what bluetooth adapter supports, so can you
> > > > > > > > > > > > > export result of these commands to userspace? My script linked above
> > > > > > > > > > > > > calls: OCF_READ_VOICE_SETTING, OCF_READ_LOCAL_COMMANDS,
> > > > > > > > > > > > > OCF_READ_LOCAL_EXT_FEATURES, OCF_READ_LOCAL_CODECS
> > > > > > > > > > > > 
> > > > > > > > > > > > Hello! Just a gently reminder for this question. How to retrieve
> > > > > > > > > > > > information about supported codecs from userspace by non-root user?
> > > > > > > > > > > > Because running all bluetooth audio applications by root is not really a
> > > > > > > > > > > > solution. Plus if above API for root user is going to be removed, what
> > > > > > > > > > > > is a replacement?
> > > > > > > > > > > 
> > > > > > > > > > > Hello!
> > > > > > > > > > > 
> > > > > > > > > > > I have not got any answer to my email from Marcel for months, so I'm
> > > > > > > > > > > adding other developers to loop. Could somebody tell me that is the
> > > > > > > > > > > replacement API if above one is going to be removed?
> > > > > > > > > > > 
> > > > > > > > > > > I was not able to find any documentation where could be described this
> > > > > > > > > > > API nor information about deprecation / removal.
> > > > > > > > > > > 
> > > > > > > > > > > And are you aware of the fact that removing of API could potentially
> > > > > > > > > > > break existing applications?
> > > > > > > > > > > 
> > > > > > > > > > > I really need to know which API should I use, because when I use API
> > > > > > > > > > > which is going to be removed, then my application stops working. And I
> > > > > > > > > > > really want to avoid it.
> > > > > > > > > > > 
> > > > > > > > > > > Also I have not got any response yet, how can I read list of supported
> > > > > > > > > > > codecs by bluetooth adapter by ordinary non-root user? Audio application
> > > > > > > > > > > needs to know list of supported codecs and it is really insane to run it
> > > > > > > > > > > as root.
> > > > > > > > > > 
> > > > > > > > > > Hello! This is just another reminder that I have not got any reply to
> > > > > > > > > > this email.
> > > > > > > > > > 
> > > > > > > > > > Does silence mean that audio applications are expected to work only
> > > > > > > > > > under root account and ordinary users are not able to use audio and list
> > > > > > > > > > supported codecs?
> > > > > > > > > 
> > > > > > > > > Hello! I have not got any reply for this issue for 10 months and if you
> > > > > > > > > are going to remove (or after these 10 months you already did it?)
> > > > > > > > > existing HCI API from kernel it would break existing and working
> > > > > > > > > userspace application. How do you want to handle such regressions?
> > > > > > > > 
> > > > > > > > What git commit caused this regression?
> > > > > > > 
> > > > > > > Hello! Marcel in January wrote that access for HCI commands is being
> > > > > > > removed from kernel. I do not know if he managed to do it in since
> > > > > > > January, but I'm going to check it...
> > > > > > 
> > > > > > So you don't see a regression/problem, but are saying there is one?
> > > > > 
> > > > > Hello!
> > > > > 
> > > > > Planed removal of used API would be a regression. Marcel wrote that it
> > > > > is "being removed". Nobody reacted to that fact for 10 months so I did
> > > > > not know if this comment was lost and removal is already in progress.
> > > > > Or if something was changed and removal is not planned anymore.
> > > > > 
> > > > > So are you aware that it will break applications?
> > > > 
> > > > Does it?
> > > 
> > > Of course.
> > > 
> > > > > > odd...
> > > > > 
> > > > > I think it is not a good idea to do something and then check what happen
> > > > > if there are people who know that such thing is in use and for sure it
> > > > > will break something.
> > > > > 
> > > > > And also I still did not get any response what is the replacement of
> > > > > that API.
> > > > 
> > > > It sounds like only new commands are restricted
> > > 
> > > So existing are not being removed? It was finally changed and can you confirm it?
> > 
> > I think you need to point us at some kernel git commits that you are
> > saying is causing problems here, as it's too confusing to determine what
> > is really happening here.
> 
> Ok, to recap:
> 
> Problem is causing [1] the fact that "direct access to HCI commands is
> being removed" as was written in first reply of this email thread.

But I don't see those commits anywhere in the tree, so nothing has
actually been removed yet?

That's what I'm asking, what has regressed?  If nothing, then there's no
problem :)

If people are considering changing things, well, work on that, and
object to any patches that break existing tools.  But I don't see that
at the moment, so what can I do?

thanks,

greg k-h
