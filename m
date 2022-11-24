Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17238637ECC
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 19:04:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229624AbiKXSEs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 13:04:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiKXSEr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 13:04:47 -0500
Received: from out30-54.freemail.mail.aliyun.com (out30-54.freemail.mail.aliyun.com [115.124.30.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA4708328C;
        Thu, 24 Nov 2022 10:04:45 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045168;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0VVbyXSw_1669313082;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0VVbyXSw_1669313082)
          by smtp.aliyun-inc.com;
          Fri, 25 Nov 2022 02:04:43 +0800
Date:   Fri, 25 Nov 2022 02:04:39 +0800
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
Message-ID: <Y3+yN32IDLcja57v@TonyMac-Alibaba>
Reply-To: Tony Lu <tonylu@linux.alibaba.com>
References: <20221123105830.17167-1-jaka@linux.ibm.com>
 <Y34Aa3MXGqyd+nlQ@TonyMac-Alibaba>
 <4c5d74f8-c5de-d50c-0682-4435de21660a@linux.ibm.com>
 <Y34DI815COX7+V0x@TonyMac-Alibaba>
 <245a7c52-ee18-56c2-7584-b75b0af1491f@linux.ibm.com>
 <73bf0f59-55b3-8959-3199-edc45e0ea138@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <73bf0f59-55b3-8959-3199-edc45e0ea138@linux.ibm.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 24, 2022 at 03:06:50PM +0100, Alexandra Winter wrote:
> 
> 
> On 24.11.22 14:00, Alexandra Winter wrote:
> > 
> > 
> > On 23.11.22 12:25, Tony Lu wrote:
> >> On Wed, Nov 23, 2022 at 12:19:19PM +0100, Jan Karcher wrote:
> >>>
> >>>
> >>> On 23/11/2022 12:13, Tony Lu wrote:
> >>>> On Wed, Nov 23, 2022 at 11:58:30AM +0100, Jan Karcher wrote:
> >>>>> In the past SMC used the values of tcp_{w|r}mem to create the send
> >>>>> buffer and RMB. We now have our own sysctl knobs to tune them without
> >>>>> influencing the TCP default.
> >>>>>
> >>>>> This patch removes the dependency on the TCP control by providing our
> >>>>> own initial values which aim for a low memory footprint.
> >>>>
> >>>> +1, before introducing sysctl knobs of SMC, we were going to get rid of
> >>>> TCP and have SMC own values. Now this does it, So I very much agree with
> >>>> this.
> >>>>
> > Iiuc you are changing the default values in this a patch and your other patch:
> > Default values for real_buf for send and receive:
> > 
> > before 0227f058aa29 ("net/smc: Unbind r/w buffer size from clcsock and make them tunable")
> >     real_buf=net.ipv4.tcp_{w|r}mem[1]/2   send: 8k  recv: 64k 
> Jan, you explained to me: "the minima is 16Kib. This is enforced in smc_compress_bufsize 
> which would move any value <= 16Kib into bucket 0 - which is 16KiB "
> so 					send  16k   recv: 64k
> >     
> > after 0227f058aa29 ("net/smc: Unbind r/w buffer size from clcsock and make them tunable")
> > real_buf=net.ipv4.tcp_{w|r}mem[1]   send: 16k (16*1024) recv: 128k (131072) 
> > 
> > after net/smc: Fix expected buffersizes and sync logic
> > real_buf=net.ipv4.tcp_{w|r}mem[1]   send: 16k (16*1024) recv: 128k (131072) 
> > 
> > after net/smc: Unbind smc control from tcp control
> > real_buf=SMC_*BUF_INIT_SIZE   send: 16k (16384) recv: 64k (65536)
> > 
> > If my understanding is correct, then I nack this. 
> > Defaults should be restored to the values before 0227f058aa29.
> > Otherwise users will notice a change in memory usage that needs to
> > be avoided or announced more explicitely. (and don't change them twice)
> See above, I stand corrected. This does restore the default receive buffer size.
> It should got to net with a Fixes: 0227f058aa29 tag.
> And the descrition should clarify that this restores the default recv buffer size
> (and uncouples from tcp control)
> Maybe the users and the distros would thank you, if you merge them into 1 patch?

AFAIK, updating kernel to the version of upstream will take a long time
for distros and users. Since we have sysctls, maybe we could let
applications and distros use sysctl to set their desired and default
values with documentation. It's a more common way to tweak kernel. 

Cheers,
Tony Lu

> 
> 
> > 
> >>>>>
> >>>>> Signed-off-by: Jan Karcher <jaka@linux.ibm.com>
> >>>>> Reviewed-by: Wenjia Zhang <wenjia@linux.ibm.com>
> >>>>> ---
> >>>>>   Documentation/networking/smc-sysctl.rst |  4 ++--
> >>>>>   net/smc/smc_core.h                      |  6 ++++--
> >>>>>   net/smc/smc_sysctl.c                    | 10 ++++++----
> >>>>>   3 files changed, 12 insertions(+), 8 deletions(-)
> >>>>>
> >>>>> diff --git a/Documentation/networking/smc-sysctl.rst b/Documentation/networking/smc-sysctl.rst
> >>>>> index 6d8acdbe9be1..a1c634d3690a 100644
> >>>>> --- a/Documentation/networking/smc-sysctl.rst
> >>>>> +++ b/Documentation/networking/smc-sysctl.rst
> >>>>> @@ -44,7 +44,7 @@ smcr_testlink_time - INTEGER
> >>>>>   wmem - INTEGER
> >>>>>   	Initial size of send buffer used by SMC sockets.
> >>>>> -	The default value inherits from net.ipv4.tcp_wmem[1].
> >>>>> +	The default value aims for a small memory footprint and is set to 16KiB.
> >>>>>   	The minimum value is 16KiB and there is no hard limit for max value, but
> >>>>>   	only allowed 512KiB for SMC-R and 1MiB for SMC-D.
> >>>>> @@ -53,7 +53,7 @@ wmem - INTEGER
> >>>>>   rmem - INTEGER
> >>>>>   	Initial size of receive buffer (RMB) used by SMC sockets.
> >>>>> -	The default value inherits from net.ipv4.tcp_rmem[1].
> >>>>> +	The default value aims for a small memory footprint and is set to 64KiB.
> >>>>>   	The minimum value is 16KiB and there is no hard limit for max value, but
> >>>>>   	only allowed 512KiB for SMC-R and 1MiB for SMC-D.
> >>>>> diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
> >>>>> index 285f9bd8e232..67c3937f341d 100644
> >>>>> --- a/net/smc/smc_core.h
> >>>>> +++ b/net/smc/smc_core.h
> >>>>> @@ -206,8 +206,10 @@ struct smc_rtoken {				/* address/key of remote RMB */
> >>>>>   	u32			rkey;
> >>>>>   };
> >>>>> -#define SMC_BUF_MIN_SIZE	16384	/* minimum size of an RMB */
> >>>>> -#define SMC_RMBE_SIZES		16	/* number of distinct RMBE sizes */
> >>>>> +#define SMC_SNDBUF_INIT_SIZE 16384 /* initial size of send buffer */
> >>>>> +#define SMC_RCVBUF_INIT_SIZE 65536 /* initial size of receive buffer */
> >>>>> +#define SMC_BUF_MIN_SIZE	 16384	/* minimum size of an RMB */
> >>>>> +#define SMC_RMBE_SIZES		 16	/* number of distinct RMBE sizes */
> There is one blank added to these lines? Why? They still don't align.
> >>>>>   /* theoretically, the RFC states that largest size would be 512K,
> >>>>>    * i.e. compressed 5 and thus 6 sizes (0..5), despite
> >>>>>    * struct smc_clc_msg_accept_confirm.rmbe_size being a 4 bit value (0..15)
> >>>>> diff --git a/net/smc/smc_sysctl.c b/net/smc/smc_sysctl.c
> >>>>> index b6f79fabb9d3..a63aa79d4856 100644
> >>>>> --- a/net/smc/smc_sysctl.c
> >>>>> +++ b/net/smc/smc_sysctl.c
> >>>>> @@ -19,8 +19,10 @@
> >>>>>   #include "smc_llc.h"
> >>>>>   #include "smc_sysctl.h"
> >>>>> -static int min_sndbuf = SMC_BUF_MIN_SIZE;
> >>>>> -static int min_rcvbuf = SMC_BUF_MIN_SIZE;
> >>>>> +static int initial_sndbuf	= SMC_SNDBUF_INIT_SIZE;
> >>>>> +static int initial_rcvbuf	= SMC_RCVBUF_INIT_SIZE;
> >>>>> +static int min_sndbuf		= SMC_BUF_MIN_SIZE;
> >>>>> +static int min_rcvbuf		= SMC_BUF_MIN_SIZE;
> > Broken formatting
> >>>>>   static struct ctl_table smc_table[] = {
> >>>>>   	{
> >>>>> @@ -88,8 +90,8 @@ int __net_init smc_sysctl_net_init(struct net *net)
> >>>>>   	net->smc.sysctl_autocorking_size = SMC_AUTOCORKING_DEFAULT_SIZE;
> >>>>>   	net->smc.sysctl_smcr_buf_type = SMCR_PHYS_CONT_BUFS;
> >>>>>   	net->smc.sysctl_smcr_testlink_time = SMC_LLC_TESTLINK_DEFAULT_TIME;
> >>>>> -	WRITE_ONCE(net->smc.sysctl_wmem, READ_ONCE(net->ipv4.sysctl_tcp_wmem[1]));
> >>>>> -	WRITE_ONCE(net->smc.sysctl_rmem, READ_ONCE(net->ipv4.sysctl_tcp_rmem[1]));
> >>>>> +	WRITE_ONCE(net->smc.sysctl_wmem, initial_sndbuf);
> >>>>> +	WRITE_ONCE(net->smc.sysctl_rmem, initial_rcvbuf);
> >>>>
> >>>> Maybe we can use SMC_{SND|RCV}BUF_INIT_SIZE macro directly, instead of
> >>>> new variables.
> >>>
> >>> The reason i created the new variables is that min_{snd|rcv}buf also have
> >>> their own variables. I know it is not needed but thought it was cleaner.
> >>> If you have a strong opinion on using the value directly i can change it.
> >>> Please let me know if you want it changed.
> >>
> >> Yep, it's okay for me to use variables or macros. Just let it be.
> > I think it's better coding style to use the macros instead of unneccessary variables.
> > At least the variables could be defined as const.
> >>
> >> Reviewed-by: Tony Lu <tonylu@linux.alibaba.com>
> >>
> >> Cheers,
> >> Tony Lu
> >>
> >>>
> >>> - Jan
> >>>>
> >>>> Cheers,
> >>>> Tony Lu
> >>>>
> >>>>>   	return 0;
> >>>>> -- 
> >>>>> 2.34.1
