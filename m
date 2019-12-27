Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9456812B628
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 18:32:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726893AbfL0Rco (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 12:32:44 -0500
Received: from mail-ot1-f68.google.com ([209.85.210.68]:45188 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726379AbfL0Rco (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Dec 2019 12:32:44 -0500
Received: by mail-ot1-f68.google.com with SMTP id 59so37057156otp.12
        for <netdev@vger.kernel.org>; Fri, 27 Dec 2019 09:32:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=q/mpSW/qL83GgxwJU/g70xQR00ZuC6l6zYDXDDuBqHk=;
        b=jlm3R58uRa4lF5+vff2qAOPN1LYUg9r3wQYobrslqBTjS4e8DtVjIKI7T49XUS4fkL
         +mWrXLBEBUg+9W6pdu2wDORKqhmYj/lcHk+cR9rvV04bmH/NGHhkRciT47xUMWrGzXTW
         ojkrSKc33qzzBnaX18pylNvyzoQLJGJBxKBo4tAMfoS1Ewxydhs87Ls3wLhrtUxWVjx0
         pzfkRfd2kG38/X2z7v8ZELV8jTUBSadfhABtdm55qMBDqRajHLmLWUE3KFGlDGq+JG03
         OrY/P6NOV3H8QEgg6RPtURYz4AN3mrdRyoj4qj2LSJiNaAw1ymJH4liQ213Fh1Tpir7n
         O82w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=q/mpSW/qL83GgxwJU/g70xQR00ZuC6l6zYDXDDuBqHk=;
        b=A5IH3QxQYhsNBHxBJq44VidFnKbyqIUOO6Oq6xLnKBhesI1A1SKkbmXLf61s/DOk73
         WoZ+eP/g9Lc/U64PVoxsZEem2loVZgoKr3ppMX3uCUHEVNPpU3zB/Xcyz64HvRqstz6r
         NDL8fLW3744OX1yhVgun7zDIyy0FtQsvkovBjXfkIdrSwJlb0wY6nsJRIHjwTRF9BbYS
         zHhxR7QRhGsaZXHFWyNhgvmYNapZgj2MEX3ArQ2vqPzWK2VMPM3FulUWj2j0EzrlcpSO
         xPNunxd8AqEtJ316OhXBYhXTJ9vEkG3jj+CBdLaPIzfoLv3h13uJfbAiH7022TMyBW8S
         SHrg==
X-Gm-Message-State: APjAAAWJAZzoAU4UtDOJhDRp6FPAairLK3KCTPEOhaPlfCOwFxNdzne0
        /sqY0m85XyAdHoCaFxlw3Wan6TEAK2eH4sPeUatr78Wq+20=
X-Google-Smtp-Source: APXvYqxXlrcvFRsPyQ+fkcRst8O7ZWqpaPNwsNFCNDjTABDGSEg1suCSsPhiaDCzRPAfsBecx0hSz4PdsACU8POzcPY=
X-Received: by 2002:a9d:7852:: with SMTP id c18mr50316190otm.247.1577467962929;
 Fri, 27 Dec 2019 09:32:42 -0800 (PST)
MIME-Version: 1.0
References: <20191223202754.127546-1-edumazet@google.com>
In-Reply-To: <20191223202754.127546-1-edumazet@google.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Fri, 27 Dec 2019 12:32:26 -0500
Message-ID: <CADVnQymnrpPvgMQLT4_2CAGieJG3p7wZsz+nwzgBNCzgEV-RyA@mail.gmail.com>
Subject: Re: [PATCH net-next v2 0/5] tcp_cubic: various fixes
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Martin KaFai Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 23, 2019 at 3:28 PM Eric Dumazet <edumazet@google.com> wrote:
>
> This patch series converts tcp_cubic to usec clock resolution
> for Hystart logic.
>
> This makes Hystart more relevant for data-center flows.
> Prior to this series, Hystart was not kicking, or was
> kicking without good reason, since the 1ms clock was too coarse.
>
> Last patch also fixes an issue with Hystart vs TCP pacing.
>
> v2: removed a last-minute debug chunk from last patch
>
> Eric Dumazet (5):
>   tcp_cubic: optimize hystart_update()
>   tcp_cubic: remove one conditional from hystart_update()
>   tcp_cubic: switch bictcp_clock() to usec resolution
>   tcp_cubic: tweak Hystart detection for short RTT flows
>   tcp_cubic: make Hystart aware of pacing
>
>  net/ipv4/tcp_cubic.c | 82 +++++++++++++++++++++++++++-----------------
>  1 file changed, 51 insertions(+), 31 deletions(-)

Thanks for this very nice patch series, Eric.

In reviewing these patches and thinking about the Hystart ACK train
heuristic, I am thinking that another behavior that could fool this
heuristic and cause a spurious/early Hystart exit of slow start would
be application-limited flights of data. In other words, just as pacing
can cause inter-ACK spacing increases that could spuriously trigger
the Hystart ACK train heuristic, AFAICT gaps between application
writes could also cause inter-ACK gaps that could spuriously trigger
the Hystart ACK train heuristic.

AFAICT to avoid such spurious exits of slow start we ought to pass in
the is_app_limited bool in the struct ack_sample, and thereby pass it
through pkts_acked(), bictcp_acked(), and hystart_update().

@@ -3233,9 +3233,12 @@ static int tcp_clean_rtx_queue(struct sock *sk,
u32 prior_fack,
  }

  if (icsk->icsk_ca_ops->pkts_acked) {
- struct ack_sample sample = { .pkts_acked = pkts_acked,
-      .rtt_us = sack->rate->rtt_us,
-      .in_flight = last_in_flight };
+  struct ack_sample sample = {
+    .pkts_acked = pkts_acked,
+    .rtt_us = sack->rate->rtt_us,
+    .in_flight = last_in_flight,
+    .is_app_limited = sack->rate->is_app_limited,
+  };

    icsk->icsk_ca_ops->pkts_acked(sk, &sample);
  }

...and then only trigger the HYSTART_ACK_TRAIN heuristic to exit slow
start if !sample->is_app_limited.

This could be a follow-on patch after this series, or an additional
patch at the end of this series.

WDYT?

neal
