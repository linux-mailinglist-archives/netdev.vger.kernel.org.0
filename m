Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C2FF532AB9
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 14:57:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237477AbiEXM5i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 08:57:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232013AbiEXM5h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 08:57:37 -0400
Received: from corp-front09-corp.i.nease.net (corp-front09-corp.i.nease.net [59.111.134.159])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8809027FF6;
        Tue, 24 May 2022 05:57:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=corp.netease.com; s=s210401; h=Received:From:To:Cc:Subject:
        Date:Message-Id:In-Reply-To:References:MIME-Version:Content-Type:
        Content-Transfer-Encoding; bh=Yt7B0KucM2nqy+KyVy3N/Gqg5XShwOIM39
        x08j9SOA0=; b=RsFe2cG2ulHWNUz/b9CMyHQi+1UkeiICypCPbvQ5kahiXcpymN
        tpwjeSfpnFI31x/ENuttA9vJlPRnr62RS97/srA0cnPxGaeXqoXBB0QU6FRx0xkD
        lef2CnUFJR9zCJVVTNQejVhX7hslIiZeUlt18us8WTOe25XcdFo6zGi48=
Received: from pubt1-k8s74.yq.163.org (unknown [115.238.122.38])
        by corp-front09-corp.i.nease.net (Coremail) with SMTP id nxDICgDn6V411oxiVBZhAA--.16490S2;
        Tue, 24 May 2022 20:57:26 +0800 (HKT)
From:   liuyacan@corp.netease.com
To:     kgraul@linux.ibm.com
Cc:     davem@davemloft.net, guangguan.wang@linux.alibaba.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com
Subject: Re: [PATCH net-next v2] net/smc: align the connect behaviour with TCP
Date:   Tue, 24 May 2022 20:57:25 +0800
Message-Id: <20220524125725.951315-1-liuyacan@corp.netease.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <26d43c65-1f23-5b83-6377-3327854387c4@linux.ibm.com>
References: <26d43c65-1f23-5b83-6377-3327854387c4@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: nxDICgDn6V411oxiVBZhAA--.16490S2
X-Coremail-Antispam: 1UD129KBjvJXoWxCw1UWF1DGr45Zw4UAFyUGFg_yoWrXr1Upr
        yIka9akrWDJr13urnIv3WDCFsayws5JF45GryxWFy8CwnFvFnxJrZ7KrWj9a17ZFykGryU
        Zr48ZFZxKFZ8A37anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUJGb7IF0VCFI7km07C26c804VAKzcIF0wAYjsxI4VWDJwAYFVCj
        jxCrM7AC8VAFwI0_Gr0_Xr1l1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67
        AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IY
        x2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVWxJr0_GcWl84ACjcxK6I
        8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1ln4vE1TuYJxuj
        qTIEc-sFP3VYkVW5Jr1DJw4UKVWUGwAawVACjsI_Ar4v6c8GOVW06r1DJrWUAwAawVACjs
        I_Ar4v6c8GOVWY6r1DJrWUAwAawVCFI7vE04vSzxk24VAqrcv_Gr1UXr18M2vj6xkI62vS
        6c8GOVWUtr1rJFyle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCE34x0Y48IcwAqx4xG64
        xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j
        6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwAKzVCY07xG64k0F24l7I
        0Y64k_MxkI7II2jI8vz4vEwIxGrwCF04k20xvY0x0EwIxGrwCF72vEw2IIxxk0rwCFx2Iq
        xVCFs4IE7xkEbVWUJVW8JwCFI7vE0wC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4
        vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IY
        x2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26c
        xKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAF
        wI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07j6wZ7UUUUU=
