Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB63B27E4F7
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 11:20:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728884AbgI3JUR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 05:20:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:35192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728451AbgI3JUR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Sep 2020 05:20:17 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D6F672071E;
        Wed, 30 Sep 2020 09:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601457616;
        bh=nX9mJ94jh3/bnuZhab5wJtjYQbT1uGXKsd6faztp0VA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1LUvRiCPOYrEHy1OYc/ohcqfDPD0nO1/U5r/tJnlKQN7nzuz66RWg+cB9sD2ygqsG
         RS1uMhIEOzZzqO+6H0Rc4Q64tHV1wY9NTiX71w0nq1glM4nNQpaoZOkwU/QCtVOnxB
         f8tAl6vlFzPNab1ChKEPS74VIYnvEoQSCKEhVjJA=
Date:   Wed, 30 Sep 2020 11:20:20 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Pavel Machek <pavel@ucw.cz>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Sebastian Reichel <sre@kernel.org>,
        David Heidelberg <david@ixit.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: Removal of HCI commands, userspace bluetooth regression?
Message-ID: <20200930092020.GA1580803@kroah.com>
References: <20191228171212.56anj4d4kvjeqhms@pali>
 <45BB2908-4E16-4C74-9DB4-8BAD93B42A21@holtmann.org>
 <20200104102436.bhqagqrfwupj6hkm@pali>
 <20200209132137.7pi4pgnassosh3ax@pali>
 <20200414225618.zgh5h4jexahfukdl@pali>
 <20200808132747.4byefjg5ysddgkel@pali>
 <20200929213254.difivzrhapk766xp@pali>
 <20200930080205.GA1571308@kroah.com>
 <B9D64012-BF9A-4C2A-8D3D-D789533DFAD0@holtmann.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B9D64012-BF9A-4C2A-8D3D-D789533DFAD0@holtmann.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 30, 2020 at 10:16:40AM +0200, Marcel Holtmann wrote:
> Hi Greg,
> 
> >>>>>>>> I wrote a simple script "sco_features.pl" which show all supported
> >>>>>>>> codecs by local HCI bluetooth adapter. Script is available at:
> >>>>>>>> 
> >>>>>>>> https://github.com/pali/hsphfpd-prototype/blob/prototype/sco_features.pl
> >>>>>>>> 
> >>>>>>>> And I found out that OCF_READ_LOCAL_CODECS HCI command cannot be send by
> >>>>>>>> non-root user. Kernel returns "Operation not permitted" error.
> >>>>>>>> 
> >>>>>>>> What is reason that kernel blocks OCF_READ_LOCAL_CODECS command for
> >>>>>>>> non-root users? Without it (audio) application does not know which
> >>>>>>>> codecs local bluetooth adapter supports.
> >>>>>>>> 
> >>>>>>>> E.g. OCF_READ_LOCAL_EXT_FEATURES or OCF_READ_VOICE_SETTING commands can
> >>>>>>>> be send also by non-root user and kernel does not block them.
> >>>>>>> 
> >>>>>>> actually the direct access to HCI commands is being removed. So we have no plans to add new commands into the list since that it what the kernel is suppose to handle. If we wanted to expose this, then it has to be via mgmt.
> >>>>>> 
> >>>>>> Hi Marcel! Thank you for information. I have not know that this API is
> >>>>>> "deprecated" and is going to be removed. But userspace audio
> >>>>>> applications need to know what bluetooth adapter supports, so can you
> >>>>>> export result of these commands to userspace? My script linked above
> >>>>>> calls: OCF_READ_VOICE_SETTING, OCF_READ_LOCAL_COMMANDS,
> >>>>>> OCF_READ_LOCAL_EXT_FEATURES, OCF_READ_LOCAL_CODECS
> >>>>> 
> >>>>> Hello! Just a gently reminder for this question. How to retrieve
> >>>>> information about supported codecs from userspace by non-root user?
> >>>>> Because running all bluetooth audio applications by root is not really a
> >>>>> solution. Plus if above API for root user is going to be removed, what
> >>>>> is a replacement?
> >>>> 
> >>>> Hello!
> >>>> 
> >>>> I have not got any answer to my email from Marcel for months, so I'm
> >>>> adding other developers to loop. Could somebody tell me that is the
> >>>> replacement API if above one is going to be removed?
> >>>> 
> >>>> I was not able to find any documentation where could be described this
> >>>> API nor information about deprecation / removal.
> >>>> 
> >>>> And are you aware of the fact that removing of API could potentially
> >>>> break existing applications?
> >>>> 
> >>>> I really need to know which API should I use, because when I use API
> >>>> which is going to be removed, then my application stops working. And I
> >>>> really want to avoid it.
> >>>> 
> >>>> Also I have not got any response yet, how can I read list of supported
> >>>> codecs by bluetooth adapter by ordinary non-root user? Audio application
> >>>> needs to know list of supported codecs and it is really insane to run it
> >>>> as root.
> >>> 
> >>> Hello! This is just another reminder that I have not got any reply to
> >>> this email.
> >>> 
> >>> Does silence mean that audio applications are expected to work only
> >>> under root account and ordinary users are not able to use audio and list
> >>> supported codecs?
> >> 
> >> Hello! I have not got any reply for this issue for 10 months and if you
> >> are going to remove (or after these 10 months you already did it?)
> >> existing HCI API from kernel it would break existing and working
> >> userspace application. How do you want to handle such regressions?
> > 
> > What git commit caused this regression?
> 
> there is no regression!
> 
> New Bluetooth standards added new HCI commands that are just not
> exposed to unprivileged users.

Ok, that makes sense.  What tool takes advantage of these new HCI
commands?

thanks,

greg k-h
