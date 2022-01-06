Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17502485E6F
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 03:09:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344604AbiAFCJu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 21:09:50 -0500
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:40677 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344590AbiAFCJt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 21:09:49 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=guwen@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0V13maAB_1641434986;
Received: from 30.225.24.14(mailfrom:guwen@linux.alibaba.com fp:SMTPD_---0V13maAB_1641434986)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 06 Jan 2022 10:09:47 +0800
Message-ID: <97c7381e-c618-a074-b1bf-5c59644f35f0@linux.alibaba.com>
Date:   Thu, 6 Jan 2022 10:09:46 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.0
Subject: Re: [PATCH net v3] net/smc: Reset conn->lgr when link group
 registration fails
To:     Karsten Graul <kgraul@linux.ibm.com>, dust.li@linux.alibaba.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1641364133-61284-1-git-send-email-guwen@linux.alibaba.com>
 <20220105075408.GC31579@linux.alibaba.com>
 <23b607fe-95da-ea8a-8dda-900a51572b90@linux.alibaba.com>
 <6e2ae46c-5407-ca6a-3353-69e76f10d913@linux.ibm.com>
From:   Wen Gu <guwen@linux.alibaba.com>
In-Reply-To: <6e2ae46c-5407-ca6a-3353-69e76f10d913@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for your suggestion.

On 2022/1/5 9:25 pm, Karsten Graul wrote:

> It might look cleaner with the following changes:
> - adopt smc_lgr_cleanup_early() to take only an lgr as parameter and remove the call to smc_conn_free()
> - change smc_conn_abort() (which is the only caller of smc_lgr_cleanup_early() right now), always
>    call smc_conn_free() and if (local_first) additionally call smc_lgr_cleanup_early()
>    (hold a local copy of the lgr for this call)
> - finally call smc_lgr_cleanup_early(lgr) from smc_conn_create()
> 
> This should be the same processing, but the smc_conn_free() is moved to smc_conn_abort() where
> it looks to be a better place for this call. And smc_lgr_cleanup_early() takes only care of an lgr.
> 

I think those are very good changes, making smc_lgr_cleanup_early() processing link group only and
more reusable.

> What do you think? Did I miss something?
I think it is better and complete. I will improve the patch and test it, then send a v4.

Thanks,
Wen Gu
