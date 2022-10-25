Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B69A60C0A4
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 03:12:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230406AbiJYBME (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 21:12:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231418AbiJYBLU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 21:11:20 -0400
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1EEA5141C
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 17:22:01 -0700 (PDT)
Received: by mail-yb1-xb2c.google.com with SMTP id 185so2279876ybc.3
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 17:22:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pQiFe9Qj/zjVblC/lqwZRoiurgH4MGQTY43OjXSALng=;
        b=pUYxaLGP64LKRZiHSThY66IVooGLmmLtvpua3IG86ZOEkpQRDljz5+wBMdL8StxTzh
         SDaFOxdQVXqNNWGYBUHB+Jr0UDyDHqzWBy/x2FEIyyy8SMz6oSrYyPzLNkG+KMuGKzNT
         o4oOa/ULnBhdv/pXFQxv0lP8TN4TN+z1APuIR8qxdhqrMt2ylC50L5saaedOCDAeMRNa
         HLe9IYq+2jDEKHIB/tuiKrG0B5sCfDwS90dhEX2I/FAPFEuvPsPoPDTT8XYH2uFEQius
         csTsJRCFypklom/xxu3ZnUKKFiPuGyMm8rlzwMwf3IVQ2L8f8679oq3uRQtWawrPfFp8
         XPQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pQiFe9Qj/zjVblC/lqwZRoiurgH4MGQTY43OjXSALng=;
        b=Gf3eEWIxxBwGtr2f/cvstoqN7Iy4dJC26PJzYDb2bFCNrLQhbaH8ZCRpu5k10kFVOe
         bpPyJv2doPF2peGRzDZPj2KfSE+ZlWFW7QdSgbg2lyAekhBWV1B4Z9LTf9D9+os9ZEO9
         tpNrAGSXAMZGZaPNplBCLuKYYQGl3THArfIaLHgLM9hCPg6NlTmEzjWYNmiy4ogtqfM7
         fds5fTEfSB5y6a+z1N8YvRjt77826UHalIFSOKjYRXj6oL3QpU2twssNWalzbmau72fY
         0s7fI+x4fjiHcmC5ZdT/WV7gG4nkZOmgeq9xEtXJliiIHaXnJtKhPKP3iKbZz+SN+4Hy
         ddlg==
X-Gm-Message-State: ACrzQf3Uj4RKNZCts5d6ToocCbzxsrbyzDVQS5Dyn35+wI/ihysXSsQX
        K/6Cy3LiUJzjBlvDj9qbhv/kBNOhtmHsZUhJdmHjr/h1pPPbZA==
X-Google-Smtp-Source: AMsMyM6WvmkzC1iaHQWwSzV0jK2PbBqVT4Kgj8i2SN+H+l/aRRvdorgOA364BSQ4nhNIqXnSdUn5CxzEvIRnNbfscA4=
X-Received: by 2002:a25:d914:0:b0:6cb:13e2:a8cb with SMTP id
 q20-20020a25d914000000b006cb13e2a8cbmr6724274ybg.231.1666657320631; Mon, 24
 Oct 2022 17:22:00 -0700 (PDT)
MIME-Version: 1.0
References: <3a24f8979afad17bc33de485a6a75bfc51102b91.camel@wdc.com> <8d29b8606b290a7edaeb2953455b997a1f2837aa.camel@wdc.com>
In-Reply-To: <8d29b8606b290a7edaeb2953455b997a1f2837aa.camel@wdc.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 24 Oct 2022 17:21:49 -0700
Message-ID: <CANn89iKfLGRaa+GSgaXAmroPG7fu0S_Bb0KnBUKsdqEwBjj6Aw@mail.gmail.com>
Subject: Re: [PATCH v1 1/2] tcp: Fix for stale host ACK when tgt window shrunk
To:     Kamaljit Singh <Kamaljit.Singh1@wdc.com>
Cc:     "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>,
        Niklas Cassel <Niklas.Cassel@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 24, 2022 at 3:07 PM Kamaljit Singh <Kamaljit.Singh1@wdc.com> wr=
ote:
>
> Hi Eric,
>
> Please find my inline responses below.
>
> Thanks,
> Kamaljit
>
>
> On Thu, 2022-10-20 at 19:48 -0700, Eric Dumazet wrote:
> > CAUTION: This email originated from outside of Western Digital. Do not =
click
> > on links or open attachments unless you recognize the sender and know t=
hat the
> > content is safe.
> >
> >
> > On Thu, Oct 20, 2022 at 6:01 PM Kamaljit Singh <Kamaljit.Singh1@wdc.com=
>
> > wrote:
> > > On Thu, 2022-10-20 at 13:45 -0700, Eric Dumazet wrote:
> > > > CAUTION: This email originated from outside of Western Digital. Do =
not
> > > > click
> > > > on links or open attachments unless you recognize the sender and kn=
ow that
> > > > the
> > > > content is safe.
> > > >
> > > >
> > > > On Thu, Oct 20, 2022 at 11:22 AM Kamaljit Singh <kamaljit.singh1@wd=
c.com>
> > > > wrote:
> > > > > Under certain congestion conditions, an NVMe/TCP target may be
> > > > > configured
> > > > > to shrink the TCP window in an effort to slow the sender down pri=
or to
> > > > > issuing a more drastic L2 pause or PFC indication.  Although the =
TCP
> > > > > standard discourages implementations from shrinking the TCP windo=
w, it
> > > > > also
> > > > > states that TCP implementations must be robust to this occurring.=
 The
> > > > > current Linux TCP layer (in conjunction with the NVMe/TCP host dr=
iver)
> > > > > has
> > > > > an issue when the TCP window is shrunk by a target, which causes =
ACK
> > > > > frames
> > > > > to be transmitted with a =E2=80=9Cstale=E2=80=9D SEQ_NUM or for d=
ata frames to be
> > > > > retransmitted by the host.
> > > >
> > > > Linux sends ACK packets, with a legal SEQ number.
> > > >
> > > > The issue is the receiver of such packets, right ?
> > > Not exactly. In certain conditions the ACK pkt being sent by the NVMe=
/TCP
> > > initiator has an incorrect SEQ-NUM.
> > >
> > > I've attached a .pcapng Network trace for Wireshark. This captures a =
small
> > > snippet of 4K Writes from 10.10.11.151 to a target at 10.10.11.12 (us=
ing
> > > fio).
> > > As you see pkt #2 shows a SEQ-NUM 4097, which is repeated in ACK pkt =
#12
> > > from
> > > the initiator. This happens right after the target closes the TCP win=
dow
> > > (pkts
> > > #7, #8). Pkt #12 should've used a SEQ-NUM of 13033 in continuation fr=
om pkt
> > > #11.
> > >
> > > This patch addresses the above scenario (tp->snd_wnd=3D0) and returns=
 the
> > > correct
> > > SEQ-NUM that is based on tp->snd_nxt. Without this patch the last els=
e path
> > > was
> > > returning tcp_wnd_end(tp), which sent the stale SEQ-NUM.
> > >
> > > Initiator Environment:
> > > - NVMe-oF Initiator: drivers/nvme/host/tcp.c
> > > - NIC driver: mlx5_core (Mellanox, 100G), IP addr 10.10.11.151
> > > - Ubuntu 20.04 LTS, Kernel 5.19.0-rc7 (with above patches 1 & 2 only)
> > >
> > >
> > > > Because as you said receivers should be relaxed about this, especia=
lly
> > > > if _they_ decided
> > > > to not respect the TCP standards.
> > > >
> > > > You are proposing to send old ACK, that might be dropped by other s=
tacks.
> > > On the contrary, I'm proposing to use the expected/correct ACK based =
on tp-
> > > > snd_nxt.
> >
> > Please take a look at the very lengthy comment at the front of the func=
tion.
> >
> > Basically we are in a mode where a value needs to be chosen, and we do
> > not really know which one
> > will be accepted by the buggy peer.
> >
> I'm pasting the source code comment you're referring to here. You're righ=
t that
> the comment is very relevant in this case as the TCP window is being shru=
nk,
> although, I'd politely argue that its a design choice rather than a bug i=
n our
> hardware target implementation.
>
> /* SND.NXT, if window was not shrunk or the amount of shrunk was less tha=
n one
>  * window scaling factor due to loss of precision.
>  * If window has been shrunk, what should we make? It is not clear at all=
.
>  * Using SND.UNA we will fail to open window, SND.NXT is out of window. :=
-(
>  * Anything in between SND.UNA...SND.UNA+SND.WND also can be already
>  * invalid. OK, let's make this for now:
>  */
>
> Below, I'm also pasting a plain-text version of the .pcapng, provided ear=
lier as
> an email attachment. Hopefully this makes it easier to refer to the packe=
ts as
> you read through my comments. I had to massage the formatting to fit it i=
n this
> email. Data remains the same except for AckNum for pkt#3 which referred t=
o an
> older packet and threw off the formatting.
>
> Initiator =3D 10.10.11.151 (aka NVMe/TCP host)
> Target =3D 10.10.11.12
>
> No. Time        Src IP          Proto    Len    SeqNum  AckNum  WinSize
> 1   0.000000000 10.10.11.151    TCP      4154   1       1       25
> 2   0.000000668 10.10.11.151    TCP      4154   4097    1       25
> 3   0.000039250 10.10.11.12     TCP      64     1       x       16384
> 4   0.000040064 10.10.11.12     TCP      64     1       1       16384
> 5   0.000040951 10.10.11.12     NVMe/TCP 82     1       1       16384
> 6   0.000041009 10.10.11.12     NVMe/TCP 82     25      1       16384
> 7   0.000059422 10.10.11.12     TCP      64     49      4097    0
> 8   0.000060059 10.10.11.12     TCP      64     49      8193    0
> 9   0.000072519 10.10.11.12     TCP      64     49      8193    16384
> 10  0.000074756 10.10.11.151    TCP      4154   8193    1       25
> 11  0.000075089 10.10.11.151    TCP      802    12289   1       25
> 12  0.000089454 10.10.11.151    TCP      64     4097    49      25
> 13  0.000102225 10.10.11.151    TCP      4154   13033   49      25
> 14  0.000102567 10.10.11.151    TCP      4154   17129   49      25
> 15  0.000140273 10.10.11.12     TCP      64     49      13033   16384
> 16  0.000157344 10.10.11.151    TCP      106    21225   49      25
> 17  0.000158580 10.10.11.12     TCP      64     49      13033   0
>
> Packets #7 and #8: Target shrinks window to zero for congestion control
> Packet #9: ~12us later Target expands window back to 16384
>
> [Packet #12] is an ACK packet from the Initiator. Since it does not send =
data,
> window shrinking should not affect its SEQ-NUM here. Hence, its probably =
safe to
> send SND.NXT, as in my patch. In other words, TCP window should be releva=
nt to
> data packets and not to ACK packets. Would you agree?

No, I do not agree.

See at the end of this email a packetdrill test demonstrating your
pacth would add extra work
(a challenge ACK)

>
> [Referring to the SND pointers diagram at this URL
> http://www.tcpipguide.com/free/t_TCPSlidingWindowDataTransferandAcknowled=
gementMech-2.htm]
>
> This unexpected behavior by the Initiator causes our hardware offloaded T=
arget
> to hand-off control to Firmware slow-path.

This is the bug.

This packet is perfectly normal and should not cause a problem with an offl=
oad.

Please contact the vendor to fix this issue.

 If we can keep everything in the
> hardware (fast) path and not invoke Firmware that's when we have the best=
 chance
> of optimal performance.
>
> Running heavy workloads at 100G link rate there can be a million instance=
s of
> such behavior as packet #12 is exhibiting and is very disruptive to fast-=
path.
>
>
> > You are changing something that has been there forever, risking
> > breaking many other stacks, and/or middleboxes.
> >
> Regardless of how we handle this patch, the fact remains that for any oth=
er
> hardware based TCP offloads existing elsewhere they will have the same
> susceptibility as a result of this Linux TCP behavior, even if their cong=
estion
> control mechanism does not match this scenario.
>
> Being fully aware of how ubiquitous TCP layer is we tried ways to avoid c=
hanging
> it. Early on, in drivers/nvme/host/tcp.c we had even tried
> tcp_sock_set_quickack() instead of PATCH 2/2 but it did not help. If you =
can
> suggest a better way that could de-risk existing deployments, I'd be more=
 than
> happy to discuss this further and try other solutions. An example could b=
e a TCP
> socket option that would stay disabled by default. We could then use it i=
n the NVMe/TCP driver or a userspace accessible method.
>
> > It seems the remote TCP stack is quite buggy, I do not think we want
> > to change something which has never been an issue until today in 2022.
> >
> IMHO, I wouldn't quite characterize it that way. It was a design choice a=
nd
> provides one of multiple ways of handling network congestion. It may also=
 be
> possible that there are other implementations affected by this issue.
>
>
> > Also not that packet #13, sent immediately after the ACK is carrying
> > whatever needed values.
> > I do not see why the prior packet (#12) would matter.
> >
> > Please elaborate.
> Packet #13, however, is a data packet sent by the Initiator. This is in d=
irect
> reaction to packet #9 from the Target that expanded the window size back =
to 16K.
> Even though it correctly uses SND.NXT it does not affect the handling for=
 packet
> #12 in our hardware Target.
>
>

Here is a packetdrill test showing the problem you are adding, since
it seems it is not clear to you.

    0 socket(..., SOCK_STREAM, IPPROTO_TCP) =3D 3
   +0 setsockopt(3, SOL_SOCKET, SO_REUSEADDR, [1], 4) =3D 0
   +0 setsockopt(3, SOL_SOCKET, SO_RCVBUF, [16384], 4) =3D 0

   +0 bind(3, ..., ...) =3D 0
   +0 listen(3, 1) =3D 0

   +0 < S 0:0(0) win 2920 <mss 4096,sackOK,nop,nop>
   +0 > S. 0:0(0) ack 1 <mss 4096,nop,nop,sackOK>
  +.1 < . 1:1(0) ack 1 win 16384
    +0 accept(3, ..., ...) =3D 4

// Note: linux will not shrink the window...
// I think this would require some patch, to emulate a buggy stack
   +0 setsockopt(4, SOL_SOCKET, SO_RCVBUF, [1000], 4) =3D 0

   +0 < P. 1:16385(16384) ack 1 win 150
   +0 write(4, ..., 100) =3D 100
   +0 > P. 1:101(100) ack 16385 win 0

// OK, what if the ACK carries a sequence in the future ?
// This could happen if the peer sent 18000 bytes while our window was
> 16384 and
// if kamaljit.singh1@wdc.com  patch would be accepted...

   +.1 < . 18001:18001(0) ack 101 win 1000

// Too bad, prior ACK has a sequence in the future
// We send a challenge ACK in an attempt to fix the synchronization issue.
// This would be avoided completely if prior ack was "16385:16385(0)
ack 101 win 1000"
  +0  > . 101:101(0) ack 16385 win 0
