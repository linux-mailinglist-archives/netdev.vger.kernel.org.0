Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CCBB635F7
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 14:34:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726695AbfGIMeJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 08:34:09 -0400
Received: from mail-qt1-f169.google.com ([209.85.160.169]:37182 "EHLO
        mail-qt1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726081AbfGIMeG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 08:34:06 -0400
Received: by mail-qt1-f169.google.com with SMTP id y26so8837722qto.4
        for <netdev@vger.kernel.org>; Tue, 09 Jul 2019 05:34:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=x9UJw2y3JXxydS6rB+eYK21oCK3KMNicLdcitq8LPvY=;
        b=J1dDK9WJZK86vxucHJS51QkGuYLIbx+G7Yo4q2JzBUYkpjZP32mWiWrXNqqa9+1H/A
         cUFBqYT9Qwm4GM76+cD7k/qsYqiCg+W8KdwPPa0YGG36R43LEzOz0abvvTnNOjkWTBoN
         xyDh3/2xJCFQZCJVu8kWwLcDjUeaKQhJwTox8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=x9UJw2y3JXxydS6rB+eYK21oCK3KMNicLdcitq8LPvY=;
        b=TlJ8/oDCfCdj02oVbETtLU3i5WPvvfey6MH/DX//9oPKs8GsT9WgRJJHyU2Vq0HfqR
         gnqTVec8L6JAxI3334JKqZB2JQDzhvFXkQGl6xsfgCougLfWWoXPzdLTVgOLoPN49O2b
         LpWzuj0cwxU64KohJ8aKmYijuHvEjiBKt5UdxSB+FB+y2rs89i8Wv+SRx81S6PIz13Ti
         o8+gzw+hIA3mCoOdIDtCGeebJqPIjFb5drgvCInJq0KYNhPEgmQBys5FbST0rtDWVWyZ
         63cv3J5x4ytvsPP265LrZmT9Gvu6vH1bNnlCF+uzohec/HV6JxdNEpZP9WDHkLxYIH7y
         vDcQ==
X-Gm-Message-State: APjAAAVc5J1IpYoQuWFqGK9FCArbUINsvfmCgia9Ur6FPrxbnc7ltRy9
        IBANbebxbVT2EpyKlADf/W0EMZRAUfK1FdRg5NnOpA==
X-Google-Smtp-Source: APXvYqzgspZT1gxZSTqXa3ZprCu+IVCYsvbM2wJMOpWjdsji+6TO6/n2kYGyMKzNC/bpe/4obcFux2BgMfpFay+JQuc=
X-Received: by 2002:ac8:48cc:: with SMTP id l12mr17131384qtr.98.1562675645333;
 Tue, 09 Jul 2019 05:34:05 -0700 (PDT)
MIME-Version: 1.0
References: <CAJPywT++ibhPSzL8pCS6Jpej9EeR3g9x89xssK8U=vi6FqLUUw@mail.gmail.com>
 <a854848f-9fb3-47b9-cb18-e76455e5e664@gmail.com>
In-Reply-To: <a854848f-9fb3-47b9-cb18-e76455e5e664@gmail.com>
From:   Marek Majkowski <marek@cloudflare.com>
Date:   Tue, 9 Jul 2019 14:33:54 +0200
Message-ID: <CAJPywTKXL=_8h3aoC=n-c8o_Uo7P6RnKOgm6CpvrNsPQuw4C9A@mail.gmail.com>
Subject: Re: IPv6 flow label reflection behave for RST packets
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        Jakub Sitnicki <jakub@cloudflare.com>, netdev@vger.kernel.org,
        kernel-team <kernel-team@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ha, thanks. I missed that.

There is a caveat though. I don't think it's working as intended...
Running my script:

$ sysctl -w net.ipv6.flowlabel_reflect=3

$ tail reflect.py
cd2.close()
cd.send(b"a")

$ python3 reflect.py
IP6 (flowlabel 0xf2927, hlim 64) ::1.1235 > ::1.60246: Flags [F.]
IP6 (flowlabel 0xf2927, hlim 64) ::1.60246 > ::1.1235: Flags [P.]
IP6 (flowlabel 0x58ecd, hlim 64) ::1.1235 > ::1.60246: Flags [R]

Note. The RST is opportunistic, depending on timing I sometimes get a
proper FIN, without RST.

If I change the script to introduce some delay:

$ tail reflect.py
cd2.close()
time.sleep(0.1)
cd.send(b"a")

$ python3 reflect.py
IP6 (flowlabel 0x2f60c, hlim 64) ::1.60326 > ::1.1235: Flags [.]
IP6 (flowlabel 0x2f60c, hlim 64) ::1.60326 > ::1.1235: Flags [P.]
IP6 (flowlabel 0x2f60c, hlim 64) ::1.1235 > ::1.60326: Flags [R]

Now it seem to work reliably. Tested on net-next under virtme.

Marek

On Tue, Jul 9, 2019 at 1:19 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
>
>
> On 7/9/19 1:10 PM, Marek Majkowski wrote:
> > Morning,
> >
> > I'm experimenting with flow label reflection from a server point of
> > view. I'm able to get it working in both supported ways:
> >
> > (a) per-socket with flow manager IPV6_FL_F_REFLECT and flowlabel_consistency=0
> >
> > (b) with global flowlabel_reflect sysctl
> >
> > However, I was surprised to see that RST after the connection is torn
> > down, doesn't have the correct flow label value:
> >
> > IP6 (flowlabel 0x3ba3d) ::1.59276 > ::1.1235: Flags [S]
> > IP6 (flowlabel 0x3ba3d) ::1.1235 > ::1.59276: Flags [S.]
> > IP6 (flowlabel 0x3ba3d) ::1.59276 > ::1.1235: Flags [.]
> > IP6 (flowlabel 0x3ba3d) ::1.1235 > ::1.59276: Flags [F.]
> > IP6 (flowlabel 0x3ba3d) ::1.59276 > ::1.1235: Flags [P.]
> > IP6 (flowlabel 0xdfc46) ::1.1235 > ::1.59276: Flags [R]
> >
> > Notice, the last RST packet has inconsistent flow label. Perhaps we
> > can argue this behaviour might be acceptable for a per-socket
> > IPV6_FL_F_REFLECT option, but with global flowlabel_reflect, I would
> > expect the RST to preserve the reflected flow label value.
> >
> > I suspect the same behaviour is true for kernel-generated ICMPv6.
> >
> > Prepared test case:
> > https://gist.github.com/majek/139081b84f9b5b6187c8ccff802e3ab3
> >
> > This behaviour is not necessarily a bug, more of a surprise. Flow
> > label reflection is mostly useful in deployments where Linux servers
> > stand behind ECMP router, which uses flow-label to compute the hash.
> > Flow label reflection allows ICMP PTB message to be routed back to
> > correct server.
> >
> > It's hard to imagine a situation where generated RST or ICMP echo
> > response would trigger a ICMP PTB. Flow label reflection is explained
> > here:
> > https://tools.ietf.org/html/draft-wang-6man-flow-label-reflection-01
> > and:
> > https://tools.ietf.org/html/rfc7098
> > https://tools.ietf.org/html/rfc6438
> >
> > Cheers,
> >     Marek
> >
> >
> > (Note: the unrelated "fwmark_reflect" toggle is about something
> > different - flow marks, but also addresses RST and ICMP generated by
> > the server)
> >
>
> Please check the recent commits, scheduled for linux-5.3
>
> a346abe051bd2bd0d5d0140b2da9ec95639acad7 ipv6: icmp: allow flowlabel reflection in echo replies
> c67b85558ff20cb1ff20874461d12af456bee5d0 ipv6: tcp: send consistent autoflowlabel in TIME_WAIT state
> 392096736a06bc9d8f2b42fd4bb1a44b245b9fed ipv6: tcp: fix potential NULL deref in tcp_v6_send_reset()
> 50a8accf10627b343109a9c9d5c361751bf753b0 ipv6: tcp: send consistent flowlabel in TIME_WAIT state
> 323a53c41292a0d7efc8748856c623324c8d7c21 ipv6: tcp: enable flowlabel reflection in some RST packets
>
