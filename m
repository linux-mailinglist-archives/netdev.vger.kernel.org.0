Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5A6F530F02
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 15:18:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235386AbiEWMNF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 08:13:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235387AbiEWMNE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 08:13:04 -0400
Received: from corp-front08-corp.i.nease.net (corp-front08-corp.i.nease.net [59.111.134.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EBF8BF47;
        Mon, 23 May 2022 05:12:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=corp.netease.com; s=s210401; h=Received:From:To:Cc:Subject:
        Date:Message-Id:In-Reply-To:References:MIME-Version:
        Content-Transfer-Encoding; bh=O+sTlVJiIR8kihiGkvpU/fkuVTQpcFKA68
        uIDzsGL7A=; b=SSASLLNxUxaYFM75kY9gFgPvvkAj2r0WZBXoGn0kvFKQP+mSne
        4a5D3S4ssesaDUu6Dy8OoF6aNXVDHxkK0rBLXu325+Ewlo2MQi/52+QI5GkpD1Oj
        BqVChvdHDC0GMvwr/6M6myUUUQHJPen3rg40GQXXmf+FXtJw8KfNsIiwA=
Received: from pubt1-k8s74.yq.163.org (unknown [115.238.122.38])
        by corp-front08-corp.i.nease.net (Coremail) with SMTP id nhDICgBXlAA9eotiqXVhAA--.7902S2;
        Mon, 23 May 2022 20:12:45 +0800 (HKT)
From:   liuyacan@corp.netease.com
To:     kgraul@linux.ibm.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        liuyacan@corp.netease.com, netdev@vger.kernel.org,
        pabeni@redhat.com, ubraun@linux.ibm.com
Subject: Re: [PATCH net] net/smc: fix listen processing for SMC-Rv2
Date:   Mon, 23 May 2022 20:12:45 +0800
Message-Id: <20220523121245.1910773-1-liuyacan@corp.netease.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <76eeb1b0-6e4f-986b-c32f-e7e4de3426a7@linux.ibm.com>
References: <76eeb1b0-6e4f-986b-c32f-e7e4de3426a7@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: nhDICgBXlAA9eotiqXVhAA--.7902S2
X-Coremail-Antispam: 1UD129KBjvJXoW7Ar1xXr47uFyrAr1rZrWfuFg_yoW8Ar48pF
        WrAF4FkFWDt3WfAanFqFyrZr4rA3yFyF1fGrZxJF4Fk3sxZr95ArWIqr1Y9FZ7Za93K3WI
        vFW8Z393uwn8Aa7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUJCb7IF0VCFI7km07C26c804VAKzcIF0wAFF20E14v26r4j6ryU
        M7CY07I20VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2
        IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84AC
        jcxK6xIIjxv20xvEc7CjxVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4
        x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1ln4vE1TuYJxujqTIEc-sFP3VYkVW5Jr1DJw4U
        KVWUGwAawVACjsI_Ar4v6c8GOVW06r1DJrWUAwAawVCFI7vE04vSzxk24VAqrcv_Gr1UXr
        18M2vj6xkI62vS6c8GOVWUtr1rJFyle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCE34x0
        Y48IcwAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4
        A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwACjI8F
        5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lw4CEc2x0rVAKj4xxMx
        02cVAKzwCY0x0Ix7I2Y4AK64vIr41l42xK82IYc2Ij64vIr41l4x8a64kIII0Yj41l4I8I
        3I0E4IkC6x0Yz7v_Jr0_Gr1l4IxY624lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8Gjc
        xK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0
        cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8V
        AvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWxJwCI42IY6I8E87Iv6xkF7I0E
        14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjTREKZWUUUUU
X-CM-SenderInfo: 5olx5txfdqquhrush05hwht23hof0z/1tbiBQAPCVt760qFUgARsE
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > From: liuyacan <liuyacan@corp.netease.com>
> > 
> > In the process of checking whether RDMAv2 is available, the current
> > implementation first sets ini->smcrv2.ib_dev_v2, and then allocates
> > smc buf desc, but the latter may fail. Unfortunately, the caller
> > will only check the former. In this case, a NULL pointer reference
> > will occur in smc_clc_send_confirm_accept() when accessing
> > conn->rmb_desc.
> > 
> > This patch does two things:
> > 1. Use the return code to determine whether V2 is available.
> > 2. If the return code is NODEV, continue to check whether V1 is
> > available.
> > 
> > Fixes: e49300a6bf62 ("net/smc: add listen processing for SMC-Rv2")
> > Signed-off-by: liuyacan <liuyacan@corp.netease.com>
> > ---
>
> I am not happy with this patch. You are right that this is a problem,
> but the fix should be much simpler: set ini->smcrv2.ib_dev_v2 = NULL in
> smc_find_rdma_v2_device_serv() after the not_found label, just like it is
> done in a similar way for the ISM device in smc_find_ism_v1_device_serv().
>
> Your patch changes many more things, and beside that you eliminated the calls 
> to smc_find_ism_store_rc() completely, which is not correct.
> 
> Since your patch was already applied (btw. 3:20 hours after you submitted it),
> please revert it and resend. Thank you.

I also have considered this way, one question is that do we need to do more roll 
back work before V1 check? 

Specifically, In smc_find_rdma_v2_device_serv(), there are the following steps:

1. smc_listen_rdma_init()
   1.1 smc_conn_create()
   1.2 smc_buf_create()   --> may fail
2. smc_listen_rdma_reg()  --> may fail

When later steps fail, Do we need to roll back previous steps?
Thank you.


