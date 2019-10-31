Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 148B3EA88B
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 02:11:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726322AbfJaBLy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 21:11:54 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:40054 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725909AbfJaBLx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 21:11:53 -0400
Received: by mail-qt1-f193.google.com with SMTP id o49so6191287qta.7;
        Wed, 30 Oct 2019 18:11:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VKqtJgAi3yuHuutymiDrEmGGJb2mv+MI/9UmSHvADqg=;
        b=Uh3UyFBfX30Bp9OWQ66UBUhlNlInHFFSIFXns9939jCfXhSgK7+7XXfnp2Tbk/zlaW
         YOPielGpU9N2EEeBdEH2W2cspHfvofUHsJObdvIet1gmq3OtnkypZNuwUjldChCdROD/
         gwM41vyLhIx6wPPyakPdEjDT99Twycz90itV8tzzC3B4R8cxVdqIqGzxbxzVtMioKT9p
         hcnz7DJO7ciptXPocAJO8zqPJaY3vVKbzepNq3Nu29MxEqbefFNb4w0DT3Wd2V29a62d
         XgJlG7PflZi8WPDxWP9QloTVQZF0FehU041sByNauOGLI6JE3mJ2m47siP3sohyExKQ2
         OVMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VKqtJgAi3yuHuutymiDrEmGGJb2mv+MI/9UmSHvADqg=;
        b=YWUZ2GtaFI/h7O3l1A91m/cQeVb/QoC6BIB9tqf9DEKp4CwINDZc0ed1lC4evJw+M/
         BUlPCIGPs/4NVu++dUpcf/oE5IqciAZq1QC/auHe/AJi6jmWfaiUkHJ7JTDWvuw51D/w
         NHDHocVyI61ZxURGzSw3KT1v0++8efUk9bThkdDHhPKHtKV5ZyQHO9uus18dUvYSmscg
         nh3mmy0cbNHEG2ELke4Y2CzSTtZ8tQLzHcWtZzhcbb5PuT1r38DAPu34WDynoK4G3lcJ
         sEdowH4ayZY25+L4ER5y7Gsu/2v179fuv2HhLkCff28NAinMjhQwr7381TMtLB71gdT9
         fHqQ==
X-Gm-Message-State: APjAAAUkC1Kp5VgX27rmmSn3CYPI1/vglxXqw6PPGLTfWZW/xjoylRic
        h/nRC2JLYCEqTYY60j4HCO/jBSqipJlQSnbzP80=
X-Google-Smtp-Source: APXvYqyzSXH/7FSkCvyhjPhhz3jnaKI0hVqqcSlD4Zyd8wSfneRguNwsaCuN+yFx4gDfp/+DuC6OlPD4Zmx5BgmLaj8=
X-Received: by 2002:ac8:1c5a:: with SMTP id j26mr3019500qtk.351.1572484312874;
 Wed, 30 Oct 2019 18:11:52 -0700 (PDT)
MIME-Version: 1.0
References: <1572451637-14085-1-git-send-email-wallyzhao@gmail.com> <c2d0890f-8900-6838-69c4-6b72b2e58062@gmail.com>
In-Reply-To: <c2d0890f-8900-6838-69c4-6b72b2e58062@gmail.com>
From:   Wei Zhao <wallyzhao@gmail.com>
Date:   Thu, 31 Oct 2019 09:11:40 +0800
Message-ID: <CAFRmqq7=AG3oaWJ-tFQt5+BddSr=e8iiuyDYF703qcDRnmKdYg@mail.gmail.com>
Subject: Re: [PATCH] sctp: set ooo_okay properly for Transmit Packet Steering
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     vyasevich@gmail.com, nhorman@tuxdriver.com,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        davem@davemloft.net, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        wally.zhao@nokia-sbell.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 31, 2019 at 3:03 AM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
>
>
> On 10/30/19 9:07 AM, Wally Zhao wrote:
> > Unlike tcp_transmit_skb,
> > sctp_packet_transmit does not set ooo_okay explicitly,
> > causing unwanted Tx queue switching when multiqueue is in use;
> > Tx queue switching may cause out-of-order packets.
> > Change sctp_packet_transmit to allow Tx queue switching only for
> > the first in flight packet, to avoid unwanted Tx queue switching.
> >
>
> While the patch seems fine, the changelog is quite confusing.
>
> When skb->ooo_olay is 0 (which is the default for freshly allocated skbs),
> the core networking stack will stick to whatever TX queue was chosen
> at the time the dst_entry was attached to the (connected) socket.
>
> This means no reorder can happen at all by default.
>
> By setting ooo_okay carefully (as you did in your patch), you allow
> core networking stack to _switch_ to another TX queue based on
> current CPU  (XPS selection)
>
> So even without your fix, SCTP should not experience out-of-order packets.

Yes, you are right, as Marcelo also pointed out.
The changelog was given based on incorrect observation of a test
result, as I replied to Marcelo.
Since ooo_okay is default to 0, this is good enough; no need for any
patch from my side.
Thank you for your time on this.


>
> > Signed-off-by: Wally Zhao <wallyzhao@gmail.com>
> > ---
> >  net/sctp/output.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> >
> > diff --git a/net/sctp/output.c b/net/sctp/output.c
> > index dbda7e7..5ff75cc 100644
> > --- a/net/sctp/output.c
> > +++ b/net/sctp/output.c
> > @@ -626,6 +626,10 @@ int sctp_packet_transmit(struct sctp_packet *packet, gfp_t gfp)
> >       /* neighbour should be confirmed on successful transmission or
> >        * positive error
> >        */
> > +
> > +     /* allow switch tx queue only for the first in flight pkt */
> > +     head->ooo_okay = asoc->outqueue.outstanding_bytes == 0;
> > +
> >       if (tp->af_specific->sctp_xmit(head, tp) >= 0 &&
> >           tp->dst_pending_confirm)
> >               tp->dst_pending_confirm = 0;
> >
