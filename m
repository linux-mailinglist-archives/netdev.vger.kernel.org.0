Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1434F5312BD
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 18:23:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236234AbiEWNZx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 09:25:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236182AbiEWNZu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 09:25:50 -0400
Received: from corp-front07-corp.i.nease.net (corp-front07-corp.i.nease.net [59.111.134.157])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 158763F897;
        Mon, 23 May 2022 06:25:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=corp.netease.com; s=s210401; h=Received:From:To:Cc:Subject:
        Date:Message-Id:In-Reply-To:References:MIME-Version:
        Content-Transfer-Encoding; bh=vij71P4VVuIOT3OaBmgG9nyixyx+SJjaYA
        EmsqnR2z4=; b=slTj/MFPoEkYxC1IJGveqxkL7MXNNctro7q78PgCf3H08BFKJK
        RlTUnGKOuSoJUlyoyD4orxI88wtM+hrdHvTy2tErADcH6cZDJvsT5hI0g6iXxN1o
        iZDMEvaxnr3xPIVBTLdxRbcFtYktaFQi5mV9UNnGfwZMPUNCfjiJbrypQ=
Received: from pubt1-k8s74.yq.163.org (unknown [115.238.122.38])
        by corp-front07-corp.i.nease.net (Coremail) with SMTP id nRDICgA31BJLi4tii9xgAA--.34974S2;
        Mon, 23 May 2022 21:25:31 +0800 (HKT)
From:   liuyacan@corp.netease.com
To:     kgraul@linux.ibm.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        liuyacan@corp.netease.com, netdev@vger.kernel.org,
        pabeni@redhat.com, ubraun@linux.ibm.com
Subject: Re: [PATCH net] net/smc: fix listen processing for SMC-Rv2
Date:   Mon, 23 May 2022 21:25:31 +0800
Message-Id: <20220523132531.2419421-1-liuyacan@corp.netease.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <f35924c0-4691-3b11-c302-9d79f3e3c1c7@linux.ibm.com>
References: <f35924c0-4691-3b11-c302-9d79f3e3c1c7@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: nRDICgA31BJLi4tii9xgAA--.34974S2
X-Coremail-Antispam: 1UD129KBjvJXoW7Ar1fZr45uFWxWw15KFWrAFb_yoW8tr45pF
        W8AF4SkFWDt3WFywsFqF1rXr4Fyryrtr9xWr9xJrs5C3s0vr95ArW8Xry5uFZ7ZF43K3Wx
        Zr48ZrWfZw1DAaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUXjb7IF0VCFI7km07C26c804VAKzcIF0wAFF20E14v26r4j6ryU
        M7CY07I20VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2
        IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84AC
        jcxK6xIIjxv20xvEc7CjxVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84
        ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0DM2kK67ZEXf0FJ3sC6x9vy-n0Xa0_Xr1Utr1k
        JwI_Jr4ln4vEF7Iv6F18KVAqrcv_GVWUtr1rJF1ln4vE4IxY62xKV4CY8xCE548m6r4UJr
        yUGwAa7VCY0VAaVVAqrcv_Jw1UWr13M2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6s8C
        jcxG0xyl5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r106r15McIj6I
        8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I2
        1c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxan2IY04v7M4kE6xkIj40Ew7xC0w
        CjxxvEw4Wlc2IjII80xcxEwVAKI48JMxAIw28IcxkI7VAKI48JMxCjnVAK0II2c7xJMxC2
        0s026xCaFVCjc4AY6r1j6r4UMxCIbckI1I0E14v26r1Y6r17MxCIbVAxMI8I3I0E5I8CrV
        AFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCI
        c40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267
        AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr0_
        Cr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7sRRhSdJ
        UUUUU==
X-CM-SenderInfo: 5olx5txfdqquhrush05hwht23hof0z/1tbiBQAPCVt760qFUgAXsC
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> >>> From: liuyacan <liuyacan@corp.netease.com>
> >>>
> >>> In the process of checking whether RDMAv2 is available, the current
> >>> implementation first sets ini->smcrv2.ib_dev_v2, and then allocates
> >>> smc buf desc, but the latter may fail. Unfortunately, the caller
> >>> will only check the former. In this case, a NULL pointer reference
> >>> will occur in smc_clc_send_confirm_accept() when accessing
> >>> conn->rmb_desc.
> >>>
> >>> This patch does two things:
> >>> 1. Use the return code to determine whether V2 is available.
> >>> 2. If the return code is NODEV, continue to check whether V1 is
> >>> available.
> >>>
> >>> Fixes: e49300a6bf62 ("net/smc: add listen processing for SMC-Rv2")
> >>> Signed-off-by: liuyacan <liuyacan@corp.netease.com>
> >>> ---
> >>
> >> I am not happy with this patch. You are right that this is a problem,
> >> but the fix should be much simpler: set ini->smcrv2.ib_dev_v2 = NULL in
> >> smc_find_rdma_v2_device_serv() after the not_found label, just like it is
> >> done in a similar way for the ISM device in smc_find_ism_v1_device_serv().
> >>
> >> Your patch changes many more things, and beside that you eliminated the calls 
> >> to smc_find_ism_store_rc() completely, which is not correct.
> >>
> >> Since your patch was already applied (btw. 3:20 hours after you submitted it),
> >> please revert it and resend. Thank you.
> > 
> > I also have considered this way, one question is that do we need to do more roll 
> > back work before V1 check? 
> > 
> > Specifically, In smc_find_rdma_v2_device_serv(), there are the following steps:
> > 
> > 1. smc_listen_rdma_init()
> >    1.1 smc_conn_create()
> >    1.2 smc_buf_create()   --> may fail
> > 2. smc_listen_rdma_reg()  --> may fail
> > 
> > When later steps fail, Do we need to roll back previous steps?
> 
> That is a good question and I think that is a different problem for another patch.
> smc_listen_rdma_init() maybe should call smc_conn_abort() similar to what smc_listen_ism_init()
> does in this situation. And when smc_listen_rdma_reg() fails ... hmm we need to think about this.
> 
> We will also discuss this here in our team.

Ok, I will revert this patch and resend a simpler one. Thank you.

