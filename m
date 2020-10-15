Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9249728F896
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 20:29:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728593AbgJOS3Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 14:29:16 -0400
Received: from pipe.dmesg.gr ([185.6.77.131]:53422 "EHLO pipe.dmesg.gr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726382AbgJOS3Q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Oct 2020 14:29:16 -0400
X-Greylist: delayed 310 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Oct 2020 14:29:13 EDT
Received: from marvin.dmesg.gr (unknown [IPv6:2a03:e40:42:102::97])
        by pipe.dmesg.gr (Postfix) with ESMTPSA id 78EA8A7607;
        Thu, 15 Oct 2020 21:24:01 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=dmesg.gr; s=2013;
        t=1602786241; bh=5w7wM/qqDpw4iM6L10pTkgDak9kimhi9uvExyg7t2nA=;
        h=From:To:Subject:Date:From;
        b=LzLFVEQK4U1peLHOkmpOaeS1IvXvvyZPRLYuii8KcW6WVw12NUuCN+lWBkfE2IZmM
         m15JpxRBBZ7XSI1KZ7+eGEv6ycQAZ+87ghbJFKggsxwQaRnp0Va+m6SZH4ck+pH3I0
         fBC4pEk+XUPcazaRBCmhZr5Wy1IMXIaSOKjLMSEkzGo7MO5rkzgNSt7JbqpNYs3mhC
         yvJHzwBf1cYWoDj/0Po5GJHmCOWqobHD31CzZeR8gU49xf0YgYbIudWiKq4/jYyRX4
         3g341yKVekkzwE1w+AC1oX43txfPL98pAyIiG1aiajw15vUKK1i2ChgDCQ1nbRzBjz
         g/hX8Ctfaua1w==
Received: by marvin.dmesg.gr (Postfix, from userid 1000)
        id D2FE8222B23; Thu, 15 Oct 2020 21:23:59 +0300 (EEST)
From:   Apollon Oikonomopoulos <apoikos@dmesg.gr>
To:     netdev@vger.kernel.org
Subject: TCP sender stuck in persist despite peer advertising non-zero window 
Date:   Thu, 15 Oct 2020 21:23:59 +0300
Message-ID: <87eelz4abk.fsf@marvin.dmesg.gr>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi,

I'm trying to debug a (possible) TCP issue we have been encountering
sporadically during the past couple of years. Currently we're running
4.9.144, but we've been observing this since at least 3.16.

Tl;DR: I believe we are seeing a case where snd_wl1 fails to be properly
updated, leading to inability to recover from a TCP persist state and
would appreciate some help debugging this.

The long version:

The issue manifests with the client =E2=86=92 server direction of an rsync
pipeline being stuck in TCP persist even though the server actually
advertises a non-zero window. The stall is not readily reproducible,
although it happens quite often (with a ~10% probability I'd say) when a
cluster of 4 machines tries to rsync an 800GB dataset from a single
server at the same time.

For those not familiar with the way rsync works, it essentially creates
a self-throttling, blocking pipeline using both directions of a single
TCP stream to connect the stages:

                 C               S              C
              generator -----> sender -----> receiver
                          A             A'

      [C: Client, S: Server, A & A': TCP stream directions]

Direction A carries file checksum data for the sender to decide what to
send, and A' carries file data for the receiver to write to disk. It's
always A that ends up in persist mode, while A' works normally. When the
zero-window condition hits, eventually the whole transfer stalls because
the generator does not send out metadata and the server has nothing more
to process and send to the receiver. When this happens, the socket on C
looks like this:

 $ ss -mito dst :873

 State      Recv-Q Send-Q                Local Address:Port                =
                 Peer Address:Port=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20
 ESTAB      0      392827               2001:db8:2a::3:38022               =
              2001:db8:2a::18:rsync                 timer:(persist,1min56se=
c,0)
	 skmem:(r0,rb4194304,t0,tb530944,f3733,w401771,o0,bl0,d757) ts sack cubic =
wscale:7,7 rto:204 backoff:15 rtt:2.06/0.541 ato:40 mss:1428 cwnd:10 ssthre=
sh:46 bytes_acked:22924107 bytes_received:100439119971 segs_out:7191833 seg=
s_in:70503044 data_segs_out:16161 data_segs_in:70502223 send 55.5Mbps lasts=
nd:16281856 lastrcv:14261988 lastack:3164 pacing_rate 133.1Mbps retrans:0/1=
1 rcv_rtt:20 rcv_space:2107888 notsent:392827 minrtt:0.189


while the socket on S looks like this:

 $ ss -mito src :873

 State      Recv-Q Send-Q                Local Address:Port                =
                 Peer Address:Port=20=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20
 ESTAB      0      0                   2001:db8:2a::18:rsync               =
               2001:db8:2a::3:38022                 timer:(keepalive,3min7s=
ec,0)
  	 skmem:(r0,rb3540548,t0,tb4194304,f0,w0,o0,bl0,d292) ts sack cubic wscal=
e:7,7 rto:204 rtt:1.234/1.809 ato:40 mss:1428 cwnd:1453 ssthresh:1431 bytes=
_acked:100439119971 bytes_received:22924106 segs_out:70503089 segs_in:71918=
33 data_segs_out:70502269 data_segs_in:16161 send 13451.4Mbps lastsnd:14277=
708 lastrcv:16297572 lastack:7012576 pacing_rate 16140.1Mbps retrans:0/794 =
rcv_rtt:7.5 rcv_space:589824 minrtt:0.026

There's a non-empty send queue on C, while S obviously has enough space
to accept new data. Also note the difference between lastsnd and lastrcv
on C. tcpdump reveals the ZWP exchange between C and S:

  [=E2=80=A6]
  09:34:34.165148 0c:c4:7a:f9:68:e4 > 0c:c4:7a:f9:69:78, ethertype IPv6 (0x=
86dd), length 86: (flowlabel 0xcbf6f, hlim 64, next-header TCP (6) payload =
length: 32) 2001:db8:2a::3.38022 > 2001:db8:2a::18.873: Flags [.], cksum 0x=
711b (incorrect -> 0x4d39), seq 4212361595, ack 1253278418, win 16384, opti=
ons [nop,nop,TS val 2864739840 ecr 2885730760], length 0
  09:34:34.165354 0c:c4:7a:f9:69:78 > 0c:c4:7a:f9:68:e4, ethertype IPv6 (0x=
86dd), length 86: (flowlabel 0x25712, hlim 64, next-header TCP (6) payload =
length: 32) 2001:db8:2a::18.873 > 2001:db8:2a::3.38022: Flags [.], cksum 0x=
1914 (correct), seq 1253278418, ack 4212361596, win 13831, options [nop,nop=
,TS val 2885760967 ecr 2863021624], length 0
  [=E2=80=A6 repeats every 2 mins]

S responds with a non-zero window (13831 << 7), but C seems to never
pick it up. I dumped the internal connection state by hooking at the
bottom of tcp_ack using the attached systemtap script, which reveals the
following:

 ack: 4212361596, ack_seq: 1253278418, prior_snd_una: 4212361596
 sk_send_head seq:4212361596, end_seq: 4212425472
 snd_wnd: 0, tcp_wnd_end: 4212361596, snd_wl1: 1708927328
 flag: 4100, may update window: 0
 rcv_tsval: 2950255047, ts_recent: 2950255047

Everything seems to check out, apart from the (strange ?) fact that
ack_seq < snd_wl1 by some 450MB, which AFAICT leads
tcp_may_update_window() to reject the update:

  static inline bool tcp_may_update_window(const struct tcp_sock *tp,
                                          const u32 ack, const u32 ack_seq,
                                          const u32 nwin)
  {
          return  after(ack, tp->snd_una) ||
                  after(ack_seq, tp->snd_wl1) ||
                  (ack_seq =3D=3D tp->snd_wl1 && nwin > tp->snd_wnd);
  }

If I understand correctly, the only ways to recover from a zero window
in a case like this would be for ack_seq to equal snd_wl1, or
after(ack_seq, tp->snd_wl1) to be true, none of which holds in our case.

Overall it looks like snd_wl1 stopped advancing at some point and the
peer sequence numbers wrapped in the meantime as traffic in the opposite
direction continued. Every single of the 5 hung connections I've seen in
the past week is in this state, with ack_seq < snd_wl1. The problem is
that - at least to my eyes - there's no way snd_wl1 could *not* advance
when processing a valid ACK, so I'm really stuck here (or I'm completely
misled and talking nonsense :) Any ideas?

Some potentially useful details about the setup and the issue:

 - All machines currently run Debian Stretch with kernel 4.9.144; we
   have been seeing this since at least Linux 3.16.

 - We've witnessed the issue with different hardware (servers &
   NICs). Currently all NICs are igb, but we've had tg3 on both sides at
   some point and still experienced hangs. We tweaked TSO settings in
   the past and it didn't seem to make a difference.

 - It correlates with network congestion. We can never reproduce this
   with a single client, but it happens when all 4 machines try to rsync
   at the same time. Also limiting the bandwidth of the transfers from
   userspace makes the issue less frequent.

Regards,
Apollon

P.S: Please Cc me on any replies as I'm not subscribed to the list.


--=-=-=
Content-Type: text/plain
Content-Disposition: inline; filename=zwp.stp

probe kernel.statement("tcp_ack@./net/ipv4/tcp_input.c:3751")
{
  if ($sk->sk_send_head != NULL) {
	  ack_seq = @cast(&$skb->cb[0], "tcp_skb_cb", "kernel<net/tcp.h>")->seq
	  printf("ack: %d, ack_seq: %d, prior_snd_una: %d\n", $ack, ack_seq, $prior_snd_una)
	  seq = @cast(&$sk->sk_send_head->cb[0], "tcp_skb_cb", "kernel<net/tcp.h>")->seq
	  end_seq = @cast(&$sk->sk_send_head->cb[0], "tcp_skb_cb", "kernel<net/tcp.h>")->end_seq
	  printf("sk_send_head seq:%d, end_seq: %d\n", seq, end_seq)

	  snd_wnd = @cast($sk, "tcp_sock", "kernel<linux/tcp.h>")->snd_wnd
	  snd_wl1 = @cast($sk, "tcp_sock", "kernel<linux/tcp.h>")->snd_wl1
	  ts_recent = @cast($sk, "tcp_sock", "kernel<linux/tcp.h>")->rx_opt->ts_recent
	  rcv_tsval = @cast($sk, "tcp_sock", "kernel<linux/tcp.h>")->rx_opt->rcv_tsval
	  printf("snd_wnd: %d, tcp_wnd_end: %d, snd_wl1: %d\n", snd_wnd, $prior_snd_una + snd_wnd, snd_wl1)
	  printf("flag: %x, may update window: %d\n", $flag, $flag & 0x02)
	  printf("rcv_tsval: %d, ts_recent: %d\n", rcv_tsval, ts_recent)
	  print("\n")
     }
}


--=-=-=--
