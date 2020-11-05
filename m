Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6D412A833C
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 17:15:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731452AbgKEQOx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 11:14:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:43278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725862AbgKEQOw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Nov 2020 11:14:52 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B5BC6206B7;
        Thu,  5 Nov 2020 16:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604592892;
        bh=urp1TUB7bsad4HXf4hTdc4VKnO9NVgIYTeMT68wlEuU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Wyyh+fFSHvTV97GVS2CF90aZljGaeaSSnfDyRwT27cf0apqDyUvPvgsYhSabjNLnu
         V/O9zFoAn/44po0ODzNjRbGzQ9TtdXv78slJTXnQg+uqBy1gUr+dLXtWxzC0oBGgBT
         +Mzx+2glIkLOXh4dAoKT8iYYEnAsFanUh8tUi890=
Date:   Thu, 5 Nov 2020 08:14:50 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Anant Thazhemadam <anant.thazhemadam@gmail.com>
Cc:     Oliver Neukum <oneukum@suse.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: Re: [RESEND PATCH v3] net: usb: usbnet: update
 __usbnet_{read|write}_cmd() to use new API
Message-ID: <20201105081450.4a257e7f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <dc3a4901-9aad-3064-4131-bc3fc82f965f@gmail.com>
References: <20201102173946.13800-1-anant.thazhemadam@gmail.com>
        <20201104162444.66b5cc56@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <dc3a4901-9aad-3064-4131-bc3fc82f965f@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 5 Nov 2020 07:56:08 +0530 Anant Thazhemadam wrote:
> On 05/11/20 5:54 am, Jakub Kicinski wrote:
> > On Mon,  2 Nov 2020 23:09:46 +0530 Anant Thazhemadam wrote:  
> >> Currently, __usbnet_{read|write}_cmd() use usb_control_msg().
> >> However, this could lead to potential partial reads/writes being
> >> considered valid, and since most of the callers of
> >> usbnet_{read|write}_cmd() don't take partial reads/writes into account
> >> (only checking for negative error number is done), and this can lead to
> >> issues.
> >>
> >> However, the new usb_control_msg_{send|recv}() APIs don't allow partial
> >> reads and writes.
> >> Using the new APIs also relaxes the return value checking that must
> >> be done after usbnet_{read|write}_cmd() is called.
> >>
> >> Signed-off-by: Anant Thazhemadam <anant.thazhemadam@gmail.com>  
> > So you're changing the semantics without updating the callers?
> >
> > I'm confused. 
> >
> > Is this supposed to be applied to some tree which already has the
> > callers fixed?
> >
> > At a quick scan at least drivers/net/usb/plusb.c* would get confused 
> > as it compares the return value to zero and 0 used to mean "nothing
> > transferred", now it means "all good", no? 
> >
> > * I haven't looked at all the other callers  
> 
> I see. I checked most of the callers that directly called the functions,
> but it seems to have slipped my mind that these callers were also
> wrappers, and to check the callers for these wrapper.
> I apologize for the oversight.
> I'll perform a more in-depth analysis of all the callers, fix this mistake,
> and send in a patch series instead, that update all the callers too.
> Would that be alright?

Yes. Probably best if you rename the existing function as first patch,
then add a new one with the old name using usb_control_msg_{send|recv}()
then switch the callers one by one, and finally remove the old renamed
function.
