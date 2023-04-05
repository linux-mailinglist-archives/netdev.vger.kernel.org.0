Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFD626D8614
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 20:34:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234228AbjDESev (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 14:34:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234209AbjDESeu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 14:34:50 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2E4792;
        Wed,  5 Apr 2023 11:34:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=zLDE4ZoYguVkZUfopXXegQvmwG/VwUXglnq6HHV+P+Y=; b=DCyahPlMemXXJW9WVuWYyPNpuZ
        gq9+mZoYQ8kzqpkZsxYwfZOpVGgUEyiVE8z5DDNoHSXJCA3P5Hzag31o5dtv7S0muavNpZG8ZePct
        AQRMxm1qTzYuC0YAN0ZChu7+yunRJWs2j8mvHqSUFaQWW80I1rCzRdolJCLMhLmrW5h9RJEfRR/E5
        uhNKecmk6BgGgmjTnQBiK97HITys87I0PCsChOAThm3mu7uOi6cdfc1ohlaO+y49hpPsJNN3/qyIS
        o55rN5RFSR+33DzpscxbJG0P0Nz4bPScGoUv2koUEC9plMLgGsYxkvAZBn2OMKWUrw9B4ZGHMtNgC
        L7ceQsog==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pk7xu-00Gds0-AQ; Wed, 05 Apr 2023 18:34:38 +0000
Date:   Wed, 5 Apr 2023 19:34:38 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Sean Anderson <seanga2@gmail.com>
Cc:     Simon Horman <horms@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        kernel test robot <lkp@intel.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linux Memory Management List <linux-mm@kvack.org>,
        linux-m68k@lists.linux-m68k.org
Subject: Re: [PATCH net-next] net: sunhme: move asm includes to below linux
 includes
Message-ID: <ZC2/Pi+M4rWw89x2@casper.infradead.org>
References: <20230405-sunhme-includes-fix-v1-1-bf17cc5de20d@kernel.org>
 <082e6ff7-6799-fa80-81e2-6f8092f8bb51@gmail.com>
 <ZC23vf6tNKU1FgRP@kernel.org>
 <ZC240XCeYCaSCu0X@casper.infradead.org>
 <dee4b415-0696-90f3-0e2f-2230ff941e1b@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dee4b415-0696-90f3-0e2f-2230ff941e1b@gmail.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 05, 2023 at 02:09:55PM -0400, Sean Anderson wrote:
> On 4/5/23 14:07, Matthew Wilcox wrote:
> > We always include linux/* headers before asm/*.  The "sorting" of
> > headers in this way was inappropriate.
> 
> Is this written down anywhere? I couldn't find it in Documentation/process...

Feel free to send a patch.  Generally, it should be:

#include <linux/foo.h>
#include <linux/bar.h>

#include <asm/baz.h>
#include <asm/quux.h>

#include "local.h"

Some drivers do this a different way with a single local.h that includes
all necessary includes.

Also if <linux/foo.h> and <asm/foo.h> both exist, you should include
<linux/foo.h> (which almost certainly includes <asm/foo.h>)
