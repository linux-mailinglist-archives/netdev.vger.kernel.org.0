Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B0D94C9E5E
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 08:29:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239876AbiCBH3j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 02:29:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236844AbiCBH3U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 02:29:20 -0500
Received: from out30-57.freemail.mail.aliyun.com (out30-57.freemail.mail.aliyun.com [115.124.30.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70CF651E51;
        Tue,  1 Mar 2022 23:28:36 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R621e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=guwen@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0V61g7Jq_1646206113;
Received: from 30.225.24.118(mailfrom:guwen@linux.alibaba.com fp:SMTPD_---0V61g7Jq_1646206113)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 02 Mar 2022 15:28:34 +0800
Message-ID: <82bd43af-1d90-4395-b868-4a045bf4a47b@linux.alibaba.com>
Date:   Wed, 2 Mar 2022 15:28:32 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.0
Subject: Re: [PATCH net] net/smc: fix unexpected SMC_CLC_DECL_ERR_REGRMB error
To:     "D. Wythe" <alibuda@linux.alibaba.com>, kgraul@linux.ibm.com
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
References: <1646140644-121649-1-git-send-email-alibuda@linux.alibaba.com>
From:   Wen Gu <guwen@linux.alibaba.com>
In-Reply-To: <1646140644-121649-1-git-send-email-alibuda@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



在 2022/3/1 下午9:17, D. Wythe 写道:
> From: "D. Wythe" <alibuda@linux.alibaba.com>
> 
> Remove connections from link group is not synchronous with handling
> SMC_LLC_DELETE_RKEY, which means that even the number of connections is
> less that SMC_RMBS_PER_LGR_MAX, it does not mean that the connection can
> register rtoken successfully later, in other words, the rtoken entry may
> have not been released. This will cause an unexpected
> SMC_CLC_DECL_ERR_REGRMB to be reported, and then ths smc connection have
> to fallback to TCP.
> 


IMHO, if there are SMC_RMBS_PER_LGR_MAX connections in the link group now,
one of them is being removed and here comes a new connection at this moment,
then:

(1) without this patch, the new connection will be added into the old link group
     but fallback if the removing connection has not finished unregistering its rmb.

(2) with this patch, a new link group will be created and the new connection
     will be added into the new link group.

I am wondering if (1) should be considered as a issue, or just a bydesign?
If it is a issue, I think this patch works, Thanks!

Reviewed-by: Wen Gu <guwen@linux.alibaba.com>

Best Regards,
Wen Gu
