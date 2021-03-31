Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5BAB3509AA
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 23:41:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232796AbhCaVkc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 17:40:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232417AbhCaVkP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 17:40:15 -0400
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A862C061574
        for <netdev@vger.kernel.org>; Wed, 31 Mar 2021 14:40:15 -0700 (PDT)
Received: by mail-yb1-xb2d.google.com with SMTP id g38so22689440ybi.12
        for <netdev@vger.kernel.org>; Wed, 31 Mar 2021 14:40:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bxPhM9HTYSi093y5XhRYJdbA77bxb8mqeGUor7xP2yE=;
        b=XwSm4jJV+3xAzbKcA+2WL4fUeE9ss3ShwNKfbSx/LfWhd8DrZO208p9UnO6po0R7HE
         soxj4GqnYrQySKRSFvcN4BPJtJHASf42KPGzjut1hHWew9grKRoK1pn22/oRIbwotAyX
         rPL5CtlyW4ekso4Am7g8jx9fS33TKpRLN0HX8IxhJFsGJ6vgWWueX5WbMwjfxOUyZ9MV
         4Ic7pGaQKJIEfDCI+X+beZuvQxuxa8eskg4vm+3SmRAUfgq0liGd29AP5oieIjkOzYhO
         4Qus8J4R5VmMHhQGMinFYzK8WqF0r3jPIvJyqpfMJfG6n/GKrVUtMzHBzNi4wZKsnhb6
         UqUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bxPhM9HTYSi093y5XhRYJdbA77bxb8mqeGUor7xP2yE=;
        b=D46jvzaXmJi0VOyMNSScvcJJBxa45PdyKV/BiAJZfs41vjIbFC1aktsE4Qwv6wHd0S
         ijTjmVzMyH7hKMTarC0IGL8uENouxYAsmxlL0TMq7OHrj50H1oGR355udKFvdy7oc7/u
         Cg72+Hbtpv0lCng5Gz209/G+UCgqnes5uWPmyv854HUJfkyagy8+fs77eYny8Pg5LuJS
         KUqOsZWVmauzeV+p+3cxG66/laY+JaGj9iSeahrZlQMVAZI5tdi1n9W/ibYlkw3+8mzr
         95mn3Kbmd9U/fT0RNmVMAalDOca4oarW0nSTDlD+kk82KhGNpkja5CqUeu1L27EJt7m9
         4gLw==
X-Gm-Message-State: AOAM5300KBJ55zVZU6ikaJ7o+qydypFkRXVKF3hVjRNsfsmZ5dF5ffLP
        X9ELJBmWqYKixORgAvLs5pOFSaQlMXAj5C23cDAdRWpDPI4=
X-Google-Smtp-Source: ABdhPJwCMeNPH/Tijq6N9MNeOUfqWA5PBv8QKtHiYOm/DRRNzifboW1mvnSHTNo06W0zcTcXMiskRfe+4BjkMrOf46M=
X-Received: by 2002:a25:6a88:: with SMTP id f130mr7600963ybc.234.1617226814452;
 Wed, 31 Mar 2021 14:40:14 -0700 (PDT)
MIME-Version: 1.0
References: <20210330064551.545964-1-eric.dumazet@gmail.com>
 <CANn89i+YuMR6DuNk8YFZvHavxRCSNRp8MpC=rWz75N0CtN82DQ@mail.gmail.com> <20210331.143855.2005036124197875041.davem@davemloft.net>
In-Reply-To: <20210331.143855.2005036124197875041.davem@davemloft.net>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 31 Mar 2021 23:40:02 +0200
Message-ID: <CANn89iJLmEjzicmUoh_Hp7qL9ZAPbEqAE-+PFkGsXGDbH9Tuag@mail.gmail.com>
Subject: Re: [PATCH net-next] ip6_tunnel: sit: proper dev_{hold|put} in
 ndo_[un]init methods
To:     David Miller <davem@davemloft.net>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 31, 2021 at 11:39 PM David Miller <davem@davemloft.net> wrote:
>
> From: Eric Dumazet <edumazet@google.com>
> Date: Wed, 31 Mar 2021 08:00:24 +0200
>
> > Can you merge this patch so that I can send my global fix for fallback
> > tunnels, with a correct Fixes: tag for this patch ?
>
> Done.

Thanks a lot David, I have sent the followup patch, with updated Fixes: tags.
