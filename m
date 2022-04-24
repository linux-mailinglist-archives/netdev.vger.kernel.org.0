Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AA5050D531
	for <lists+netdev@lfdr.de>; Sun, 24 Apr 2022 22:57:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239606AbiDXVAQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Apr 2022 17:00:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233920AbiDXVAO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Apr 2022 17:00:14 -0400
Received: from relais-inet.orange.com (relais-inet.orange.com [80.12.70.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 244415F8FF
        for <netdev@vger.kernel.org>; Sun, 24 Apr 2022 13:57:13 -0700 (PDT)
Received: from opfednr06.francetelecom.fr (unknown [xx.xx.xx.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by opfednr25.francetelecom.fr (ESMTP service) with ESMTPS id 4KmgSR26fpzCrnL
        for <netdev@vger.kernel.org>; Sun, 24 Apr 2022 22:57:11 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=orange.com;
        s=ORANGE001; t=1650833831;
        bh=m40H71R7Wn+uKSuVncq2a2bzlZN+T+jiIO6AhmtH7bk=;
        h=Message-ID:Date:MIME-Version:From:Subject:To:Content-Type:
         Content-Transfer-Encoding;
        b=iWiram5XCSnp5h78UoW796q1MOUNP1bNCGM+RjXhA9fIH9QcU9uw98k604ZAKLLpl
         1gDgRFyFOiL8LOoqqu9SFcWbLItxWPaWX4Y563qOVW4eblo1xAPJuhTt73Yw8dP/GP
         3JwRxF8lNayIPrNNFwjPlN6ABfewh29L/lKY45skBPxjhWEPtRC6uUvExKDD16ViZC
         /Fq2MEgWNQhYb91SfqHuT17N8mc4W2bIHT9CcjAZfbJngJnFlAodFXs5fdD0X/9ATJ
         L/Wrl36TybV0vpkoLXTH+2ViqcZ71cOi7QJAD/OoRzZx5YCRYQr2GZRCnl2nn9ges1
         W3t52MYnu/wrw==
Message-ID: <9067_1650833831_6265B9A7_9067_294_1_88d7e4c2-1c6e-07dd-d2d8-70cc73e02cbe@orange.com>
Date:   Sun, 24 Apr 2022 22:57:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
From:   <alexandre.ferrieux@orange.com>
Subject: Re: Zero-Day bug in VLAN offloading + cooked AF_PACKET
To:     <netdev@vger.kernel.org>
References: <4756cc37-340b-f2f6-e004-0d77573f33df@orange.com>
Content-Language: en-US
In-Reply-To: <4756cc37-340b-f2f6-e004-0d77573f33df@orange.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.115.26.50]
X-ClientProxiedBy: OPE16NORMBX603.corporate.adroot.infra.ftgroup
 (10.115.26.31) To OPE16NORMBX107.corporate.adroot.infra.ftgroup (10.115.27.4)
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_MUA_MOZILLA,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/23/22 22:02, alexandre.ferrieux@orange.com wrote:
> 
> TL;DR: outgoing VLAN-tagged traffic to non-offloaded interfaces is captured as 
> corrupted in cooked mode, and has been so since at least 3.4...
> 
> [...]
> 
> However, there's a catch: for outgoing packets, *if* the interface has no 
> hardware VLAN offloading, the ethertype gets overwritten by ... the TPID 
> (0x8100). As a result, a consumer of the L3 frame has absolutely no way to 
> recover its type.

Digging a bit shows that the key is a discrepancy between where "layer 2.5" sits 
wrt the link/network boundary.

Indeed:

  - to L3 abstractions, the VLAN belongs to "link layer" and should be mostly 
ignored: skb->protocol and skb->network_header rule the world.

  - to (software) VLAN insertion code "__vlan_hwaccel_push_inside", when a frame 
is prepared for transmission by a non-vlan-offload-capable device, the link 
layer stops right after the MAC adresses, the TPID is provided as an ethertype 
and written into skb->protocol, and the original ethertype is explicitly stacked 
after the TCI. In other words, 802.1Q is a kind of layer 3 (though not 
completely: skb->network_header is *not* set to the TPID position - it remains 
at the true L3).

This discrepancy is mostly harmless, except in the presence of a tap: there 
(e.g. in packet_rcv), on the tx path in cooked (SOCK_DGRAM) mode, the packet is 
stripped of everything before its skb->network_header:

   if (sk->sk_type != SOCK_DGRAM)
     skb_push(skb, skb->data - skb_mac_header(skb));
   else if (skb->pkt_type == PACKET_OUTGOING) {
     /* Special case: outgoing packets have ll header at head */
     skb_pull(skb, skb_network_offset(skb));
   }

As a result, the original ethertype is lost, with the effect we know.

Now I can see two ways out:

  (A) "Fix" _vlan_hwaccel_push_inside to update skb->network_header 
(decrementing it by 4 bytes), to preserve the invariant "skb->protocol describes 
what starts at skb->network_header".

  (B) Refine the stripping in packet_rcv (and brothers) to special-case VLANs, 
effectively re-parsing what we've just inserted.

To me, (A) is cleanest as it enforces a broken invariant; however, it possibly 
modifies the tx path in ways I cannot fathom. Conversely, (B) looks like an ugly 
hack whose sole value is to be confined to tap-cloned skbs, bounding the harm it 
may cause, but with a bit of CPU waste...

Please advise :)

-Alex




_________________________________________________________________________________________________________________________

Ce message et ses pieces jointes peuvent contenir des informations confidentielles ou privilegiees et ne doivent donc
pas etre diffuses, exploites ou copies sans autorisation. Si vous avez recu ce message par erreur, veuillez le signaler
a l'expediteur et le detruire ainsi que les pieces jointes. Les messages electroniques etant susceptibles d'alteration,
Orange decline toute responsabilite si ce message a ete altere, deforme ou falsifie. Merci.

This message and its attachments may contain confidential or privileged information that may be protected by law;
they should not be distributed, used or copied without authorisation.
If you have received this email in error, please notify the sender and delete this message and its attachments.
As emails may be altered, Orange is not liable for messages that have been modified, changed or falsified.
Thank you.