X-CM-SenderInfo: 5olx5txfdqquhrush05hwht23hof0z/1tbiBQAQCVt761lFGAAFsW
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > 
> > 
> > On 2022/5/23 20:24, Karsten Graul wrote:
> >> On 13/05/2022 04:24, Guangguan Wang wrote:
> >>> Connect with O_NONBLOCK will not be completed immediately
> >>> and returns -EINPROGRESS. It is possible to use selector/poll
> >>> for completion by selecting the socket for writing. After select
> >>> indicates writability, a second connect function call will return
> >>> 0 to indicate connected successfully as TCP does, but smc returns
> >>> -EISCONN. Use socket state for smc to indicate connect state, which
> >>> can help smc aligning the connect behaviour with TCP.
> >>>
> >>> Signed-off-by: Guangguan Wang <guangguan.wang@linux.alibaba.com>
> >>> Acked-by: Karsten Graul <kgraul@linux.ibm.com>
> >>> ---
> >>>  net/smc/af_smc.c | 50 ++++++++++++++++++++++++++++++++++++++++++++----
> >>>  1 file changed, 46 insertions(+), 4 deletions(-)
> >>>
> >>> diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
> >>> index fce16b9d6e1a..5f70642a8044 100644
> >>> --- a/net/smc/af_smc.c
> >>> +++ b/net/smc/af_smc.c
> >>> @@ -1544,9 +1544,29 @@ static int smc_connect(struct socket *sock, struct sockaddr *addr,
> >>>  		goto out_err;
> >>>  
> >>>  	lock_sock(sk);
> >>> +	switch (sock->state) {
> >>> +	default:
> >>> +		rc = -EINVAL;
> >>> +		goto out;
> >>> +	case SS_CONNECTED:
> >>> +		rc = sk->sk_state == SMC_ACTIVE ? -EISCONN : -EINVAL;
> >>> +		goto out;
> >>> +	case SS_CONNECTING:
> >>> +		if (sk->sk_state == SMC_ACTIVE)
> >>> +			goto connected;
> >>
> >> I stumbled over this when thinking about the fallback processing. If for whatever reason
> >> fallback==true during smc_connect(), the "if (smc->use_fallback)" below would set sock->state
> >> to e.g. SS_CONNECTED. But in the fallback case sk_state keeps SMC_INIT. So during the next call
> >> the SS_CONNECTING case above would break because sk_state in NOT SMC_ACTIVE, and we would end
> >> up calling kernel_connect() again. Which seems to be no problem when kernel_connect() returns 
> >> -EISCONN and we return this to the caller. But is this how it should work, or does it work by chance?
> >>
> > 
> > Since the sk_state keeps SMC_INIT and does not correctly indicate the state of clcsock, it should end
> > up calling kernel_connect() again to get the actual connection state of clcsock.
> > 
> > And I'm sorry there is a problem that if sock->state==SS_CONNECTED and sk_state==SMC_INIT, further call
> > of smc_connect will return -EINVAL where -EISCONN is preferred. 
> > The steps to reproduce:
> > 1）switch fallback before connect, such as setsockopt TCP_FASTOPEN
> > 2）connect with noblocking and returns -EINPROGRESS. (sock->state changes to SS_CONNECTING)
> > 3) end up calling connect with noblocking again and returns 0. (kernel_connect() returns 0 and sock->state changes to
> >    SS_CONNECTED but sk->sk_state stays SMC_INIT)
> > 4) call connect again, maybe by mistake, will return -EINVAL, but -EISCONN is preferred.
> > 
> > What do you think about if we synchronize the sk_state to SMC_ACTIVE instead of keeping SMC_INIT when clcsock
> > connected successfully in fallback case described above.
> > 
> > ...
> 
> I start thinking that the fix in 86434744 introduced a problem. Before that fix a connect with
> fallback always reached __smc_connect() and on top of that function in case of fallback
> smc_connect_fallback() is called, which itself sets sk_state to SMC_ACTIVE.
> 
> 86434744 removed that code path and I wonder what it actually fixed, because at this time the 
> fallback check in __smc_connect() was already present.
> 
> Without that "goto out;" the state would be set correctly in smc_connect_fallback(), and the 
> socket close processing would work as expected.

I think it is OK without that "goto out;". And I guess the purpose of "goto out;" is to avoid calling __smc_connect(), 
because it is impossible to establish an rdma channel at this time.

