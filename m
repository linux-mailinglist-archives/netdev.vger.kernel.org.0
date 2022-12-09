Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE3BC648AC7
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 23:35:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229818AbiLIWf1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 17:35:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbiLIWf0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 17:35:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D836C6F0FA;
        Fri,  9 Dec 2022 14:35:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 237A56238D;
        Fri,  9 Dec 2022 22:35:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 400CAC433D2;
        Fri,  9 Dec 2022 22:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670625324;
        bh=UHqQw9ydItZXFG/qBe/IWzVLihWfiLX6WpPk/Cct0mw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=co1nMnjq4SCIIlBPX7AWGnx8mgz+EG4DmN7HOP44ZmphONWhxkm4XCShj9/9oHVLr
         q0ZhEAtGrT2H18wdLvDLIjNj2W2TndkPuFauDcpcvgkdcFTi34rgSWqXz5Vad0O9Mj
         hU7HgKy3rQ+izFpD4UWf1kh1Mx0hhjSXJUUiKNDiSpi+UnmSfZxtSY5wlDkH/1NQEg
         Lt92Oq0N8ee0eX+zGQYiCW58UXf5kK5KnbOCvu9zpuLJllwhn7wfmYTqLpwLqy/RCp
         x7BzJC15i1Rz6f1E6ZTQNIyc5JrsSoAu1SDfYTRXxFaa/iFYqV3cThMxO2X5gC3zfP
         IrbFzLl8bPkjQ==
Date:   Fri, 9 Dec 2022 14:35:23 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     <davem@davemloft.net>, <pabeni@redhat.com>, <edumazet@google.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@openeuler.org>, <ezequiel.garcia@free-electrons.com>
Subject: Re: [PATCH net-next] net: tso: inline tso_count_descs()
Message-ID: <20221209143523.03d9584b@kernel.org>
In-Reply-To: <fc37030e-6888-7a08-348d-cdcc524285ce@huawei.com>
References: <20221208024303.11191-1-linyunsheng@huawei.com>
        <20221208195721.698f68b6@kernel.org>
        <fc37030e-6888-7a08-348d-cdcc524285ce@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 9 Dec 2022 16:48:57 +0800 Yunsheng Lin wrote:
> >> diff --git a/include/net/tso.h b/include/net/tso.h
> >> index 62c98a9c60f1..ab6bbf56d984 100644
> >> --- a/include/net/tso.h
> >> +++ b/include/net/tso.h
> >> @@ -16,7 +16,13 @@ struct tso_t {
> >>  	u32	tcp_seq;
> >>  };  
> > 
> > no include for skbuff.h here  
> 
> Do you mean including skbuff.h explicitly in tso.h?
> It seems ip.h included in tso.h has included skbuff.h.

Yes, we need the definition of skb_shinfo() so let's include the header.
Let's not depend on second-order includes, it makes refactoring harder.

> >> -int tso_count_descs(const struct sk_buff *skb);
> >> +/* Calculate expected number of TX descriptors */
> >> +static inline int tso_count_descs(const struct sk_buff *skb)
> >> +{
> >> +	/* The Marvell Way */  
> > 
> > these comments should be rewritten as we move
> > the function clearly calculates the worst case buffer count  
> 
> Will change to below:
> /* Calculate the worst case buffer count */

Thanks, you can replace the comment about the function with this
comment. No need to have two comments, and mentioning descriptors
is slightly confusing because descriptor is not always equivalent
to a buffer.
