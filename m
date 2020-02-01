Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D805514FA1A
	for <lists+netdev@lfdr.de>; Sat,  1 Feb 2020 20:08:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726814AbgBATIt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Feb 2020 14:08:49 -0500
Received: from mail-ot1-f45.google.com ([209.85.210.45]:41763 "EHLO
        mail-ot1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726270AbgBATIs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Feb 2020 14:08:48 -0500
Received: by mail-ot1-f45.google.com with SMTP id r27so9842061otc.8
        for <netdev@vger.kernel.org>; Sat, 01 Feb 2020 11:08:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JTbnb9aEXiUcTMCHd/pR5Wrwq0T/BCsh9rlf5HGyNTc=;
        b=hwfQVJzKS0I5H37ocGwj3q4670YrHSnEoMJKV8yaqnmeIwspqrMqfElgzGHYu6Tay0
         jr84xoM9unWRNllKuyT/Vk0M3oSaMPT0GOn7qeM9oLGG1R5xc7yWRcuIKoE6VdITlDi1
         1bPH7Ri3BR4VKrBdIKHrUEkVE7PqeNwGILp63crk80qqqELxRsLOwlyQGkeo982V9CV4
         KTvLaO2K9OurFtsYRUKYVgYwsF/srO3WDkskPdouEXv0qAHlTdf3MH/WuPN2Cp++OAzt
         WoKShwa5YjgLAo/gSogUU07doLxtWiwLkmPE2TZ2y5jBupMuk2RImaDcYL8aK8pfLa3T
         2UAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JTbnb9aEXiUcTMCHd/pR5Wrwq0T/BCsh9rlf5HGyNTc=;
        b=OQllHa6bOr4h1dotN2DBp2S8u+QCXCqEqJk59o/IxOaGQVmgbtVb94sWLF9oD5jhwx
         Y4V3JMqj3eajh43UtBa/UJn/ojmdtwWJmAJGlAoH5ujXPpp1xA8NXK7c4fEJF6WShWov
         qb608JJ+edyG7DSmXWxcPcisQNpOAbGkfdR7jHrzq8tPiTgCYJkrCxSybbCOTTS1DMsW
         JDQK14O4IvpUqVt8HtBjOYa7mWsswbnB6udQZezHgrgQLZ9TvtO2UB5MTV3DDeaH4O5B
         Zo8UKEr1Y63NoxR1pUWw7GSrjcW+UGyqQPyB2buxSKOJW8tDM7pOZbOWu4rwfkK7nkK+
         dWqw==
X-Gm-Message-State: APjAAAWX81L/ZN/IjIY/6WIc3NLCi4MxfTTlBgLxSKbaFp24tBOERhIs
        B/UgGPn92vZhiSaoqvQK7LSexyHTtorm3SykeU4=
X-Google-Smtp-Source: APXvYqy6ZVptPtTuzuoJqIz6XCZqTa+gc7TKpjiSeTzF8DX++PcAJr3divb3VembQ3BpsvHqRbHHczEwKK0rIgWXJj4=
X-Received: by 2002:a9d:53c4:: with SMTP id i4mr12759798oth.48.1580584127995;
 Sat, 01 Feb 2020 11:08:47 -0800 (PST)
MIME-Version: 1.0
References: <CAJx5YvHH9CoC8ZDz+MwG8RFr3eg2OtDvmU-EaqG76CiAz+W+5Q@mail.gmail.com>
In-Reply-To: <CAJx5YvHH9CoC8ZDz+MwG8RFr3eg2OtDvmU-EaqG76CiAz+W+5Q@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sat, 1 Feb 2020 11:08:37 -0800
Message-ID: <CAM_iQpUcGr-MHhWBxhL01O-nxWg1NPM8siEPkYgckyDT+Ku3gA@mail.gmail.com>
Subject: Re: Why is NIC driver queue depth driver dependent when it allocates
 system memory?
To:     Martin T <m4rtntns@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 30, 2020 at 5:03 AM Martin T <m4rtntns@gmail.com> wrote:
>
> Hi,
>
> when I read the source code of for example tg3 driver or e1000e
> driver, then looks like the driver queue is allocated from system
> memory. For example, in e1000_ethtool.c kcalloc() is called to
> allocate GFP_KERNEL memory.
>
> If system memory is allocated, then why are there driver-dependent
> limits? For example, in my workstation the maximum RX/TX queue for the
> NIC using tg3 driver is 511 while maximum RX/TX queue for the NIC
> using e1000e driver is 4096:

I doubt memory is a consideration for driver to decide the number
of queues. How many CPU's do you have? At least mellanox driver
uses the number of CPU's to determine the default value. Anyway,
you can change it to whatever you prefer.

Thanks.
