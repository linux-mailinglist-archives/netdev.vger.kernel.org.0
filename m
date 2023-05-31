Return-Path: <netdev+bounces-6784-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 378E0717FAA
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 14:14:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3341A1C20E42
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 12:14:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 938101428A;
	Wed, 31 May 2023 12:14:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8427CC8C5
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 12:14:02 +0000 (UTC)
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9CE7C0
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 05:14:00 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by a.mx.secunet.com (Postfix) with ESMTP id 8B6C22084C;
	Wed, 31 May 2023 14:13:58 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
	by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id PeF4FngxxH3E; Wed, 31 May 2023 14:13:58 +0200 (CEST)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by a.mx.secunet.com (Postfix) with ESMTPS id 0D9E9205ED;
	Wed, 31 May 2023 14:13:58 +0200 (CEST)
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
	by mailout2.secunet.com (Postfix) with ESMTP id 0813080004A;
	Wed, 31 May 2023 14:13:58 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 31 May 2023 14:13:57 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Wed, 31 May
 2023 14:13:57 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
	id 561EF3180CF7; Wed, 31 May 2023 14:13:57 +0200 (CEST)
Date: Wed, 31 May 2023 14:13:57 +0200
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Benedict Wong <benedictwong@google.com>
CC: <netdev@vger.kernel.org>, <martin@strongswan.org>, <nharold@google.com>,
	<evitayan@google.com>
Subject: Re: Re-adding support for nested IPsec tunnels
Message-ID: <ZHc6Bdt4NfI7nclq@gauss3.secunet.de>
References: <20230510013022.2602474-1-benedictwong@google.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230510013022.2602474-1-benedictwong@google.com>
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 10, 2023 at 01:30:20AM +0000, Benedict Wong wrote:
> This patch set adds support for inbound nested IPsec tunnels within the 
> same network namespace by incrementally marking verified secpath entries 
> once policy checks are complete. This allows verification that each layer 
> of nested tunnels can be verified, even where the outermost headers 
> change (src/dst/proto/etc). 
> 
> The previous iteration b0355dbbf13c ("Fix XFRM-I support for nested ESP 
> tunnels") attempted to clear secpath entries once verified, but that 
> caused issues with netfilter policy matching (lack of secpath entries to 
> match against), and transport-in-tunnel mode (where the tunnel policies 
> are still resolvable, and thus expected). 
> 
> Notably, all secpath entries (except where optional) must still have the 
> secpath entries validated, but they may now happen in multiple steps.
> 

Series now applied, thanks Ben!

