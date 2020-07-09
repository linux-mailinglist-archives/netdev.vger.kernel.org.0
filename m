Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B00721A857
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 22:01:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726560AbgGIUBS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 16:01:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726396AbgGIUBL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 16:01:11 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 575B0C08E806
        for <netdev@vger.kernel.org>; Thu,  9 Jul 2020 13:01:11 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id s16so1872836lfp.12
        for <netdev@vger.kernel.org>; Thu, 09 Jul 2020 13:01:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lTuFFx+LM7FvItVugeQGGweyAvmIIEb57TLVDjlPY0c=;
        b=gpjQZRBfgknPgToKf4jJopWuArBbfyzEqorYF86kvD65J4xt9C2k1qEZRGU/p+ZG5B
         Ixm+TqJgPxYDtzo7Tork0MgD4E+oSyD9y45vQMzxY2Gl01j5Rw1fKEkdy8Kx7xKkNa7P
         deM6rEIaRNzGbiTs8yY/ICU7aV11OnW8+vyLE94Wq5coWQTixDsVyBy5A49X19sDUr5B
         KnRW/U8xrlHgtu63PEPZyeniB8GhjxqRZ5zQnM4HZb6/4pRwOzrLu7qYyysUqedtnhPp
         vA9UVik+kgCkAKY+6meGwOLcvS5a9RZAKbd69JOjp9GVXoB4hdAI1odoNyp5sqtac8am
         ZBbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lTuFFx+LM7FvItVugeQGGweyAvmIIEb57TLVDjlPY0c=;
        b=WQZ3OIMKBO0ZdxWVqkgbpW5Y8/PvuBUTdY3w1oibz3maOLFf3hpxBbOy7EHVX1Xmf7
         r5r3TU18sTGmWraOYSgmRq9FcOutQOETzuzwA31JSt2tt3LNDSDXDre6S+Hka+k9uL/9
         TYFepzfHk10UPpWivJwJOiDQYRlhVA0TIFAHQhWBIg1LQhYGMEghc42Iss3Hkpp3Sq9i
         ZpcuCOJ8BLgYxqJ4akQSDJamCtqwoCoVr3WV+defz3MEdj8Wem5J7Q2Hss7KuhUwHamB
         MZ2U/ACBdQtKlyvKkkeZsl5vvEoy5Eb/HwdpILVYCLEbe3EfzN/fVnSdBXVruLt+IMbV
         DzFg==
X-Gm-Message-State: AOAM5320BJqunsD0h+yrU8VK3Dmt7Ls3WLbjKP5yoPGtrHspedTfqpCH
        HiEwXXLGatPhpVcrsRLfZWMa2dw95YeVF5xrc+nG3g==
X-Google-Smtp-Source: ABdhPJzMEObKGztP4FkJdtpJ/jsigQq5atbT70AaZs8psKw5IErg+CIW340AK74bJ/ktHqLM57A7CacQhNPzzfvbILs=
X-Received: by 2002:a05:6512:3107:: with SMTP id n7mr42006913lfb.63.1594324868930;
 Thu, 09 Jul 2020 13:01:08 -0700 (PDT)
MIME-Version: 1.0
References: <20200709182642.1773477-1-keescook@chromium.org> <20200709182642.1773477-3-keescook@chromium.org>
In-Reply-To: <20200709182642.1773477-3-keescook@chromium.org>
From:   Jann Horn <jannh@google.com>
Date:   Thu, 9 Jul 2020 22:00:42 +0200
Message-ID: <CAG48ez1gz3mtAO5QdvGEMt5KnRBq7hhWJMGS6piGDrcGNEdSrQ@mail.gmail.com>
Subject: Re: [PATCH v7 2/9] pidfd: Add missing sock updates for pidfd_getfd()
To:     Kees Cook <keescook@chromium.org>
Cc:     kernel list <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Sargun Dhillon <sargun@sargun.me>,
        Christian Brauner <christian@brauner.io>,
        Tycho Andersen <tycho@tycho.ws>,
        David Laight <David.Laight@aculab.com>,
        Christoph Hellwig <hch@lst.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Aleksa Sarai <cyphar@cyphar.com>,
        Matt Denton <mpdenton@google.com>,
        Chris Palmer <palmer@google.com>,
        Robert Sesek <rsesek@google.com>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Will Drewry <wad@chromium.org>, Shuah Khan <shuah@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        Linux API <linux-api@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 9, 2020 at 8:26 PM Kees Cook <keescook@chromium.org> wrote:
> The sock counting (sock_update_netprioidx() and sock_update_classid())
> was missing from pidfd's implementation of received fd installation. Add
> a call to the new __receive_sock() helper.
[...]
> diff --git a/kernel/pid.c b/kernel/pid.c
[...]
> @@ -642,10 +643,12 @@ static int pidfd_getfd(struct pid *pid, int fd)
>         }
>
>         ret = get_unused_fd_flags(O_CLOEXEC);
> -       if (ret < 0)
> +       if (ret < 0) {
>                 fput(file);
> -       else
> +       } else {
>                 fd_install(ret, file);
> +               __receive_sock(file);
> +       }

__receive_sock() has to be before fd_install(), otherwise `file` can
be a dangling pointer.
