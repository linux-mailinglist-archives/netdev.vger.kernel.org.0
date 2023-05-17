Return-Path: <netdev+bounces-3315-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D278706657
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 13:15:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2922E281177
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 11:14:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CB52171B7;
	Wed, 17 May 2023 11:09:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 929F7154A1
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 11:09:39 +0000 (UTC)
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33276DF
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 04:09:19 -0700 (PDT)
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R901e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046050;MF=cambda@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0VisXCKN_1684321741;
Received: from smtpclient.apple(mailfrom:cambda@linux.alibaba.com fp:SMTPD_---0VisXCKN_1684321741)
          by smtp.aliyun-inc.com;
          Wed, 17 May 2023 19:09:02 +0800
From: Cambda Zhu <cambda@linux.alibaba.com>
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.500.231\))
Subject: net: getsockopt(TCP_MAXSEG) on listen sock returns wrong MSS?
Message-Id: <34BAAED6-5CD0-42D0-A9FB-82A01962A2D7@linux.alibaba.com>
Date: Wed, 17 May 2023 19:08:49 +0800
Cc: Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
 Dust Li <dust.li@linux.alibaba.com>,
 Tony Lu <tonylu@linux.alibaba.com>,
 Cambda Zhu <cambda@linux.alibaba.com>
To: netdev@vger.kernel.org,
 "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>
X-Mailer: Apple Mail (2.3731.500.231)
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,
	USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

I want to call setsockopt(TCP_MAXSEG) on a listen sock to let
all child socks have smaller MSS. And I found the child sock
MSS changed but getsockopt(TCP_MAXSEG) on the listen sock
returns 536 always.

It seems the tp->mss_cache is initialized with TCP_MSS_DEFAULT,
but getsockopt(TCP_MAXSEG) returns tp->rx_opt.user_mss only when
tp->mss_cache is 0. I don't understand the purpose of the mss_cache
check of TCP_MAXSEG. If getsockopt(TCP_MAXSEG) on listen sock makes
no sense, why does it have a branch for close/listen sock to return
user_mss? If getsockopt(TCP_MAXSEG) on listen sock is ok, why does
it check mss_cache for a listen sock?

I tried to find the commit log about TCP_MAXSEG, and found that
in commit 0c409e85f0ac ("Import 2.3.41pre2"), the mss_cache check
was added. No more detailed information found. Is this a bug or am
I misunderstanding something?

Regards,
Cambda

