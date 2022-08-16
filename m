Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B88DF5957F2
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 12:19:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233737AbiHPKTz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 06:19:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233675AbiHPKT0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 06:19:26 -0400
Received: from out30-44.freemail.mail.aliyun.com (out30-44.freemail.mail.aliyun.com [115.124.30.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B726286FE8;
        Tue, 16 Aug 2022 01:28:30 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046059;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0VMPLOAB_1660638505;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0VMPLOAB_1660638505)
          by smtp.aliyun-inc.com;
          Tue, 16 Aug 2022 16:28:26 +0800
Date:   Tue, 16 Aug 2022 16:28:25 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     "D. Wythe" <alibuda@linux.alibaba.com>
Cc:     kgraul@linux.ibm.com, wenjia@linux.ibm.com, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH net-next 09/10] net/smc: fix potential panic dues to
 unprotected smc_llc_srv_add_link()
Message-ID: <YvtVKT44JuqhyWB2@TonyMac-Alibaba>
Reply-To: Tony Lu <tonylu@linux.alibaba.com>
References: <cover.1660152975.git.alibuda@linux.alibaba.com>
 <f4c5b1ba19c926e8b3d1def2ff685f29b2631b24.1660152975.git.alibuda@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f4c5b1ba19c926e8b3d1def2ff685f29b2631b24.1660152975.git.alibuda@linux.alibaba.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 11, 2022 at 01:47:40AM +0800, D. Wythe wrote:
> From: "D. Wythe" <alibuda@linux.alibaba.com>
> 
> After we optimize the parallel capability of SMC-R connection
> establishment, there is a certain chance to trigger the
> following panic:
> 
> PID: 5900   TASK: ffff88c1c8af4100  CPU: 1   COMMAND: "kworker/1:48"
>  #0 [ffff9456c1cc79a0] machine_kexec at ffffffff870665b7
>  #1 [ffff9456c1cc79f0] __crash_kexec at ffffffff871b4c7a
>  #2 [ffff9456c1cc7ab0] crash_kexec at ffffffff871b5b60
>  #3 [ffff9456c1cc7ac0] oops_end at ffffffff87026ce7
>  #4 [ffff9456c1cc7ae0] page_fault_oops at ffffffff87075715
>  #5 [ffff9456c1cc7b58] exc_page_fault at ffffffff87ad0654
>  #6 [ffff9456c1cc7b80] asm_exc_page_fault at ffffffff87c00b62
>     [exception RIP: ib_alloc_mr+19]
>     RIP: ffffffffc0c9cce3  RSP: ffff9456c1cc7c38  RFLAGS: 00010202
>     RAX: 0000000000000000  RBX: 0000000000000002  RCX: 0000000000000004
>     RDX: 0000000000000010  RSI: 0000000000000000  RDI: 0000000000000000
>     RBP: ffff88c1ea281d00   R8: 000000020a34ffff   R9: ffff88c1350bbb20
>     R10: 0000000000000000  R11: 0000000000000001  R12: 0000000000000000
>     R13: 0000000000000010  R14: ffff88c1ab040a50  R15: ffff88c1ea281d00
>     ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
>  #7 [ffff9456c1cc7c60] smc_ib_get_memory_region at ffffffffc0aff6df [smc]
>  #8 [ffff9456c1cc7c88] smcr_buf_map_link at ffffffffc0b0278c [smc]
>  #9 [ffff9456c1cc7ce0] __smc_buf_create at ffffffffc0b03586 [smc]
> 
> The reason here is that when the server tries to create a second link,
> smc_llc_srv_add_link() has no protection and may add a new link to
> link group. This breaks the security environment protected by
> llc_conf_mutex.
> 
> Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>

I am curious if this patch can be merged with the previous one? It seems
that this panic is introduced by previous one?

> ---
>  net/smc/af_smc.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
> index 39dbf39..0b0c53a 100644
> --- a/net/smc/af_smc.c
> +++ b/net/smc/af_smc.c
> @@ -1834,8 +1834,10 @@ static int smcr_serv_conf_first_link(struct smc_sock *smc)
>  	smc_llc_link_active(link);
>  	smcr_lgr_set_type(link->lgr, SMC_LGR_SINGLE);
>  
> +	down_write(&link->lgr->llc_conf_mutex);
>  	/* initial contact - try to establish second link */
>  	smc_llc_srv_add_link(link, NULL);
> +	up_write(&link->lgr->llc_conf_mutex);
>  	return 0;
>  }
>  
> -- 
> 1.8.3.1
