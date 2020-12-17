Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 645752DCCAA
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 07:47:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727190AbgLQGqa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 01:46:30 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:52872 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726525AbgLQGq3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Dec 2020 01:46:29 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 1242D204EF;
        Thu, 17 Dec 2020 07:45:46 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id yg1ZAAZJ2-ox; Thu, 17 Dec 2020 07:45:45 +0100 (CET)
Received: from mail-essen-01.secunet.de (unknown [10.53.40.204])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 97BBF20265;
        Thu, 17 Dec 2020 07:45:45 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-01.secunet.de (10.53.40.204) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Thu, 17 Dec 2020 07:45:45 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2044.4; Thu, 17 Dec
 2020 07:45:45 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id A3924318070E;
 Thu, 17 Dec 2020 07:45:44 +0100 (CET)
Date:   Thu, 17 Dec 2020 07:45:44 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     "Marler, Jonathan" <jonathan.j.marler@hp.com>
CC:     "bpoirier@suse.de" <bpoirier@suse.de>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "martin@strongswan.org" <martin@strongswan.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "kuznet@ms2.inr.ac.ru" <kuznet@ms2.inr.ac.ru>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Bhat, Jayalakshmi Manjunath" <jayalakshmi.bhat@hp.com>,
        "Shankaranarayana, Viswanatha" <viswanatha.s@hp.com>,
        "PURTIPLI, SACHIN" <sachin.purtipli@hp.com>
Subject: Re: USGv6 Tunnel Mode Fragmentation Failures
Message-ID: <20201217064544.GA3576117@gauss3.secunet.de>
References: <CS1PR8401MB12862DA9EC8238888449215ADBF90@CS1PR8401MB1286.NAMPRD84.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CS1PR8401MB12862DA9EC8238888449215ADBF90@CS1PR8401MB1286.NAMPRD84.PROD.OUTLOOK.COM>
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 26, 2020 at 09:21:39AM +0000, Marler, Jonathan wrote:
> We've found an issue while running the following USGv6 tests where the kernel drops outgoing packets:
> 
> 5.3.11 Tunnel Mode: Fragmentation
> 5.4.11 Tunnel Mode: Fragmentation
> 
> During the test, an esp PING request is sent to our device under test, and we send back a response that is rejected by our router with a "packet to big" error.  This error is fine, it's part of the test.  This error packet then sets the MTU to 1280 (which also happens to be the minimum MTU size allowed by ipv6 and the kernel).
> 
> The issue comes up when this mtu is adjusted by the esp6_get_mtu function.  It adjusts it to a value below the 1280 threshold, which causes any packets associated with this MTU to be dropped in the ipv6_setup_cork function.
> 
> We are running on kernel version 4.9.180, but this issue looks as if it would still exist in the latest version except that esp6_get_mtu has been replaced by xfrm_state_mtu.  By adding instrumentation, we found during the test the mtu value of 1280 given by the "packet to big" response gets passed to the esp6_get_mtu function, and the following values are what we logged in that function:
> 
> mtu = 1280
> x->props.header_len = 56
> crypto_aead_authsize(aead) = 12
> net_adj = 0
> blocksize = 8
> 
> This causes the function to return an mtu size of 1206, causing packets thereafter to be dropped because this falls below the IPV6_MIN_MTU threshold.
> 
> Our idea is to modify esp6_get_mtu to limit the minimum mtu to IPV6_MIN_MTU.  We're not certain this is the correct fix, and thought to check with the maintainers of that file, and a few others who have modified that function.  Any help or guidance here is appreciated, thank you.
> 

We should not return a mtu below IPV6_MIN_MTU for IPv6 and not below
IPV6_MIN_MTU for IPv4. So the proposed fix looks correct to me.
