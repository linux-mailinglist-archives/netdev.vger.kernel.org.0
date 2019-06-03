Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFF1E33AB5
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 00:04:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726538AbfFCWEz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 18:04:55 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:45756 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726211AbfFCWEy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 18:04:54 -0400
Received: by mail-lj1-f194.google.com with SMTP id r76so17724461lja.12
        for <netdev@vger.kernel.org>; Mon, 03 Jun 2019 15:04:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9i0fLB3ctHjhbMv4GYPOBusi0dAWBcq7kpoGxU/5uy0=;
        b=ONMCeqFi2tN4KQtO8Da4s9yG59tc8l/KfFqoS1qMjM18ZALi+QRdNvLyvmqjblfODX
         AEDDqvyyVbhpxg/VK23dTgeYdOCNfUAeN9FMKxPHyN0oOgeZXok+ZdnjAU71ZRwhjRcZ
         RKItIQEhhsnBqu68xNOZ4kGcM7U88snPqRtDsLUEx8rf3Yhzq0Qic4T7B76sFqZf00i7
         AElPiJoLHOF+jb7bESf1g+jcZihky+tgr51oHeOGb6U4JSkGjP+rWTQfsGba+S3nPimu
         AO4tBX9I8ylLnCTVAKVNnUMY5lmasvu4gqpdI4OdGfoDFbNCBNxdy/VApJOD7Zps4aJo
         qZmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9i0fLB3ctHjhbMv4GYPOBusi0dAWBcq7kpoGxU/5uy0=;
        b=nQYygrx3Rb8TnIvGzf6zUkjEoYHeDSSQr24sZ5O7XN2de3eHLow1OLhE0Wc1NNo13T
         B780AdU0scxELrMls5NzG+i3EEwdpp07zsFyK97BlwUfi0i8TjfMn63WUubq6+9T99oI
         rK6jjwd8JVeYUslmVHCdjLPGpwiv1Uhn7lm+5ZqI/SBltX/K38tSxjdp25LXnNxtdnVO
         Pi+Y4jTdhqLER3eFhTSBQaJd9Rmmbhe/Z8wJS51y3wFEMGRGfiQlSQ+eeBdPKwe0dyyZ
         5Djza/uD6DRkLNkleQw9p0+OqsH2dFc9FaQV0TIUitzE7T2nIuuS9doBLuHunuOk03Q6
         hMGg==
X-Gm-Message-State: APjAAAVFFnK4LsqVfIL/g6SfBKzQ1hVmHWpOZe/6obwQa6lBz7iwQnA0
        PCAy3JBQoGIhM5j/4NuN2hKev8UyJU3H8pD/WmPX
X-Google-Smtp-Source: APXvYqwOt5QwwF991N5QgfhgtcwXRJbuTWTAvKoJqehKyrnMTSwptDkGcIf1MEltn7xdxIzkIBJlP3kGx13ECWw/nmo=
X-Received: by 2002:a2e:900e:: with SMTP id h14mr14762142ljg.77.1559595589392;
 Mon, 03 Jun 2019 13:59:49 -0700 (PDT)
MIME-Version: 1.0
References: <20190601021526.GA8264@zhanggen-UX430UQ> <20190601022527.GR17978@ZenIV.linux.org.uk>
 <20190601024459.GA8563@zhanggen-UX430UQ>
In-Reply-To: <20190601024459.GA8563@zhanggen-UX430UQ>
From:   Paul Moore <paul@paul-moore.com>
Date:   Mon, 3 Jun 2019 16:59:38 -0400
Message-ID: <CAHC9VhSbS6_Hp6_k0qpqQTvyG29ADx+b7JoXjDgXViO9bRXVMA@mail.gmail.com>
Subject: Re: [PATCH v3] selinux: lsm: fix a missing-check bug in selinux_sb_eat_lsm_opts()
To:     Gen Zhang <blackgod016574@gmail.com>
Cc:     Al Viro <viro@zeniv.linux.org.uk>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Eric Paris <eparis@parisplace.org>, omosnace@redhat.com,
        selinux@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 31, 2019 at 10:45 PM Gen Zhang <blackgod016574@gmail.com> wrote:
> On Sat, Jun 01, 2019 at 03:25:27AM +0100, Al Viro wrote:
> > On Sat, Jun 01, 2019 at 10:15:26AM +0800, Gen Zhang wrote:
> > > In selinux_sb_eat_lsm_opts(), 'arg' is allocated by kmemdup_nul(). It
> > > returns NULL when fails. So 'arg' should be checked. And 'mnt_opts'
> > > should be freed when error.
> >
> > What's the latter one for?  On failure we'll get to put_fs_context()
> > pretty soon, so
> >         security_free_mnt_opts(&fc->security);
> > will be called just fine.  Leaving it allocated on failure is fine...
> Paul Moore <paul@paul-moore.com> wrote:
> >It seems like we should also check for, and potentially free *mnt_opts
> >as the selinux_add_opt() error handling does just below this change,
> >yes?  If that is the case we might want to move that error handling
> >code to the bottom of the function and jump there on error.
> I am not familiar with this part. So could you please show the function
> call sequence?

I'm not sure I understand your question above, but I did review your
latest patch and agree with Ondrej's comment regarding the ret/rc
variable.  If you make that change I think we can merge this into
selinux/stable-5.2.

-- 
paul moore
www.paul-moore.com
