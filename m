Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E443C4BB46E
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 09:41:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232675AbiBRIli (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 03:41:38 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232705AbiBRIlg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 03:41:36 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57E2C265136;
        Fri, 18 Feb 2022 00:41:20 -0800 (PST)
Received: from fraeml707-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4K0QBF56lTz67xv7;
        Fri, 18 Feb 2022 16:40:21 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml707-chm.china.huawei.com (10.206.15.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 18 Feb 2022 09:41:17 +0100
Received: from [10.47.86.67] (10.47.86.67) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Fri, 18 Feb
 2022 08:41:16 +0000
Message-ID: <eee8d4b8-6b47-d675-aa6c-b0376b693e87@huawei.com>
Date:   Fri, 18 Feb 2022 08:41:13 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH 1/2] genirq: Extract irq_set_affinity_masks() from
 devm_platform_get_irqs_affinity()
To:     Marc Zyngier <maz@kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Marcin Wojtas <mw@semihalf.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, <kernel-team@android.com>
References: <20220216090845.1278114-1-maz@kernel.org>
 <20220216090845.1278114-2-maz@kernel.org>
 <bdfe935b-6ee0-b588-e1e8-776d85f91813@huawei.com>
 <b502141b201a68eb4896c1653b67663a@kernel.org>
From:   John Garry <john.garry@huawei.com>
In-Reply-To: <b502141b201a68eb4896c1653b67663a@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.86.67]
X-ClientProxiedBy: lhreml714-chm.china.huawei.com (10.201.108.65) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17/02/2022 17:17, Marc Zyngier wrote:

Hi Marc,

>> I know you mentioned it in 2/2, but it would be interesting to see how
>> network controller drivers can handle the problem of missing in-flight
>> IO completions for managed irq shutdown. For storage controllers this
>> is all now safely handled in the block layer.
> 
> Do you have a pointer to this? It'd be interesting to see if there is
> a common pattern.

Check blk_mq_hctx_notify_offline() and other hotplug handler friends in 
block/blk-mq.c and also blk_mq_get_ctx()/blk_mq_map_queue()

So the key steps in CPU offlining are:
- when the last CPU in HW queue context cpumask is going offline we mark 
the HW queue as inactive and no longer queue requests there
- drain all in-flight requests before we allow that last CPU to go 
offline, meaning that we always have a CPU online to service any 
completion interrupts

This scheme relies on symmetrical HW submission and completion queues 
and also that the blk-mq HW queue context cpumask is same as the HW 
queue's IRQ affinity mask (see blk_mq_pci_map_queues()).

I am not sure how much this would fit with the networking stack or that 
marvell driver.

Thanks,
John
