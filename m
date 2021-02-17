Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CCEA31DE4E
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 18:35:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234437AbhBQRex (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 12:34:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234496AbhBQRdb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Feb 2021 12:33:31 -0500
Received: from ms.lwn.net (ms.lwn.net [IPv6:2600:3c01:e000:3a1::42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89963C0613D6;
        Wed, 17 Feb 2021 09:32:50 -0800 (PST)
Received: from localhost (unknown [IPv6:2601:281:8300:104d::5f6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ms.lwn.net (Postfix) with ESMTPSA id 202E677F;
        Wed, 17 Feb 2021 17:32:50 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 202E677F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
        t=1613583170; bh=7h0D63BQ0DnKqu3SxWKB+yxCVCyldHVF+7Zggt0SEd8=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=pQCIxTZ1SQqrD16cuDkQmKGwmJ/9IrdPPk6kf2l+cRpi8X88gdroZgB1802QOymsz
         pj0PaHvaqdpgCJtgtD5ga7vU6k43MVJvocTIbPp5pXnSem/sLFYTiz76zhrHWZyPa6
         zJSbTfvNtP1Y+FrUgCWzp6kkviqQo36Kww225LnLMU17437bbCRCkkf4+8NJrAd0db
         Hk9RPop2QC9QibaR7cKjyiWFDY/AQulbkOH+dqUT9acqjkh1MMFs7D17fSJvjdaB8l
         XIv7Zu1riv+EijztY339v0KXNmYuDI9JID7RxEK8tC2doAsVXB8QmzOJkou0Uk/Myg
         g9c1kHIc3Ow3Q==
From:   Jonathan Corbet <corbet@lwn.net>
To:     Joe Stringer <joe@wand.net.nz>, bpf@vger.kernel.org
Cc:     Joe Stringer <joe@cilium.io>, linux-man@vger.kernel.org,
        netdev@vger.kernel.org, mtk.manpages@gmail.com, ast@kernel.org,
        brianvv@google.com, daniel@iogearbox.net, daniel@zonque.org,
        john.fastabend@gmail.com, ppenkov@google.com,
        quentin@isovalent.com, sean@mess.org, yhs@fb.com,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH bpf-next 00/17] Improve BPF syscall command documentation
In-Reply-To: <20210217010821.1810741-1-joe@wand.net.nz>
References: <20210217010821.1810741-1-joe@wand.net.nz>
Date:   Wed, 17 Feb 2021 10:32:49 -0700
Message-ID: <871rdewqf2.fsf@meer.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[CC += linux-doc]

Joe Stringer <joe@wand.net.nz> writes:

> From: Joe Stringer <joe@cilium.io>
>
> The state of bpf(2) manual pages today is not exactly ideal. For the
> most part, it was written several years ago and has not kept up with the
> pace of development in the kernel tree. For instance, out of a total of
> ~35 commands to the BPF syscall available today, when I pull the
> kernel-man-pages tree today I find just 6 documented commands: The very
> basics of map interaction and program load.
>
> In contrast, looking at bpf-helpers(7), I am able today to run one
> command[0] to fetch API documentation of the very latest eBPF helpers
> that have been added to the kernel. This documentation is up to date
> because kernel maintainers enforce documenting the APIs as part of
> the feature submission process. As far as I can tell, we rely on manual
> synchronization from the kernel tree to the kernel-man-pages tree to
> distribute these more widely, so all locations may not be completely up
> to date. That said, the documentation does in fact exist in the first
> place which is a major initial hurdle to overcome.
>
> Given the relative success of the process around bpf-helpers(7) to
> encourage developers to document their user-facing changes, in this
> patch series I explore applying this technique to bpf(2) as well.

So I am totally in favor of improving the BPF docs, this is great work.

That said, I am a bit less thrilled about creating a new, parallel
documentation-build system in the kernel.  I don't think that BPF is so
special that it needs to do its own thing here.

In particular, I would love to have the bpf() syscall API information
incorporated into the userspace-api book with all the rest of the
user-space API docs.  That could be done now by formatting your
information as a DOC: block.

If you started that way, you'd get the whole existing build system for
free.  You would also have started down a path that could, some bright
shining day, lead to this kind of documentation for *all* of our system
calls.  That would be a huge improvement in how we do things.

The troff output would still need implementation, but we'd like to have
that anyway.  We used to create man pages for internal kernel APIs; that
was lost in the sphinx transition and hasn't been a priority since
people haven't been screaming, but it could still be nice to have it
back.

So...could I ask you to have a look at doing this within the kernel's
docs system instead of in addition to it?  Even if it means digging into
scripts/kernel-doc, which isn't all that high on my list of Fun Things
To Do either?  I'm willing to try to help, and maybe we can get some
other assistance too - I'm ever the optimist.

Thanks,

jon
