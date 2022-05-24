Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 042165329A1
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 13:46:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237064AbiEXLo0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 07:44:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234556AbiEXLoQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 07:44:16 -0400
Received: from out30-56.freemail.mail.aliyun.com (out30-56.freemail.mail.aliyun.com [115.124.30.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CA8D1209F;
        Tue, 24 May 2022 04:43:53 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R471e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0VEHxxv7_1653392624;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0VEHxxv7_1653392624)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 24 May 2022 19:43:45 +0800
Date:   Tue, 24 May 2022 19:43:44 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     liuyacan@corp.netease.com
Cc:     kgraul@linux.ibm.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, ubraun@linux.ibm.com
Subject: Re: [PATCH v2 net] net/smc: postpone sk_refcnt increment in connect()
Message-ID: <YozE8GrQEKMjjsI4@TonyMac-Alibaba>
Reply-To: Tony Lu <tonylu@linux.alibaba.com>
References: <e0b64b80-90e1-5aed-1ca4-f6d20ebac6b7@linux.ibm.com>
 <20220523152119.406443-1-liuyacan@corp.netease.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220523152119.406443-1-liuyacan@corp.netease.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 23, 2022 at 11:21:19PM +0800, liuyacan@corp.netease.com wrote:
> > >> This is a rather unusual problem that can come up when fallback=true BEFORE smc_connect()
> > >> is called. But nevertheless, it is a problem.
> > >>
> > >> Right now I am not sure if it is okay when we NOT hold a ref to smc->sk during all fallback
> > >> processing. This change also conflicts with a patch that is already on net-next (3aba1030).
> > > 
> > > Do you mean put the ref to smc->sk during all fallback processing unconditionally and remove 
> > > the fallback branch sock_put() in __smc_release()?
> > 
> > What I had in mind was to eventually call sock_put() in __smc_release() even if sk->sk_state == SMC_INIT
> > (currently the extra check in the if() for sk->sk_state != SMC_INIT prevents the sock_put()), but only
> > when it is sure that we actually reached the sock_hold() in smc_connect() before.
> > 
> > But maybe we find out that the sock_hold() is not needed for fallback sockets, I don't know...
> 
> I do think the sock_hold()/sock_put() for smc->sk is a bit complicated, Emm, I'm not sure if it 
> can be simplified..
> 
> In fact, I'm sure there must be another ref count issue in my environment,but I haven't caught it yet.

I am wondering the issue of this ref count. If it is convenient, would
you like to provide some more details?

syzkaller has reported some issues about ref count, but syzkaller and
others' bot don't have RDMA devices, they cannot cover most of the code
routines in SMC. We are working on it to provide SMC fuzz test with RDMA
environment. So it's very nice to have real world issues.

Thanks,
Tony Lu
