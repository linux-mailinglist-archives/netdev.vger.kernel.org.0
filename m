Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3167F193547
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 02:30:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727652AbgCZBaX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 21:30:23 -0400
Received: from mail-il1-f196.google.com ([209.85.166.196]:36544 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727574AbgCZBaW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 21:30:22 -0400
Received: by mail-il1-f196.google.com with SMTP id p13so3883168ilp.3;
        Wed, 25 Mar 2020 18:30:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=I4cuIyu/omhcY8YXZWH8kJbJw98P2odDZvIJixI3E5g=;
        b=jaKrd7YeEmGbkjFUbycPVv8pzEL0/SFIVCzSjpQZ96Iuv3hPdGPt1l6mKlf47WBfmE
         qFeo2ulVWGfETdv9DMIt71jhTXrfBp8/Yu6Y7zqGI6vX0ehO8sPCT0+S+iguxMQqZ6v7
         eSqk1+fxqRO1qt8tr2AFr+A94Acnluya/W481EEf7o95wi4IsQ8ZCzn0UyU+z8STQ6P4
         /vvhsy4CCxe0PrVAzMRZFKsSN6KsVQE2akCDV+GGwlCtlFctwI1tKT6M2VGefs9FDKhO
         Fb1Yr9rSl4rrh4EPdZmie6Nc8dLiknA15Pi9x8JmaRxFBtcjlx/6vm3r+So9s/UrE111
         mPOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=I4cuIyu/omhcY8YXZWH8kJbJw98P2odDZvIJixI3E5g=;
        b=KMQjxxm/g46zqTmqOCA65UDKW2XFUEaZ6l3+uXjjL8IHIxRaMpBymlb03wpZmeM31v
         mym3DF78oyadEOVo6cE8n2g3rpGDnyFcAlrwDsWoitNUUmw5xm2T/DAmY/EJoOMdVM45
         M+DjZig4VoCjJoC6Hdm+g81CyudF2tMe31Njcqe/jWL6BgBsnNscEJiURXQXU36xVPpX
         PmGJZWWoeZb5SNR3uIuI17Rj34lovFQ5PVIxYJssZ2LR7NsvpQ9abforwRmPW6edJgTA
         wZfr1VvqnuUOd7CSp2USlbFwYA0YZF5LlvLYv7GEvh3QgzhW9NHR35zDySB//dqKtNGr
         eTsw==
X-Gm-Message-State: ANhLgQ2zfAfyDPgSG9l3ZR9mzS84Xe+eHlCnahjL3O0TMLkboBDlhUPK
        WfyPbfaSsfqy0XL5kb6JG1JAQCiCTWWr1ZCQG1E=
X-Google-Smtp-Source: ADFU+vvQ1cFsu4Vlqoe+cIiB4q/YXbv5CPv+Ezun8ZBdyo1Ogg/A/M7m+45lL04KZu4gIws0RFKSq0cHZuZuBIGi2l4=
X-Received: by 2002:a92:83ca:: with SMTP id p71mr5896717ilk.278.1585186221583;
 Wed, 25 Mar 2020 18:30:21 -0700 (PDT)
MIME-Version: 1.0
References: <20200322090425.6253-1-hqjagain@gmail.com> <20200326001416.GH3756@localhost.localdomain>
In-Reply-To: <20200326001416.GH3756@localhost.localdomain>
From:   Qiujun Huang <hqjagain@gmail.com>
Date:   Thu, 26 Mar 2020 09:30:08 +0800
Message-ID: <CAJRQjoeWUHj7Ep5ycTxVJVuxmhzrzXx=-rP_h=hCCrBvgTUNEg@mail.gmail.com>
Subject: Re: [PATCH v4] sctp: fix refcount bug in sctp_wfree
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

On Thu, Mar 26, 2020 at 8:14 AM Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
>
> On Sun, Mar 22, 2020 at 05:04:25PM +0800, Qiujun Huang wrote:
> > sctp_sock_migrate should iterate over the datamsgs to modify
> > all trunks(skbs) to newsk. For this, out_msg_list is added to
>
> s/trunks/chunks/

My :p.

>
> > sctp_outq to maintain datamsgs list.
>
> It is an interesting approach. It speeds up the migration, yes, but it
> will also use more memory per datamsg, for an operation that, when
> performed, the socket is usually calm.
>
> It's also another list to be handled, and I'm not seeing the patch
> here move the datamsg itself now to the new outq. It would need
> something along these lines:

Are all the rx chunks in the rx queues?

> sctp_sock_migrate()
> {
> ...
>         /* Move any messages in the old socket's receive queue that are for the
>          * peeled off association to the new socket's receive queue.
>          */
>         sctp_skb_for_each(skb, &oldsk->sk_receive_queue, tmp) {
>                 event = sctp_skb2event(skb);
> ...
>                 /* Walk through the pd_lobby, looking for skbs that
>                  * need moved to the new socket.
>                  */
>                 sctp_skb_for_each(skb, &oldsp->pd_lobby, tmp) {
>                         event = sctp_skb2event(skb);
>
> That said, I don't think it's worth this new list.

About this case:
datamsg
                   ->chunk0                       chunk1
       chunk2
 queue          ->transmitted                 ->retransmit
 ->not in any queue

Also need to maintain a datamsg list to record which datamsg is
processed avoiding repetitive
processing.
So, list it to outq. Maybe it will be used sometime.

>
>   Marcelo
