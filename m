Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EB3E4EB867
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 04:40:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241355AbiC3Cmc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 22:42:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231689AbiC3Cma (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 22:42:30 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86CE4F3294
        for <netdev@vger.kernel.org>; Tue, 29 Mar 2022 19:40:45 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id z9-20020a05683020c900b005b22bf41872so14042607otq.13
        for <netdev@vger.kernel.org>; Tue, 29 Mar 2022 19:40:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=vW+hbyk4J/zcF4AgSfPOyw6F0EA04UzRtTKR2+Wu8Pc=;
        b=ULB1pYYD4leOqjCkyU+/DAlIHxfJJVDibwWb229gXdIbV+47IHRb9USAKV4J/kPRif
         jQJHtG89hfFWPyghXNsiEqTLxdFNDSK4pYmZ2BWTQjJkczTaeoibEJZNkW+hqIfAY875
         3zcmjq5n2qOZ/MU9IHey576EeCi6YONvBN2xwIhBNdq2EFI5RjiJXpwrNxvjTKVf2+vY
         5IJmYj0XX4naGeHBegIF1x7hvzdEiLBHZqr9f2J5T4rV69soTrmP2y79+mFQnyLlGOPG
         9/th3DO62OyVbcWp5T7bgxyHp7XnIf6ZqCXlILHdGeDgFxlB2mkrHzcnG1mgea9qzs8a
         OznQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=vW+hbyk4J/zcF4AgSfPOyw6F0EA04UzRtTKR2+Wu8Pc=;
        b=WRE2CQjcX9ZvgjmVSM+SPUbURtT2/1LCN4ASojZ0VEu/gDmAqLZ83n8nillVFKNoA1
         YyKRvTmIiWNbr0qNA3rhKUku4FpRMGmVsLpthRoOWGo+a4oHpFG4ReDOAWTW6ZFC0u7h
         Nz8jUEDebu2MUvou9GWOsw+qn3XuaR7njvlYwcxeO49IryugHe4jJ5C8fbUrzOKvr2sz
         FNceGhsfzNsJcXZlXGLeHZ6jEfI2txZy87oTKosCvc7U34meMORUifHfJao19zoPUqDj
         fC8i1U/qISdWyF6hl8PnexhOrEN/YjKjYXyg2uY293WTqF9GU9EvChMTfv1XxiOBc+RU
         PipQ==
X-Gm-Message-State: AOAM532woTdyammCmgCn9qLRnEHWkO08UNFsfpbf2Ug9kjUQYCWD+0C+
        cWi3EEb7n58BlRXdpA0tY+PM4SoaGSP5clUUOyR8EJtyBCkonQ==
X-Google-Smtp-Source: ABdhPJz7Co/sHeok0vZYzmR1cumXFb/98oumsbdjCWC517BlX5eIUCy26FQ032mOYcSNoh5dEMlWCoC+85zSPEaDf4Q=
X-Received: by 2002:a05:6902:72a:b0:634:6843:499c with SMTP id
 l10-20020a056902072a00b006346843499cmr32583948ybt.36.1648608033765; Tue, 29
 Mar 2022 19:40:33 -0700 (PDT)
MIME-Version: 1.0
References: <E1nZMdl-0006nG-0J@plastiekpoot> <CADVnQyn=A9EuTwxe-Bd9qgD24PLQ02YQy0_b7YWZj4_rqhWRVA@mail.gmail.com>
In-Reply-To: <CADVnQyn=A9EuTwxe-Bd9qgD24PLQ02YQy0_b7YWZj4_rqhWRVA@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 29 Mar 2022 19:40:22 -0700
Message-ID: <CANn89i+nJ=jiTtm40xa9d5XT+ru4urZf7yPHSFF2M22vQePH+A@mail.gmail.com>
Subject: Re: linux 5.17.1 disregarding ACK values resulting in stalled TCP connections
To:     Neal Cardwell <ncardwell@google.com>
Cc:     Jaco <jaco@uls.co.za>, LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 29, 2022 at 7:01 PM Neal Cardwell <ncardwell@google.com> wrote:
>
> On Tue, Mar 29, 2022 at 9:03 PM Jaco <jaco@uls.co.za> wrote:
> >
> > Dear All,
> >
> > I'm seeing very strange TCP behaviour.  Disabled TCP Segmentation Offlo=
ad to
> > try and pinpoint this more closely.
> >
> > It seems the kernel is ignoring ACKs coming from the remote side in som=
e cases.
> > In this case, on one of four hosts, and seemingly between this one host=
 and
> > Google ... (We've have two emails to google stuck on another host due t=
o same
> > issue, but several hundred others passed out today on that same host). =
 I also
> > killed selective ACKs as a test as these are known to sometimes cause i=
ssues
> > for firewalls and "tcp accelerators" (or used to at the very least).
> >
> > SMTP connection between ourselves and Google ... I'm going to be select=
ive in
> > copying from tcpdump (full coversation up to the point where I killed i=
t
> > because it plainly got stuck in a loop is attached).
> >
> > Connection setup:
> >
> > 00:56:17.055481 IP6 2c0f:f720:0:3:d6ae:52ff:feb8:f27b.59110 > 2a00:1450=
:400c:c07::1b.25: Flags [S], seq 956633779, win 62580, options [mss 8940,no=
p,nop,TS val 3687705482 ecr 0,nop,wscale 7,tfo  cookie f025dd84b6122510,nop=
,nop], length 0
> >
> > 00:56:17.217747 IP6 2a00:1450:400c:c07::1b.25 > 2c0f:f720:0:3:d6ae:52ff=
:feb8:f27b.59110: Flags [S.], seq 726465675, ack 956633780, win 65535, opti=
ons [mss 1440,nop,nop,TS val 3477429218 ecr 3687705482,nop,wscale 8], lengt=
h 0
> >
> > 00:56:17.218628 IP6 2a00:1450:400c:c07::1b.25 > 2c0f:f720:0:3:d6ae:52ff=
:feb8:f27b.59110: Flags [P.], seq 726465676:726465760, ack 956633780, win 2=
56, options [nop,nop,TS val 3477429220 ecr 3687705482], length 84: SMTP: 22=
0 mx.google.com ESMTP e16-20020a05600c4e5000b0038c77be9b2dsi226281wmq.72 - =
gsmtp
> >
> > 00:56:17.218663 IP6 2c0f:f720:0:3:d6ae:52ff:feb8:f27b.59110 > 2a00:1450=
:400c:c07::1b.25: Flags [.], ack 726465760, win 489, options [nop,nop,TS va=
l 3687705645 ecr 3477429220], length 0
> >
> > This is pretty normal, we advertise an MSS of 8940 and the return is 14=
40, thus
> > we shouldn't send segments larger than that, and they "can't".  I need =
to
> > determine if this is some form of offloading or they really are sending=
 >1500
> > byte frames (which I know won't pass our firewalls without fragmentatio=
n so
> > probably some form of NIC offloading - which if it was active on older =
5.8
> > kernels did not cause problems):
> >
> > 00:56:17.709905 IP6 2a00:1450:400c:c07::1b.25 > 2c0f:f720:0:3:d6ae:52ff=
:feb8:f27b.59110: Flags [P.], seq 726465979:726468395, ack 956634111, win 2=
61, options [nop,nop,TS val 3477429710 ecr 3687705973], length 2416: SMTP
> >
> > 00:56:17.709906 IP6 2a00:1450:400c:c07::1b.25 > 2c0f:f720:0:3:d6ae:52ff=
:feb8:f27b.59110: Flags [P.], seq 726468395:726470811, ack 956634111, win 2=
61, options [nop,nop,TS val 3477429710 ecr 3687705973], length 2416: SMTP
> >
> > These are the only two frames I can find that supposedly exceeds the MS=
S values
> > (although, they don't exceed our value).
> >
> > Then everything goes pretty normal for a bit.  The last data we receive=
 from
> > the remote side before stuff goes wrong:
> >
> > 00:56:18.088725 IP6 2a00:1450:400c:c07::1b.25 > 2c0f:f720:0:3:d6ae:52ff=
:feb8:f27b.59110: Flags [P.], seq 726471823:726471919, ack 956634348, win 2=
61, options [nop,nop,TS val 3477430089 ecr 3687706330], length 96: SMTP
> >
> > We ACK immediately along with the next segment:
> >
> > 00:56:18.088969 IP6 2c0f:f720:0:3:d6ae:52ff:feb8:f27b.59110 > 2a00:1450=
:400c:c07::1b.25: Flags [.], seq 956634348:956635776, ack 726471919, win 44=
6, options [nop,nop,TS val 3687706515 ecr 3477430089], length 1428: SMTP
> >
> > Hereafter there is a flurry of data that we transmit, all nicely acknow=
ledged,
> > no retransmits that I can pick up (eyeballs).
> >
> > Before a long sequence of TX data we get this ACK:
> >
> > 00:56:18.576247 IP6 2a00:1450:400c:c07::1b.25 > 2c0f:f720:0:3:d6ae:52ff=
:feb8:f27b.59110: Flags [.], ack 956700036, win 774, options [nop,nop,TS va=
l 3477430577 ecr 3687706840], length 0
> >
> > We then continue to RX a sequence of:
> >
> > 00:56:18.576300 IP6 2c0f:f720:0:3:d6ae:52ff:feb8:f27b.59110 > 2a00:1450=
:400c:c07::1b.25: Flags [.], seq 956745732:956747160, ack 726471919, win 44=
6, options [nop,nop,TS val 3687707002 ecr 3477430577], length 1428: SMTP
> >
> > up to:
> >
> > 00:56:18.577031 IP6 2c0f:f720:0:3:d6ae:52ff:feb8:f27b.59110 > 2a00:1450=
:400c:c07::1b.25: Flags [P.], seq 956778576:956780004, ack 726471919, win 4=
46, options [nop,nop,TS val 3687707003 ecr 3477430577], length 1428: SMTP
> >
> > Before we hit our first retransmit:
> >
> > 00:56:18.960078 IP6 2c0f:f720:0:3:d6ae:52ff:feb8:f27b.59110 > 2a00:1450=
:400c:c07::1b.25: Flags [.], seq 956700036:956701464, ack 726471919, win 44=
6, options [nop,nop,TS val 3687707386 ecr 3477430577], length 1428: SMTP
> >
> > Since 956700036 is the last ACKed data, this seems correct, not sure wh=
at timer
> > this is based on though, the ACK for the just prior data came in ~384ms=
 prior
> > (could be based on normal time to ACK, I don't know, this is about doub=
le the
> > usual round-trip-time currently).
> >
> > And then we receive this ACK (we can see this time the kernel waited fo=
r ACK of
> > this single segment):
> >
> > 00:56:19.126678 IP6 2a00:1450:400c:c07::1b.25 > 2c0f:f720:0:3:d6ae:52ff=
:feb8:f27b.59110: Flags [.], ack 956701464, win 785, options [nop,nop,TS va=
l 3477431127 ecr 3687707386], length 0
> >
> > Then we do something (in my opinion) strange by jumping back to the tai=
l of the previous burst:
> >
> > 00:56:19.126735 IP6 2c0f:f720:0:3:d6ae:52ff:feb8:f27b.59110 > 2a00:1450=
:400c:c07::1b.25: Flags [.], seq 956780004:956781432, ack 726471919, win 44=
6, options [nop,nop,TS val 3687707553 ecr 3477431127], length 1428: SMTP
> >
> > 00:56:19.126751 IP6 2c0f:f720:0:3:d6ae:52ff:feb8:f27b.59110 > 2a00:1450=
:400c:c07::1b.25: Flags [.], seq 956781432:956782860, ack 726471919, win 44=
6, options [nop,nop,TS val 3687707553 ecr 3477431127], length 1428: SMTP
> >
> > We then jump back and retransmit again from the just received ACK:
> >
> > 00:56:19.510078 IP6 2c0f:f720:0:3:d6ae:52ff:feb8:f27b.59110 > 2a00:1450=
:400c:c07::1b.25: Flags [.], seq 956701464:956702892, ack 726471919, win 44=
6, options [nop,nop,TS val 3687707936 ecr 3477431127], length 1428: SMTP
> >
> > We then continue from there on as I'd expect (slow restart), this goes =
pretty
> > normal up to:
> >
> > 00:56:19.997088 IP6 2a00:1450:400c:c07::1b.25 > 2c0f:f720:0:3:d6ae:52ff=
:feb8:f27b.59110: Flags [.], ack 956708604, win 841, options [nop,nop,TS va=
l 3477431998 ecr 3687708261], length 0
> >
> > 00:56:19.997148 IP6 2c0f:f720:0:3:d6ae:52ff:feb8:f27b.59110 > 2a00:1450=
:400c:c07::1b.25: Flags [.], seq 956708604:956710032, ack 726471919, win 44=
6, options [nop,nop,TS val 3687708423 ecr 3477431998], length 1428: SMTP
> >
> > 00:56:20.262683 IP6 2a00:1450:400c:c07::1b.25 > 2c0f:f720:0:3:d6ae:52ff=
:feb8:f27b.59110: Flags [.], ack 956710032, win 852, options [nop,nop,TS va=
l 3477432263 ecr 3687708423], length 0
> >
> > Up to here is fine, now things gets bizarre, we just jump to a differen=
t
> > sequence number, which has already been ACKed:
> >
> > 00:56:20.380076 IP6 2c0f:f720:0:3:d6ae:52ff:feb8:f27b.59110 > 2a00:1450=
:400c:c07::1b.25: Flags [.], seq *956707176*:956708604, ack 726471919, win =
446, options [nop,nop,TS val 3687708806 ecr 3477431998], length 1428: SMTP
> >
> > 00:56:20.542356 IP6 2a00:1450:400c:c07::1b.25 > 2c0f:f720:0:3:d6ae:52ff=
:feb8:f27b.59110: Flags [.], ack 956710032, win 852, options [nop,nop,TS va=
l 3477432543 ecr 3687708423], length 0
> >
> > And remote side re-ACKs the 956710032 value, which frankly indicates we=
 need to
> > realize that the data we are transmitting has already been received, an=
d we can
> > continue on to transmit the segments following up on sequence number 95=
6710032,
> > instead we choose to get stuck in this sequence:
> >
> > 00:56:21.180080 IP6 2c0f:f720:0:3:d6ae:52ff:feb8:f27b.59110 > 2a00:1450=
:400c:c07::1b.25: Flags [.], seq 956707176:956708604, ack 726471919, win 44=
6, options [nop,nop,TS val 3687709606 ecr 3477431998], length 1428: SMTP
> >
> > 00:56:21.342347 IP6 2a00:1450:400c:c07::1b.25 > 2c0f:f720:0:3:d6ae:52ff=
:feb8:f27b.59110: Flags [.], ack 956710032, win 852, options [nop,nop,TS va=
l 3477433343 ecr 3687708423], length 0
> >
> > 00:56:22.780101 IP6 2c0f:f720:0:3:d6ae:52ff:feb8:f27b.59110 > 2a00:1450=
:400c:c07::1b.25: Flags [.], seq 956707176:956708604, ack 726471919, win 44=
6, options [nop,nop,TS val 3687711206 ecr 3477431998], length 1428: SMTP
> >
> > 00:56:22.942346 IP6 2a00:1450:400c:c07::1b.25 > 2c0f:f720:0:3:d6ae:52ff=
:feb8:f27b.59110: Flags [.], ack 956710032, win 852, options [nop,nop,TS va=
l 3477434943 ecr 3687708423], length 0
> >
> > And here the connection dies.  It eventually times out, and we retry to=
 the
> > next host, resulting in the same problem.
> >
> > I am aware that Google is having congestion issues in the JHB area in S=
A
> > currently, and there are probably packet delays and losses somewhere al=
ong the
> > line between us, but this really should not stall as dead as it is here=
.
> >
> > Looking at only the incoming ACK values, I can see they are strictly
> > increasing, so we've never received an ACK > 956710032, but this is sti=
ll
> > greater than the value we are retransmitting.
> >

It could be that ACK packets have a wrong checksum, after some point
is reached (some bug in a firewall/middlebox)

"tcpdump -v" will tell you something about checksum errors.
And/or "nstat -az | grep TcpInCsumError"

Also, packets could be dropped in a layer like netfilter.
Make sure you do not have a rule rate limiting flows, or something like tha=
t.

> > The first time we transmitted the frame at sequence number 956707176 wa=
s part
> > of the longest sequence of TX frames without a returning ACK, part of t=
his
> > sequence:
> >
> > ...
> >
> > 00:56:18.414299 IP6 2c0f:f720:0:3:d6ae:52ff:feb8:f27b.59110 > 2a00:1450=
:400c:c07::1b.25: Flags [.], seq 956705748:956707176, ack 726471919, win 44=
6, options [nop,nop,TS val 3687706840 ecr 3477430415], length 1428: SMTP
> >
> > 00:56:18.414302 IP6 2c0f:f720:0:3:d6ae:52ff:feb8:f27b.59110 > 2a00:1450=
:400c:c07::1b.25: Flags [P.], seq 956707176:956708604, ack 726471919, win 4=
46, options [nop,nop,TS val 3687706840 ecr 3477430415], length 1428: SMTP
> >
> > 00:56:18.414316 IP6 2c0f:f720:0:3:d6ae:52ff:feb8:f27b.59110 > 2a00:1450=
:400c:c07::1b.25: Flags [.], seq 956708604:956710032, ack 726471919, win 44=
6, options [nop,nop,TS val 3687706840 ecr 3477430415], length 1428: SMTP
> >
> > ...
> >
> > Google here is ACKing not only the frame we are continuously retransmit=
ting,
> > but also the frame directly after ... so why would the kernel not move =
on to
> > retransmitting starting from sequence number 956710032 (which is larger=
 than
> > the start sequence number of the frame we are retransmitting)?
> >
> > Kind Regards,
> > Jaco
>
> Thanks for the report!  I have CC-ed the netdev list, since it is
> probably a better forum for this discussion.
>
> Can you please attach (or link to) a tcpdump raw .pcap file  (produced
> with the -w flag)? There are a number of tools that will make this
> easier to visualize and analyze if we can see the raw .pcap file. You
> may want to anonymize the trace and/or capture just headers, etc (for
> example, the -s flag can control how much of each packet tcpdump
> grabs).
>
> Can you please share the exact kernel version of the client machine?
>
> Also, can you please summarize/clarify whether you think the client,
> server, or both are misbehaving?
>
> Thanks!
> neal
