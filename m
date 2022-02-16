Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 367D04B7E4C
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 04:15:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241938AbiBPDNY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 22:13:24 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236446AbiBPDNV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 22:13:21 -0500
Received: from out30-56.freemail.mail.aliyun.com (out30-56.freemail.mail.aliyun.com [115.124.30.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC8F3B1084;
        Tue, 15 Feb 2022 19:13:09 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R881e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0V4b46J._1644981187;
Received: from localhost(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0V4b46J._1644981187)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 16 Feb 2022 11:13:07 +0800
Date:   Wed, 16 Feb 2022 11:13:07 +0800
From:   "D. Wythe" <alibuda@linux.alibaba.com>
To:     Karsten Graul <kgraul@linux.ibm.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH net-next] net/smc: return ETIMEDOUT when
 smc_connect_clc() timeout
Message-ID: <20220216031307.GA2243@e02h04389.eu6sqa>
Reply-To: "D. Wythe" <alibuda@linux.alibaba.com>
References: <1644913490-21594-1-git-send-email-alibuda@linux.alibaba.com>
 <c85310ed-fd9c-fa8c-88d2-862b5d99dbbe@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c85310ed-fd9c-fa8c-88d2-862b5d99dbbe@linux.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 15, 2022 at 02:02:37PM +0100, Karsten Graul wrote:
> On 15/02/2022 09:24, D. Wythe wrote:
> > From: "D. Wythe" <alibuda@linux.alibaba.com>
> > 
> > When smc_connect_clc() times out, it will return -EAGAIN(tcp_recvmsg
> > retuns -EAGAIN while timeout), then this value will passed to the
> > application, which is quite confusing to the applications, makes
> > inconsistency with TCP.
> > 
> > From the manual of connect, ETIMEDOUT is more suitable, and this patch
> > try convert EAGAIN to ETIMEDOUT in that case.
> 
> You say that the sock_recvmsg() in smc_clc_wait_msg() returns -EAGAIN?
> Is there a reason why you translate it in __smc_connect() and not already in
> smc_clc_wait_msg() after the call to sock_recvmsg()?


Because other code that uses smc_clc_wait_msg() handles EAGAIN allready, 
and the only exception is smc_listen_work(), but it doesn't really matter for it. 

The most important thing is that this conversion needs to be determined according to 
the calling scene, convert in smc_clc_wait_msg() is not very suitable.

Thanks.
