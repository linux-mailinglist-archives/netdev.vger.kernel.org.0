Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B066428540
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 04:44:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233664AbhJKCqG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 22:46:06 -0400
Received: from out2.migadu.com ([188.165.223.204]:58237 "EHLO out2.migadu.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231578AbhJKCqF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 Oct 2021 22:46:05 -0400
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1633920244;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AZ82gyhlQYUiMxzKvLmPbmy3KKD10pObF9BmwWMecNQ=;
        b=V/HaHYLkX4t7w5VW0Wb4yIvTfpx6ok52nXyIehyQEtihWiUmhU2iSDuGHWfJTGkmjvIg0G
        G38wdon32f4gdseq4Zph4+p/dED++Zv1lQA07QNwxlg4VFdkaRQfM1EMjblpp8/cb6cuEA
        /JeVggYTSZXXDDq+/6agvJeAZPamPQQ=
Date:   Mon, 11 Oct 2021 02:44:04 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   yajun.deng@linux.dev
Message-ID: <83d864e81ea774b8124948a65c069e82@linux.dev>
Subject: Re: [PATCH net-next] net: procfs: add seq_puts() statement for
 dev_mcast
To:     "Vladimir Oltean" <olteanv@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20211009164249.euf7dfpccr6kz7a3@skbuf>
References: <20211009164249.euf7dfpccr6kz7a3@skbuf>
 <20210816085757.28166-1-yajun.deng@linux.dev>
 <20211009163511.vayjvtn3rrteglsu@skbuf>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: yajun.deng@linux.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is PCIe NIC with long name, this is the reason why put the 'Interfa=
ce' a whole.=0A=0Abefore:=0AInter-|   Receive                            =
                    |  Transmit=0A face |bytes    packets errs drop fifo =
frame compressed multicast|bytes    packets errs drop fifo colls carrier =
compressed=0A    lo:  251136    2956    0    0    0     0          0     =
    0   251136    2956    0    0    0     0       0          0=0Aenp27s0f=
0:       0       0    0    0    0     0          0         0        0    =
   0    0    0    0     0       0          0=0Aenp27s0f1: 95099489  62711=
6    0 328486    0     0          0    187285 18680642   67213    0    0 =
   0     0       0          0=0Adocker0:       0       0    0    0    0  =
   0          0         0        0       0    0    0    0     0       0  =
        0=0A=0A=0Aafter:=0AInterface|                            Receive =
                                      |                                 T=
ransmit=0A         |            bytes      packets errs   drop fifo frame=
 compressed multicast|            bytes      packets errs   drop fifo col=
ls carrier compressed=0A       lo:           251136         2956    0    =
  0    0     0          0         0            251136         2956    0  =
    0    0     0       0          0=0Aenp27s0f0:                0        =
    0    0      0    0     0          0         0                 0      =
      0    0      0    0     0       0          0=0Aenp27s0f1:         95=
099489       627116    0 328486    0     0          0    187285          =
18680642        67213    0      0    0     0       0          0=0A  docke=
r0:                0            0    0      0    0     0          0      =
   0                 0            0    0      0    0     0       0       =
   0=0A=0A=0A=0AOctober 10, 2021 12:42 AM, "Vladimir Oltean" <olteanv@gma=
il.com> =E5=86=99=E5=88=B0:=0A=0A> On Sat, Oct 09, 2021 at 07:35:11PM +03=
00, Vladimir Oltean wrote:=0A> =0A>> On Mon, Aug 16, 2021 at 04:57:57PM +=
0800, Yajun Deng wrote:=0A>> Add seq_puts() statement for dev_mcast, make=
 it more readable.=0A>> As also, keep vertical alignment for {dev, ptype,=
 dev_mcast} that=0A>> under /proc/net.=0A>> =0A>> Signed-off-by: Yajun De=
ng <yajun.deng@linux.dev>=0A>> ---=0A>> =0A>> FYI, this program got broke=
n by this commit (reverting it restores=0A>> functionality):=0A>> =0A>> r=
oot@debian:~# ifstat=0A>> ifstat: /proc/net/dev: unsupported format.=0A>>=
 =0A>> Confusingly enough, the "ifstat" provided by Debian is not from ip=
route2:=0A>> https://git.kernel.org/pub/scm/network/iproute2/iproute2.git=
/tree/misc/ifstat.c=0A>> but rather a similarly named program:=0A>> https=
://packages.debian.org/source/bullseye/ifstat=0A>> https://github.com/mat=
ttbe/ifstat=0A>> =0A>> I haven't studied how this program parses /proc/ne=
t/dev, but here's how=0A>> the kernel's output changed:=0A> =0A> Ah, it s=
crapes the text for "Inter-|":=0A> https://github.com/matttbe/ifstat/blob=
/main/drivers.c#L825=0A> =0A>> Doesn't work:=0A>> =0A>> root@debian:~# ca=
t /proc/net/dev=0A>> Interface| Receive | Transmit=0A>> | bytes packets e=
rrs drop fifo frame compressed multicast| bytes packets errs drop fifo co=
lls=0A>> carrier compressed=0A>> lo: 97400 1204 0 0 0 0 0 0 97400 1204 0 =
0 0 0 0 0=0A>> bond0: 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0=0A>> sit0: 0 0 0 0 =
0 0 0 0 0 0 0 0 0 0 0 0=0A>> eno2: 5002206 6651 0 0 0 0 0 0 105518642 146=
5023 0 0 0 0 0 0=0A>> swp0: 134531 2448 0 0 0 0 0 0 99599598 1464381 0 0 =
0 0 0 0=0A>> swp1: 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0=0A>> swp2: 4867675 420=
3 0 0 0 0 0 0 58134 631 0 0 0 0 0 0=0A>> sw0p0: 0 0 0 0 0 0 0 0 0 0 0 0 0=
 0 0 0=0A>> sw0p1: 124739 2448 0 1422 0 0 0 0 93741184 1464369 0 0 0 0 0 =
0=0A>> sw0p2: 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0=0A>> sw2p0: 4850863 4203 0 =
0 0 0 0 0 54722 619 0 0 0 0 0 0=0A>> sw2p1: 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0=
 0=0A>> sw2p2: 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0=0A>> sw2p3: 0 0 0 0 0 0 0 =
0 0 0 0 0 0 0 0 0=0A>> br0: 10508 212 0 212 0 0 0 212 61369558 958857 0 0=
 0 0 0 0=0A>> =0A>> Works:=0A>> =0A>> root@debian:~# cat /proc/net/dev=0A=
>> Inter-| Receive | Transmit=0A>> face |bytes packets errs drop fifo fra=
me compressed multicast|bytes packets errs drop fifo colls=0A>> carrier c=
ompressed=0A>> lo: 13160 164 0 0 0 0 0 0 13160 164 0 0 0 0 0 0=0A>> bond0=
: 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0=0A>> sit0: 0 0 0 0 0 0 0 0 0 0 0 0 0 0 =
0 0=0A>> eno2: 30824 268 0 0 0 0 0 0 3332 37 0 0 0 0 0 0=0A>> swp0: 0 0 0=
 0 0 0 0 0 0 0 0 0 0 0 0 0=0A>> swp1: 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0=0A>=
> swp2: 30824 268 0 0 0 0 0 0 2428 27 0 0 0 0 0 0=0A>> sw0p0: 0 0 0 0 0 0=
 0 0 0 0 0 0 0 0 0 0=0A>> sw0p1: 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0=0A>> sw0=
p2: 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0=0A>> sw2p0: 29752 268 0 0 0 0 0 0 156=
4 17 0 0 0 0 0 0=0A>> sw2p1: 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0=0A>> sw2p2: =
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0=0A>> sw2p3: 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0=
=200
