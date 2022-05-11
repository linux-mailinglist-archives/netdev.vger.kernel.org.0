Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03DB552343F
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 15:32:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242171AbiEKNcY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 09:32:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232658AbiEKNcX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 09:32:23 -0400
Received: from out30-56.freemail.mail.aliyun.com (out30-56.freemail.mail.aliyun.com [115.124.30.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B89C162204;
        Wed, 11 May 2022 06:32:17 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0VCwIlBX_1652275933;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0VCwIlBX_1652275933)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 11 May 2022 21:32:14 +0800
Date:   Wed, 11 May 2022 21:32:13 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     Guangguan Wang <guangguan.wang@linux.alibaba.com>
Cc:     kgraul@linux.ibm.com, davem@davemloft.net, kuba@kernel.org,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 2/2] net/smc: align the connect behaviour with TCP
Message-ID: <Ynu63ZIz433CYBtb@TonyMac-Alibaba>
Reply-To: Tony Lu <tonylu@linux.alibaba.com>
References: <20220509115837.94911-1-guangguan.wang@linux.alibaba.com>
 <20220509115837.94911-3-guangguan.wang@linux.alibaba.com>
 <Ynowrcnqb/wv1iNt@TonyMac-Alibaba>
 <b380e302-5b16-2de0-eca0-9805359daaaa@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b380e302-5b16-2de0-eca0-9805359daaaa@linux.alibaba.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 10, 2022 at 08:58:38PM +0800, Guangguan Wang wrote:
> 
> 
> On 2022/5/10 17:30, Tony Lu wrote:
> > On Mon, May 09, 2022 at 07:58:37PM +0800, Guangguan Wang wrote:
> >> Connect with O_NONBLOCK will not be completed immediately
> >> and returns -EINPROGRESS. It is possible to use selector/poll
> >> for completion by selecting the socket for writing. After select
> >> indicates writability, a second connect function call will return
> >> 0 to indicate connected successfully as TCP does, but smc returns
> > 
> > If the connection is established successfully, the following up call of
> > connect() returns -EISCONN (SS_CONNECTED), which is expected and SMC
> > does it, same as TCP.
> > 
> > In case of misunderstanding, could you append more detailed information?
> > 
> > Thanks,
> > Tony Lu
> > 
> 
> io_uring uses nonblocking connect as follow steps:
>   1) call connect with nonblocking
>   2) wait for selector/poll to indicate writability
>   3) call connect to confirm connection's state
> 
> In the third step, tcp changes the socket state from SS_CONNECTING to
> SS_CONNECTED and returns 0 if the connection is established successfully,
> but smc returns -EISCONN.

Based on the steps you list, I am wondering if it is finished in the
step #1, the call of connect() in step #3 would return -EISCONN. Should
we check 0 and -EISCONN in  step #3?

To fix this issue, I think we should be careful about adding and
handling sock state, maybe we could push it to net-next and take
advantage of sock state. And I will test this patch later in our test
cases.

Thanks,
Tony Lu
