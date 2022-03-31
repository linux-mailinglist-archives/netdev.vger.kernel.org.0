Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 933FD4EE46D
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 01:06:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242000AbiCaXId (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 19:08:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236367AbiCaXIc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 19:08:32 -0400
Received: from uriel.iewc.co.za (uriel.iewc.co.za [IPv6:2c0f:f720:0:3:d6ae:52ff:feb8:f27b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76C8623FF33;
        Thu, 31 Mar 2022 16:06:41 -0700 (PDT)
Received: from [2c0f:f720:fe16:c400::1] (helo=tauri.local.uls.co.za)
        by uriel.iewc.co.za with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jaco@uls.co.za>)
        id 1na3s4-0003TG-Lp; Fri, 01 Apr 2022 01:06:28 +0200
Received: from [192.168.42.210]
        by tauri.local.uls.co.za with esmtp (Exim 4.94.2)
        (envelope-from <jaco@uls.co.za>)
        id 1na3s3-00077U-Hx; Fri, 01 Apr 2022 01:06:27 +0200
Message-ID: <5f1bbeb2-efe4-0b10-bc76-37eff30ea905@uls.co.za>
Date:   Fri, 1 Apr 2022 01:06:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: linux 5.17.1 disregarding ACK values resulting in stalled TCP
 connections
Content-Language: en-GB
To:     Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>
References: <E1nZMdl-0006nG-0J@plastiekpoot>
 <CADVnQyn=A9EuTwxe-Bd9qgD24PLQ02YQy0_b7YWZj4_rqhWRVA@mail.gmail.com>
 <eaf54cab-f852-1499-95e2-958af8be7085@uls.co.za>
 <CANn89iKHbmVYoBdo2pCQWTzB4eFBjqAMdFbqL5EKSFqgg3uAJQ@mail.gmail.com>
 <10c1e561-8f01-784f-c4f4-a7c551de0644@uls.co.za>
 <CADVnQynf8f7SUtZ8iQi-fACYLpAyLqDKQVYKN-mkEgVtFUTVXQ@mail.gmail.com>
 <e0bc0c7f-5e47-ddb7-8e24-ad5fb750e876@uls.co.za>
 <CANn89i+Dqtrm-7oW+D6EY+nVPhRH07GXzDXt93WgzxZ1y9_tJA@mail.gmail.com>
 <CADVnQyn=VfcqGgWXO_9h6QTkMn5ZxPbNRTnMFAxwQzKpMRvH3A@mail.gmail.com>
From:   Jaco Kroon <jaco@uls.co.za>
Organization: Ultimate Linux Solutions (Pty) Ltd
In-Reply-To: <CADVnQyn=VfcqGgWXO_9h6QTkMn5ZxPbNRTnMFAxwQzKpMRvH3A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Neal,

This sniff was grabbed ON THE CLIENT HOST.  There is no middlebox or
anything between the sniffer and the client.  Only the firewall on the
host itself, where we've already establish the traffic is NOT DISCARDED
(at least not in filter/INPUT).

Setup on our end:

2 x routers, usually each with a direct peering with Google (which is
being ignored at the moment so instead traffic is incoming via IPT over DD).

Connected via switch to

2 x firewalls, of which ONE is active (they have different networks
behind them, and could be active / standby for different networks behind
them - avoiding active-active because conntrackd is causing more trouble
than it's worth), Linux hosts, using netfilter, has been operating for
years, no recent kernel upgrades.

4 x hosts in mail cluster, one of which you're looking at here.

On 2022/03/31 17:41, Neal Cardwell wrote:
> On Wed, Mar 30, 2022 at 9:04 AM Jaco Kroon <jaco@uls.co.za> wrote:
> ...
>> When you state sane/normal, do you mean there is fault with the other
>> frames that could not be explained by packet loss in one or both of the
>> directions?
> Yes.
>
> (1) If you look at the attached trace time/sequence plots (from
> tcptrace and xplot.org) there are several behaviors that do not look
> like normal congestive packet loss:
OK.  I'm not 100% sure how these plots of yours work, but let's see if I
can follow your logic here - they mostly make sense.  A legend would
probably help.  As I understand the white dots are original transmits,
green is what has been ACKED.  R is retransmits ... what's the S? 
What's the yellow line (I'm guessing receive window as advertised by the
server)?
>
>   (a) Literally *all* original transmissions (white segments in the
> plot) of packets after client sequence 66263 appear lost (are not
> ACKed). Congestion generally does not behave like that. But broken
> firewalls/middleboxes do.
>        (See netdev-2022-03-29-tcp-disregarded-acks-zoomed-out.png )

Agreed.  So could it be that something in the transit path towards
Google is actually dropping all of that?

As stated - I highly doubt this is on our network unless newer kernel
(on mail cluster) is doing stuff which is causing older netfilter to
drop perhaps?  But this doesn't explain why newer kernel retransmits
data for which it received an ACK.

>
>   (b) When the client is retransmitting packets, only packets at
> exactly snd_una are ACKed. The packets beyond that point are always
> un-ACKed. Again sounds like a broken firewall/middlebox.
>        (See netdev-2022-03-29-tcp-disregarded-acks-zoomed-in.png )
No middlebox between packet sniffer and client ... client here is linux
5.17.1.  Brings me back to the only thing that could be dropping the
traffic is netfilter on the host, or the kernel doesn't like something
about the ACK, or kernel is doing something else wrong as a result of
TFO.  I'm not sure which option I like less.  Unfortunately I also use
netfilter for redirecting traffic into haproxy here so can't exactly
just switch off netfilter.
>
>   (c) After the client receives the server's "ack 73403", the client
> ignores/drops all other incoming packets that show up in the trace.

Agreed.  However, if I read your graph correctly, it gets an ACK for
frame X at ~3.8s into the connection, then for X+2 at 4s, but it keeps
retransmitting X+2, not X+1?


>
>        As Eric notes, this doesn't look like a PAWS issue. And it
> doesn't look like a checksum or sequence/ACK validation issue. The
> client starts ignoring ACKs between two ACKs that have correct
> checksums, valid ACK numbers, and valid (identical) sequence numbers
> and TS val and ecr values (here showing absolute sequence/ACK
> numbers):
I'm not familiar with PAWS here.  Assuming that the green line is ACKs,
then at around 4s we get an ACK that basically ACKs two frames in one
(which is fine from my understanding of TCP), and then the second of
these frames keeps getting retransmitted going forward, so it's almost
like the kernel ACKs the *first* of these two frames but not the second.
>
>     (i) The client processes this ACK and uses it to advance snd_una:
>     17:46:49.889911 IP6 (flowlabel 0x97427, hlim 61, next-header TCP
> (6) payload length: 32) 2a00:1450:4013:c16::1a.25 >
> 2c0f:f720:0:3:d6ae:52ff:feb8:f27b.48590: . cksum 0x7005 (correct)
> 2699968514:2699968514(0) ack 3451415932 win 830 <nop,nop,TS val
> 1206546583 ecr 331191428>

>
>     (ii) The client ignores this ACK and all later ACKs:
>     17:46:49.889912 IP6 (flowlabel 0x97427, hlim 61, next-header TCP
> (6) payload length: 32) 2a00:1450:4013:c16::1a.25 >
> 2c0f:f720:0:3:d6ae:52ff:feb8:f27b.48590: . cksum 0x6a66 (correct)
> 2699968514:2699968514(0) ack 3451417360 win 841 <nop,nop,TS val
> 1206546583 ecr 331191428>
>
> neal
