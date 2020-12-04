Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 819712CF441
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 19:44:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729945AbgLDSmY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 13:42:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729897AbgLDSmY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 13:42:24 -0500
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11DEDC061A51
        for <netdev@vger.kernel.org>; Fri,  4 Dec 2020 10:42:09 -0800 (PST)
Received: by mail-il1-x142.google.com with SMTP id y9so6131569ilb.0
        for <netdev@vger.kernel.org>; Fri, 04 Dec 2020 10:42:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=pkzvk+nivjFiXCehCTlARD/Ca7tjEsyGw3FbWFFZmzs=;
        b=lIyQlcH21san+qL/yL3QOteX8bPSvA11CtU9PT/ObLJbnI/kPoPZUHrwmf4pLE03rH
         XfDsuIELw0geHyMfVOjPKi3AFoAsKOV0QW/NPEIEKuqm6LbKUhO6nLv23lKSWN3VD6JW
         7785yM6VBhx87kQdIK8N68t5/DgXUouwLMa5uTIk9CGJe2YxSsWFCLNSv9PweUmwTy4S
         9sdZh9n0cCdZXuQMEsLCQNajTBApT56GwMIx/O5nRU76W+159Iw9WOzcAFZQkRfeGnN/
         AKJ/3+xex3vXOL/1HN/7UMj58AMIuPMigKtuPUSP5UvgAENPbMm1CI/HHb7ic/fClVOd
         terA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=pkzvk+nivjFiXCehCTlARD/Ca7tjEsyGw3FbWFFZmzs=;
        b=A7qHRqwpmH/uk4aTW3Dj6zV5XQHPTY5hb7G67Dy1vCn+0fVg/0l0hdNKSwVpkFuej3
         PMJxMAJ0zrESDoFD3ocyjZYzKI/M3dhay+7R/3BXtB6dN7jC7kaAJyTObAfRgwwM15go
         T21EsFc7/noi6Kn3PNIG55pyKD16luO3AGCR80/pzmEGsxT9/R4LgignoYBqh3RdYzAj
         PtTtEuLXM+LlZpGw1/22TLCMTiomcGCrE0j8Jwdlg1Nk2zUElSdcMo9dDPkYzWk2HDVK
         mzAcvw0293tfZxnMRk1SJh2Zr5xkbAWU6VX7y24AWqPlsiULFhtdqZZzsi+Ok4bY3oNx
         L5uw==
X-Gm-Message-State: AOAM53107j1csoObRnbKLJZAJIFzO1z6ESEIrIIgVX+fLN14WqMqzZjQ
        ssNtos7qxFhSaKN0atEXaYYXM6IolwMDzDZGiylktAWPBJI8fw==
X-Google-Smtp-Source: ABdhPJwHhtlWtmzqlvmOj1XP2dPxTFZkQbuyNr7r2/ozDiBxk7BQWaB7OzOvCtOmzkfMWPYSoyeu4cQgUpfnMKyirH8=
X-Received: by 2002:a92:da48:: with SMTP id p8mr8390318ilq.216.1607107327397;
 Fri, 04 Dec 2020 10:42:07 -0800 (PST)
MIME-Version: 1.0
References: <20201204180622.14285-1-abuehaze@amazon.com> <44E3AA29-F033-4B8E-A1BC-E38824B5B1E3@amazon.com>
In-Reply-To: <44E3AA29-F033-4B8E-A1BC-E38824B5B1E3@amazon.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 4 Dec 2020 19:41:55 +0100
Message-ID: <CANn89iJgJQfOeNr9aZHb+_Vozgd9v4S87Kf4iV=mKhuPDGLkEg@mail.gmail.com>
Subject: Re: [PATCH net-next] tcp: optimise receiver buffer autotuning
 initialisation for high latency connections
To:     "Mohamed Abuelfotoh, Hazem" <abuehaze@amazon.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "ycheng@google.com" <ycheng@google.com>,
        "ncardwell@google.com" <ncardwell@google.com>,
        "weiwan@google.com" <weiwan@google.com>,
        "Strohman, Andy" <astroh@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 4, 2020 at 7:19 PM Mohamed Abuelfotoh, Hazem
