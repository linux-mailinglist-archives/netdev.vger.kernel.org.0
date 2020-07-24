Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 062FD22BDDD
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 08:04:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726583AbgGXGEf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 02:04:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725898AbgGXGEf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 02:04:35 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3797FC0619D3
        for <netdev@vger.kernel.org>; Thu, 23 Jul 2020 23:04:35 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id t131so8728493iod.3
        for <netdev@vger.kernel.org>; Thu, 23 Jul 2020 23:04:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KTngSbr/Hor/XrCHd0GuebUqV9yuzFp4bYNZbr5WWnw=;
        b=bdUd+A62eS0tAHaCTfik66c65qJdQe9eAEcdsNvDmnVro06Oy5lXLCPsT9BacgnkVc
         fCZnJIB1goUD89UqBrbdSN/u+eXZVH1oRfzDdHVxSATRLmm3XT0pTKjS6RFIj3MP+wuS
         iJztVUONyeLW5tweLWMk2Polj3tRlHxzxzSWhj5manwsopRglvM98YspyLZKvOWKw+6f
         iAVN6AG1afOapaIJfGzEY2hIJar8nhYe9ThgzjAPrfY7roEfsBBdsGQQ30311+YngViQ
         dzEv1OX0Tuc9XpWFS/Tn5DObYVhFw0n4c2KyC4HvtXqWIkJTb3WFoLf8hSbjn2eJb3fW
         0/GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KTngSbr/Hor/XrCHd0GuebUqV9yuzFp4bYNZbr5WWnw=;
        b=L3fJkiKHqu+CveqOuhjufIB/ZJy5M14FeABYXtFUGDuz0WInF6jpwKuZ0iDxLuQEhO
         OSfPfs7/hxDYBOsTNt08cN6NeZrBBz4i3HbEdp2+oaGLUupKV3KZAUx8DJEPxpjZXMm7
         zZDcNDiqFpZOsutA25+qyRm4uE/G945xxLeFQXsV1DDVZmhLknyRDLzyu4++46y84cMo
         ac5+Wzo8I5caBuwr7sIVMdHlJk3k0qy/sSR3JoOB4es6dUQBh0eWrbDFi6vXi5L3vypJ
         dnh80epENH7WFG8jz5ySltzTdB8RsZA7f2lljWCs0A9GxraMxH4fqLfBnv34H+htlZLF
         dS+A==
X-Gm-Message-State: AOAM532fOaHtiQLblFAwTFdJISWk5kQmu4BjQgC+QO6jloJd6fusgmDl
        hmNu33WAggf/uvOQz+81xfiq+2h3PZehkjp57js=
X-Google-Smtp-Source: ABdhPJw6GV0L404BJs03DFk+OAe0dJ38BXw+02QptvsUwzmz3jQXYkgEjwreB5iMRGKzwnaAbCMiqQA86qiloLdGgVw=
X-Received: by 2002:a05:6602:1225:: with SMTP id z5mr8887109iot.64.1595570674577;
 Thu, 23 Jul 2020 23:04:34 -0700 (PDT)
MIME-Version: 1.0
References: <20200724045040.20070-1-xiyou.wangcong@gmail.com>
 <590b7621-95bf-1220-f786-783996fd4a4c@gmail.com> <CAM_iQpW+TmWjFu=gqDkAVPZ9q6PkJAfMeu87WJ98d-c2PxWoQA@mail.gmail.com>
In-Reply-To: <CAM_iQpW+TmWjFu=gqDkAVPZ9q6PkJAfMeu87WJ98d-c2PxWoQA@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 23 Jul 2020 23:04:23 -0700
Message-ID: <CAM_iQpVu1U44Vm0ComRamVpuzskRPiBr6O+8=H+iff4oL2i5Jw@mail.gmail.com>
Subject: Re: [Patch net] qrtr: orphan skb before queuing in xmit
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        syzbot <syzbot+6720d64f31c081c2f708@syzkaller.appspotmail.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 23, 2020 at 11:00 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> I said socket, not sock. I believe the socket can be gone while the sock is
> still there.

Hmm, looks llike sock_orphan() should be called...
