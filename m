Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B75943FB919
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 17:38:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237615AbhH3Piw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 11:38:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237508AbhH3Piv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 11:38:51 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A64FC06175F
        for <netdev@vger.kernel.org>; Mon, 30 Aug 2021 08:37:57 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id u14so31933339ejf.13
        for <netdev@vger.kernel.org>; Mon, 30 Aug 2021 08:37:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=JF+4zb8krwFIQgHdb2rsSw9vpfFyX0Z9uMAVD3JOUR8=;
        b=benhsRsBQmeGZ+fHrfklv0g928jJc7KDc8Du9QPaURO95Krmn8bl8o7yVzVh82o9wz
         ZcJk6ULBlbNclcYxcEK+JtPibAEexCipSooB/ZSJBD2ESHvjss48TTiLkmtoJOgNmGSX
         gHGY+AKKl//JNEfXbLpSopgQmRhtI/vYVexgouETePULEOyuOpJho3dDmac2+UTFLBHO
         8/WBvIla2AmWQLYuoGxObfgzlvkDMxKOCbhSgC93X1UNNhRWYycjYM7S5BQ1zJTTROUt
         LQ2AQgaT+tjNDNP+bKbULrML/iUAli9FMPwIQ5KP6LMhcVgeOMROY6wn9mfM/iZZCWLI
         I/6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=JF+4zb8krwFIQgHdb2rsSw9vpfFyX0Z9uMAVD3JOUR8=;
        b=U6frzRBWnqCtIhvTNcREEEvdNxEc+pdTBDRxK1JaZu61Ao10BBgMoEcFlX4gpcBhpo
         PTuvB16Nt6Y2kLYUC9ZhqXwCU0wfp/0RxSRJIlJXDLMC5/Px76oGMvU4+v3KSjNe8Yg3
         +L3ZfSIpudAnnEVIn7wcJwzQZeA16tGFt9s1e5+4bOQElK+FeXM5pIHfBnJohTbc92nl
         Q1uKS/8rCgKAZDzFzTBtgOyL2QZqXOFTojZRrngV7rQbQZZTqtHGqp4ni43dAZVld/O9
         P9GCvfgCQlA9uXmom0joPX62XDn3IhjWSonj0K6H3/L/g0do5lx8CfxYaA6By0+xJdJq
         r8FA==
X-Gm-Message-State: AOAM533OURAboLITItIOYXSyZs7LlMecuGLg2RNFxcZQYIpbQtYHx5Lb
        gFygc9q5z9Q1m0XrATWFru5hiY6y3fZfoZ2ftplQNYzLd9egFg==
X-Google-Smtp-Source: ABdhPJyB9RgLqt8Ni09atTiUMN4PE86RO13DJCxxjYHhi6RFwyEzaMjpBi2OJXAbe0eC3ZClqh+Iwa38CM+q4h1ekUU=
X-Received: by 2002:a17:906:6b96:: with SMTP id l22mr16057071ejr.430.1630337875823;
 Mon, 30 Aug 2021 08:37:55 -0700 (PDT)
MIME-Version: 1.0
From:   Michael Johnson <mjohnson459@gmail.com>
Date:   Mon, 30 Aug 2021 16:37:45 +0100
Message-ID: <CACsRnHVGatk0YrV1ayrGqK0S3G1xTJYatgY07h86bRZ5BFA6Ug@mail.gmail.com>
Subject: Delay sending packets after a wireless roam
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

I posted this on linux-wireless last week but didn't receive much
response, I hope it is ok to repeat it here.

I'm having an odd issue with wireless roaming whereby any time I roam
from one access point to another (same SSID) I start receiving packets
instantly after the roam is successful but experience a delay of
roughly 1 second before I can send packets out. I have seen this with
multiple configurations but haven't been able to test with the
mainline kernel yet (working on it now). Listening to the netlink
traffic I can see the roam is successful with the interface going down
and then back up but nothing seems to be logged or sent that hints at
what the delay might be.

I started seeing this delay after upgrading from Ubuntu 16.04 to 20.04
but because so much of the wireless stack changed between those
releases I'm not sure if it's possible to bisect the change?

Configurations I've tested that show this behaviour:
  Distro(kernel) version - 20.04 (5.4, 5.8 and 5.11), Kali 2021.2 (5.10)
  Hardware(driver): intel (iwlwifi), qualcomm (ath10k), realtek.
  Supplicant: iwd and wpa_supplicant
  Manager: iwd, systemd-networkd, NetworkManager
  Data: ping, iperf3 (tcp and udp), custom python udp script
  APs:  Meraki MR46, tp-link decos

Here is the output of the simplest test that still shows the issue
(ping + tcpdump + iwd + 5.11.0-27-generic):
https://pastebin.com/92TKKktb

My naive tl;dr of that data is:
  30.322638 - we start to roam which falls between icmp_seq=121 and
icmp_seq=122.
  30.415411 - roam is complete
  30.424277 - iwd is sending and receiving neighbor reports over the link
  31.358491 - an ARP request is sent out (why is the ARP cache cleared?)
  31.367930 - ARP response
  31.368009 - packets start being sent again as soon as we get the ARP response

Can anyone help me understand what might be happening between the
interface going "up" at 30.415411 and the ARP request at 31.358491
please? I don't think the ARP is the problem given I can clear the arp
cache without any delay but I hope it hints at what the underlying
issue might be.
I'm also curious if anyone else sees the same delay in their environment?

I'm not that familiar with networking in Linux so I apologise if any
of my description/question didn't make sense.

Kind Regards,
Michael
