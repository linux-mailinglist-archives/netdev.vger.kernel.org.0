Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD710595776
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 12:04:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234248AbiHPKEW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 06:04:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234217AbiHPKDj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 06:03:39 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5A399080F
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 01:53:50 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id B086020606;
        Tue, 16 Aug 2022 10:53:48 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id ufsWMSfTFFgm; Tue, 16 Aug 2022 10:53:48 +0200 (CEST)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 280A3205B2;
        Tue, 16 Aug 2022 10:53:48 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id 1E9AC80004A;
        Tue, 16 Aug 2022 10:53:48 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 16 Aug 2022 10:53:47 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Tue, 16 Aug
 2022 10:53:47 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 253563182A2F; Tue, 16 Aug 2022 10:53:47 +0200 (CEST)
Date:   Tue, 16 Aug 2022 10:53:47 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Benedict Wong <benedictwong@google.com>
CC:     <netdev@vger.kernel.org>, <nharold@google.com>,
        <lorenzo@google.com>
Subject: Re: [PATCH ipsec 1/2] xfrm: Check policy for nested XFRM packets in
 xfrm_input
Message-ID: <20220816085347.GC2950045@gauss3.secunet.de>
References: <20220810182210.721493-1-benedictwong@google.com>
 <20220810182210.721493-2-benedictwong@google.com>
 <20220815084514.GA2950045@gauss3.secunet.de>
 <CANrj0baLB5a5QpdmmcNYZLyxe1r0gySLhT3krXVFXKOzBb8aww@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CANrj0baLB5a5QpdmmcNYZLyxe1r0gySLhT3krXVFXKOzBb8aww@mail.gmail.com>
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 15, 2022 at 02:25:42PM -0700, Benedict Wong wrote:
> >
> > Hm, shouldn't the xfrm_policy_check called along the
> > packet path for each round after decapsulation?
> >
> > Do you use ESP transformation offload (INET_ESP_OFFLOAD/
> > INET6_ESP_OFFLOAD)?
> 
> Been a while since I've gotten a chance to look through the
> code, but when I previously looked through the stack, it looked
> like we have policy checks in the following places:
> - IPv4/IPv6 deliver to host
> - UDP/TCP/ICMP/L2TP/SCTP/VTI/raw in direct rcv methods
> 
> Additionally, we have a conditional check in XFRM-I, but
> *only if the packet is crossing network namespaces* (which
> in the Android case, it isn't)

Yes, this is because the secpath is cleared when crossing
network namespaces. The inbound policy check in the packet
path would fail in this case. That's why we do the policy
check there.

> Notably, it appears that the missing case is when the outer
> tunnel is an unencap'd ESP packet, which simply calls xfrm_input
> via xfrm(4|6)_rcv_spi. This changes adds that call to ensure
> that the verification is always performed in each packet path.

Please note that all policy checks are done for the traffic
selector of the inner packets. The inbound policy check makes
sure that the inner packets are allowed to pass and really
came through the SA that is recorded in the secpath.

When receiving an ESP packet, the packets IPsec ID (daddr/
SPI/proto) is mached against the SADB. If a matching SA is
there, it is used to decapsulate. The TS of the decapsulated
packet is used to do the policy lookup then.

If the decapsulated packet is not dropped by the policy lookup
and is again an ESP packet, we start with the SADB lookup as
described above.

So I think the behaviour is correct as it is implemented.