<abuehaze@amazon.com> wrote:
>
> Hey Team,
>
> I am sending you this e-mail as a follow-up to provide more context about=
 the patch that I proposed in my previous e-mail.
>
>
> 1-We have received a customer complain[1] about degraded download speed  =
 from google endpoints after they upgraded their Ubuntu kernel from 4.14 to=
 5.4.These customers were getting around 80MB/s on kernel 4.14 which became=
 3MB/s after the upgrade to kernel 5.4.
> 2-We tried to reproduce the issue locally between EC2 instances within th=
e same region but we couldn=E2=80=99t however we were able to reproduce it =
when fetching data from google endpoint.
> 3-The issue could only be reproduced in Regions where we have high RTT(ar=
ound 12msec  or more ) with Google endpoints.
> 4-We have found some workarounds that can be applied on the receiver side=
 which has proven to be effective and I am listing them below:
>             A) Decrease TCP socket default rmem from 131072 to 87380
>             B) Decrease MTU from 9001 to 1500.
>             C) Change sysctl_tcp_adv_win_scale from default 1 to 0 or 2
>             D)We have also found that disabling net.ipv4.tcp_moderate_rcv=
buf on kernel 4.14 is giving exactly the same bad performance speed.
> 5-We have done some kernel bisect to understand when this behaviour has b=
een introduced and found that   commit a337531b942b ("tcp: up initial rmem =
to 128KB and SYN rwin to around 64KB")[2] which has been merged to mainline=
 kernel 4.19.86 is the culprit behind this download performance degradation=
, The commit  mainly did two main changes:
> A)Raising the initial TCP receive buffer size and receive window.
> B)Changing the way in which TCP Dynamic Right Sizing (DRS) is been kicked=
 off.
>
> 6)There was a regression that has been introduced because of the above pa=
tch causing the receive window scaling  to take long time after raising the=
 initial receiver buffer & receive window  and there was additional fix for=
 that  in commit 041a14d26715 ("tcp: start receiver buffer autotuning soone=
r")[3].
>
> 7)Commit 041a14d26715 ("tcp: start receiver buffer autotuning sooner") wa=
s trying to decrease the initial rcvq_space.space which  is used in TCP's i=
nternal auto-tuning to grow socket buffers based on how much data the kerne=
l estimates the sender can send and It should  change over the life of any =
connection based on the amount of data that the sender is sending. This pat=
ch is relying on advmss (which is the MSS configured on the receiver) to id=
entify the initial receive space, although this works very well with receiv=
ers with small MTUs like 1500 it=E2=80=99s doesn=E2=80=99t help if the rece=
iver is configured to use Jumbo frames (9001 MTU) which is the default MTU =
on AWS EC2 instances and this is why we think this hasn=E2=80=99t been repo=
rted before beside the high RTT >=3D12msec required to see the issue as wel=
l.
>
> 8)After further debugging and testing we have found that the issue can on=
ly be reproduced under any of the  below conditions:
> A)Sender (MTU 1500) using bbr/bbrv2 as congestion control algorithm =E2=
=80=94=E2=80=94> Receiver (MTU 9001) with default ipv4.sysctl_tcp_rmem[1] =
=3D 131072   running kernel 4.19.86 or later with RTT >=3D12msec.=E2=80=94=
=E2=80=94>consistently reproducible
> B)Sender (MTU 1500) using cubic as congestion control algorithm with fq a=
s disc =E2=80=94=E2=80=94> Receiver (MTU 9001) with default ipv4.sysctl_tcp=
_rmem[1] =3D 131072 running kernel 4.19.86 or later with RTT >=3D30msec.=E2=
=80=94=E2=80=94>consistently reproducible.
> C)Sender (MTU 1500) using cubic as congestion control algorithm with pfif=
o_fast as qdisc =E2=80=94=E2=80=94> Receiver (MTU 9001) with default ipv4.s=
ysctl_tcp_rmem[1] =3D 131072   running kernel 4.19.86 or later with RTT >=
=3D30msec.=E2=80=94=E2=80=94>intermittently  reproducible
> D)Sender needs a MTU of 1500. If the sender is using MTU of 9001  with no=
 MSS clamping , then we  couldn=E2=80=99t  reproduce the issue.
