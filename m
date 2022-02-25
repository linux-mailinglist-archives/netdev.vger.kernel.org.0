Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2A284C5220
	for <lists+netdev@lfdr.de>; Sat, 26 Feb 2022 00:42:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233934AbiBYXmu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 18:42:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230190AbiBYXmt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 18:42:49 -0500
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DABC81F038B;
        Fri, 25 Feb 2022 15:42:15 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R441e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0V5Uzc0U_1645832532;
Received: from localhost(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0V5Uzc0U_1645832532)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sat, 26 Feb 2022 07:42:12 +0800
Date:   Sat, 26 Feb 2022 07:42:11 +0800
From:   "dust.li" <dust.li@linux.alibaba.com>
To:     Karsten Graul <kgraul@linux.ibm.com>,
        Hendrik Brueckner <brueckner@linux.ibm.com>
Cc:     Stefan Raspl <raspl@linux.ibm.com>,
        Tony Lu <tonylu@linux.alibaba.com>, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH] net/smc: Add autocork support
Message-ID: <20220225234211.GA5282@linux.alibaba.com>
Reply-To: dust.li@linux.alibaba.com
References: <20220216152721.GB39286@linux.alibaba.com>
 <454b5efd-e611-2dfb-e462-e7ceaee0da4d@linux.ibm.com>
 <20220217132200.GA5443@linux.alibaba.com>
 <Yg6Q2kIDJrhvNVz7@linux.ibm.com>
 <20220218073327.GB5443@linux.alibaba.com>
 <d4ce4674-3ced-da34-a8a4-30d74cbe24bb@linux.ibm.com>
 <20220218234232.GC5443@linux.alibaba.com>
 <bc3252a3-5a84-63d4-dfc5-009f602a5bec@linux.ibm.com>
 <20220224020253.GF5443@linux.alibaba.com>
 <f2afb775-a156-2c32-a49a-225545dc2bf7@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f2afb775-a156-2c32-a49a-225545dc2bf7@linux.ibm.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 25, 2022 at 07:10:40PM +0100, Karsten Graul wrote:
>On 24/02/2022 03:02, dust.li wrote:
>> On Wed, Feb 23, 2022 at 07:57:31PM +0100, Karsten Graul wrote:
>>> On 19/02/2022 00:42, dust.li wrote:
>>>> On Fri, Feb 18, 2022 at 05:03:56PM +0100, Karsten Graul wrote:
>>>>> Right now for me it looks like there is no way to use netlink for container runtime
>>>>> configuration, which is a pity.
>>>>> We continue our discussions about this in the team, and also here on the list.
>>>>
>>>> Many thanks for your time on this topic !
>>>
>>> We checked more specs (like Container Network Interface (CNI) Specification) 
>>> but all we found uses sysctl at the end. There is lot of infrastructure 
>>> to use sysctls in a container environment.
>>>
>>> Establishing netlink-like controls for containers is by far out of our scope, and
>>> would take a long time until it would be available in the popular projects.
>>>
>>> So at the moment I see no alternative to an additional sysctl interface in the 
>>> SMC module that provides controls which are useful in container environments.
>> 
>> Got it, I will add sysctl interface and a switch with this function.
>> 
>> Thank again !
>
>Can you explain again why this auto_cork needs a switch to disable it?
>My understanding is that this auto_cork makes always sense and is triggered
>when there are not enough resources.

My initial intention to provide a switch is to be like TCP to let user
to disable it. For user cases like debug and workaround bugs if it is
associated with auto cork, or compare performance like I did (But this
should not be a real world case in production environment).

But after Stefan suggested that we make the auto corked size turnable,
I realized that we can only need one sysctl switch: which tunes the auto
corked bytes size. Disable auto cork can be archived by setting this to 0.

Something like this bellow:
static bool smc_should_autocork(struct smc_sock *smc)
{
        struct smc_connection *conn = &smc->conn;
        int corking_size;

        corking_size = min(sock_net(&smc->sk)->smc.sysctl_autocorking_size,
                           conn->sndbuf_desc->len >> 1);

        if (atomic_read(&conn->cdc_pend_tx_wr) == 0 ||
            smc_tx_prepared_sends(conn) > corking_size)
                return false;
        return true;
}

Thanks.
