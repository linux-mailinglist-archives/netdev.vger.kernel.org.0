Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F55D4DD9E6
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 13:42:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236386AbiCRMnq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 08:43:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236364AbiCRMno (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 08:43:44 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [176.9.125.105])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DEC42E35A6;
        Fri, 18 Mar 2022 05:42:25 -0700 (PDT)
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 7CA1022239;
        Fri, 18 Mar 2022 13:42:23 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1647607344;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2gI1By7d7pZODcR9Jrg5KJt0BGb720XzrAnoqlGIfr4=;
        b=QvJUD4udt719Hh1uXXCDZXR4omi2XirBDFQ9PiSYxnxL6ALD9y/ey8k1tkzwj/W0o2GB6d
        Vp7YevDYqptBt/awTEiOdtosRJMbCW9XSbE84+4Ca7V8Rb177Upw7r6RP/um3ZEacNhcXo
        uVWeJKqzLAtsTeimAWBctdJxfx231Uw=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 18 Mar 2022 13:42:23 +0100
From:   Michael Walle <michael@walle.cc>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     UNGLinuxDriver@microchip.com, davem@davemloft.net,
        devicetree@vger.kernel.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        robh+dt@kernel.org
Subject: Re: [PATCH net-next 0/5] net: lan966x: Add support for FDMA
In-Reply-To: <20220318121033.vklrsnxspg2f66dp@soft-dev3-1.localhost>
References: <20220317185159.1661469-1-horatiu.vultur@microchip.com>
 <20220318110731.27794-1-michael@walle.cc>
 <20220318121033.vklrsnxspg2f66dp@soft-dev3-1.localhost>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <d05af3a88ef1bd846f0b9c6f548e2c45@walle.cc>
X-Sender: michael@walle.cc
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2022-03-18 13:10, schrieb Horatiu Vultur:
> The 03/18/2022 12:07, Michael Walle wrote:
>> > Currently when injecting or extracting a frame from CPU, the frame
>> > is given to the HW each word at a time. There is another way to
>> > inject/extract frames from CPU using FDMA(Frame Direct Memory Access).
>> > In this way the entire frame is given to the HW. This improves both
>> > RX and TX bitrate.
>> 
>> I wanted to test this. ping and such works fine and I'm also
>> seeing fdma interrupts.
> 
> Thanks for testing this also on your board.
> 
>> But as soon as I try iperf3 I get a skb_panic
>> (due to frame size?). Hope that splash below helps.
> 
> I have not seen this issue. But it looks like it is a problem that 
> there
> is no more space to add the FCS.
> Can you tell me how you run iperf3 so I can also try it?

oh, I forgot to include the commandline.

# on the remote computer
$ iperf3 --version
iperf 3.6 (cJSON 1.5.2)
Linux eddie01 4.19.0-18-686-pae #1 SMP Debian 4.19.208-1 (2021-09-29) 
i686
Optional features available: CPU affinity setting, IPv6 flow label, 
SCTP, TCP congestion algorithm setting, sendfile / zerocopy, socket 
pacing, authentication
$ iperf3 -s

# on the board
$ iperf3 --version
iperf 3.10.1 (cJSON 1.7.13)
Linux buildroot 5.17.0-rc8-next-20220316-00058-gc6cb0628f2a6-dirty #385 
SMP Fri Mar 18 13:34:26 CET 2022 armv7l
Optional features available: CPU affinity setting, IPv6 flow label, TCP 
congestion algorithm setting, sendfile / zerocopy, socket pacing, bind 
to device, support IPv4 don't fragment
$ iperf3 -c eddie01

> Also I have a small diff that might fix the issue:
> ---
> --- a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
> +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
> @@ -534,6 +534,8 @@ int lan966x_fdma_xmit(struct sk_buff *skb, __be32
> *ifh, struct net_device *dev)
>         struct lan966x_tx_dcb *next_dcb, *dcb;
>         struct lan966x_tx *tx = &lan966x->tx;
>         struct lan966x_db *next_db;
> +       int needed_headroom;
> +       int needed_tailroom;
>         dma_addr_t dma_addr;
>         int next_to_use;
>         int err;
> @@ -554,10 +556,11 @@ int lan966x_fdma_xmit(struct sk_buff *skb,
> __be32 *ifh, struct net_device *dev)
> 
>         /* skb processing */
>         skb_tx_timestamp(skb);

btw. skb_tx_timestamp() should be as close to the handover
of the frame to the hardware as possible, no?

> -       if (skb_headroom(skb) < IFH_LEN * sizeof(u32)) {
> -               err = pskb_expand_head(skb,
> -                                      IFH_LEN * sizeof(u32) -
> skb_headroom(skb),
> -                                      0, GFP_ATOMIC);
> +       needed_headroom = max_t(int, IFH_LEN * sizeof(u32) -
> skb_headroom(skb), 0);
> +       needed_tailroom = max_t(int, ETH_FCS_LEN - skb_tailroom(skb), 
> 0);
> +       if (needed_headroom || needed_tailroom) {
> +               err = pskb_expand_head(skb, needed_headroom, 
> needed_tailroom,
> +                                      GFP_ATOMIC);
>                 if (unlikely(err)) {
>                         dev->stats.tx_dropped++;
>                         err = NETDEV_TX_OK;

Indeed this will fix the issue:

# iperf3 -c eddie01
Connecting to host eddie01, port 5201
[  5] local 10.0.1.143 port 55342 connected to 10.0.1.42 port 5201
[ ID] Interval           Transfer     Bitrate         Retr  Cwnd
[  5]   0.00-1.01   sec  43.8 MBytes   364 Mbits/sec    0    245 KBytes
[  5]   1.01-2.02   sec  43.8 MBytes   364 Mbits/sec    0    246 KBytes
[  5]   2.02-3.03   sec  43.8 MBytes   364 Mbits/sec    0    259 KBytes

# iperf3 -R -c eddie01
Connecting to host eddie01, port 5201
Reverse mode, remote host eddie01 is sending
[  5] local 10.0.1.143 port 55346 connected to 10.0.1.42 port 5201
[ ID] Interval           Transfer     Bitrate
[  5]   0.00-1.00   sec  28.6 MBytes   240 Mbits/sec
[  5]   1.00-2.00   sec  28.9 MBytes   242 Mbits/sec
[  5]   2.00-3.00   sec  28.7 MBytes   241 Mbits/sec

-michael
