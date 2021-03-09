Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E7BD332F24
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 20:38:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231387AbhCITiQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 14:38:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231138AbhCIThw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 14:37:52 -0500
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBE16C06174A
        for <netdev@vger.kernel.org>; Tue,  9 Mar 2021 11:37:51 -0800 (PST)
Received: by mail-yb1-xb2b.google.com with SMTP id b10so15214421ybn.3
        for <netdev@vger.kernel.org>; Tue, 09 Mar 2021 11:37:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=E8irDDILWp3uBM3f6tu3LKVe1+TSzdb0Tt57sXKreYU=;
        b=qfeeYnKuiG1V3FUWsFo7dR9z/gsazQFQQbVFEOFyHAkexd0DMSkpr25PApuefzEy92
         kdO5e+gjVLmK9JwTWezRnzU4p4rM1G0nQcQnzUXeYpxAwhGXoskWZVLRWDU3ggLZc00C
         mjGMiv2FjZcuhboQTFPoYloI8UX9vtOR/yHo75gKk15cUV27it28Ll0ypd23J85fR+8H
         nOHms3sx8Xh6gMYReVxqDEo6x+rCfHrxH1oKzOiCA+EPZudXqJQ2bbkkA05rOuYZomn2
         EMmzFciiMzB+k89khKDTWxatYLFI/OH9xN9mYuZY+PQzTHuaAzyzuhiajhloZmcLoZZz
         iVeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=E8irDDILWp3uBM3f6tu3LKVe1+TSzdb0Tt57sXKreYU=;
        b=T6dzPAu+62y8hfcbKk13bCCe87kThrnPITimUdWtLJIQZgJ5ZPfGxDXVKViWWZUegC
         O8X3JebXObuoitibGz6LGTmWWhqmuwLY7v8rX7jlUA5Xe281/ejD6lmDUak6M/dcEDN/
         C7xzeOl7Kseou7tDkQQBvMxdqfTQEBZwd4Rg2B5KFvz0F818y8K2CfXscm2LE8j+aQ3N
         rOs1i5hYStSEiFUDrXAoSi+EH9+j9Kp5QOj+QzTUaLTq63/3ix0aihE02XwCAfEOVEKX
         sQNr4IpUl8Y8Rk+9Fh9uYNftZAPCrNxDlgALGVzlkMzeOgl7+fPrm0jKv+FXaBCzY5Hh
         yflg==
X-Gm-Message-State: AOAM533YUOlUIMuQgxAd4wpxVCtod0HD3FjCdlZZAyxTNIzPAomaLYis
        LJGsFIhJ8LpBFt/g209NC7IjNyf22I8Y5292fYAHiDJzn/M=
X-Google-Smtp-Source: ABdhPJwbOKIStBz7cI3JOtnT9V7qPikxw451fccWVyqle96FRJhaThcdZLJIHJ4KvfXEtt2YYyM5em4cqDCLzZaufPk=
X-Received: by 2002:a25:d016:: with SMTP id h22mr42660083ybg.278.1615318670842;
 Tue, 09 Mar 2021 11:37:50 -0800 (PST)
MIME-Version: 1.0
References: <20210308192113.2721435-1-weiwan@google.com> <0d18e982-93de-5b88-b3a5-efb6ebd200f2@gmail.com>
 <YEcukkO7bsKYVqEZ@shredder.lan> <CAEA6p_C8TRWsMCvs2x7nW9TYUwEyBrL46Li3oB-HjNwUDjNcwQ@mail.gmail.com>
 <f4ffcaf3-adfe-3623-2779-fc9ce1a363ce@gmail.com>
In-Reply-To: <f4ffcaf3-adfe-3623-2779-fc9ce1a363ce@gmail.com>
From:   Wei Wang <weiwan@google.com>
Date:   Tue, 9 Mar 2021 11:37:40 -0800
Message-ID: <CAEA6p_BGpiKmjEMr9TpuSdbK_hsxa+fPzeB6YTRzm59MSXisCw@mail.gmail.com>
Subject: Re: [PATCH net] ipv6: fix suspecious RCU usage warning
To:     David Ahern <dsahern@gmail.com>
Cc:     Ido Schimmel <idosch@idosch.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        syzbot <syzkaller@googlegroups.com>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 9, 2021 at 11:33 AM David Ahern <dsahern@gmail.com> wrote:
>
> On 3/9/21 10:32 AM, Wei Wang wrote:
> > Thanks David and Ido.
> > To clarify, David, you suggest we add a separate function instead of
> > adding an extra parameter, right?
>
> for this case I think it is the better way to go.

OK. Will send out v2 for this.