> E)AWS EC2 instances are using 9001 as MTU by default hence they are likel=
y more impacted by this.
>
>
> 9)With some kernel hacking & packet capture analysis we found that the ma=
in issue is that under the above mentioned conditions the receive window ne=
ver scales up as it looks like the tcp receiver autotuning never kicks off,=
 I have attached to this e-mail  screenshots showing Window scaling with an=
d without the proposed patch.
> We also found that all workarounds either decreasing initial rcvq_space (=
this includes decreasing receiver advertised MSS from 9001 to 1500 or  defa=
ult receive buffer size from 131072 to 87380) or increasing the maximum adv=
ertised receive window (before TCP autotuning start scaling) and this inclu=
des changing net.ipv4.tcp_adv_win_scale from 1 to 0 or 2.
>
> 10)It looks like when the issue happen we have a  kind of deadlock here s=
o advertised receive window has to exceed rcvq_space for the tcp auto tunin=
g to kickoff at the same time with the initial default  configuration the r=
eceive window is not going to exceed rcvq_space because it can only get hal=
f of the initial receive socket buffer size.
>
> 11)The current code which is based on patch has main drawback  which shou=
ld be handled:
> A)It relies on receiver configured MTU to define the initial receive spac=
e(threshold where tcp autotuning starts), as mentioned above this works wel=
l with 1500 MTU because with that it will make sure that initial receive sp=
ace is lower than receive window so tcp autotuning will work just fine whil=
e it won=E2=80=99t work with Jumbo frames in use on the receiver because at=
 this case the receiver won=E2=80=99t start tcp autotuning especially with =
high RTT and we will be hitting the regression that commit  041a14d26715 ("=
tcp: start receiver buffer autotuning sooner") was trying to handle.
> 12)I am proposing  the below patch which is relying on RCV_MSS (our guess=
 about MSS used by the peer which is equal to TCP_MSS_DEFAULT 536 bytes by =
default) this should work regardless the receiver configured MSS. I am also=
 sharing  my iperf test results with and without the patch and also verifie=
