Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DE7F687F46
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 14:53:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230317AbjBBNxx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 08:53:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229881AbjBBNxx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 08:53:53 -0500
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 711D46D055;
        Thu,  2 Feb 2023 05:53:49 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045192;MF=guwen@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0ValHekG_1675346025;
Received: from 30.221.129.148(mailfrom:guwen@linux.alibaba.com fp:SMTPD_---0ValHekG_1675346025)
          by smtp.aliyun-inc.com;
          Thu, 02 Feb 2023 21:53:46 +0800
Message-ID: <39206f64-3f88-235e-7017-2479ac58844d@linux.alibaba.com>
Date:   Thu, 2 Feb 2023 21:53:43 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [net-next v2 0/8] drivers/s390/net/ism: Add generalized interface
To:     Jan Karcher <jaka@linux.ibm.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Wenjia Zhang <wenjia@linux.ibm.com>,
        Thorsten Winkler <twinkler@linux.ibm.com>,
        Stefan Raspl <raspl@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Nils Hoppmann <niho@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Tony Lu <tonylu@linux.alibaba.com>
References: <20230123181752.1068-1-jaka@linux.ibm.com>
From:   Wen Gu <guwen@linux.alibaba.com>
In-Reply-To: <20230123181752.1068-1-jaka@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-10.0 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2023/1/24 02:17, Jan Karcher wrote:

> Previously, there was no clean separation between SMC-D code and the ISM
> device driver.This patch series addresses the situation to make ISM available
> for uses outside of SMC-D.
> In detail: SMC-D offers an interface via struct smcd_ops, which only the
> ISM module implements so far. However, there is no real separation between
> the smcd and ism modules, which starts right with the ISM device
> initialization, which calls directly into the SMC-D code.
> This patch series introduces a new API in the ISM module, which allows
> registration of arbitrary clients via include/linux/ism.h: struct ism_client.
> Furthermore, it introduces a "pure" struct ism_dev (i.e. getting rid of
> dependencies on SMC-D in the device structure), and adds a number of API
> calls for data transfers via ISM (see ism_register_dmb() & friends).
> Still, the ISM module implements the SMC-D API, and therefore has a number
> of internal helper functions for that matter.
> Note that the ISM API is consciously kept thin for now (as compared to the
> SMC-D API calls), as a number of API calls are only used with SMC-D and
> hardly have any meaningful usage beyond SMC-D, e.g. the VLAN-related calls.
> 

Hi,

Thanks for the great work!

We are tring to adapt loopback and virtio-ism device into SMC-D based on the new
interface and want to confirm something. (cc: Alexandra Winter, Jan Karcher, Wenjia Zhang)

 From my understanding, this patch set is from the perspective of ISM device driver
and aims to make ISM device not only used by SMC-D, which is great!

But from the perspective of SMC, SMC-D protocol now binds with the helper in
smc_ism.c (smc_ism_* helper) and some part of smc_ism.c and smcd_ops seems to be
dedicated to only serve ISM device.

For example,

- The input param of smcd_register_dev() and smcd_unregister_dev() is ism_dev,
   instead of abstract smcd_dev like before.

- the smcd->ops->register_dmb has param of ism_client, exposing specific underlay.

So I want to confirm that, which of the following is our future direction of the
SMC-D device expansion?

(1) All extended devices (eg. virtio-ism and loopback) are ISM devices and SMC-D
     only supports ISM type device.

     SMC-D protocol -> smc_ism_* helper in smc_ism.c -> only ISM device.

     Future extended device must under the definition of ism_dev, in order to share
     the ism-specific helper in smc_ism.c (such as smcd_register_dev(), smcd_ops->register_dmbs..).

     With this design intention, futher extended SMC-D used device may be like:

                     +---------------------+
                     |    SMC-D protocol   |
                     +---------------------+
                       | current helper in|
                       |    smc_ism.c     |
          +--------------------------------------------+
          |              Broad ISM device              |
          |             defined as ism_dev             |
          |  +----------+ +------------+ +----------+  |
          |  | s390 ISM | | virtio-ism | | loopback |  |
          |  +----------+ +------------+ +----------+  |
          +--------------------------------------------+

(2) All extended devices (eg. virtio-ism and loopback) are abstracted as smcd_dev and
     SMC-D protocol use the abstracted capabilities.

     SMC-D does not care about the type of the underlying device, and only focus on the
     capabilities provided by smcd_dev.

     SMC-D protocol use a kind of general helpers, which only invoking smcd_dev->ops,
     without underlay device exposed. Just like most of helpers now in smc_ism.c, such as
     smc_ism_cantalk()/smc_ism_get_chid()/smc_ism_set_conn()..

     With this design intention, futher extended SMC-D used device should be like:

                      +----------------------+
                      |     SMC-D protocol   |
                      +----------------------+
                       |   general helper   |
                       |invoke smcd_dev->ops|
                       | hiding underlay dev|
            +-----------+  +------------+  +----------+
            | smc_ism.c |  | smc_vism.c |  | smc_lo.c |
            |           |  |            |  |          |
            | s390 ISM  |  | virtio-ism |  | loopback |
            |  device   |  |   device   |  |  device  |
            +-----------+  +------------+  +----------+

IMHO, (2) is more clean and beneficial to the flexible expansion of SMC-D devices, with no
underlay devices exposed.

So (2) should be our target. Do you agree? :)

If so, maybe we should make some part of helpers or ops of SMC-D device (such as smcd_register/unregister_dev
and smcd->ops->register_dmb) more generic？

Thanks,
Wen Gu
