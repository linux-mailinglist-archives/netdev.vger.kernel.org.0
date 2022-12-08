Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51EE2646A7C
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 09:29:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbiLHI3O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 03:29:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbiLHI3N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 03:29:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EBF657B5F;
        Thu,  8 Dec 2022 00:29:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D7AD461DDF;
        Thu,  8 Dec 2022 08:29:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B951C433C1;
        Thu,  8 Dec 2022 08:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670488151;
        bh=It0RTvA+tJvH/AQF08sXXXSECafrWbUvleu8U5jgslA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cR+s/WEHhvwFdGtYvLXgrNp65Y04mLXL883tzC2JClow1An3Dct5Y08zKGimuSoTL
         9FB/oIcXqYHoPgeDwonhJCVWskwIr1gf6Ly/X2qMJv0Yqxu/+K5crHzW5hgEaafbqu
         16lkKgdQ+EQ9y9MLko6dNyYrBsl3ltiUSdEVXreKGYErrTi7JGm1EBzOcSu9nCLkW+
         0YuUv22jZFWX6gve74b8ecB21QUXnWH7km9rGFDVyENuhhWEe7nywtYqcqgJA5Ztbi
         zrMGqxVwAGH13N+ymt6WQxZgY5b8SqzbZ/SUTnXi1YGJUgFhG50Lrt93TVYkZK7ssp
         m2qX74CXInGCA==
Date:   Thu, 8 Dec 2022 10:29:06 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Zhang Changzhong <zhangchangzhong@huawei.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: stmmac: selftests: fix potential memleak in
 stmmac_test_arpoffload()
Message-ID: <Y5GgUoGHfoRC5pib@unreal>
References: <1670401920-7574-1-git-send-email-zhangchangzhong@huawei.com>
 <Y5BY+ZpW20XpkVZw@unreal>
 <100d8307-4ae6-d370-e836-6c76aff4d920@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <100d8307-4ae6-d370-e836-6c76aff4d920@huawei.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 07, 2022 at 06:07:16PM +0800, Zhang Changzhong wrote:
> On 2022/12/7 17:12, Leon Romanovsky wrote:
> > On Wed, Dec 07, 2022 at 04:31:59PM +0800, Zhang Changzhong wrote:
> >> The skb allocated by stmmac_test_get_arp_skb() hasn't been released in
> >> some error handling case, which will lead to a memory leak. Fix this up
> >> by adding kfree_skb() to release skb.
> >>
> >> Compile tested only.
> >>
> >> Fixes: 5e3fb0a6e2b3 ("net: stmmac: selftests: Implement the ARP Offload test")
> >> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
> >> ---
> >>  drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c | 8 ++++++--
> >>  1 file changed, 6 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
> >> index 49af7e7..687f43c 100644
> >> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
> >> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
> >> @@ -1654,12 +1654,16 @@ static int stmmac_test_arpoffload(struct stmmac_priv *priv)
> >>  	}
> >>  
> >>  	ret = stmmac_set_arp_offload(priv, priv->hw, true, ip_addr);
> >> -	if (ret)
> >> +	if (ret) {
> >> +		kfree_skb(skb);
> >>  		goto cleanup;
> >> +	}
> >>  
> >>  	ret = dev_set_promiscuity(priv->dev, 1);
> >> -	if (ret)
> >> +	if (ret) {
> >> +		kfree_skb(skb);
> >>  		goto cleanup;
> >> +	}
> >>  
> >>  	ret = dev_direct_xmit(skb, 0);
> >>  	if (ret)
> > 
> > You should release skb here too. So the better patch will be to write
> > something like that:
> > 
> 
> Hi Leon,
> 
> Thanks for your review, but I don't think we need release skb here,
> because dev_direct_xmit() is responsible for freeing it.

Interesting, __dev_direct_xmit() releases skb too.
Thanks for the clarification.


> 
> Regards,
> Changzhong
> 
> > cleanup:
> >   stmmac_set_arp_offload(priv, priv->hw, false, 0x0);
> >   if (ret)
> >   	kfree_skb(skb);
> >> Thanks
> > 
> >> -- 
> >> 2.9.5
> >>
> > .
> > 
