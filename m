Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 666A113DE20
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 15:55:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726965AbgAPOzA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 09:55:00 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:33457 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726160AbgAPOzA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 09:55:00 -0500
Received: by mail-lj1-f195.google.com with SMTP id y6so23066339lji.0
        for <netdev@vger.kernel.org>; Thu, 16 Jan 2020 06:54:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zUc9+k1rcXsy9V4HYiOJ5EEGd0ukDuWJyEuWW7IqVws=;
        b=FYGWeKjvPVNNBJ3gDLF5gtpSnVvwqzDVVt/wFix70ynRZ5rwG82fcIMMma9wyc8hr5
         T1QgPohZWRkUl6VxaFsMehzSCpslBUvTaDGqokq2PyfTHaFokMy6Gp9He9IAHGqN75F4
         3/kR8Qy9agAQZRYSRtFlGOk5kNpuIncJFg/kdCHIzbfXJkM0Eke0utiiYsEyhsvkKM9C
         FDkvWBORyEXQPDxezArlGMJVaRNNIBy8pdVVQCVa73FIvw6A0ME+OZ4V7cXNJm4wnc5P
         psJJbKWMLxThmz3RLTmSdvBlmMb4dN/NXkWmzCCpIHdYhCHlRcl8mWVEyW8xjbYh/fib
         lV0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zUc9+k1rcXsy9V4HYiOJ5EEGd0ukDuWJyEuWW7IqVws=;
        b=c1osDl+CqEnv0VCNKxI/6cxj3JthtGT/4npswm+QMF6LVCuvLXJrZsDPdeXi2wYX3D
         7FQ+2vxOkRE61niolRqtZVESeImkaVihx7LBKXkFnKwij6IN7pSik9hX187jQFuCJhcB
         D3kXBHHCqx3Q6j8xx8CDWu4gCeRWU0xiFGfxQYtth8D06klU19ihDGhiVFVj8Tlt/ass
         K/9lnCuqGv1JhRAiSNrDQlo1T/OjohQTpsp9nt5s/oVzqSXuFDmFWnrTPF09SHAo0Nc1
         eumhJw4onVOAl8Bzd5EnMlwwKqsmO7rCkwyXjVDc7vM81AmJkTr1ehMmZW2N6M67DOlk
         eIUA==
X-Gm-Message-State: APjAAAUufu0Ge00T+YCHa5KXn0oJUtx9CsDcPho8MTlbDLs2zuIKU/UJ
        xAV7RArlkO3E85+Qqin9axrd6MFIue/qpxh47OY=
X-Google-Smtp-Source: APXvYqziHB+7XT13sYjQ+wORVQSMMYt9L/38ka+va4DXTYtaBp3077zZNqiigAKHco6G3WNaO+bIEMgC+Vot5oSJfR0=
X-Received: by 2002:a2e:880a:: with SMTP id x10mr2537589ljh.211.1579186498032;
 Thu, 16 Jan 2020 06:54:58 -0800 (PST)
MIME-Version: 1.0
References: <20200111163723.4260-1-ap420073@gmail.com> <20200112064110.43245268@cakuba>
In-Reply-To: <20200112064110.43245268@cakuba>
From:   Taehee Yoo <ap420073@gmail.com>
Date:   Thu, 16 Jan 2020 23:54:46 +0900
Message-ID: <CAMArcTUZ476vinLb2f+JfGB209=qYeSWFgAHgb4DJdt4o9OHKw@mail.gmail.com>
Subject: Re: [PATCH net 3/5] netdevsim: avoid debugfs warning message when
 module is remove
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>, Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 12 Jan 2020 at 23:45, Jakub Kicinski <kuba@kernel.org> wrote:
>

Hi Jakub,
Thank you for catching the problem!

> On Sat, 11 Jan 2020 16:37:23 +0000, Taehee Yoo wrote:
> > When module is being removed, it couldn't be held by try_module_get().
> > debugfs's open function internally tries to hold file_operation->owner
> > if .owner is set.
> > If holding owner operation is failed, it prints a warning message.
>
> > [  412.227709][ T1720] debugfs file owner did not clean up at exit: ipsec
>
> > In order to avoid the warning message, this patch makes netdevsim module
> > does not set .owner. Unsetting .owner is safe because these are protected
> > by inode_lock().
>
> So inode_lock will protect from the code getting unloaded/disappearing?
> At a quick glance at debugs code it doesn't seem that inode_lock would
> do that. Could you explain a little more to a non-fs developer like
> myself? :)
>
> Alternatively should we perhaps hold a module reference for each device
> created and force user space to clean up the devices? That may require
> some fixes to the test which use netdevsim.
>

Sorry, I misunderstood the debugfs logic.
inode_lock() is called by debugfs_remove() and debugfs_create_file().
It doesn't protect read and write operations.

Currently, I have been taking look at debugfs_file_{get/put}() function,
which increases and decreases the reference counter.
In the __debugfs_file_removed(), this reference counter is used for
waiting read and write operations. Unfortunately, the
__debugfs_file_removed() isn't used because of "dentry->d_flags" value.
So, I'm looking for a way to use these functions.

Thanks a lot!
Taehee Yoo
