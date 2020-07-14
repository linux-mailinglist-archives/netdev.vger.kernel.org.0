Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 375E421ED18
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 11:44:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725997AbgGNJoK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 05:44:10 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:32824 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725816AbgGNJoK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Jul 2020 05:44:10 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 7F4AE20538;
        Tue, 14 Jul 2020 11:44:08 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id T3w69OtHEhkc; Tue, 14 Jul 2020 11:44:08 +0200 (CEST)
Received: from mail-essen-02.secunet.de (mail-essen-02.secunet.de [10.53.40.205])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 0B5422027C;
        Tue, 14 Jul 2020 11:44:08 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-02.secunet.de (10.53.40.205) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Tue, 14 Jul 2020 11:44:07 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Tue, 14 Jul
 2020 11:44:07 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 24C7C31800C5;
 Tue, 14 Jul 2020 11:44:07 +0200 (CEST)
Date:   Tue, 14 Jul 2020 11:44:07 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Eyal Birger <eyal.birger@gmail.com>
CC:     <davem@davemloft.net>, <herbert@gondor.apana.org.au>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH ipsec-next 0/2] xfrm interface: use hash to store xfrmi
 contexts
Message-ID: <20200714094407.GR20687@gauss3.secunet.de>
References: <20200709101652.1911784-1-eyal.birger@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200709101652.1911784-1-eyal.birger@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 09, 2020 at 01:16:50PM +0300, Eyal Birger wrote:
> When having many xfrm interfaces, the linear lookup of devices based on
> if_id becomes costly.
> 
> The first patch refactors xfrmi_decode_session() to use the xi used in
> the netdevice priv context instead of looking it up in the list based
> on ifindex. This is needed in order to use if_id as the only key used
> for xi lookup.
> 
> The second patch extends the existing infrastructure - which already
> stores the xfrmi contexts in an array of lists - to use a hash of the
> if_id.
> 
> Example benchmarks:
> - running on a KVM based VM
> - xfrm tunnel mode between two namespaces
> - xfrm interface in one namespace (10.0.0.2)
> 
> Before this change set:
> 
> Single xfrm interface in namespace:
> $ netperf -H 10.0.0.2 -l8 -I95,10 -t TCP_STREAM
> 
> MIGRATED TCP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to 10.0.0.2 () port 0 AF_INET : +/-5.000% @ 95% conf.  : demo
> Recv   Send    Send                          
> Socket Socket  Message  Elapsed              
> Size   Size    Size     Time     Throughput  
> bytes  bytes   bytes    secs.    10^6bits/sec  
> 
> 131072  16384  16384    8.00      298.36
> 
> After adding 400 xfrmi interfaces in the same namespace:
> 
> $ netperf -H 10.0.0.2 -l8 -I95,10 -t TCP_STREAM
> 
> MIGRATED TCP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to 10.0.0.2 () port 0 AF_INET : +/-5.000% @ 95% conf.  : demo
> Recv   Send    Send                          
> Socket Socket  Message  Elapsed              
> Size   Size    Size     Time     Throughput  
> bytes  bytes   bytes    secs.    10^6bits/sec  
> 
> 131072  16384  16384    8.00      221.77   
> 
> After this patchset there was no observed change after adding the
> xfrmi interfaces.
> 
> Eyal Birger (2):
>   xfrm interface: avoid xi lookup in xfrmi_decode_session()
>   xfrm interface: store xfrmi contexts in a hash by if_id
> 
>  net/xfrm/xfrm_interface.c | 52 +++++++++++++++++++++++++--------------
>  1 file changed, 33 insertions(+), 19 deletions(-)

Applied to ipsec-next, thanks a lot Eyal!
