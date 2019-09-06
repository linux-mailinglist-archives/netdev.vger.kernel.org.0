Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85F6DAB719
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 13:26:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387845AbfIFL0E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 07:26:04 -0400
Received: from rp02.intra2net.com ([62.75.181.28]:44044 "EHLO
        rp02.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726008AbfIFL0D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 07:26:03 -0400
Received: from mail.m.i2n (unknown [172.17.128.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by rp02.intra2net.com (Postfix) with ESMTPS id 07AC8100104;
        Fri,  6 Sep 2019 13:26:02 +0200 (CEST)
Received: from localhost (mail.m.i2n [127.0.0.1])
        by localhost (Postfix) with ESMTP id C8A0F6CC;
        Fri,  6 Sep 2019 13:26:01 +0200 (CEST)
X-Virus-Scanned: by Intra2net Mail Security (AVE=8.3.54.90,VDF=8.16.22.164)
X-Spam-Status: 
X-Spam-Level: 0
Received: from rocinante.m.i2n (rocinante.m.i2n [172.16.1.86])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: smtp-auth-user)
        by mail.m.i2n (Postfix) with ESMTPSA id D9DAE59D;
        Fri,  6 Sep 2019 13:25:59 +0200 (CEST)
Subject: Re: r8169: Performance regression and latency instability
From:   Juliana Rodrigueiro <juliana.rodrigueiro@intra2net.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org
References: <72898d5b-9424-0bcd-3d8a-fc2e2dd0dbf1@intra2net.com>
 <217e3fa9-7782-08c7-1f2b-8dabacaa83f9@gmail.com>
 <792d3a56-32aa-afee-f2b4-1f867b9cf75f@applied-asynchrony.com>
 <8fa71d82-d309-df38-5924-2275db188b61@gmail.com>
 <a757135b-ec79-0ad5-5886-2989330424ee@intra2net.com>
Cc:     Thomas Jarosch <thomas.jarosch@intra2net.com>,
        "Gerd v. Egidy" <gerd.von.egidy@intra2net.com>
Message-ID: <c4f8fd11-39e4-8ea1-f405-80453a4b001e@intra2net.com>
Date:   Fri, 6 Sep 2019 13:25:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <a757135b-ec79-0ad5-5886-2989330424ee@intra2net.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all!

I would like to kindly ask your help to understand this subject, since my
familiarity with the network stack is limited. I'm still
trying to find a solution for the latency problems with Realtek cards I
reported earlier.

Why does the GSO have to be forced on the socket level
if drivers for high performance chips will have it enabled by default?

A consequence of forcing GSO is that TSO is also forced [1] in
sk_setup_caps() via the NETIF_F_GSO_SOFTWARE flag (list of features with
software fallbacks). I'm sorry for my ignorance, but I wonder if TSO
will really be done in software in case the card does have NETIF_F_TSO
capability but "might not work properly" [2]. (Plus tx-checksum and SG
are all off)

Effectively for me, the following patch shows the same good performance
as the 3.14 kernel (or kernel 4.19 with reverted "tcp: switch to GSO 
being always on").

diff --git a/net/core/sock.c b/net/core/sock.c
index 9c32e8eb64da..d792d12e0f66 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1770,7 +1770,7 @@ void sk_setup_caps(struct sock *sk, struct 
dst_entry *dst)
         sk_dst_set(sk, dst);
         sk->sk_route_caps = dst->dev->features | sk->sk_route_forced_caps;
         if (sk->sk_route_caps & NETIF_F_GSO)
-               sk->sk_route_caps |= NETIF_F_GSO_SOFTWARE;
+               sk->sk_route_caps |= (NETIF_F_GSO_SOFTWARE & 
~NETIF_F_ALL_TSO);
         sk->sk_route_caps &= ~sk->sk_route_nocaps;
         if (sk_can_gso(sk)) {
                 if (dst->header_len && !xfrm_dst_offload_ok(dst)) {


Any help is highly appreciated.

Best regards,
Juliana.


[1] 
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/net/core/sock.c?h=linux-4.19.y#n1773
[2] 
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/drivers/net/ethernet/realtek/r8169.c?h=linux-4.19.y#n7590