d  that the connection won=E2=80=99t get stuck in the middle in case of pac=
ket loss or latency spike which I emulated using tc netem on the sender sid=
e.
>
>
> Test Results using the same sender & receiver:
>
> -Without our proposed patch
>
> #iperf3 -c xx.xx.xx.xx -t15 -i1 -R
> Connecting to host xx.xx.xx.xx, port 5201
> Reverse mode, remote host xx.xx.xx.xx is sending
> [  4] local 172.31.37.167 port 52838 connected to xx.xx.xx.xx port 5201
> [ ID] Interval           Transfer     Bandwidth
> [  4]   0.00-1.00   sec   269 KBytes  2.20 Mbits/sec
> [  4]   1.00-2.00   sec   332 KBytes  2.72 Mbits/sec
> [  4]   2.00-3.00   sec   334 KBytes  2.73 Mbits/sec
> [  4]   3.00-4.00   sec   335 KBytes  2.75 Mbits/sec
> [  4]   4.00-5.00   sec   332 KBytes  2.72 Mbits/sec
> [  4]   5.00-6.00   sec   283 KBytes  2.32 Mbits/sec
> [  4]   6.00-7.00   sec   332 KBytes  2.72 Mbits/sec
> [  4]   7.00-8.00   sec   335 KBytes  2.75 Mbits/sec
> [  4]   8.00-9.00   sec   335 KBytes  2.75 Mbits/sec
> [  4]   9.00-10.00  sec   334 KBytes  2.73 Mbits/sec
> [  4]  10.00-11.00  sec   332 KBytes  2.72 Mbits/sec
> [  4]  11.00-12.00  sec   332 KBytes  2.72 Mbits/sec
> [  4]  12.00-13.00  sec   338 KBytes  2.77 Mbits/sec
> [  4]  13.00-14.00  sec   334 KBytes  2.73 Mbits/sec
> [  4]  14.00-15.00  sec   332 KBytes  2.72 Mbits/sec
> - - - - - - - - - - - - - - - - - - - - - - - - -
> [ ID] Interval           Transfer     Bandwidth       Retr
> [  4]   0.00-15.00  sec  6.07 MBytes  3.39 Mbits/sec    0             sen=
der
> [  4]   0.00-15.00  sec  4.90 MBytes  2.74 Mbits/sec                  rec=
eiver
>
> iperf Done.
>
>
> Test downloading from google endpoint:
>
> # wget https://storage.googleapis.com/kubernetes-release/release/v1.18.9/=
bin/linux/amd64/kubelet
> --2020-12-04 16:53:00--  https://storage.googleapis.com/kubernetes-releas=
e/release/v1.18.9/bin/linux/amd64/kubelet
> Resolving storage.googleapis.com (storage.googleapis.com)... 172.217.1.48=
, 172.217.8.176, 172.217.4.48, ...
> Connecting to storage.googleapis.com (storage.googleapis.com)|172.217.1.4=
8|:443... connected.
> HTTP request sent, awaiting response... 200 OK
> Length: 113320760 (108M) [application/octet-stream]
> Saving to: =E2=80=98kubelet.45=E2=80=99
>
> 100%[=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
>] 113,320,760 3.04MB/s   in 36s
>
> 2020-12-04 16:53:36 (3.02 MB/s) - =E2=80=98kubelet=E2=80=99 saved [113320=
760/113320760]
>
>
> #########################################################################=
###############################################
>
> -With the proposed  patch:
>
> #iperf3 -c xx.xx.xx.xx -t15 -i1 -R
> Connecting to host xx.xx.xx.xx, port 5201
> Reverse mode, remote host xx.xx.xx.xx is sending
> [  4] local 172.31.37.167 port 44514 connected to xx.xx.xx.xx port 5201
> [ ID] Interval           Transfer     Bandwidth
> [  4]   0.00-1.00   sec   911 KBytes  7.46 Mbits/sec
> [  4]   1.00-2.00   sec  8.95 MBytes  75.1 Mbits/sec
> [  4]   2.00-3.00   sec  9.57 MBytes  80.3 Mbits/sec
> [  4]   3.00-4.00   sec  9.56 MBytes  80.2 Mbits/sec
> [  4]   4.00-5.00   sec  9.58 MBytes  80.3 Mbits/sec
> [  4]   5.00-6.00   sec  9.58 MBytes  80.4 Mbits/sec
> [  4]   6.00-7.00   sec  9.59 MBytes  80.4 Mbits/sec
> [  4]   7.00-8.00   sec  9.59 MBytes  80.5 Mbits/sec
> [  4]   8.00-9.00   sec  9.58 MBytes  80.4 Mbits/sec
> [  4]   9.00-10.00  sec  9.58 MBytes  80.4 Mbits/sec
> [  4]  10.00-11.00  sec  9.59 MBytes  80.4 Mbits/sec
> [  4]  11.00-12.00  sec  9.59 MBytes  80.5 Mbits/sec
> [  4]  12.00-13.00  sec  8.05 MBytes  67.5 Mbits/sec
> [  4]  13.00-14.00  sec  9.57 MBytes  80.3 Mbits/sec
> [  4]  14.00-15.00  sec  9.57 MBytes  80.3 Mbits/sec
> - - - - - - - - - - - - - - - - - - - - - - - - -
> [ ID] Interval           Transfer     Bandwidth       Retr
> [  4]   0.00-15.00  sec   136 MBytes  76.3 Mbits/sec    0             sen=
der
> [  4]   0.00-15.00  sec   134 MBytes  75.2 Mbits/sec                  rec=
eiver
>
> iperf Done.
>
> Test downloading from google endpoint:
>
>
> # wget https://storage.googleapis.com/kubernetes-release/release/v1.18.9/=
bin/linux/amd64/kubelet
> --2020-12-04 16:54:34--  https://storage.googleapis.com/kubernetes-releas=
e/release/v1.18.9/bin/linux/amd64/kubelet
> Resolving storage.googleapis.com (storage.googleapis.com)... 172.217.0.16=
, 216.58.192.144, 172.217.6.16, ...
> Connecting to storage.googleapis.com (storage.googleapis.com)|172.217.0.1=
6|:443... connected.
> HTTP request sent, awaiting response... 200 OK
> Length: 113320760 (108M) [application/octet-stream]
> Saving to: =E2=80=98kubelet=E2=80=99
>
> 100%[=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
>] 113,320,760 80.0MB/s   in 1.4s
>
> 2020-12-04 16:54:36 (80.0 MB/s) - =E2=80=98kubelet.1=E2=80=99 saved [1133=
20760/113320760]
>
> Links:
>
> [1] https://github.com/kubernetes/kops/issues/10206
> [2] https://lore.kernel.org/patchwork/patch/1157936/
> [3] https://lore.kernel.org/patchwork/patch/1157883/
>

