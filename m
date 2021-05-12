Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A95C37D061
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 19:41:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240639AbhELRd5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 13:33:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244516AbhELQuj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 May 2021 12:50:39 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9C20C022A8F
        for <netdev@vger.kernel.org>; Wed, 12 May 2021 09:23:48 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id a4so35904501ejk.1
        for <netdev@vger.kernel.org>; Wed, 12 May 2021 09:23:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sPhA/5oxp7tvZCmXw/waTJLyyY6raAYfgYxrBgAmwyM=;
        b=SYoFDx/Zzixg1Z4D0jeH1vTMiEe+P69opHbSwG8ECggk/vHidyrKZ9K2E4m0b+i3i1
         K83HryhQJQQwyKJD2wDav1FQRNkauXOu/e2wPsrp8hps5qNCRyxUi+JtvCuo1w5DpHM5
         3B6+LRj1a92CVU1h2YidjPJ2DJSGjKhcn7UqFRPOLTObGYJ/WxCUgH72f6Yvw0uiGs5n
         Txd5KN2fMIdiYQNP7BEVnNiFOOWqyodtFLagVJKZ6T7jIYstslYAvw3ualmCWqdYKfCt
         RL+Xw+9+hqfnmQMJJNjbVGfkmYMyoJyIkDMJLexvX85Mkohyu/NVfsV5hc+WjMwpeN5n
         anjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sPhA/5oxp7tvZCmXw/waTJLyyY6raAYfgYxrBgAmwyM=;
        b=c/rkF321/kF2Pyn3ITn8A5mebjcwn0JGPkW+fWdHWG+JMQ8Ax+h7szAN0U9FOF6spW
         /S5hamiofOhVBMYZtBkSZ1AwYgdqEMTrAbuugFduOn5x36CAE6TPMpEfwzkaFRP1QsXc
         si41a5rtSeS3Q9ydJMMp8JLZrMbpjvbZ4uY4cm/as047J/YE9ijFBX8bh/OZCyoVSgTf
         prQzCxfpnmzKvUhOOYZ7z499XunhWEhrQAtJRaBOI4iLSkSfaPcC0VYZi6y3orzLPCWb
         Cx9UWs9ADo08Q/zyRJVfoscTFQmN3UDl3XNMKRVjIDiLff2HuDs4O5DedMaIEgvAkO4/
         QGfg==
X-Gm-Message-State: AOAM531t8sFl+rSywdlhREFpye6fHOfeK3acgC/H5aT1cJ7M9OGsLZ0e
        aIvXGPJuX0+3AFxcSD87z8aiY6l/BOx+E7KiAcRA
X-Google-Smtp-Source: ABdhPJxzTvz4e3IxBmnaK3WmYXJZbzN5Zq06UuaBzHtcPCb3mZVtS8qUf8gHkah92LuUo/6uuvWFQnDEFJKIFg48vRY=
X-Received: by 2002:a17:907:10d8:: with SMTP id rv24mr38393600ejb.542.1620836627295;
 Wed, 12 May 2021 09:23:47 -0700 (PDT)
MIME-Version: 1.0
References: <CAA-qYXi-znXVt_8KuMwEpbqmeWVQJZX9ixnOLs22fPM7HKmmtA@mail.gmail.com>
In-Reply-To: <CAA-qYXi-znXVt_8KuMwEpbqmeWVQJZX9ixnOLs22fPM7HKmmtA@mail.gmail.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Wed, 12 May 2021 12:23:36 -0400
Message-ID: <CAHC9VhRo0y+3_VmWKpiw9h-p4ci6JVNJ9ZzQ2yXTOXtUf-XEyA@mail.gmail.com>
Subject: Re: A missing check bug in __sys_accept4_file()
To:     Jinmeng Zhou <jjjinmeng.zhou@gmail.com>
Cc:     axboe@kernel.dk, Jakub Kicinski <kuba@kernel.org>,
        davem@davemloft.net, James Morris <jmorris@namei.org>,
        Serge Hallyn <serge@hallyn.com>, shenwenbosmile@gmail.com,
        netdev@vger.kernel.org, linux-security-module@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 12, 2021 at 3:43 AM Jinmeng Zhou <jjjinmeng.zhou@gmail.com> wrote:
