Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C71EA524022
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 00:16:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348650AbiEKWQx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 18:16:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232825AbiEKWQw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 18:16:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9B7E37BFC;
        Wed, 11 May 2022 15:16:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A485AB82617;
        Wed, 11 May 2022 22:16:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAD5BC34114;
        Wed, 11 May 2022 22:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652307409;
        bh=Ibde5NPEHI+ISPFgedToJYypsoPY3AeS1t76w6zY15I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BCg9Cb/JqTWEFBaFeifnbSh1qLq5VOBjWYNYv/gj1oOtaFLzCU/xMtY5sWNsLtAlO
         8OqLupmESdbdbC/Q5rULO9VehhCL90jcWPraHcb1J/A3U7pr3hZyDGioScABaNol+m
         rv1a+efCJXUZj/Eanz4+aNtF4QgZ4d+W2W/Dr87VDAqMFG1Stv3+E3F96k5EwEGL82
         SdkgSfp+ret2wivonAM/Oqy32ld6Ug3dGf1sBZ/r2TtyfDpJt3R8Qj1U+innFOIowH
         NtdwlkmZgWFGBou4CPPChUtmSzvoAgPjwnuBBxvO6o29qS6s8cBIRySUu622psNrHr
         nrnO9bWL+zAXg==
Date:   Wed, 11 May 2022 15:16:47 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Christoph Hellwig <hch@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, Du Cheng <ducheng2@gmail.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Vlastimil Babka <vbabka@suse.cz>,
        William Kucharski <william.kucharski@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Nathan Chancellor <nathan@kernel.org>, netdev@vger.kernel.org,
        linux-mm@kvack.org, linux-hardening@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] niu: Silence randstruct warnings
Message-ID: <20220511151647.7290adbe@kernel.org>
In-Reply-To: <20220510205729.3574400-1-keescook@chromium.org>
References: <20220510205729.3574400-1-keescook@chromium.org>
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

On Tue, 10 May 2022 13:57:29 -0700 Kees Cook wrote:
> Clang randstruct gets upset when it sees struct addresspace (which is
> randomized) being assigned to a struct page (which is not randomized):
> 
> drivers/net/ethernet/sun/niu.c:3385:12: error: casting from randomized structure pointer type 'struct address_space *' to 'struct page *'
>                         *link = (struct page *) page->mapping;
>                                 ^
> 
> It looks like niu.c is looking for an in-line place to chain its allocated
> pages together and is overloading the "mapping" member, as it is unused.
> This is very non-standard, and is expected to be cleaned up in the
> future[1], but there is no "correct" way to handle it today.
> 
> No meaningful machine code changes result after this change, and source
> readability is improved.
> 
> Drop the randstruct exception now that there is no "confusing" cross-type
> assignment.
> 
> [1] https://lore.kernel.org/lkml/YnqgjVoMDu5v9PNG@casper.infradead.org/
> 
> Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> Cc: Christoph Hellwig <hch@infradead.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: Du Cheng <ducheng2@gmail.com>
> Cc: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: William Kucharski <william.kucharski@oracle.com>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Nathan Chancellor <nathan@kernel.org>
> Cc: netdev@vger.kernel.org
> Cc: linux-mm@kvack.org
> Cc: linux-hardening@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>

I presume you prefer to take this one via your tree too, so:

Acked-by: Jakub Kicinski <kuba@kernel.org>
