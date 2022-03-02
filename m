Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54BE34C9EA0
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 08:51:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239892AbiCBHwh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 02:52:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233208AbiCBHwg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 02:52:36 -0500
Received: from out30-54.freemail.mail.aliyun.com (out30-54.freemail.mail.aliyun.com [115.124.30.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 951651C133;
        Tue,  1 Mar 2022 23:51:49 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0V61jDA6_1646207506;
Received: from localhost(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0V61jDA6_1646207506)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 02 Mar 2022 15:51:47 +0800
Date:   Wed, 2 Mar 2022 15:51:46 +0800
From:   "D. Wythe" <alibuda@linux.alibaba.com>
To:     Wen Gu <guwen@linux.alibaba.com>
Cc:     kgraul@linux.ibm.com, kuba@kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: Re: [PATCH net] net/smc: fix unexpected SMC_CLC_DECL_ERR_REGRMB error
Message-ID: <20220302075146.GA29189@e02h04389.eu6sqa>
Reply-To: "D. Wythe" <alibuda@linux.alibaba.com>
References: <1646140644-121649-1-git-send-email-alibuda@linux.alibaba.com>
 <82bd43af-1d90-4395-b868-4a045bf4a47b@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=gb2312
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <82bd43af-1d90-4395-b868-4a045bf4a47b@linux.alibaba.com>
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

On Wed, Mar 02, 2022 at 03:28:32PM +0800, Wen Gu wrote:
> 
> 
> ÔÚ 2022/3/1 ÏÂÎç9:17, D. Wythe Ð´µÀ:
> >From: "D. Wythe" <alibuda@linux.alibaba.com>
> >
> >Remove connections from link group is not synchronous with handling
> >SMC_LLC_DELETE_RKEY, which means that even the number of connections is
> >less that SMC_RMBS_PER_LGR_MAX, it does not mean that the connection can
> >register rtoken successfully later, in other words, the rtoken entry may
> >have not been released. This will cause an unexpected
> >SMC_CLC_DECL_ERR_REGRMB to be reported, and then ths smc connection have
> >to fallback to TCP.
> >
> 
> 
> IMHO, if there are SMC_RMBS_PER_LGR_MAX connections in the link group now,
> one of them is being removed and here comes a new connection at this moment,
> then:
> 
> (1) without this patch, the new connection will be added into the old link group
>     but fallback if the removing connection has not finished unregistering its rmb.
> 
> (2) with this patch, a new link group will be created and the new connection
>     will be added into the new link group.
> 
> I am wondering if (1) should be considered as a issue, or just a bydesign?
> If it is a issue, I think this patch works, Thanks!


We should always be willing to improve the success rate of the SMC 
connection, creating a new group is not a side effect of this patch, it 
actually dues to the state bewteen connections that can not achieve 
clock synchronization. In fact, it can happen in any times.

Thanks.
