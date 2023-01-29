Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E08D67FEA6
	for <lists+netdev@lfdr.de>; Sun, 29 Jan 2023 12:48:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234569AbjA2Lsb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Jan 2023 06:48:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbjA2Lsa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Jan 2023 06:48:30 -0500
Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FE7920D05;
        Sun, 29 Jan 2023 03:48:27 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R421e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046059;MF=dust.li@linux.alibaba.com;NM=1;PH=DS;RN=17;SR=0;TI=SMTPD_---0VaKR4Av_1674992903;
Received: from localhost(mailfrom:dust.li@linux.alibaba.com fp:SMTPD_---0VaKR4Av_1674992903)
          by smtp.aliyun-inc.com;
          Sun, 29 Jan 2023 19:48:24 +0800
Date:   Sun, 29 Jan 2023 19:48:21 +0800
From:   Dust Li <dust.li@linux.alibaba.com>
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
        Tony Lu <tonylu@linux.alibaba.com>,
        Wen Gu <guwen@linux.alibaba.com>
Subject: Re: [net-next v2 0/8] drivers/s390/net/ism: Add generalized interface
Message-ID: <20230129114821.GF74595@linux.alibaba.com>
Reply-To: dust.li@linux.alibaba.com
References: <20230123181752.1068-1-jaka@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230123181752.1068-1-jaka@linux.ibm.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 23, 2023 at 07:17:44PM +0100, Jan Karcher wrote:
>Previously, there was no clean separation between SMC-D code and the ISM
>device driver.This patch series addresses the situation to make ISM available
>for uses outside of SMC-D.
>In detail: SMC-D offers an interface via struct smcd_ops, which only the
>ISM module implements so far. However, there is no real separation between
>the smcd and ism modules, which starts right with the ISM device
>initialization, which calls directly into the SMC-D code.
>This patch series introduces a new API in the ISM module, which allows
>registration of arbitrary clients via include/linux/ism.h: struct ism_client.
>Furthermore, it introduces a "pure" struct ism_dev (i.e. getting rid of
>dependencies on SMC-D in the device structure), and adds a number of API
>calls for data transfers via ISM (see ism_register_dmb() & friends).
>Still, the ISM module implements the SMC-D API, and therefore has a number
>of internal helper functions for that matter.
>Note that the ISM API is consciously kept thin for now (as compared to the
>SMC-D API calls), as a number of API calls are only used with SMC-D and
>hardly have any meaningful usage beyond SMC-D, e.g. the VLAN-related calls.

Hi,

Great work ! This makes the SMC & ISM code much more clear !

I like this patchset, just some questions on this refactor.
I still see there are some SMC related code in
'drivers/s390/net/ism_drv.c', mainly to implement smcd_ops.

As ISM is the lower layer of SMC, I think remove the dependency
on SMC would be better ? Do you have any plan to do that ?

One more thing:
I didn't find any call for smcd_ops->set_vlan_required/reset_vlan_required,
looks it's not needed, so why not remove it, am I missed something ?

Thanks!

>
>v1 -> v2:
>  Removed s390x dependency which broke config for other archs.
>
>Stefan Raspl (8):
>  net/smc: Terminate connections prior to device removal
>  net/ism: Add missing calls to disable bus-mastering
>  s390/ism: Introduce struct ism_dmb
>  net/ism: Add new API for client registration
>  net/smc: Register SMC-D as ISM client
>  net/smc: Separate SMC-D and ISM APIs
>  s390/ism: Consolidate SMC-D-related code
>  net/smc: De-tangle ism and smc device initialization
>
> drivers/s390/net/ism.h     |  19 +-
> drivers/s390/net/ism_drv.c | 376 ++++++++++++++++++++++++++++++-------
> include/linux/ism.h        |  98 ++++++++++
> include/net/smc.h          |  24 +--
> net/smc/af_smc.c           |   9 +-
> net/smc/smc_clc.c          |  11 +-
> net/smc/smc_core.c         |  13 +-
> net/smc/smc_diag.c         |   3 +-
> net/smc/smc_ism.c          | 180 ++++++++++--------
> net/smc/smc_ism.h          |   3 +-
> net/smc/smc_pnet.c         |  40 ++--
> 11 files changed, 560 insertions(+), 216 deletions(-)
> create mode 100644 include/linux/ism.h
>
>-- 
>2.25.1