Unfortunately few things are missing in this report.

What is the RTT between hosts in your test ?

What driver is used at the receiving side ?

Usually, this kind of problem comes when s(kb->len / skb->truesize) is
pathologically small.
This could be caused by a driver lacking scatter gather support at RX
(a 1500 bytes incoming packet would use 12KB of memory or so, because
driver MTU was set to 9000)

Also worth noting that if you set MTU to 9000 (instead of standard
1500), you probably need to tweak a few sysctls.

autotuning is tricky, changing initial values can be good in some
cases, bad in others.

It would be nice if you send "ss -temoi"  output taken at receiver
while transfer is in progress.

>
>
> Thank you.
>
> Hazem
>
> =EF=BB=BFOn 04/12/2020, 18:08, "Hazem Mohamed Abuelfotoh" <abuehaze@amazo=
n.com> wrote:
>
>         Previously receiver buffer auto-tuning starts after receiving
>         one advertised window amount of data.After the initial
>         receiver buffer was raised by
>         commit a337531b942b ("tcp: up initial rmem to 128KB
>         and SYN rwin to around 64KB"),the receiver buffer may
>         take too long for TCP autotuning to start raising
>         the receiver buffer size.
>         commit 041a14d26715 ("tcp: start receiver buffer autotuning soone=
r")
>         tried to decrease the threshold at which TCP auto-tuning starts
>         but it's doesn't work well in some environments
>         where the receiver has large MTU (9001) configured
>         specially within environments where RTT is high.
>         To address this issue this patch is relying on RCV_MSS
>         so auto-tuning can start early regardless
>         the receiver configured MTU.
>
>         Fixes: a337531b942b ("tcp: up initial rmem to 128KB and SYN rwin =
to around 64KB")
>         Fixes: 041a14d26715 ("tcp: start receiver buffer autotuning soone=
r")
>
>     Signed-off-by: Hazem Mohamed Abuelfotoh <abuehaze@amazon.com>
>     ---
>      net/ipv4/tcp_input.c | 3 ++-
>      1 file changed, 2 insertions(+), 1 deletion(-)
>
>     diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
>     index 389d1b340248..f0ffac9e937b 100644
>     --- a/net/ipv4/tcp_input.c
>     +++ b/net/ipv4/tcp_input.c
>     @@ -504,13 +504,14 @@ static void tcp_grow_window(struct sock *sk, co=
nst struct sk_buff *skb)
>      static void tcp_init_buffer_space(struct sock *sk)
>      {
>         int tcp_app_win =3D sock_net(sk)->ipv4.sysctl_tcp_app_win;
>     +   struct inet_connection_sock *icsk =3D inet_csk(sk);
>         struct tcp_sock *tp =3D tcp_sk(sk);
>         int maxwin;
>
>         if (!(sk->sk_userlocks & SOCK_SNDBUF_LOCK))
>                 tcp_sndbuf_expand(sk);
>
>     -   tp->rcvq_space.space =3D min_t(u32, tp->rcv_wnd, TCP_INIT_CWND * =
tp->advmss);
>     +   tp->rcvq_space.space =3D min_t(u32, tp->rcv_wnd, TCP_INIT_CWND * =
icsk->icsk_ack.rcv_mss);
>         tcp_mstamp_refresh(tp);
>         tp->rcvq_space.time =3D tp->tcp_mstamp;
>         tp->rcvq_space.seq =3D tp->copied_seq;
>     --
>     2.16.6
>
>
>
>
>
> Amazon Web Services EMEA SARL, 38 avenue John F. Kennedy, L-1855 Luxembou=
rg, R.C.S. Luxembourg B186284
>
> Amazon Web Services EMEA SARL, Irish Branch, One Burlington Plaza, Burlin=
gton Road, Dublin 4, Ireland, branch registration number 908705
>
>
