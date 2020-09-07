Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4576625F234
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 05:48:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726526AbgIGDsp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Sep 2020 23:48:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726318AbgIGDsl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Sep 2020 23:48:41 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5110EC061573
        for <netdev@vger.kernel.org>; Sun,  6 Sep 2020 20:48:41 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id d20so11715846qka.5
        for <netdev@vger.kernel.org>; Sun, 06 Sep 2020 20:48:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=T5+Gm9SZ6Wqi/wgrqZYei3E5B+AkWfk6Mbef5VKH1tk=;
        b=ajg9zEP5eDTv2jaqV20baQYBhsZhURUAM57O2blaK7oaG+ZuuMjXIpqGQGtp3SjYR+
         nQUjZ9SPVjvuvzkzIz1IrxISTBWScq7Vk9qX6s3tRZtVjGymbeWNZlm92Rb30YbNxGzj
         Zb6vsOEZKMwHzNIuIdssfS1co4RYKD+9kGz7o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=T5+Gm9SZ6Wqi/wgrqZYei3E5B+AkWfk6Mbef5VKH1tk=;
        b=SZZRLdGu2vzqlocK62uV5cXiHCsrhiWaspFiw93nd3Tirv6y3Qs5q22jJ/mj5tFJaX
         STdamqcKb5VeTutQmLZIh8rk9keerC4pGvGvYxuypNelYbfP+Az5dtYHHCd//bkyi97Y
         WPNk1KttVGT4WVCPJS4QZW0TkOA/VcpORZa7vhfpmHU7FZ9CyiWnLm6O5CExFdeOVOWy
         ttg9Sui5JqKteSMlkcNTkXlNUZMZsJDdIUkQFgFvrbmB2zI4W7QuxfVpOuqSQkMSdQCS
         +aIh5pKQJ1CnRSm4mixtpCzyOJHqTUK5cbf5SVrRw55ltTvfutLZcP5+O/GaMe383ZJu
         qMkA==
X-Gm-Message-State: AOAM53057D6kxozck9FVyZduLLMXp6LuBXFTo0b4bpQ0mCEJZBSHnmg6
        5zhSVnwtEMkfNncZbUmapMoi+8L2gAjg7BynbdTFrw3vKCn2kw==
X-Google-Smtp-Source: ABdhPJzH6Fijq5jV+Dc4ZZLycljbPu9y3Uq4qy6tOF0No8CkxqMl6m1IPUEjRIeXTCdEzlWIMY0thg8Z4Tnb8IwiDG4=
X-Received: by 2002:a37:bcc:: with SMTP id 195mr17480892qkl.287.1599450520226;
 Sun, 06 Sep 2020 20:48:40 -0700 (PDT)
MIME-Version: 1.0
References: <1599360937-26197-1-git-send-email-michael.chan@broadcom.com>
 <1599360937-26197-3-git-send-email-michael.chan@broadcom.com>
 <20200906122534.54e16e08@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CACKFLin=-9=2x0MFuRfXM1HwFQ7uZSZ4i0HymRZDBVKcnK73NA@mail.gmail.com> <20200906201311.0873ad59@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200906201311.0873ad59@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Michael Chan <michael.chan@broadcom.com>
Date:   Sun, 6 Sep 2020 20:48:04 -0700
Message-ID: <CACKFLimwdvnCWw6qG1ReCRW3XgSS1UEwNa=cuPFZKeb+VG2hZQ@mail.gmail.com>
Subject: Re: [PATCH net 2/2] bnxt_en: Fix NULL ptr dereference crash in bnxt_fw_reset_task()
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 6, 2020 at 8:13 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Sun, 6 Sep 2020 15:07:02 -0700 Michael Chan wrote:
> > On Sun, Sep 6, 2020 at 12:25 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > >
> > > devlink can itself scheduler a recovery via:
> > >
> > >   bnxt_fw_fatal_recover() -> bnxt_fw_reset()
> > >
> >
> > Yes, this is how it is initiated when we call devlink_health_report()
> > to report the error condition.  From bnxt_fw_reset(), we use a
> > workqueue because we have to go through many states, requiring
> > sleeping/polling to transition through the states.
> >
> > > no? Maybe don't make the devlink recovery path need to go via a
> > > workqueue?
> >
> > Current implementation is going through a work queue.
>
> What I'm saying is the code looks like this after this patch:
>
> +       clear_bit(BNXT_STATE_IN_FW_RESET, &bp->state);
> +       bnxt_cancel_sp_work(bp);
> +       bp->sp_event = 0;
> +
>         bnxt_dl_fw_reporters_destroy(bp, true);
>
> It cancels the work, _then_ destroys the reporter. But I think the
> reported can be used to schedule a recovery from command line. So the
> work may get re-scheduled after it has been canceled.

bnxt_en does not support recovery from the command line.  We return
-EOPNOTSUPP when it comes from the command line.

Recovery has to be triggered from a firmware reported error or a
driver detected error.
