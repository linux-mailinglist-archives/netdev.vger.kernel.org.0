Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D482E189414
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 03:46:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726730AbgCRCqC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 22:46:02 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:40117 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726229AbgCRCqC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 22:46:02 -0400
Received: by mail-io1-f67.google.com with SMTP id h18so2753305ioh.7;
        Tue, 17 Mar 2020 19:46:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HmI0RMPyhwlmaO8Qr7O9Xwp+ugsNgOEyCsiabbFK+es=;
        b=LMuX11ZcSHF+tQU/KnFmGjilz6BcVP9hrain8dbHYPIzaa5KbpfEbnSpeyp1hqEf9l
         G6lPWklk3sO3sM2mfRCimJrXcFy0YXJcejafLHYk3XQdD31OzC7sUoD04wfnB+B8cffZ
         pPIiZX6XmLIZZd8dcNBAwujCFEUhttz4FnTJNcG1Mm/xbaf0/P4nKf7m+Z20jJtOQgFB
         VempRnbs/TbDOBJW1RCUW1skWKemlVu0GW4f3+Ybm0ra702K7zQpd8WNsmZHNLhzEtEq
         AeVQLWv89pmydguSPfw53CREspyEK9wmtCEM80seLYrd73XiiRQ2cHtnw8r8tnpYhjN6
         3bEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HmI0RMPyhwlmaO8Qr7O9Xwp+ugsNgOEyCsiabbFK+es=;
        b=eg8VPz9zttXgyZq9stPqVxB+AKbQKLbsXJjMe2+qKh/SIbd7x5gGzAdye8sGPR6hP+
         adD+y8yWiowWvJk4jriI6pwLH9kThd/9ZLyD6ovXoowGysRCjuI7GIkgno+XoBHnpsrY
         j7eTpvT5mD2o+GG+GT/4Tna/y5x3rAZ2sznzF2g5Bm5V7ZwD++nlfzJQIXEwFLxNuuQ/
         WfTFqtzc7uLSkw2DFf48gYOViSVBBh+CrD+7CX80HGZU5usRrLnkz6p++F3dnr+oCPBn
         2lml1Q47a7cOdYehqCiNlRJRe/ssiE7ApdktWpFlEahdL/CNC//t0A38r6eH3hMB5OYl
         5GeA==
X-Gm-Message-State: ANhLgQ3i644KeMQ+l6Ic8FyM8377YLocFtVyQzRuGnhab1PqACFYfUqd
        vVl0W83Axkc70DMzitoDme+fuvCOxCuwu7IJ0PmZm+k3
X-Google-Smtp-Source: ADFU+vu7ASoM/a9tA1PJlBd+5ZUSo0HpmB4s0bW5JSxUP/lgawvFE9ABn3QAEZe7WwSRpsAVX1pqfFJcyLSbtVmPwNA=
X-Received: by 2002:a6b:f404:: with SMTP id i4mr1715360iog.175.1584499561560;
 Tue, 17 Mar 2020 19:46:01 -0700 (PDT)
MIME-Version: 1.0
References: <20200317155536.10227-1-hqjagain@gmail.com> <20200317173039.GA3828@localhost.localdomain>
In-Reply-To: <20200317173039.GA3828@localhost.localdomain>
From:   Qiujun Huang <hqjagain@gmail.com>
Date:   Wed, 18 Mar 2020 10:45:51 +0800
Message-ID: <CAJRQjocwMzmBiYXwCnupE7hd8qYveBXtUiF2WKBe=TFfJLqcDw@mail.gmail.com>
Subject: Re: [PATCH v2] sctp: fix refcount bug in sctp_wfree
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, vyasevich@gmail.com,
        nhorman@tuxdriver.com, Jakub Kicinski <kuba@kernel.org>,
        linux-sctp@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, anenbupt@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 18, 2020 at 1:30 AM Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
>
> Hi,
>
> On Tue, Mar 17, 2020 at 11:55:36PM +0800, Qiujun Huang wrote:
> > Do accounting for skb's real sk.
> > In some case skb->sk != asoc->base.sk:
> >
> > migrate routing        sctp_check_transmitted routing
> > ------------                    ---------------
>                                  sctp_close();
>                                    lock_sock(sk2);
>                                  sctp_primitive_ABORT();
>                                  sctp_do_sm();
>                                  sctp_cmd_interpreter();
>                                  sctp_cmd_process_sack();
>                                  sctp_outq_sack();
>                                  sctp_check_transmitted();
>
>   lock_sock(sk1);
>   sctp_getsockopt_peeloff();
>   sctp_do_peeloff();
>   sctp_sock_migrate();
> > lock_sock_nested(sk2);
> >                                mv the transmitted skb to
> >                                the it's local tlist
>
>
> How can sctp_do_sm() be called in the 2nd column so that it bypasses
> the locks in the left column, allowing this mv to happen?
>
> >
> > sctp_for_each_tx_datachunk(
> > sctp_clear_owner_w);
> > sctp_assoc_migrate();
> > sctp_for_each_tx_datachunk(
> > sctp_set_owner_w);
> >
> >                                put the skb back to the
> >                                assoc lists
> > ----------------------------------------------------
> >
> > The skbs which held bysctp_check_transmitted were not changed
> > to newsk. They were not dealt with by sctp_for_each_tx_datachunk
> > (sctp_clear_owner_w/sctp_set_owner_w).
>
> It would make sense but I'm missing one step earlier, I'm not seeing
> how the move to local list is allowed/possible in there. It really
> shouldn't be possible.

I totally agree that.
My mistake. So I added some log in my test showing the case:
The backtrace:
sctp_close
sctp_primitive_ABORT
sctp_do_sm
sctp_association_free
__sctp_outq_teardown
     /* Throw away unacknowledged chunks. */
    list_for_each_entry(transport, &q->asoc->peer.transport_addr_list,
    transports) {
    printk("[%d]deal with transmitted %#llx from transport %#llx  %s,
%d\n", raw_smp_processor_id(),
   &transport->transmitted, transport, __func__, __LINE__);
   while ((lchunk = sctp_list_dequeue(&transport->transmitted)) != NULL) {

The trouble skb is from another peer sk in the same asoc, but
accounted to the base.sk.
