Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDEAE20B0AA
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 13:40:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728740AbgFZLkN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 07:40:13 -0400
Received: from mail-pj1-f65.google.com ([209.85.216.65]:36155 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725900AbgFZLkM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 07:40:12 -0400
Received: by mail-pj1-f65.google.com with SMTP id h22so4842773pjf.1;
        Fri, 26 Jun 2020 04:40:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wnn5CPE1OQI5MbFdoVeNzug5Y/E4qNsr7nm00pkYjsg=;
        b=VX/NDcK3cWNkOqEznH+rHxPMCVA2ZZ/Yvsv5Pm52vlgMQQ74cnifJ+D2ecxcODvC5v
         Fkj0Ci8vYYONLziSJeMqSFs3iyyMmvPCpJ1EgAy903rYYZcU3UdyoOY9DYzxAqPeAQsD
         EtGEK2MZLpqSWV8tbU76mZlCdMRoypUI2oXIk3zIbS+rNZVLk5oN+cm61AB6JpBywBa0
         H3uTZOGfHH6UChsodjhDBVoO9Kpy9AXbPrk/skrhYCeoS2gPH/ueg5Ra4ru5ykZNcETW
         RR4+qA4tDYjy1xf+Y6ancZ2HEmH/Jn+Z+Rn6fFtNH4qNA3sBtvtqt+96vlM5zSDn7Cgq
         P+5w==
X-Gm-Message-State: AOAM531ObMrp6gfRCJ5JWKX5yKbh/Y/o9UELnjHWNBw9Re530u4XL29W
        4RdpomuWlplHgMJy4xzgkQo=
X-Google-Smtp-Source: ABdhPJwGnA6i8X9De1IIY6uo4WMjc9fcRybYmtI1FEyCJ5SkbsL4wzndlVbt12ryEpm7GBivRrC8Cw==
X-Received: by 2002:a17:90b:1292:: with SMTP id fw18mr2901992pjb.183.1593171610835;
        Fri, 26 Jun 2020 04:40:10 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id g21sm25348911pfh.134.2020.06.26.04.40.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jun 2020 04:40:09 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id 8D0D340B24; Fri, 26 Jun 2020 11:40:08 +0000 (UTC)
Date:   Fri, 26 Jun 2020 11:40:08 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>, ast@kernel.org,
        axboe@kernel.dk, bfields@fieldses.org,
        bridge@lists.linux-foundation.org, chainsaw@gentoo.org,
        christian.brauner@ubuntu.com, chuck.lever@oracle.com,
        davem@davemloft.net, dhowells@redhat.com,
        gregkh@linuxfoundation.org, jarkko.sakkinen@linux.intel.com,
        jmorris@namei.org, josh@joshtriplett.org, keescook@chromium.org,
        keyrings@vger.kernel.org, kuba@kernel.org,
        lars.ellenberg@linbit.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-security-module@vger.kernel.org, nikolay@cumulusnetworks.com,
        philipp.reisner@linbit.com, ravenexp@gmail.com,
        roopa@cumulusnetworks.com, serge@hallyn.com, slyfox@gentoo.org,
        viro@zeniv.linux.org.uk, yangtiezhu@loongson.cn,
        netdev@vger.kernel.org, markward@linux.ibm.com,
        linux-s390 <linux-s390@vger.kernel.org>
Subject: Re: linux-next: umh: fix processed error when UMH_WAIT_PROC is used
 seems to break linux bridge on s390x (bisected)
Message-ID: <20200626114008.GK4332@42.do-not-panic.com>
References: <20200624144311.GA5839@infradead.org>
 <9e767819-9bbe-2181-521e-4d8ca28ca4f7@de.ibm.com>
 <20200624160953.GH4332@42.do-not-panic.com>
 <ea41e2a9-61f7-aec1-79e5-7b08b6dd5119@de.ibm.com>
 <4e27098e-ac8d-98f0-3a9a-ea25242e24ec@de.ibm.com>
 <4d8fbcea-a892-3453-091f-d57c03f9aa90@de.ibm.com>
 <1263e370-7cee-24d8-b98c-117bf7c90a83@de.ibm.com>
 <20200626025410.GJ4332@42.do-not-panic.com>
 <feb6a8c4-2b94-3f95-6637-679e089a71ca@de.ibm.com>
 <20200626090001.GA30103@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200626090001.GA30103@infradead.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 26, 2020 at 10:00:01AM +0100, Christoph Hellwig wrote:
> On Fri, Jun 26, 2020 at 07:22:34AM +0200, Christian Borntraeger wrote:
> > 
> > 
> > On 26.06.20 04:54, Luis Chamberlain wrote:
> > > On Wed, Jun 24, 2020 at 08:37:55PM +0200, Christian Borntraeger wrote:
> > >>
> > >>
> > >> On 24.06.20 20:32, Christian Borntraeger wrote:
> > >> [...]> 
> > >>> So the translations look correct. But your change is actually a sematic change
> > >>> if(ret) will only trigger if there is an error
> > >>> if (KWIFEXITED(ret)) will always trigger when the process ends. So we will always overwrite -ECHILD
> > >>> and we did not do it before. 
> > >>>
> > >>
> > >> So the right fix is
> > >>
> > >> diff --git a/kernel/umh.c b/kernel/umh.c
> > >> index f81e8698e36e..a3a3196e84d1 100644
> > >> --- a/kernel/umh.c
> > >> +++ b/kernel/umh.c
> > >> @@ -154,7 +154,7 @@ static void call_usermodehelper_exec_sync(struct subprocess_info *sub_info)
> > >>                  * the real error code is already in sub_info->retval or
> > >>                  * sub_info->retval is 0 anyway, so don't mess with it then.
> > >>                  */
> > >> -               if (KWIFEXITED(ret))
> > >> +               if (KWEXITSTATUS(ret))
> > >>                         sub_info->retval = KWEXITSTATUS(ret);
> > >>         }
> > >>  
> > >> I think.
> > > 
> > > Nope, the right form is to check for WIFEXITED() before using WEXITSTATUS().
> > 
> > But this IS a change over the previous code, no?
> > I will test next week as I am travelling right now. 
> 
> I'm all for reverting back to the previous behavior.  If someone wants
> a behavior change it should be a separate patch.  And out of pure self
> interest I'd like to see that change after my addition of the
> kernel_wait helper to replace the kernel_wait4 abuse :)

Yeah sure, this will be *slightly* cleaner after that. Today we
implicitly return -ECHLD as well under the assumption the kernel_wait4()
call failed.

Andrew, can you please revert these two for now:

selftests: simplify kmod failure value
umh: fix processed error when UMH_WAIT_PROC is used

Later, we'll add Christoph's simplier kernel wait, and make the change
directly there to catpure the right error. That still won't fix this reported
issue, but it will be cleaner and will go tested by Christian Borntraeger
before.

  Luis
