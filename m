Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23C91194042
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 14:48:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727647AbgCZNsg convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 26 Mar 2020 09:48:36 -0400
Received: from zimbra.alphalink.fr ([217.15.80.77]:33960 "EHLO
        zimbra.alphalink.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727444AbgCZNsg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 09:48:36 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail-2-cbv2.admin.alphalink.fr (Postfix) with ESMTP id C2A4A2B52099;
        Thu, 26 Mar 2020 14:48:33 +0100 (CET)
Received: from zimbra.alphalink.fr ([127.0.0.1])
        by localhost (mail-2-cbv2.admin.alphalink.fr [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id ac2um0AxUbXG; Thu, 26 Mar 2020 14:48:32 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by mail-2-cbv2.admin.alphalink.fr (Postfix) with ESMTP id 636222B52093;
        Thu, 26 Mar 2020 14:48:32 +0100 (CET)
X-Virus-Scanned: amavisd-new at mail-2-cbv2.admin.alphalink.fr
Received: from zimbra.alphalink.fr ([127.0.0.1])
        by localhost (mail-2-cbv2.admin.alphalink.fr [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id x1hDRMRExKM6; Thu, 26 Mar 2020 14:48:32 +0100 (CET)
Received: from Simons-MacBook-Pro.local (94-84-15-217.reverse.alphalink.fr [217.15.84.94])
        by mail-2-cbv2.admin.alphalink.fr (Postfix) with ESMTPSA id EE2402B52099;
        Thu, 26 Mar 2020 14:48:31 +0100 (CET)
Subject: Re: [PATCH net-next] pppoe: new ioctl to extract per-channel stats
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Networking <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Guillaume Nault <gnault@redhat.com>
References: <20200326103230.121447-1-s.chopin@alphalink.fr>
 <CAK8P3a2THNOTcx=XMxXRH3RaNYBhsE7gMNx91M8p8D8qUdB-7A@mail.gmail.com>
From:   Simon Chopin <s.chopin@alphalink.fr>
Message-ID: <c70371c2-7783-b66a-3108-dbbda383673d@alphalink.fr>
Date:   Thu, 26 Mar 2020 14:48:31 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <CAK8P3a2THNOTcx=XMxXRH3RaNYBhsE7gMNx91M8p8D8qUdB-7A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: fr
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

(Dropping Michal Ostrowski from the CC list as the address bounces for me)

Le 26/03/2020 à 11:42, Arnd Bergmann a écrit :
> On Thu, Mar 26, 2020 at 11:32 AM Simon Chopin <s.chopin@alphalink.fr> wrote:
>> The PPP subsystem uses the abstractions of channels and units, the
>> latter being an aggregate of the former, exported to userspace as a
>> single network interface.  As such, it keeps traffic statistics at the
>> unit level, but there are no statistics on the individual channels,
>> partly because most PPP units only have one channel.
>>
>> However, it is sometimes useful to have statistics at the channel level,
>> for instance to monitor multilink PPP connections. Such statistics
>> already exist for PPPoL2TP via the PPPIOCGL2TPSTATS ioctl, this patch
>> introduces a very similar mechanism for PPPoE via a new
>> PPPIOCGPPPOESTATS ioctl.
>>
>> The contents of this patch were greatly inspired by the L2TP
>> implementation, many thanks to its authors.
> The patch looks fine from from an interface design perspective,
> but I wonder if you could use a definition that matches the
> structure layout and command number for PPPIOCGL2TPSTATS
> exactly, rather than a "very similar mechanism" with a subset
> of the fields. You would clearly have to pass down a number of
> zero fields, but the implementation could be abstracted at a
> higher level later.
>
>       Arnd

This sounds like a good idea, indeed. Is what follows what you had in mind ?
I'm not too sure about keeping the chan_priv field in this form, my knowledge
of alignment issues being relatively superficial. As I understand it, the matching
fields in l2tp_ioc_stats should always be packed to 8 bytes as they fall on natural
boundaries, but I might be wrong ?

  Simon


diff --git a/include/uapi/linux/ppp-ioctl.h b/include/uapi/linux/ppp-ioctl.h
index a0abc68eceb5..803cbe374fb2 100644
--- a/include/uapi/linux/ppp-ioctl.h
+++ b/include/uapi/linux/ppp-ioctl.h
@@ -79,14 +79,21 @@ struct pppol2tp_ioc_stats {
        __aligned_u64   rx_errors;
 };

-/* For PPPIOCGPPPOESTATS */
-struct pppoe_ioc_stats {
+struct pppchan_ioc_stats {
+       __u8            chan_priv[8];
        __aligned_u64   tx_packets;
        __aligned_u64   tx_bytes;
+       __aligned_u64   tx_errors;
        __aligned_u64   rx_packets;
        __aligned_u64   rx_bytes;
+       __aligned_u64   rx_seq_discards;
+       __aligned_u64   rx_oos_packets;
+       __aligned_u64   rx_errors;
 };

+_Static_assert(sizeof(struct pppol2tp_ioc_stats) == sizeof(struct pppchan_ioc_stats), "same size");
+_Static_assert((size_t)&((struct pppol2tp_ioc_stats *)0)->tx_packets == (size_t)&((struct pppchan_ioc_stats *)0)->tx_packets, "same offset");
+
 /*
  * Ioctl definitions.
  */
@@ -123,7 +130,7 @@ struct pppoe_ioc_stats {
 #define PPPIOCATTCHAN  _IOW('t', 56, int)      /* attach to ppp channel */
 #define PPPIOCGCHAN    _IOR('t', 55, int)      /* get ppp channel number */
 #define PPPIOCGL2TPSTATS _IOR('t', 54, struct pppol2tp_ioc_stats)
-#define PPPIOCGPPPOESTATS _IOR('t', 53, struct pppoe_ioc_stats)
+#define PPPIOCGCHANSTATS _IOR('t', 54, struct pppchan_ioc_stats)

 #define SIOCGPPPSTATS   (SIOCDEVPRIVATE + 0)
 #define SIOCGPPPVER     (SIOCDEVPRIVATE + 1)   /* NEVER change this!! */

