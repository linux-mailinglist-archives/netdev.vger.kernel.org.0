Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E79D6531269
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 18:22:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237726AbiEWPVh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 11:21:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237717AbiEWPVe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 11:21:34 -0400
Received: from corp-front08-corp.i.nease.net (corp-front08-corp.i.nease.net [59.111.134.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 152A9286ED;
        Mon, 23 May 2022 08:21:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=corp.netease.com; s=s210401; h=Received:From:To:Cc:Subject:
        Date:Message-Id:In-Reply-To:References:MIME-Version:
        Content-Transfer-Encoding; bh=R3zygWyvjLx8PkoAiXgkSSLytNNRrxTxeZ
        e8vycXt/8=; b=MsiMme38qLMldGXcrNpZ+HfPCVvoG6s7ic4m0iTDfvm4e/B7ny
        sFuG7yvO/VIlFg74aXL+7q9VoZb5Rd0v4uRCVcAgIAU6jsX2jo7bttH8+gMlUEzE
        ZTeVtxobWba7M9JIiO12kP7x7nwQCKDT4NZwjgkF51XkWQBHTKsdc68+o=
Received: from pubt1-k8s74.yq.163.org (unknown [115.238.122.38])
        by corp-front08-corp.i.nease.net (Coremail) with SMTP id nhDICgBXlABvpotibIJhAA--.8009S2;
        Mon, 23 May 2022 23:21:19 +0800 (HKT)
From:   liuyacan@corp.netease.com
To:     kgraul@linux.ibm.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        liuyacan@corp.netease.com, netdev@vger.kernel.org,
        pabeni@redhat.com, ubraun@linux.ibm.com
Subject: Re: [PATCH v2 net] net/smc: postpone sk_refcnt increment in connect()
Date:   Mon, 23 May 2022 23:21:19 +0800
Message-Id: <20220523152119.406443-1-liuyacan@corp.netease.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <e0b64b80-90e1-5aed-1ca4-f6d20ebac6b7@linux.ibm.com>
References: <e0b64b80-90e1-5aed-1ca4-f6d20ebac6b7@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: nhDICgBXlABvpotibIJhAA--.8009S2
X-Coremail-Antispam: 1UD129KBjvdXoW7Jw4xuF4xtF47ur4xArWDJwb_yoWkGFcEga
        9akrykCr4rXFWrJayvkF4rGw43K3yjk348XF4kJr47Jw1rXrWkGrZ8urnaqryxJFWfKrsx
        Gw4rta4Iy342kjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbEAYjxAI6xCIbckI1I0E57IF64kEYxAxM7AC8VAFwI0_Gr0_Xr1l
        1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0I
        I2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0
        Y4vE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84
        ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0DM2kK67ZEXf0FJ3sC6x9vy-n0Xa0_Xr1Utr1k
        JwI_Jr4ln4vE4IxY62xKV4CY8xCE548m6r4UJryUGwAa7VCY0VAaVVAqrcv_Jw1UWr13M2
        AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6s8CjcxG0xyl5I8CrVACY4xI64kE6c02F40E
        x7xfMcIj6xIIjxv20xvE14v26r106r15McIj6I8E87Iv67AKxVW8JVWxJwAm72CE4IkC6x
        0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v
        6xkF7I0E8cxan2IY04v7M4kE6xkIj40Ew7xC0wCjxxvEw4Wlc2IjII80xcxEwVAKI48JMx
        AIw28IcxkI7VAKI48JMxCjnVAK0II2c7xJMxC20s026xCaFVCjc4AY6r1j6r4UMxCIbVAx
        MI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67
        AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0
        cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z2
        80aVAFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI
        43ZEXa7VUUna93UUUUU==
X-CM-SenderInfo: 5olx5txfdqquhrush05hwht23hof0z/1tbiBQAPCVt760qFUgAesL
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> >> This is a rather unusual problem that can come up when fallback=true BEFORE smc_connect()
> >> is called. But nevertheless, it is a problem.
> >>
> >> Right now I am not sure if it is okay when we NOT hold a ref to smc->sk during all fallback
> >> processing. This change also conflicts with a patch that is already on net-next (3aba1030).
> > 
> > Do you mean put the ref to smc->sk during all fallback processing unconditionally and remove 
> > the fallback branch sock_put() in __smc_release()?
> 
> What I had in mind was to eventually call sock_put() in __smc_release() even if sk->sk_state == SMC_INIT
> (currently the extra check in the if() for sk->sk_state != SMC_INIT prevents the sock_put()), but only
> when it is sure that we actually reached the sock_hold() in smc_connect() before.
> 
> But maybe we find out that the sock_hold() is not needed for fallback sockets, I don't know...

I do think the sock_hold()/sock_put() for smc->sk is a bit complicated, Emm, I'm not sure if it 
can be simplified..

In fact, I'm sure there must be another ref count issue in my environment,but I haven't caught it yet.

