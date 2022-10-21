Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87F0E607B83
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 17:52:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230000AbiJUPwE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 11:52:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229789AbiJUPv5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 11:51:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAAE52502AD;
        Fri, 21 Oct 2022 08:51:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 65F18B82A47;
        Fri, 21 Oct 2022 15:51:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C163BC433C1;
        Fri, 21 Oct 2022 15:51:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666367500;
        bh=vJVVl6G3LW2W0CgmV5kzfZ12Km/1GlMJOiX85Yi03+w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pv1hlDesSsZDt91vkq+jcEKvRdjdEfoImQ6V5F77Vw76WmlThpxY47m+tjWhNJZUP
         2e88Gd8Y41TtnkdyUHfd6u3omhoy/5L90ahNSHuAyZOJrhRwn1Tva2B48F53/fe4cV
         VjlMQ4tW63HfP9Gbtou9cpCCJRTIhmIYMPQcQAxlkkHuhZMolj7DnEweRJoWtbc6lq
         v+2SZGj3Erzi/BJpYwWjbbaZCbKWKATUK60P2MYag/059tNVw0G+T3LF0xaMe8CdPg
         QY+VUhQ4+nG/MGna91HLvSO1Q7QKIvZ54qURCD1QjCKuNfnXKdTC+5DhqLk8cc4bNw
         GJz0dMZACMItQ==
Date:   Fri, 21 Oct 2022 08:51:38 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     Yunsheng Lin <linyunsheng@huawei.com>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxarm@openeuler.org, pabeni@redhat.com, hawk@kernel.org
Subject: Re: [PATCH net-next] net: skb: move skb_pp_recycle() to skbuff.c
Message-ID: <20221021085138.19b2c8a7@kernel.org>
In-Reply-To: <CAC_iWj+oKwHkQRKZhELB=5FOj8n-0ZRC7B0uc9F4vF2h7bncHg@mail.gmail.com>
References: <20221021025822.64381-1-linyunsheng@huawei.com>
        <CAC_iWj+oKwHkQRKZhELB=5FOj8n-0ZRC7B0uc9F4vF2h7bncHg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 21 Oct 2022 09:02:36 +0300 Ilias Apalodimas wrote:
> > +static bool skb_pp_recycle(struct sk_buff *skb, void *data)
> > +{
> > +       if (!IS_ENABLED(CONFIG_PAGE_POOL) || !skb->pp_recycle)
> > +               return false;
> > +       return page_pool_return_skb_page(virt_to_page(data));
> > +}
> 
> Any particular reason you are removing the inline hint here? 

It's recommended in networking to avoid using the inline keyword
unless someone actually checked the compiler output and found the
compiler is being stupid. I don't know the full history of this
recommendation tho.

> Doing it like this will add an extra function call for every packet
> (assuming the compiler decided to inline the previous version)

Should be fine, tiny static function with one caller, I'd bet it's
always inlined, even with -Os.
