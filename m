Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 844DD29947D
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 18:56:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1788789AbgJZRzw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 13:55:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:46090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1788768AbgJZRzt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Oct 2020 13:55:49 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4517722265;
        Mon, 26 Oct 2020 17:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603734949;
        bh=NNIbbFb7W6DvybHlpLAu6+F1xGVbmScbL7eadIzXdQw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=X9l0WbDg7VUsIKOma/+cLoSJ08IHOMTMYeie41y7jryFSAnwX9IlkWt5/q0rm6PtL
         xvcgnozQixfJYrij1nvyoussMNAk5pPLd7SU9IrR6AlnOJz0/kE6RtFJBoRw+g2pw1
         p5XniN5EQoAVHxB3abDvr7dyuhR5F5VV6oCfLpdk=
Date:   Mon, 26 Oct 2020 10:55:48 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     David Laight <David.Laight@aculab.com>,
        Colin King <colin.king@canonical.com>,
        "David S . Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] vsock: ratelimit unknown ioctl error message
Message-ID: <20201026105548.0cc911a8@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201026100112.qaorff6c6vucakyg@steredhat>
References: <20201023122113.35517-1-colin.king@canonical.com>
        <20201023140947.kurglnklaqteovkp@steredhat>
        <e535c07df407444880d8b678bc215d9f@AcuMS.aculab.com>
        <20201026084300.5ag24vck3zeb4mcz@steredhat>
        <d893e3251f804cffa797b6eb814944fd@AcuMS.aculab.com>
        <20201026093917.5zgginii65pq6ezd@steredhat>
        <3e34e4121f794355891fd7577c9dfbc0@AcuMS.aculab.com>
        <20201026100112.qaorff6c6vucakyg@steredhat>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 26 Oct 2020 11:01:12 +0100 Stefano Garzarella wrote:
> On Mon, Oct 26, 2020 at 09:46:17AM +0000, David Laight wrote:
> >From: Stefano Garzarella  
> >> Sent: 26 October 2020 09:39
> >>
> >> On Mon, Oct 26, 2020 at 09:13:23AM +0000, David Laight wrote:  
> >> >From: Stefano Garzarella  
> >> >> Sent: 26 October 2020 08:43  
> >> >...  
> >> >> >Isn't the canonical error for unknown ioctl codes -ENOTTY?
> >> >> >  
> >> >>
> >> >> Oh, thanks for pointing that out!
> >> >>
> >> >> I had not paid attention to the error returned, but looking at it I
> >> >> noticed that perhaps the most appropriate would be -ENOIOCTLCMD.
> >> >> In the ioctl syscall we return -ENOTTY, if the callback returns
> >> >> -ENOIOCTLCMD.
> >> >>
> >> >> What do you think?  
> >> >
> >> >It is 729 v 443 in favour of ENOTTY (based on grep).  
> >>
> >> Under net/ it is 6 vs 83 in favour of ENOIOCTLCMD.
> >>  
> >> >
> >> >No idea where ENOIOCTLCMD comes from, but ENOTTY probably
> >> >goes back to the early 1970s.  
> >>
> >> Me too.
> >>  
> >> >
> >> >The fact that the ioctl wrapper converts the value is a good
> >> >hint that userspace expects ENOTTY.  
> >>
> >> Agree on that, but since we are not interfacing directly with userspace,
> >> I think it is better to return the more specific error (ENOIOCTLCMD).  
> >
> >I bet Linux thought it could use a different error code then
> >found that 'unknown ioctl' was spelt ENOTTY.  
> 
> It could be :-)
> 
> Anyway, as you pointed out, I think we should change the -EINVAL with 
> -ENOTTY or -ENOIOCTLCMD.
> 
> @Jakub what do you suggest?

ENOIOCTLCMD is a kernel-internal high return code (515) which should 
be returned by the driver, but it's then caught inside the core and
translated to ENOTTY which is then returned to user space.

So you're both right, I guess? But the driver should use ENOIOCTLCMD.
