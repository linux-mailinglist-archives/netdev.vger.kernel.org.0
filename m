Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B9CA2072CE
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 14:06:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390844AbgFXMFv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 08:05:51 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:39921 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388522AbgFXMFt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 08:05:49 -0400
Received: by mail-pl1-f193.google.com with SMTP id s14so982132plq.6;
        Wed, 24 Jun 2020 05:05:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4rW66tKgMxqam/uZ0Bz8Bt7qxGkjsWEZUtUfdcWMRhc=;
        b=XMlLF2B+pioEMrPQZj3RDmyozPWMTSp2Y5bUwU8DkblV2+DkldHhM/ppyp+n6jb396
         7D5v7nJ5LaAunRH33dwATmcG8zWn1i0HLZb+fGQZwma8/1i6zvq0obF1XuGnMLlQe2OX
         Hwr3KJyWXWQHnSFjR/vzXwgC5cqb776738drwoOUJtuNVsGcuzSInbk+I553bPA/Bi4T
         zQoZF27Ozxnw/LvU+Itrjb1AuwBZiIZQGRrepaINNMj7ekTsYcw+PcvICKaCafLfciCa
         /lmz/x6dKy8+Ru2OZ7YPV9SmeLIFmmQdPicPfFg0jhiV8pqPG6OyO7X3PdPynSBi/6pM
         hAHw==
X-Gm-Message-State: AOAM5301N0bJedtkn+VakeApif5q6cYp4Ix5Aot4P4qHyqEi7eb/YlUp
        Fn65emJE2mgPTo+hxRONy7U=
X-Google-Smtp-Source: ABdhPJx9eNUtUf3wuLMsAQaZO33hgDdcCinYPWgXgNxzY43C5jkpxbcvMxqvxkaY5VupgSIqvNCnfQ==
X-Received: by 2002:a17:90a:30c2:: with SMTP id h60mr3388528pjb.23.1593000348658;
        Wed, 24 Jun 2020 05:05:48 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id y3sm20167541pff.37.2020.06.24.05.05.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2020 05:05:47 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id 3F48940430; Wed, 24 Jun 2020 12:05:46 +0000 (UTC)
Date:   Wed, 24 Jun 2020 12:05:46 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     ast@kernel.org, axboe@kernel.dk, bfields@fieldses.org,
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
Message-ID: <20200624120546.GC4332@42.do-not-panic.com>
References: <20200610154923.27510-5-mcgrof@kernel.org>
 <20200623141157.5409-1-borntraeger@de.ibm.com>
 <b7d658b9-606a-feb1-61f9-b58e3420d711@de.ibm.com>
 <3118dc0d-a3af-9337-c897-2380062a8644@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3118dc0d-a3af-9337-c897-2380062a8644@de.ibm.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 24, 2020 at 01:11:54PM +0200, Christian Borntraeger wrote:
> 
> 
> On 23.06.20 16:23, Christian Borntraeger wrote:
> > 
> > 
> > On 23.06.20 16:11, Christian Borntraeger wrote:
> >> Jens Markwardt reported a regression in the linux-next runs.  with "umh: fix
> >> processed error when UMH_WAIT_PROC is used" (from linux-next) a linux bridge
> >> with an KVM guests no longer activates :
> >>
> >> without patch
> >> # ip addr show dev virbr1
> >> 6: virbr1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
> >>     link/ether 52:54:00:1e:3f:c0 brd ff:ff:ff:ff:ff:ff
> >>     inet 192.168.254.254/24 brd 192.168.254.255 scope global virbr1
> >>        valid_lft forever preferred_lft forever
> >>
> >> with this patch the bridge stays DOWN with NO-CARRIER
> >>
> >> # ip addr show dev virbr1
> >> 6: virbr1: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN group default qlen 1000
> >>     link/ether 52:54:00:1e:3f:c0 brd ff:ff:ff:ff:ff:ff
> >>     inet 192.168.254.254/24 brd 192.168.254.255 scope global virbr1
> >>        valid_lft forever preferred_lft forever
> >>
> >> This was bisected in linux-next. Reverting from linux-next also fixes the issue.
> >>
> >> Any idea?
> > 
> > FWIW, s390 is big endian. Maybe some of the shifts inn the __KW* macros are wrong.
> 
> Does anyone have an idea why "umh: fix processed error when UMH_WAIT_PROC is used" breaks the
> linux-bridge on s390?

glibc for instance defines __WEXITSTATUS in only one location: bits/waitstatus.h
and it does not special case it per architecture, so at this point I'd
have to say we have to look somewhere else for why this is happening.

The commmit which caused this is issuing a correct error code down the
pipeline, nothing more. I'll make taking a look at this a priority right
now. Let us see what I come up with today.

  Luis
