Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A15095393B5
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 17:14:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345542AbiEaPOS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 11:14:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237336AbiEaPOR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 11:14:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A9B125F0;
        Tue, 31 May 2022 08:14:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 112FDB8119C;
        Tue, 31 May 2022 15:14:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E149C385A9;
        Tue, 31 May 2022 15:14:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654010053;
        bh=gDp6UNdQ0PKd5CJVOD3E4KkUjLefxtxl9Ek4Nl2FAww=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mXlSXKTpzFFbquqZzqwvtnvCZhcVvGXl02PY5LezepuGRt4lhTakVtteFtu/fd9Uq
         tZFcfHkNDgyAnRcl5DFxYGxLIM7H1LBOFKqLq9P7sm98S4N+5UnWlFfdQxiZxz7Ucd
         UJ+lOZhhh026r3qFAob+L+00lWT0uBs5gzXahsvg3pGIz0MFSQEcoYgbK8z9fzHlV0
         inW42vMBYRZHhhKKqQ2j6Crh4ojGJo+BaSTHH26CkDTVfZv9GDSypjBwJhSqkY8mZj
         5zTz40yuIzjyPwtFikCybZmKtk4bs9TcD/XjmEQOIUbmcBBVzZYCNE801MhFRULDX0
         JeF0EOrwiek6g==
Date:   Tue, 31 May 2022 08:14:12 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Chen Lin <chen45464546@163.com>
Cc:     akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, alexander.duyck@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2] mm: page_frag: Warn_on when frag_alloc size is
 bigger than PAGE_SIZE
Message-ID: <20220531081412.22db88cc@kernel.org>
In-Reply-To: <1654008072-3136-1-git-send-email-chen45464546@163.com>
References: <20220530122918.549ef054@kernel.org>
        <1654008072-3136-1-git-send-email-chen45464546@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 31 May 2022 22:41:12 +0800 Chen Lin wrote:
> At 2022-05-31 02:29:18, "Jakub Kicinski" <kuba@kernel.org> wrote:
> >Oh, well, the reuse also needs an update. We can slap a similar
> >condition next to the pfmemalloc check.  
> 
> The sample code above cannot completely solve the current problem.
> For example, when fragsz is greater than PAGE_FRAG_CACHE_MAX_SIZE(32768),
> __page_frag_cache_refill will return a memory of only 32768 bytes, so 
> should we continue to expand the PAGE_FRAG_CACHE_MAX_SIZE? Maybe more 
> work needs to be done

Right, but I can think of two drivers off the top of my head which will
allocate <=32k frags but none which will allocate more.
