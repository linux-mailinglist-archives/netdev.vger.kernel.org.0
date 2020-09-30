Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBD8A27E334
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 10:02:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728385AbgI3ICD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 04:02:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:51256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725776AbgI3ICC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Sep 2020 04:02:02 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 663A42072E;
        Wed, 30 Sep 2020 08:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601452922;
        bh=IkuYjh3NLglBPiKsHUdQqIPHL+bEXM/LIKPDB6J6LTM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=j/yceBd3NWE4z+2pZ7zX3Su9m1EGp+rJ4IySmKHzQiGqIunfhRcPGmFonLdhteozv
         6arawg6zhnrTuGRUg2KOMO+D0nmHV4EGOEEDDsgMPWjONElogUxu5m07MJtrEOMufw
         N7UZwhOnRgyRY4xSsVh9i9WpDHdiszm8FnEWyo28=
Date:   Wed, 30 Sep 2020 10:02:05 +0200
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
Message-ID: <20200930080205.GA1571308@kroah.com>
References: <20191228171212.56anj4d4kvjeqhms@pali>
 <45BB2908-4E16-4C74-9DB4-8BAD93B42A21@holtmann.org>
 <20200104102436.bhqagqrfwupj6hkm@pali>
 <20200209132137.7pi4pgnassosh3ax@pali>
 <20200414225618.zgh5h4jexahfukdl@pali>
 <20200808132747.4byefjg5ysddgkel@pali>
 <20200929213254.difivzrhapk766xp@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200929213254.difivzrhapk766xp@pali>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 29, 2020 at 11:32:54PM +0200, Pali Rohár wrote:
> CCing other lists and maintainers, hopefully, somebody would have a time to look at it...
> 
> On Saturday 08 August 2020 15:27:47 Pali Rohár wrote:
> > On Wednesday 15 April 2020 00:56:18 Pali Rohár wrote:
> > > On Sunday 09 February 2020 14:21:37 Pali Rohár wrote:
> > > > On Saturday 04 January 2020 11:24:36 Pali Rohár wrote:
> > > > > On Saturday 04 January 2020 10:44:52 Marcel Holtmann wrote:
> > > > > > Hi Pali,
> > > > > > 
> > > > > > > I wrote a simple script "sco_features.pl" which show all supported
> > > > > > > codecs by local HCI bluetooth adapter. Script is available at:
> > > > > > > 
> > > > > > > https://github.com/pali/hsphfpd-prototype/blob/prototype/sco_features.pl
> > > > > > > 
> > > > > > > And I found out that OCF_READ_LOCAL_CODECS HCI command cannot be send by
> > > > > > > non-root user. Kernel returns "Operation not permitted" error.
> > > > > > > 
> > > > > > > What is reason that kernel blocks OCF_READ_LOCAL_CODECS command for
> > > > > > > non-root users? Without it (audio) application does not know which
> > > > > > > codecs local bluetooth adapter supports.
> > > > > > > 
> > > > > > > E.g. OCF_READ_LOCAL_EXT_FEATURES or OCF_READ_VOICE_SETTING commands can
> > > > > > > be send also by non-root user and kernel does not block them.
> > > > > > 
> > > > > > actually the direct access to HCI commands is being removed. So we have no plans to add new commands into the list since that it what the kernel is suppose to handle. If we wanted to expose this, then it has to be via mgmt.
> > > > > 
> > > > > Hi Marcel! Thank you for information. I have not know that this API is
> > > > > "deprecated" and is going to be removed. But userspace audio
> > > > > applications need to know what bluetooth adapter supports, so can you
> > > > > export result of these commands to userspace? My script linked above
> > > > > calls: OCF_READ_VOICE_SETTING, OCF_READ_LOCAL_COMMANDS,
> > > > > OCF_READ_LOCAL_EXT_FEATURES, OCF_READ_LOCAL_CODECS
> > > > 
> > > > Hello! Just a gently reminder for this question. How to retrieve
> > > > information about supported codecs from userspace by non-root user?
> > > > Because running all bluetooth audio applications by root is not really a
> > > > solution. Plus if above API for root user is going to be removed, what
> > > > is a replacement?
> > > 
> > > Hello!
> > > 
> > > I have not got any answer to my email from Marcel for months, so I'm
> > > adding other developers to loop. Could somebody tell me that is the
> > > replacement API if above one is going to be removed?
> > > 
> > > I was not able to find any documentation where could be described this
> > > API nor information about deprecation / removal.
> > > 
> > > And are you aware of the fact that removing of API could potentially
> > > break existing applications?
> > > 
> > > I really need to know which API should I use, because when I use API
> > > which is going to be removed, then my application stops working. And I
> > > really want to avoid it.
> > > 
> > > Also I have not got any response yet, how can I read list of supported
> > > codecs by bluetooth adapter by ordinary non-root user? Audio application
> > > needs to know list of supported codecs and it is really insane to run it
> > > as root.
> > 
> > Hello! This is just another reminder that I have not got any reply to
> > this email.
> > 
> > Does silence mean that audio applications are expected to work only
> > under root account and ordinary users are not able to use audio and list
> > supported codecs?
> 
> Hello! I have not got any reply for this issue for 10 months and if you
> are going to remove (or after these 10 months you already did it?)
> existing HCI API from kernel it would break existing and working
> userspace application. How do you want to handle such regressions?

What git commit caused this regression?

thanks,

greg k-h
