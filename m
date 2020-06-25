Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EC8120A1FD
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 17:33:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405780AbgFYPdD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 11:33:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405760AbgFYPdC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 11:33:02 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6B96C08C5C1
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 08:33:02 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id s1so2946627ybo.7
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 08:33:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xfBKdIxHu1mVd19IWX7E9GLo7uSjvA8mNODU6AkLXyA=;
        b=UhtxP6JY2UeGp5/ghxY5pcTc5386Dktrb2/ov2YzRFx2rj+Jz3GhJ193iYR1pfjkfd
         /9r72xoYiXFKGUhSqHm/tqVIClI/pDvzQ4o2Oa/s8GiP142QRd8fQtGERroZaQ/whGdh
         oM/w1sQpVcmr2hcvsz8G2rs0X+Er8sLMkJC0335F0uEOM2uLjSfvqv1SdRwqECir5tJe
         jvgi+WoiT9J+C6NYp8n5UxDhi+p/AMIf4IeuFJd50ZmrRq/kwZalCq9Yc0na0neEdiEq
         2Q8idXqk7SGuJMIsJmYwEtIX1gXIqRvra8JMGAxzNehGBScHdF8iG6GRJICEUxjWDiJC
         vcRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xfBKdIxHu1mVd19IWX7E9GLo7uSjvA8mNODU6AkLXyA=;
        b=EzvgVmK2c8l3u10koS0gOU2eXOkubIZ/vONIpfFk6IK9elP7LiKhEEL+3oVGy70nVG
         Q+022DgKU+phglu5SBl/wl7W1EczOeqUz2Q40DV5iC9uaQJ6y0RJE1rDBrixsozQ8L8c
         hGsY2TP7+nbUR/XDVLstK/QKZFcVdHNESPnl30HfSaWgJ6+917D/lT+pwsxVUhhfxt8f
         E6lDQLXPzYbMDWfOiIj+ejE3RUzVKUCmMEKhIF1dGaGWHvhyj3o1Nh13YkXw2V79KbCj
         WH4cGcdo5rJ+zNnAK3068hZMt342aAOmFJNBB8QBlzIZzjWwcp0l2jS3skeX2XO7UOP7
         1uZA==
X-Gm-Message-State: AOAM532zst6UNZ4sMqPtV/PyxWgU9iXOZ5jQMJ68cm8msXcAyFx3ap3D
        uF6G+83GelIYk4+CdF9cfiRLGwHzxi6evz8xrT8d/g==
X-Google-Smtp-Source: ABdhPJxC6FLxmKODS+YAWb+JFsgftvms5vjIA9GhERDlEt//xCPyPwfcaw4zJj51TjjhzLDQUGR8HMHV83nzgoWIiPI=
X-Received: by 2002:a25:7003:: with SMTP id l3mr52323744ybc.380.1593099181963;
 Thu, 25 Jun 2020 08:33:01 -0700 (PDT)
MIME-Version: 1.0
References: <20200625115106.23370-1-denis.kirjanov@suse.com> <CADVnQykjvtgVDW9a4Jsj+o5LObB-vG=+p1MaDo37H0T6Zi0zRw@mail.gmail.com>
In-Reply-To: <CADVnQykjvtgVDW9a4Jsj+o5LObB-vG=+p1MaDo37H0T6Zi0zRw@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 25 Jun 2020 08:32:50 -0700
Message-ID: <CANn89iKK-vvzSCXHdOVHdksHfPBKC_Nt=SmhqUPzwOndXnyNRw@mail.gmail.com>
Subject: Re: [PATCH v3] tcp: don't ignore ECN CWR on pure ACK
To:     Neal Cardwell <ncardwell@google.com>
Cc:     Denis Kirjanov <kda@linux-powerpc.org>,
        Netdev <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        "Scheffenegger, Richard" <Richard.Scheffenegger@netapp.com>,
        Bob Briscoe <ietf@bobbriscoe.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 25, 2020 at 5:51 AM Neal Cardwell <ncardwell@google.com> wrote:
>
> On Thu, Jun 25, 2020 at 7:51 AM Denis Kirjanov <kda@linux-powerpc.org> wrote:
> >
> > there is a problem with the CWR flag set in an incoming ACK segment
> > and it leads to the situation when the ECE flag is latched forever
> >

> > Signed-off-by: Denis Kirjanov <denis.kirjanov@suse.com>

> Thanks, Denis!
>
> Acked-by: Neal Cardwell <ncardwell@google.com>
>
> neal

Signed-off-by: Eric Dumazet <edumazet@google.com>

Thanks
