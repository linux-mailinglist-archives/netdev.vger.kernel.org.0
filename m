Return-Path: <netdev+bounces-265-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2734E6F6910
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 12:28:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 67037280CBA
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 10:28:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 215DA746B;
	Thu,  4 May 2023 10:28:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14E82A2D
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 10:28:33 +0000 (UTC)
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25A73524C;
	Thu,  4 May 2023 03:28:23 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1puWBs-00586I-Pl; Thu, 04 May 2023 18:28:02 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 04 May 2023 18:28:01 +0800
Date: Thu, 4 May 2023 18:28:01 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: syzbot <syzbot+b3346cca0c23c839e787@syzkaller.appspotmail.com>
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	pabeni@redhat.com, steffen.klassert@secunet.com,
	syzkaller-bugs@googlegroups.com,
	Alexey Dobriyan <adobriyan@gmail.com>,
	Eric Biederman <ebiederm@xmission.com>
Subject: Re: [syzbot] [net?] WARNING in xfrm_policy_fini (2)
Message-ID: <ZFOIsffqSV07WzRt@gondor.apana.org.au>
References: <000000000000e1fc7905f9189b86@google.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000e1fc7905f9189b86@google.com>
X-Spam-Status: No, score=2.7 required=5.0 tests=BAYES_00,HELO_DYNAMIC_IPADDR2,
	RDNS_DYNAMIC,SPF_HELO_NONE,SPF_PASS,TVD_RCVD_IP,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Apr 11, 2023 at 05:22:53PM -0700, syzbot wrote:
>
> WARNING: CPU: 0 PID: 41 at net/xfrm/xfrm_policy.c:4176 xfrm_policy_fini+0x2f2/0x3c0 net/xfrm/xfrm_policy.c:4176

This code was broken from day one.  Prior to netns this policy
fini function didn't exist.

With netns, somehow it wants to get rid of all xfrm policies.
However, it's not doing a very good job at it because it only
deletes the global policies, and not the socket policies.

Therefore this is completely expected to fail.

Do we have a netns maintainer? What is this supposed to do?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

