Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B01E637E1F
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 18:15:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229804AbiKXRP4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 12:15:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229763AbiKXRPn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 12:15:43 -0500
Received: from out30-54.freemail.mail.aliyun.com (out30-54.freemail.mail.aliyun.com [115.124.30.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74A3C4A9F2;
        Thu, 24 Nov 2022 09:15:24 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046056;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0VVbtcFK_1669310120;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0VVbtcFK_1669310120)
          by smtp.aliyun-inc.com;
          Fri, 25 Nov 2022 01:15:21 +0800
Date:   Fri, 25 Nov 2022 01:15:18 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     Alexandra Winter <wintera@linux.ibm.com>
Cc:     Jan Karcher <jaka@linux.ibm.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        Wenjia Zhang <wenjia@linux.ibm.com>,
        Thorsten Winkler <twinkler@linux.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>
Subject: Re: [PATCH net-next] net/smc: Unbind smc control from tcp control
Message-ID: <Y3+mpjGhG1+JwBjN@TonyMac-Alibaba>
Reply-To: Tony Lu <tonylu@linux.alibaba.com>
References: <20221123105830.17167-1-jaka@linux.ibm.com>
 <Y34Aa3MXGqyd+nlQ@TonyMac-Alibaba>
 <4c5d74f8-c5de-d50c-0682-4435de21660a@linux.ibm.com>
 <Y34DI815COX7+V0x@TonyMac-Alibaba>
 <245a7c52-ee18-56c2-7584-b75b0af1491f@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <245a7c52-ee18-56c2-7584-b75b0af1491f@linux.ibm.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 24, 2022 at 02:00:35PM +0100, Alexandra Winter wrote:
> 
> 
> On 23.11.22 12:25, Tony Lu wrote:
> > On Wed, Nov 23, 2022 at 12:19:19PM +0100, Jan Karcher wrote:
> >>
> >>
> >> On 23/11/2022 12:13, Tony Lu wrote:
> >>> On Wed, Nov 23, 2022 at 11:58:30AM +0100, Jan Karcher wrote:
> >>>> In the past SMC used the values of tcp_{w|r}mem to create the send
> >>>> buffer and RMB. We now have our own sysctl knobs to tune them without
> >>>> influencing the TCP default.
> >>>>
> >>>> This patch removes the dependency on the TCP control by providing our
> >>>> own initial values which aim for a low memory footprint.
> >>>
> >>> +1, before introducing sysctl knobs of SMC, we were going to get rid of
> >>> TCP and have SMC own values. Now this does it, So I very much agree with
> >>> this.
> >>>
> Iiuc you are changing the default values in this a patch and your other patch:
> Default values for real_buf for send and receive:
> 
> before 0227f058aa29 ("net/smc: Unbind r/w buffer size from clcsock and make them tunable")
>     real_buf=net.ipv4.tcp_{w|r}mem[1]/2   send: 8k  recv: 64k 
>     
> after 0227f058aa29 ("net/smc: Unbind r/w buffer size from clcsock and make them tunable")
> real_buf=net.ipv4.tcp_{w|r}mem[1]   send: 16k (16*1024) recv: 128k (131072) 
> 
> after net/smc: Fix expected buffersizes and sync logic
> real_buf=net.ipv4.tcp_{w|r}mem[1]   send: 16k (16*1024) recv: 128k (131072) 
> 
> after net/smc: Unbind smc control from tcp control
> real_buf=SMC_*BUF_INIT_SIZE   send: 16k (16384) recv: 64k (65536)
> 
> If my understanding is correct, then I nack this. 
> Defaults should be restored to the values before 0227f058aa29.
> Otherwise users will notice a change in memory usage that needs to
> be avoided or announced more explicitely. (and don't change them twice)

The logic of buffer size are changed indeed. I very much agree that do
not break the user space. I am wondering that the values of user-defined
configurations should be the ABI/API compatibilities.

Actually before the patch of adding sysctls of buffers, the values of
buffer size is bind to tcp_{w|r}mem[1] tightly. The people who changed
the value of tcp_{w|r}mem[1] may break the convention of SMC by
accident.

After getting rid of tcp_{w|r}mem[1], SMC have its own sysctl for
buffer size. I do think this a really good chance for us to determined
the reasonable values of buffers and document them in a place that
people are easy to learn, the logic of {set|get}sockopt in SMC are
different from socket manual. What do you think?

Cheers,
Tony Lu

> 
> >>>>
> >>>> Signed-off-by: Jan Karcher <jaka@linux.ibm.com>
> >>>> Reviewed-by: Wenjia Zhang <wenjia@linux.ibm.com>
> >>>> ---
> >>>>   Documentation/networking/smc-sysctl.rst |  4 ++--
> >>>>   net/smc/smc_core.h                      |  6 ++++--
> >>>>   net/smc/smc_sysctl.c                    | 10 ++++++----
> >>>>   3 files changed, 12 insertions(+), 8 deletions(-)
> >>>>
> >>>> diff --git a/Documentation/networking/smc-sysctl.rst b/Documentation/networking/smc-sysctl.rst
> >>>> index 6d8acdbe9be1..a1c634d3690a 100644
> >>>> --- a/Documentation/networking/smc-sysctl.rst
> >>>> +++ b/Documentation/networking/smc-sysctl.rst
> >>>> @@ -44,7 +44,7 @@ smcr_testlink_time - INTEGER
> >>>>   wmem - INTEGER
> >>>>   	Initial size of send buffer used by SMC sockets.
> >>>> -	The default value inherits from net.ipv4.tcp_wmem[1].
> >>>> +	The default value aims for a small memory footprint and is set to 16KiB.
> >>>>   	The minimum value is 16KiB and there is no hard limit for max value, but
> >>>>   	only allowed 512KiB for SMC-R and 1MiB for SMC-D.
> >>>> @@ -53,7 +53,7 @@ wmem - INTEGER
> >>>>   rmem - INTEGER
> >>>>   	Initial size of receive buffer (RMB) used by SMC sockets.
> >>>> -	The default value inherits from net.ipv4.tcp_rmem[1].
> >>>> +	The default value aims for a small memory footprint and is set to 64KiB.
> >>>>   	The minimum value is 16KiB and there is no hard limit for max value, but
> >>>>   	only allowed 512KiB for SMC-R and 1MiB for SMC-D.
> >>>> diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
> >>>> index 285f9bd8e232..67c3937f341d 100644
> >>>> --- a/net/smc/smc_core.h
> >>>> +++ b/net/smc/smc_core.h
> >>>> @@ -206,8 +206,10 @@ struct smc_rtoken {				/* address/key of remote RMB */
> >>>>   	u32			rkey;
> >>>>   };
> >>>> -#define SMC_BUF_MIN_SIZE	16384	/* minimum size of an RMB */
> >>>> -#define SMC_RMBE_SIZES		16	/* number of distinct RMBE sizes */
> >>>> +#define SMC_SNDBUF_INIT_SIZE 16384 /* initial size of send buffer */
> >>>> +#define SMC_RCVBUF_INIT_SIZE 65536 /* initial size of receive buffer */
> >>>> +#define SMC_BUF_MIN_SIZE	 16384	/* minimum size of an RMB */
> >>>> +#define SMC_RMBE_SIZES		 16	/* number of distinct RMBE sizes */
> >>>>   /* theoretically, the RFC states that largest size would be 512K,
> >>>>    * i.e. compressed 5 and thus 6 sizes (0..5), despite
> >>>>    * struct smc_clc_msg_accept_confirm.rmbe_size being a 4 bit value (0..15)
> >>>> diff --git a/net/smc/smc_sysctl.c b/net/smc/smc_sysctl.c
> >>>> index b6f79fabb9d3..a63aa79d4856 100644
> >>>> --- a/net/smc/smc_sysctl.c
> >>>> +++ b/net/smc/smc_sysctl.c
> >>>> @@ -19,8 +19,10 @@
> >>>>   #include "smc_llc.h"
> >>>>   #include "smc_sysctl.h"
> >>>> -static int min_sndbuf = SMC_BUF_MIN_SIZE;
> >>>> -static int min_rcvbuf = SMC_BUF_MIN_SIZE;
> >>>> +static int initial_sndbuf	= SMC_SNDBUF_INIT_SIZE;
> >>>> +static int initial_rcvbuf	= SMC_RCVBUF_INIT_SIZE;
> >>>> +static int min_sndbuf		= SMC_BUF_MIN_SIZE;
> >>>> +static int min_rcvbuf		= SMC_BUF_MIN_SIZE;
> Broken formatting
> >>>>   static struct ctl_table smc_table[] = {
> >>>>   	{
> >>>> @@ -88,8 +90,8 @@ int __net_init smc_sysctl_net_init(struct net *net)
> >>>>   	net->smc.sysctl_autocorking_size = SMC_AUTOCORKING_DEFAULT_SIZE;
> >>>>   	net->smc.sysctl_smcr_buf_type = SMCR_PHYS_CONT_BUFS;
> >>>>   	net->smc.sysctl_smcr_testlink_time = SMC_LLC_TESTLINK_DEFAULT_TIME;
> >>>> -	WRITE_ONCE(net->smc.sysctl_wmem, READ_ONCE(net->ipv4.sysctl_tcp_wmem[1]));
> >>>> -	WRITE_ONCE(net->smc.sysctl_rmem, READ_ONCE(net->ipv4.sysctl_tcp_rmem[1]));
> >>>> +	WRITE_ONCE(net->smc.sysctl_wmem, initial_sndbuf);
> >>>> +	WRITE_ONCE(net->smc.sysctl_rmem, initial_rcvbuf);
> >>>
> >>> Maybe we can use SMC_{SND|RCV}BUF_INIT_SIZE macro directly, instead of
> >>> new variables.
> >>
> >> The reason i created the new variables is that min_{snd|rcv}buf also have
> >> their own variables. I know it is not needed but thought it was cleaner.
> >> If you have a strong opinion on using the value directly i can change it.
> >> Please let me know if you want it changed.
> > 
> > Yep, it's okay for me to use variables or macros. Just let it be.
> I think it's better coding style to use the macros instead of unneccessary variables.
> At least the variables could be defined as const.
> > 
> > Reviewed-by: Tony Lu <tonylu@linux.alibaba.com>
> > 
> > Cheers,
> > Tony Lu
> > 
> >>
> >> - Jan
> >>>
> >>> Cheers,
> >>> Tony Lu
> >>>
> >>>>   	return 0;
> >>>> -- 
> >>>> 2.34.1
