Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 053B6521624
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 14:58:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242101AbiEJNCm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 09:02:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235608AbiEJNCl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 09:02:41 -0400
Received: from out199-14.us.a.mail.aliyun.com (out199-14.us.a.mail.aliyun.com [47.90.199.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EA8825BA7A;
        Tue, 10 May 2022 05:58:42 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=guangguan.wang@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0VCrRFdb_1652187518;
Received: from 30.43.104.207(mailfrom:guangguan.wang@linux.alibaba.com fp:SMTPD_---0VCrRFdb_1652187518)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 10 May 2022 20:58:39 +0800
Message-ID: <b380e302-5b16-2de0-eca0-9805359daaaa@linux.alibaba.com>
Date:   Tue, 10 May 2022 20:58:38 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.1
Subject: Re: [PATCH net 2/2] net/smc: align the connect behaviour with TCP
Content-Language: en-US
To:     Tony Lu <tonylu@linux.alibaba.com>
Cc:     kgraul@linux.ibm.com, davem@davemloft.net, kuba@kernel.org,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220509115837.94911-1-guangguan.wang@linux.alibaba.com>
 <20220509115837.94911-3-guangguan.wang@linux.alibaba.com>
 <Ynowrcnqb/wv1iNt@TonyMac-Alibaba>
From:   Guangguan Wang <guangguan.wang@linux.alibaba.com>
In-Reply-To: <Ynowrcnqb/wv1iNt@TonyMac-Alibaba>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-10.8 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022/5/10 17:30, Tony Lu wrote:
> On Mon, May 09, 2022 at 07:58:37PM +0800, Guangguan Wang wrote:
>> Connect with O_NONBLOCK will not be completed immediately
>> and returns -EINPROGRESS. It is possible to use selector/poll
>> for completion by selecting the socket for writing. After select
>> indicates writability, a second connect function call will return
>> 0 to indicate connected successfully as TCP does, but smc returns
> 
> If the connection is established successfully, the following up call of
> connect() returns -EISCONN (SS_CONNECTED), which is expected and SMC
> does it, same as TCP.
> 
> In case of misunderstanding, could you append more detailed information?
> 
> Thanks,
> Tony Lu
> 

io_uring uses nonblocking connect as follow steps:
  1) call connect with nonblocking
  2) wait for selector/poll to indicate writability
  3) call connect to confirm connection's state

In the third step, tcp changes the socket state from SS_CONNECTING to
SS_CONNECTED and returns 0 if the connection is established successfully,
but smc returns -EISCONN.
