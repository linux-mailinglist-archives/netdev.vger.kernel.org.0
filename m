Return-Path: <netdev+bounces-1712-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 603DE6FEF9C
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 12:05:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EF0002815EB
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 10:05:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 341B41C75C;
	Thu, 11 May 2023 10:05:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28B081C741
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 10:05:03 +0000 (UTC)
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9C577EF6
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 03:05:01 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by a.mx.secunet.com (Postfix) with ESMTP id 8D2DE2085A;
	Thu, 11 May 2023 12:05:00 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
	by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id yGSbEi3E6HKh; Thu, 11 May 2023 12:05:00 +0200 (CEST)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by a.mx.secunet.com (Postfix) with ESMTPS id 0F77220890;
	Thu, 11 May 2023 12:05:00 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
	by mailout2.secunet.com (Postfix) with ESMTP id 0975D80004A;
	Thu, 11 May 2023 12:05:00 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 11 May 2023 12:04:59 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Thu, 11 May
 2023 12:04:59 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
	id 4AAEC3182C36; Thu, 11 May 2023 12:04:59 +0200 (CEST)
Date: Thu, 11 May 2023 12:04:59 +0200
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Benedict Wong <benedictwong@google.com>
CC: <netdev@vger.kernel.org>, <nharold@google.com>, <evitayan@google.com>
Subject: Re: [PATCH ipsec] xfrm: Check if_id in inbound policy/secpath match
Message-ID: <ZFy9y1XC18g3JXqF@gauss3.secunet.de>
References: <20230510011414.2599184-1-benedictwong@google.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230510011414.2599184-1-benedictwong@google.com>
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 10, 2023 at 01:14:14AM +0000, Benedict Wong wrote:
> This change ensures that if configured in the policy, the if_id set in
> the policy and secpath states match during the inbound policy check.
> Without this, there is potential for ambiguity where entries in the
> secpath differing by only the if_id could be mismatched.
> 
> Notably, this is checked in the outbound direction when resolving
> templates to SAs, but not on the inbound path when matching SAs and
> policies.
> 
> Test: Tested against Android kernel unit tests & CTS
> Signed-off-by: Benedict Wong <benedictwong@google.com>

Applied, thanks a lot Ben!

