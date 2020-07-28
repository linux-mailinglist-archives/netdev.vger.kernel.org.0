Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FB622311D4
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 20:37:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732465AbgG1ShJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 14:37:09 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:55438 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729475AbgG1ShI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 14:37:08 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 94F75205A4;
        Tue, 28 Jul 2020 20:37:06 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id R75qeuH7M_oU; Tue, 28 Jul 2020 20:37:06 +0200 (CEST)
Received: from cas-essen-01.secunet.de (201.40.53.10.in-addr.arpa [10.53.40.201])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 152302049A;
        Tue, 28 Jul 2020 20:37:06 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 28 Jul 2020 20:37:05 +0200
Received: from moon.secunet.de (172.18.26.121) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Tue, 28 Jul
 2020 20:37:05 +0200
Date:   Tue, 28 Jul 2020 20:36:58 +0200
From:   Antony Antony <antony.antony@secunet.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     Antony Antony <antony.antony@secunet.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>,
        Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>,
        Antony Antony <antony@phenome.org>
Subject: Re: [PATCH ipsec-next] xfrm: add
 /proc/sys/core/net/xfrm_redact_secret
Message-ID: <20200728183640.GA32084@moon.secunet.de>
Reply-To: <antony.antony@secunet.com>
References: <20200728154342.GA31835@moon.secunet.de>
 <20200728162252.GA3255@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200728162252.GA3255@gondor.apana.org.au>
Organization: secunet
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 29, 2020 at 02:22:52 +1000, Herbert Xu wrote:
> On Tue, Jul 28, 2020 at 05:47:30PM +0200, Antony Antony wrote:
> > when enabled, 1, redact XFRM SA secret in the netlink response to
> > xfrm_get_sa() or dump all sa.
> > 
> > e.g
> > echo 1 > /proc/sys/net/core/xfrm_redact_secret
> > ip xfrm state
> > src 172.16.1.200 dst 172.16.1.100
> > 	proto esp spi 0x00000002 reqid 2 mode tunnel
> > 	replay-window 0
> > 	aead rfc4106(gcm(aes)) 0x0000000000000000000000000000000000000000 96
> > 
> > the aead secret is redacted.
> > 
> > /proc/sys/core/net/xfrm_redact_secret is a toggle.
> > Once enabled, either at compile or via proc, it can not be disabled.
> > Redacting secret is a FIPS 140-2 requirement.
> 
> Couldn't you use the existing fips_enabled sysctl?

that could be a step, however, not yet.

Libreswan in FIPS mode with xfrm_redact_secret enabled would work fine, however, enabling xfrm_redact_secret would break Strongswan in FIPS mode. We can add this option fips_enabled once Strongswan does not need SA secret, child_sa->update().

Also there was interest to able to use xfrm_redact_secret independent of FIPS.

I thik for now it best to be ouside fips_enabled.