> Dear maintainers,
>
> hi, our team has found and reported a missing check bug on Linux
> kernel v5.10.7 using static analysis.
> We are looking forward to having more experts' eyes on this. Thank you!

Creating a new socket, not associated with a connection (e.g. via
sock_create_lite()), is a different operation than creating a new
socket in response to an incoming connection as is done in
__sys_accept4_file().  This is why the sock_create_lite() uses the
security_socket_create() LSM hook and __sys_accept4_file() uses the
security_socket_accept() LSM hook.

> > On Fri, May 7, 2021 at 1:59 AM Jakub Kicinski <kuba@kernel.org> wrote:
> > > On Thu, 6 May 2021 15:44:36 +0800 Jinmeng Zhou wrote:
> > > hi, our team has found a missing check bug on Linux kernel v5.10.7 using static analysis. There is a path calls sock_alloc() after checking LSM function security_socket_create(), while another path calls it without checking.
> > > We think there is a missing check bug in __sys_accept4_file() before calling sock_alloc().
> >
> > Perhaps the semantics for listening sockets is that only the parent
> > sockets get the LSM check. Could you please circulate the report more
> > widely? I'd be good to have LSM experts' eyes on this at least.
> > CCing the mailing list should help get more opinions. Thank you!
> >
> > > Function sock_create_lite() uses security_socket_create() to check.
> > > 1.    // check security_socket_create() ///////////////////////
> > > 2.    int sock_create_lite(int family, int type, int protocol, struct socket **res)
> > > 3.    {
> > > 4.      int err;
> > > 5.      struct socket *sock = NULL;
> > > 6.      err = security_socket_create(family, type, protocol, 1);
> > > 7.      if (err)
> > > 8.        goto out;
> > > 9.      sock = sock_alloc();
> > > 10.   ...
> > > 11.   }
> > >
> > > However, __sys_accept4_file() directly calls sock_alloc() without the security check.
> > > 1.    // no check ////////////////////////////////////
> > > 2.    int __sys_accept4_file(struct file *file, unsigned file_flags,
> > > 3.          struct sockaddr __user *upeer_sockaddr,
> > > 4.          int __user *upeer_addrlen, int flags,
> > > 5.          unsigned long nofile)
> > > 6.    {
> > > 7.      struct socket *sock, *newsock;
> > > 8.      struct file *newfile;
> > > 9.      int err, len, newfd;
> > > 10.     struct sockaddr_storage address;
> > > 11.     if (flags & ~(SOCK_CLOEXEC | SOCK_NONBLOCK))
> > > 12.       return -EINVAL;
> > > 13.     if (SOCK_NONBLOCK != O_NONBLOCK && (flags & SOCK_NONBLOCK))
> > > 14.       flags = (flags & ~SOCK_NONBLOCK) | O_NONBLOCK;
> > > 15.     sock = sock_from_file(file, &err);
> > > 16.     if (!sock)
> > > 17.       goto out;
> > > 18.     err = -ENFILE;
> > > 19.     newsock = sock_alloc();
> > > 20.   ...
> > > 21.   }
> > >
> > > This no-check function can be reached through syscall.
> > > syscall => __sys_accept4 => __sys_accept4_file
> > >
> > > SYSCALL_DEFINE4(accept4, int, fd, struct sockaddr __user *, upeer_sockaddr,
> > > int __user *, upeer_addrlen, int, flags)
> > > {
> > > return __sys_accept4(fd, upeer_sockaddr, upeer_addrlen, flags);
> > > }

-- 
paul moore
www.paul-moore.com
