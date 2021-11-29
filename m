Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E31A34624C5
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 23:24:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232528AbhK2W1V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 17:27:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233027AbhK2WZH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 17:25:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D707C01CB29
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 12:44:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6388EB81643
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 20:44:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF058C53FC7
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 20:44:36 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="GpzXCVzp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1638218676;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bw1P8Q23Z36L0BkuVraEt9kGUXNBVT3Z0WrYakwK2gk=;
        b=GpzXCVzpyBtvatsDTRAw21LIqzy4IMZtHISetEPwBsMbEdHDruipgC8CuNH7q+xW8PkNmi
        tIXp3retb1jGo7cboD9HEGLWXWZR7og5cRv0F7YmalBYZaEdKiSDjoT1wp04ky3N3+Crbf
        AbVXd8X/+NBYQxCOdaJOSShWAzIFpHs=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 2d0bcd99 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO)
        for <netdev@vger.kernel.org>;
        Mon, 29 Nov 2021 20:44:36 +0000 (UTC)
MIME-Version: 1.0
Date:   Mon, 29 Nov 2021 13:18:06 -0500
References: <20211129153929.3457-1-Jason@zx2c4.com>
        <20211129101712.0b74c2a8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211129101712.0b74c2a8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Message-ID: <CAHmME9o1__oLov_p_jydy6qCyzdBJBOu25amLsPRY-fMuTLq9A@mail.gmail.com>
Subject: Re: [PATCH net 00/10] wireguard/siphash patches for 5.16-rc6
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Netdev <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 29, 2021 at 1:17 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon, 29 Nov 2021 10:39:19 -0500 Jason A. Donenfeld wrote:
> > Here's quite a largeish set of stable patches I've had queued up and
> > testing for a number of months now:
> >
> >   - Patch (1) squelches a sparse warning by fixing an annotation.
> >   - Patches (2), (3), and (5) are minor improvements and fixes to the
> >     test suite.
> >   - Patch (4) is part of a tree-wide cleanup to have module-specific
> >     init and exit functions.
> >   - Patch (6) fixes a an issue with dangling dst references, by having a
> >     function to release references immediately rather than deferring,
> >     and adds an associated test case to prevent this from regressing.
> >   - Patches (7) and (8) help mitigate somewhat a potential DoS on the
> >     ingress path due to the use of skb_list's locking hitting contention
> >     on multiple cores by switching to using a ring buffer and dropping
> >     packets on contention rather than locking up another core spinning.
> >   - Patch (9) switches kvzalloc to kvcalloc for better form.
> >   - Patch (10) fixes alignment traps in siphash with clang-13 (and maybe
> >     other compilers) on armv6, by switching to using the unaligned
> >     functions by default instead of the aligned functions by default.
>
> Typo in the subject, right? No particular connection to -rc6 here?
> Just checking.

I definitely meant to type 5.16-rc4, yes, sorry. Noticed this after it
was too late.
