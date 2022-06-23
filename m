Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73CB655781E
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 12:48:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230334AbiFWKso (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 06:48:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231248AbiFWKsn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 06:48:43 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AEE2496B9;
        Thu, 23 Jun 2022 03:48:42 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id EE98C20624;
        Thu, 23 Jun 2022 12:48:39 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id czrVqp6l5LlV; Thu, 23 Jun 2022 12:48:39 +0200 (CEST)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 4E40920606;
        Thu, 23 Jun 2022 12:48:39 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id 452F180004A;
        Thu, 23 Jun 2022 12:48:39 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 23 Jun 2022 12:48:39 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Thu, 23 Jun
 2022 12:48:38 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id AD47E3182CD5; Thu, 23 Jun 2022 12:48:38 +0200 (CEST)
Date:   Thu, 23 Jun 2022 12:48:38 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
CC:     Eyal Birger <eyal.birger@gmail.com>, <dsahern@kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <yoshfuji@linux-ipv6.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <shmulik.ladkani@gmail.com>
Subject: Re: [PATCH ipsec-next] xfrm: no need to set DST_NOPOLICY in IPv4
Message-ID: <20220623104838.GC566407@gauss3.secunet.de>
References: <20220520104845.2644470-1-eyal.birger@gmail.com>
 <8557f7a3-9fc6-393d-14bd-d7bd26c4e7fc@6wind.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8557f7a3-9fc6-393d-14bd-d7bd26c4e7fc@6wind.com>
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
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

On Fri, May 20, 2022 at 02:01:19PM +0200, Nicolas Dichtel wrote:
> 
> Le 20/05/2022 à 12:48, Eyal Birger a écrit :
> > This is a cleanup patch following commit e6175a2ed1f1
> > ("xfrm: fix "disable_policy" flag use when arriving from different devices")
> > which made DST_NOPOLICY no longer be used for inbound policy checks.
> > 
> > On outbound the flag was set, but never used.
> > 
> > As such, avoid setting it altogether and remove the nopolicy argument
> > from rt_dst_alloc().
> > 
> > Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
> Reviewed-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>

Now applied to ipsec-next, thanks everyone!
