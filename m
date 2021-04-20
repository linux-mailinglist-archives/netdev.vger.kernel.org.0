Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02281365841
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 13:59:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231718AbhDTL7e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 07:59:34 -0400
Received: from mailout1.secunet.com ([62.96.220.44]:46688 "EHLO
        mailout1.secunet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230118AbhDTL7d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 07:59:33 -0400
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id 4ED44800056;
        Tue, 20 Apr 2021 13:59:01 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 20 Apr 2021 13:59:01 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Tue, 20 Apr
 2021 13:59:00 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 890F531803A8; Tue, 20 Apr 2021 13:59:00 +0200 (CEST)
Date:   Tue, 20 Apr 2021 13:59:00 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Sabrina Dubroca <sd@queasysnail.net>
CC:     <netdev@vger.kernel.org>, Jianwen Ji <jiji@redhat.com>
Subject: Re: [PATCH ipsec] xfrm: xfrm_state_mtu should return at least 1280
 for ipv6
Message-ID: <20210420115900.GG62598@gauss3.secunet.de>
References: <62a73daeec236ed1346a89042050fe4b2fd06226.1618394317.git.sd@queasysnail.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <62a73daeec236ed1346a89042050fe4b2fd06226.1618394317.git.sd@queasysnail.net>
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 16, 2021 at 11:27:59AM +0200, Sabrina Dubroca wrote:
> Jianwen reported that IPv6 Interoperability tests are failing in an
> IPsec case where one of the links between the IPsec peers has an MTU
> of 1280. The peer generates a packet larger than this MTU, the router
> replies with a "Packet too big" message indicating an MTU of 1280.
> When the peer tries to send another large packet, xfrm_state_mtu
> returns 1280 - ipsec_overhead, which causes ip6_setup_cork to fail
> with EINVAL.
> 
> We can fix this by forcing xfrm_state_mtu to return IPV6_MIN_MTU when
> IPv6 is used. After going through IPsec, the packet will then be
> fragmented to obey the actual network's PMTU, just before leaving the
> host.
> 
> Currently, TFC padding is capped to PMTU - overhead to avoid
> fragementation: after padding and encapsulation, we still fit within
> the PMTU. That behavior is preserved in this patch.
> 
> Fixes: 91657eafb64b ("xfrm: take net hdr len into account for esp payload size calculation")
> Reported-by: Jianwen Ji <jiji@redhat.com>
> Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>

Applied, thanks Sabrina!
