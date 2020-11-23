Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A04F2C09EC
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 14:19:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388596AbgKWNOJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 08:14:09 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:48974 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388559AbgKWNOH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Nov 2020 08:14:07 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 52ECD20501;
        Mon, 23 Nov 2020 14:14:02 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id HfJRb24I4Lvz; Mon, 23 Nov 2020 14:14:01 +0100 (CET)
Received: from mail-essen-01.secunet.de (unknown [10.53.40.204])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id D322D20322;
        Mon, 23 Nov 2020 14:14:01 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-01.secunet.de (10.53.40.204) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Mon, 23 Nov 2020 14:14:01 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2044.4; Mon, 23 Nov
 2020 14:14:01 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 8E45D3180619;
 Mon, 23 Nov 2020 07:42:57 +0100 (CET)
Date:   Mon, 23 Nov 2020 07:42:57 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Antony Antony <antony.antony@secunet.com>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-security-module@vger.kernel.org>,
        "Antony Antony" <antony@phenome.org>,
        Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH ipsec-next v5] xfrm: redact SA secret with lockdown
 confidentiality
Message-ID: <20201123064257.GF15658@gauss3.secunet.de>
References: <20201016133352.GA2338@moon.secunet.de>
 <20201117164723.GA3868@moon.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20201117164723.GA3868@moon.secunet.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 17, 2020 at 05:47:23PM +0100, Antony Antony wrote:
> redact XFRM SA secret in the netlink response to xfrm_get_sa()
> or dumpall sa.
> Enable lockdown, confidentiality mode, at boot or at run time.
> 
> e.g. when enabled:
> cat /sys/kernel/security/lockdown
> none integrity [confidentiality]
> 
> ip xfrm state
> src 172.16.1.200 dst 172.16.1.100
> 	proto esp spi 0x00000002 reqid 2 mode tunnel
> 	replay-window 0
> 	aead rfc4106(gcm(aes)) 0x0000000000000000000000000000000000000000 96
> 
> note: the aead secret is redacted.
> Redacting secret is also a FIPS 140-2 requirement.
> 
> v1->v2
>  - add size checks before memset calls
> v2->v3
>  - replace spaces with tabs for consistency
> v3->v4
>  - use kernel lockdown instead of a /proc setting
> v4->v5
>  - remove kconfig option
> 
> Reviewed-by: Stephan Mueller <smueller@chronox.de>
> Signed-off-by: Antony Antony <antony.antony@secunet.com>
> ---
>  include/linux/security.h |  1 +
>  net/xfrm/xfrm_user.c     | 74 ++++++++++++++++++++++++++++++++++++----
>  security/security.c      |  1 +
>  3 files changed, 69 insertions(+), 7 deletions(-)

I'm ok with this and I plan to apply it to ipsec-next if I do not see
objections from the LSM people.

