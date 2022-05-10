Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45DE952229D
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 19:28:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348121AbiEJRcK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 13:32:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348164AbiEJRcD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 13:32:03 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08CD0562F1;
        Tue, 10 May 2022 10:28:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=d0Hkb5yZv7o4mCTLzbNDo3V6J+B8rXkEK/qUdzCIUvU=; b=sSmG2Em/o9PHLyGs3CU8EHL1le
        va/zjEt7uHgZDCI8Jcw4lpvtP1nouOoYImMG13FquRDBTriyrbZ0Jt4Khx2pxDgMYdldGF2m4cjUt
        q87VA94xPPWTxCiRWkpqdcA0iki/Dz4zqUnckQQCwl9mJSbD13KXx5JO5+c4oAuD8NStmvr5NxvQ6
        x3ax+vazK252pxNktD7OjuiLgct+FJCyF+bWOliC28CNaxgWs2fC6VRCb3e51MMvoTnlIMn77Ve6l
        niXMPMVYD+Lf2YuCsISQ2c1oOPezW1oVAHF5W11W5YzB4Lw97jh87hzJTVZp2zZPU6lppDM/LparT
        2U+a/MfQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1noTe9-004fCw-9d; Tue, 10 May 2022 17:27:41 +0000
Date:   Tue, 10 May 2022 18:27:41 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Du Cheng <ducheng2@gmail.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Vlastimil Babka <vbabka@suse.cz>,
        William Kucharski <william.kucharski@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Nathan Chancellor <nathan@kernel.org>, netdev@vger.kernel.org,
        linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH] niu: Add "overloaded" struct page union member
Message-ID: <YnqgjVoMDu5v9PNG@casper.infradead.org>
References: <20220509222334.3544344-1-keescook@chromium.org>
 <YnoT+cBTNnPzzg8H@infradead.org>
 <202205100849.58D2C81@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202205100849.58D2C81@keescook>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 10, 2022 at 08:50:47AM -0700, Kees Cook wrote:
> On Tue, May 10, 2022 at 12:27:53AM -0700, Christoph Hellwig wrote:
> > On Mon, May 09, 2022 at 03:23:33PM -0700, Kees Cook wrote:
> > > The randstruct GCC plugin gets upset when it sees struct addresspace
> > > (which is randomized) being assigned to a struct page (which is not
> > > randomized):
> > 
> > Well, the right fix here is to remove this abuse from the driver, not
> > to legitimize it as part of a "driver" patch touching a core mm header
> 
> Right, I didn't expect anyone to like the new "overloaded" member.
> Mainly I'd just like to understand how niu _should_ be fixed. Is using
> the "private" member the correct thing here?

Well ... no.  We're not entirely set up yet to go to the good answer
that means we don't have to touch this driver again, and yet we're also
in a situation where we'll need to touch this driver at some point in
order to get rid of the way it abuses struct page before we can get to
our good place.

The eventual good answer is that we declare a driver-private memdesc
variant that has a ->link, ->base ->refcount and ->pfn (maybe it has more
than that; I'd have to really understand this driver to be completely
certain about what it needs).  Or perhaps there's a better way to handle
driver-allocated memory for this kind of networking card that this driver
should be converted to use.

I haven't looked into this case deeply enough to have strong thoughts
about how we should handle it, both now and in the glorious future.
