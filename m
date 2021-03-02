Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE39332B397
	for <lists+netdev@lfdr.de>; Wed,  3 Mar 2021 05:20:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1449795AbhCCEDq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 23:03:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1839538AbhCBQhX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Mar 2021 11:37:23 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3F81C06121D
        for <netdev@vger.kernel.org>; Tue,  2 Mar 2021 08:10:27 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id ci14so17267956ejc.7
        for <netdev@vger.kernel.org>; Tue, 02 Mar 2021 08:10:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vJDGGYw7tvcK+titjb5UUUKjKogKFbuBWfwBQn8pnpY=;
        b=BlJkHpJ9gb2T6xH4d7E6DsfDVr0uh9W/Z84RVzgIuhv/Qy8ZfKayi3gWppMi4kMSXj
         LErYX2rZn36FwdYsyG3kZGhKii9OoE6QpO+PUmmCSk5lI0YW5riJfIK1VIJMyxoFUqoG
         379zxil7FtYzj0JPDQ2/87FgaXDypPkhU6TdwiaOl1WwN7NDqt+HBSgJOKFX9abjwpm+
         cmJg9XDLYsaLp3xMOouOx7bqSBYoOvemqiKQ9XQXF+QPWZWPgXYG8shXQT06TnlRZRY4
         x1zbduD4zPKj1TxcyaFrvvER8rnfiuu4G4X+MFT1K2gnsJTkZqi8JDtf5Sb59DPOWwEh
         pHFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vJDGGYw7tvcK+titjb5UUUKjKogKFbuBWfwBQn8pnpY=;
        b=TMTuvqciFtsZxTjBH8FKVbew0/zohjqjapqr7M5oJOaG8kFO0+qP6ihQHAU2/q2ow8
         6OCohcJ/MKXuVsStw/CrvJXOlVJ6UQCbiIrw3xarvyNcfT95uY8sjQGFw2qvzTxjy6yA
         PeGfDFTKuoMGi0fzc9xdPrG4Jyl+czQMXpy22Q1OwmJV7aKvcPIS6O0cVpuTmcjgGRuI
         bW/o9GhegsuLASMGEEbGkqfZLFBLyaL4TgLZdjt+1OQEActx5mU6FFE9biIIINdhmGRz
         Ugvb1auUT1DD8fbFZIBI+oDMxyXmU6BiHb1KeOQles/tM0TQwlE40EuqmA+VXzDNbH4F
         MbbQ==
X-Gm-Message-State: AOAM530S64sznRkXKmbj6onuu7yFKEZrzcH8W/CuFj/ENLIfMVNvLzYT
        5CUxoxjsaIg7uJmw5sNsgOlZ3C7eYLd05bTzJD2O
X-Google-Smtp-Source: ABdhPJx8PQFaZgOM2xUwSD8DpzvBCZqhortPrXsbuQRmYKE4KenPCbP0EoVbTKZ9wj1YIut8Zj0gMSbUKh7l4apxoGg=
X-Received: by 2002:a17:906:7056:: with SMTP id r22mr6639665ejj.106.1614701426386;
 Tue, 02 Mar 2021 08:10:26 -0800 (PST)
MIME-Version: 1.0
References: <0000000000006305c005bc8ba7f0@google.com> <CACT4Y+YFtUHzWcU3VBvxsdq-V_4hN_ZDs4riZiHPt4f0cy8ryA@mail.gmail.com>
In-Reply-To: <CACT4Y+YFtUHzWcU3VBvxsdq-V_4hN_ZDs4riZiHPt4f0cy8ryA@mail.gmail.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Tue, 2 Mar 2021 11:10:15 -0500
Message-ID: <CAHC9VhTxrGgBDW_439HeSP=_F9Jt2_cYrrQ7DtAXtKG4evGb9g@mail.gmail.com>
Subject: Re: KASAN: use-after-free Read in cipso_v4_genopt
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     syzbot <syzbot+9ec037722d2603a9f52e@syzkaller.appspotmail.com>,
        David Miller <davem@davemloft.net>, dsahern@kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 2, 2021 at 6:03 AM Dmitry Vyukov <dvyukov@google.com> wrote:
>

...

> Besides these 2 crashes, we've also seen one on a 4.19 based kernel, see below.
> Based on the reports with mismatching stacks, it looks like
> cipso_v4_genopt is doing some kind of wild pointer access (uninit
> pointer?).

Hmm, interesting.  Looking quickly at the stack dump, it appears that
the problem occurs (at least in the recent kernel) when accessing the
cipso_v4_doi.tags[] array which is embedded in the cipso_v4_doi
struct.  Based on the code in cipso_v4_genopt() it doesn't appear that
we are shooting past the end of the array/struct and the cipso_v4_doi
struct appears to be refcounted correctly in cipso_v4_doi_getdef() and
cipso_v4_doi_putdef().  I'll look at it some more today to see if
something jumps out at me, but obviously a reproducer would be very
helpful if you are able to find one.

It's also worth adding that this code really hasn't changed much in a
*long* time, not that this means it isn't broken, just that it might
also be worth looking at other odd memory bugs to see if there is
chance they are wandering around and stomping on memory ...

-- 
paul moore
www.paul-moore.com
