Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 226226A0E57
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 18:09:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229550AbjBWRJn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 12:09:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjBWRJm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 12:09:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8356C6E8C;
        Thu, 23 Feb 2023 09:09:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 78E4E61761;
        Thu, 23 Feb 2023 17:09:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 278BFC433EF;
        Thu, 23 Feb 2023 17:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677172179;
        bh=dJ+/lNry7X+lnSPXlyFnUhQfLm9BxG8cYx0kk/ZOK58=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eLOsVbsWZK5mGsZr3AYwNUg7PqA1i5DiOLMW7gOkUx7ZiaJuieBlJeUx93GUshoB4
         vaLCQ/Aiss0rcG850KOkCi735fEyqFCECGqeNmIOCXmX8u09QN4vcJJRi1bWhIhHzG
         uY0Ro7eeyz3ndBK7r4n7V2lfp+GVzfBxL85TBZV6TH96JZmjmbN80JTkHAy+pxAgAV
         kkOIFvQLT7ectNqss0dCYKeEwuhyTAwMoxAs9skYFA1dqTrflg0AoQVlOknZVP9N/X
         lwuf+7YGQtvs4rNjX8+Tyg1oSSNEeLRnuMR9E4ZFmjDZIJEbq35j/feb0NcG17ME3r
         rn+Vy1UJlSMog==
Date:   Thu, 23 Feb 2023 09:09:37 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        saeedm@nvidia.com, tariqt@nvidia.com, leon@kernel.org,
        shayagr@amazon.com, akiyano@amazon.com, darinzon@amazon.com,
        sgoutham@marvell.com, lorenzo.bianconi@redhat.com, toke@redhat.com
Subject: Re: [RFC net-next 1/6] tools: ynl: fix render-max for flags
 definition
Message-ID: <20230223090937.53103f89@kernel.org>
In-Reply-To: <0252b7d3f7af70ce5d9da688bae4f883b8dfa9c7.1677153730.git.lorenzo@kernel.org>
References: <cover.1677153730.git.lorenzo@kernel.org>
        <0252b7d3f7af70ce5d9da688bae4f883b8dfa9c7.1677153730.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 Feb 2023 13:11:33 +0100 Lorenzo Bianconi wrote:
> +                if const['type'] == 'flags':
> +                    max_name = c_upper(name_pfx + 'mask')
> +                    max_val = f' = {(entry.user_value() << 1) - 1},'
> +                    cw.p(max_name + max_val)

Could you use EnumSet::get_mask instead() ?

I think it also needs to be fixed to actually walk the elements 
and combine the user_value()s rather than count them and assume
there are no gaps.
