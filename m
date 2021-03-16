Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE93533D85A
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 16:56:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238198AbhCPPzd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 11:55:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238233AbhCPPzL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 11:55:11 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2424C06174A;
        Tue, 16 Mar 2021 08:55:09 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id f8so3638602plg.10;
        Tue, 16 Mar 2021 08:55:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CBzNMbocqQsxjfYGQ1EhaQ7uFSjRE7ceXnc5NaxO654=;
        b=dzYeJ1wT59wMMvs2pHK2ATQt++uhGR6mEwuyp6H838gqPrjAtdIn8X+UFolhukHeA8
         caizWrUGEZqOdTqUFiWzGujq+dB3/3hDN0NoJcoinZxQTWZ4os+Akv36qyhFVSjtsLU2
         H74inxcj/t1xEgHW+m3dduB4p+HWhaNA/P2am3AE7Wi/6Vl7MbN7EgXl41+y5r/Yo1E5
         FH+TxtBOEvAe4mWVrhkkYj/LR2mS8C5yn5yh9KYsBvaFN5/occy7WT36l3e/9dSmk/sx
         PpIBuz4gsWUext5EBRiig+47KKa/slOpmtyOHKmye6pvASAljooIt/epYNza3H609FHO
         FZDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CBzNMbocqQsxjfYGQ1EhaQ7uFSjRE7ceXnc5NaxO654=;
        b=NXQQ5ztFglsqpb5P/Tp5VcE6ZQW1jewJLB69W1JKh5ByoN6Ucwij/6wKTfL0nnsVVT
         x6Vc3vztetR42HMtFFQ3DSURKlYoeYDMr72HNTtPH3Rck3aRo1PtmItgksx8viREU8fS
         huzETDkRbf2H8Gs3TUxdIUhe7AWfxgVl0UGppyQFnR/lIINnSRya6ErTPPuZffgl2FlA
         Wj0nKGwyt0hCnJgPNUE82oe7FLHaVEtMjxXOozoVh7Vm0FM/dttQFIqGX3dyhEdoOHmK
         09e0JVoHborMq3lAo1vAiaWPPuClREbUVUr9Qw0c2qe6Hpr5XM465RijVoVvj8U0FOCs
         +7Xw==
X-Gm-Message-State: AOAM531xq0XKkMUR3NjLRAxukAzRugewo8NgBMeyHWjRAFwX6oR5kPf+
        5FiUao/LgV5w0MU1KlwBPtoaNm/E2vPTd7qQc7o=
X-Google-Smtp-Source: ABdhPJwNfzehECf4Y6hcy0GFboZ85XdYW6NRzzEnRsuM7ixoqnV09A48CrHjEoP1DwcrNXLtesjL6gxh9/g4DeAZETE=
X-Received: by 2002:a17:90a:ea91:: with SMTP id h17mr345965pjz.66.1615910109592;
 Tue, 16 Mar 2021 08:55:09 -0700 (PDT)
MIME-Version: 1.0
References: <20210311072311.2969-1-xie.he.0141@gmail.com> <CAJht_ENT6E4pekdTJ8YKntKdH94e-1H6Tf6iBr-=Vbxj5rCs+A@mail.gmail.com>
 <111a4642c8ae3c9e0d9f271fe7c54e86@dev.tdt.de>
In-Reply-To: <111a4642c8ae3c9e0d9f271fe7c54e86@dev.tdt.de>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Tue, 16 Mar 2021 08:54:58 -0700
Message-ID: <CAJht_EOLKSv=0A86GafDWTG1sEFNJCmFBH5QsdOtx28GzPL_pQ@mail.gmail.com>
Subject: Re: [PATCH net] net: lapbether: Prevent racing when checking whether
 the netif is running
To:     Martin Schiller <ms@dev.tdt.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux X25 <linux-x25@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 16, 2021 at 8:17 AM Martin Schiller <ms@dev.tdt.de> wrote:
>
> On 2021-03-14 02:59, Xie He wrote:
> > Hi Martin,
> >
> > Could you ack? Thanks!
>
> Acked-by: Martin Schiller <ms@dev.tdt.de>

Thank you!!
