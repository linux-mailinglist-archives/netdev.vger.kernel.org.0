Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71BA84B1C8B
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 03:34:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347417AbiBKCc0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 21:32:26 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347425AbiBKCcZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 21:32:25 -0500
Received: from out30-42.freemail.mail.aliyun.com (out30-42.freemail.mail.aliyun.com [115.124.30.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 782415FCD;
        Thu, 10 Feb 2022 18:32:20 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R741e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0V46drYP_1644546737;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0V46drYP_1644546737)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 11 Feb 2022 10:32:18 +0800
Date:   Fri, 11 Feb 2022 10:32:16 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     Wen Gu <guwen@linux.alibaba.com>
Cc:     kgraul@linux.ibm.com, davem@davemloft.net, kuba@kernel.org,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net/smc: Avoid overwriting the copies of clcsock
 callback functions
Message-ID: <YgXKsNIdJIgEhEkd@TonyMac-Alibaba>
Reply-To: Tony Lu <tonylu@linux.alibaba.com>
References: <1644415853-46641-1-git-send-email-guwen@linux.alibaba.com>
 <YgR9XrT8cATDP4Zx@TonyMac-Alibaba>
 <fb71bcc5-77ad-698c-b025-36e1910f868f@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fb71bcc5-77ad-698c-b025-36e1910f868f@linux.alibaba.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 10, 2022 at 04:56:00PM +0800, Wen Gu wrote:
> 
> 
> On 2022/2/10 10:50 am, Tony Lu wrote:
> 
> > I am wondering that there is a potential racing. If ->use_fallback is
> > setted to true, but the rest of replacing process is on the way, others
> > who tested and passed ->use_fallback, they would get old value before
> > replacing.
> > 
> 
> Thanks for your comments.
> 
> I understand your concern. But when I went through all the places that
> check for smc->use_fallback, I haven't found the exact potential racing
> point. Please point out if I missed something. Thank you.
> 
> In my humble opinion, most of the operations after smc->use_fallback check
> have no direct relationship with what did in smc_switch_to_fallback() (the
> replacement of clcsock callback functions), except for which in smc_sendmsg(),
> smc_recvmsg() and smc_sendpage():
> 
> smc_sendmsg():
> 
> 	if (smc->use_fallback) {
> 		rc = smc->clcsock->ops->sendmsg(smc->clcsock, msg, len);
> 	}
> 
> smc_recvmsg():
> 
> 	if (smc->use_fallback) {
> 		rc = smc->clcsock->ops->recvmsg(smc->clcsock, msg, len, flags);
> 	}
> 
> smc_sendpage():
> 
> 	if (smc->use_fallback) {
> 		rc = kernel_sendpage(smc->clcsock, page, offset,
> 				     size, flags);
> 	}
> 
> If smc->use_fallback is set to true, but callback functions (sk_data_ready ...)
> of clcsock haven't been replaced yet at this moment, there may be a racing as
> you described.
> 
> But it won't happen, because fallback must already be done before sending and receiving.
> 
> What do you think about it?
> 
I am concerning about the non-blocking work in workqueue. If we can make
sure the order of fallback is determined, it would be safe. From your
analysis, I think it is safe for now.

Let's back to the patch, the original version of switch_to_fallback()
has a implicit reentrant semantics. This fixes should work, thanks.

Thanks for your detailed investigation.

Best regards,
Tony Lu
