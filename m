Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E24015A4175
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 05:26:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbiH2D0G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Aug 2022 23:26:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229661AbiH2D0D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Aug 2022 23:26:03 -0400
Received: from out30-45.freemail.mail.aliyun.com (out30-45.freemail.mail.aliyun.com [115.124.30.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5699E20BCD;
        Sun, 28 Aug 2022 20:26:02 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R231e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045168;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0VNVmFny_1661743558;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0VNVmFny_1661743558)
          by smtp.aliyun-inc.com;
          Mon, 29 Aug 2022 11:25:59 +0800
Date:   Mon, 29 Aug 2022 11:25:55 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "D. Wythe" <alibuda@linux.alibaba.com>, kgraul@linux.ibm.com,
        wenjia@linux.ibm.com, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH net-next v2 00/10] optimize the parallelism of SMC-R
 connections
Message-ID: <Ywwxw+/INy+01axV@TonyMac-Alibaba>
Reply-To: Tony Lu <tonylu@linux.alibaba.com>
References: <cover.1661407821.git.alibuda@linux.alibaba.com>
 <20220826183213.38eb4cac@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220826183213.38eb4cac@kernel.org>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 26, 2022 at 06:32:13PM -0700, Jakub Kicinski wrote:
> On Fri, 26 Aug 2022 17:51:27 +0800 D. Wythe wrote:
> > This patch set attempts to optimize the parallelism of SMC-R connections,
> > mainly to reduce unnecessary blocking on locks, and to fix exceptions that
> > occur after thoses optimization.
> > 
> > According to Off-CPU graph, SMC worker's off-CPU as that: 
> > 
> > smc_close_passive_work			(1.09%)
> > 	smcr_buf_unuse			(1.08%)
> > 		smc_llc_flow_initiate	(1.02%)
> > 	
> > smc_listen_work 			(48.17%)
> > 	__mutex_lock.isra.11 		(47.96%)
> 
> The patches should be ordered so that the prerequisite changes are
> first, then the removal of locks. Looks like there are 3 patches here
> which carry a Fixes tag, for an old commit but in fact IIUC there is no
> bug in those old commits, the problem only appears after the locking is
> removed?
> 
> That said please wait for IBM folks to review first before reshuffling
> the patches, I presume the code itself won't change.
> 
> Also I still haven't see anyone reply to Al Viro, IIRC he was
> complaining about changes someone from your team has made. 
> I consider this a blocker for applying new patches from your team :(

Yes, the approach of replacing socket needs to be refactored, and I have
been working on it for the fixes. Maybe I missed something, you can
check this reply here [1].

[1] https://lore.kernel.org/all/YvTL%2Fsf6lrhuGDuy@TonyMac-Alibaba/

Thanks.
Tony Lu
