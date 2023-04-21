Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59EF86EB1E0
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 20:54:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232346AbjDUSyN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 14:54:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229916AbjDUSyL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 14:54:11 -0400
Received: from mx06lb.world4you.com (mx06lb.world4you.com [81.19.149.116])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 305681FE3;
        Fri, 21 Apr 2023 11:54:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=R3sHZfcOzOQymuuD1iMK3qgK1r+J0oJDe00+/EzqdHA=; b=F1fvh/rGpS6sCeNxBIvwLd7hix
        PUWs+z0xTTN9gtoUbRq6w8hjECqSB52wlc39L9BZMDdKNIUAujObOxM9g4REIOuP/4nSWCk6TOjBv
        u0VatGDNkzDtmTeaijU7ejdd7kjTeNg9ozzrPn93pDrzd/K03aTbefV/0UNVeDI7m5vQ=;
Received: from [88.117.57.231] (helo=[10.0.0.160])
        by mx06lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.96)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1ppvtW-0004om-1b;
        Fri, 21 Apr 2023 20:54:06 +0200
Message-ID: <0792956c-c2d3-0102-5d41-8fccc5091b08@engleder-embedded.com>
Date:   Fri, 21 Apr 2023 20:54:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH net-next v3 5/6] tsnep: Add XDP socket zero-copy RX
 support
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        kuba@kernel.org, edumazet@google.com, pabeni@redhat.com,
        bjorn@kernel.org, magnus.karlsson@intel.com,
        jonathan.lemon@gmail.com
References: <20230418190459.19326-1-gerhard@engleder-embedded.com>
 <20230418190459.19326-6-gerhard@engleder-embedded.com>
 <ZEGWmYmsM2uV48Lh@boxer>
Content-Language: en-US
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
In-Reply-To: <ZEGWmYmsM2uV48Lh@boxer>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AV-Do-Run: Yes
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20.04.23 21:46, Maciej Fijalkowski wrote:
> On Tue, Apr 18, 2023 at 09:04:58PM +0200, Gerhard Engleder wrote:
>> Add support for XSK zero-copy to RX path. The setup of the XSK pool can
>> be done at runtime. If the netdev is running, then the queue must be
>> disabled and enabled during reconfiguration. This can be done easily
>> with functions introduced in previous commits.
>>
>> A more important property is that, if the netdev is running, then the
>> setup of the XSK pool shall not stop the netdev in case of errors. A
>> broken netdev after a failed XSK pool setup is bad behavior. Therefore,
>> the allocation and setup of resources during XSK pool setup is done only
>> before any queue is disabled. Additionally, freeing and later allocation
>> of resources is eliminated in some cases. Page pool entries are kept for
>> later use. Two memory models are registered in parallel. As a result,
>> the XSK pool setup cannot fail during queue reconfiguration.
>>
>> In contrast to other drivers, XSK pool setup and XDP BPF program setup
>> are separate actions. XSK pool setup can be done without any XDP BPF
>> program. The XDP BPF program can be added, removed or changed without
>> any reconfiguration of the XSK pool.
>>
>> Test results with A53 1.2GHz:
>>
>> xdpsock rxdrop copy mode:
>>                     pps            pkts           1.00
>> rx                 856,054        10,625,775
>> Two CPUs with both 100% utilization.
>>
>> xdpsock rxdrop zero-copy mode:
>>                     pps            pkts           1.00
>> rx                 889,388        4,615,284
>> Two CPUs with 100% and 20% utilization.
>>
>> xdpsock l2fwd copy mode:
>>                     pps            pkts           1.00
>> rx                 248,985        7,315,885
>> tx                 248,921        7,315,885
>> Two CPUs with 100% and 10% utilization.
>>
>> xdpsock l2fwd zero-copy mode:
>>                     pps            pkts           1.00
>> rx                 254,735        3,039,456
>> tx                 254,735        3,039,456
>> Two CPUs with 100% and 4% utilization.
> 
> Thanks for sharing the numbers. This is for 64 byte frames?

Yes. I will add that information.

>>
>> Packet rate increases and CPU utilization is reduced in both cases.
>> 100% CPU load seems to the base load. This load is consumed by ksoftirqd
>> just for dropping the generated packets without xdpsock running.
>>
>> Using batch API reduced CPU utilization slightly, but measurements are
>> not stable enough to provide meaningful numbers.
>>
>> Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
>> ---
>>   drivers/net/ethernet/engleder/tsnep.h      |  13 +-
>>   drivers/net/ethernet/engleder/tsnep_main.c | 494 ++++++++++++++++++++-
>>   drivers/net/ethernet/engleder/tsnep_xdp.c  |  66 +++
>>   3 files changed, 558 insertions(+), 15 deletions(-)
>>
> 
> (...)
> 
>>   static const struct net_device_ops tsnep_netdev_ops = {
>>   	.ndo_open = tsnep_netdev_open,
>>   	.ndo_stop = tsnep_netdev_close,
>> @@ -1713,6 +2177,7 @@ static const struct net_device_ops tsnep_netdev_ops = {
>>   	.ndo_setup_tc = tsnep_tc_setup,
>>   	.ndo_bpf = tsnep_netdev_bpf,
>>   	.ndo_xdp_xmit = tsnep_netdev_xdp_xmit,
>> +	.ndo_xsk_wakeup = tsnep_netdev_xsk_wakeup,
>>   };
>>   
>>   static int tsnep_mac_init(struct tsnep_adapter *adapter)
>> @@ -1973,7 +2438,8 @@ static int tsnep_probe(struct platform_device *pdev)
>>   
>>   	netdev->xdp_features = NETDEV_XDP_ACT_BASIC | NETDEV_XDP_ACT_REDIRECT |
>>   			       NETDEV_XDP_ACT_NDO_XMIT |
>> -			       NETDEV_XDP_ACT_NDO_XMIT_SG;
>> +			       NETDEV_XDP_ACT_NDO_XMIT_SG |
>> +			       NETDEV_XDP_ACT_XSK_ZEROCOPY;
> 
> In theory enabling this feature here before implementing Tx ZC can expose
> you to some broken behavior, so just for the sake of completeness, i would
> move this to Tx ZC patch.

Will be done.
