Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7FA86D16AD
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 07:15:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbjCaFPa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 01:15:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjCaFP3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 01:15:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45346EB5E
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 22:15:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D1ECE622EA
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 05:15:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFB04C433D2;
        Fri, 31 Mar 2023 05:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680239728;
        bh=BXrWWJuP5DKyTD6I6lhBoQZO40Ciq9y5AXvcT80z21s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OktAf0Eyn51uZz1n9tYRlQNkxUBBdwFp1YStbJje1HHe4GfxYPBoe5MJyZHa/Tj7J
         MrPZLdqx/uJxWUx9857grQ2yMFStjaHZhhSlLC1CpNuO6mYRYzqFFlPmTHLpJvm4LD
         Qg4fkK9ZrwPJe/UVsjYfheuZrRlDLtGZwXRE0QgwGwKg4985pVmuk1FwjwMW89wPaO
         LulQfF/oSLUFK8KZtPmmpK8Yi1Md6j5hn76mZ7hYpD9o3dcCXA4Fg4/ex16a84JQ5k
         CEgozkzG+XFEc3nL5qO4tFovheWl9JP3joEOFO0GoPR/dHbuMKs7Bws3bJj2+df+PL
         LdMapPFKIN33w==
Date:   Thu, 30 Mar 2023 22:15:26 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        hawk@kernel.org, ilias.apalodimas@linaro.org
Subject: Re: [RFC net-next 1/2] page_pool: allow caching from safely
 localized NAPI
Message-ID: <20230330221526.36a5c7e1@kernel.org>
In-Reply-To: <20230331043906.3015706-1-kuba@kernel.org>
References: <20230331043906.3015706-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 30 Mar 2023 21:39:05 -0700 Jakub Kicinski wrote:
> +/* If caller didn't allow direct recycling check if we have other reasons
> + * to believe that the producer and consumer can't race.
> + *
> + * Result is only meaningful in softirq context.
> + */
> +static bool page_pool_safe_producer(struct page_pool *pool)
> +{
> +	struct napi_struct *napi = pool->p.napi;
> +
> +	return napi && READ_ONCE(napi->list_owner) == smp_processor_id();

Herm, this also needs && !in_hardirq()
