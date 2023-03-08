Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E09D36B007C
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 09:07:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229657AbjCHIHM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 03:07:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229815AbjCHIHK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 03:07:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64B7AA8E9E;
        Wed,  8 Mar 2023 00:06:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B5C12616D2;
        Wed,  8 Mar 2023 08:06:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7487C433D2;
        Wed,  8 Mar 2023 08:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678262810;
        bh=gCMUhNXLQ6tMhJL1mLPlFrGFePKFJgqZuppKqYN+6+Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mh9YgxGYzfNzIn/+BCApueF+6/jXMWwvZH03q7XPKTR4z8htNAykqfrDQyQONoI7U
         1oqFMPC4Vd5eJ5n0CY8pRF8R+b+nadQOBzKVcu3xqlWF0a4DELe9dchRCQr+GyppxD
         UM0tzMtalIBgFvPrBThLKv5aYELlYGHPOYRs2os8O0M6qoD7caVqRifxZE+cXk6b55
         1wtRWDGHMnJSh/gQfZg1LgZA4w1o9mf1EuhWShlqNqkt/arSh9+q7UvSxY3x99Ximc
         7rMz0ckP7INI5sT1aQ2zUM2u0kcQMZjr0KQ8kX/9zDBN2isZIfrXh6sJciHLKWdEDB
         EjrlqpOo1NC4A==
Date:   Wed, 8 Mar 2023 00:06:49 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        saeedm@nvidia.com, tariqt@nvidia.com, leon@kernel.org,
        shayagr@amazon.com, akiyano@amazon.com, darinzon@amazon.com,
        sgoutham@marvell.com, lorenzo.bianconi@redhat.com, toke@redhat.com,
        teknoraver@meta.com
Subject: Re: [PATCH net-next 1/8] tools: ynl: fix render-max for flags
 definition
Message-ID: <20230308000649.03adbcce@kernel.org>
In-Reply-To: <b4359cc25819674de797029eb7e4a746853c1df4.1678200041.git.lorenzo@kernel.org>
References: <cover.1678200041.git.lorenzo@kernel.org>
        <b4359cc25819674de797029eb7e4a746853c1df4.1678200041.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  7 Mar 2023 15:53:58 +0100 Lorenzo Bianconi wrote:
> Properly manage render-max property for flags definition type
> introducing mask value and setting it to (last_element << 1) - 1
> instead of adding max value set to last_element + 1
> 
> Fixes: be5bea1cc0bf ("net: add basic C code generators for Netlink")
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  tools/net/ynl/ynl-gen-c.py | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/net/ynl/ynl-gen-c.py b/tools/net/ynl/ynl-gen-c.py
> index 274e9c566f61..f2e41dd962d4 100755
> --- a/tools/net/ynl/ynl-gen-c.py
> +++ b/tools/net/ynl/ynl-gen-c.py
> @@ -1995,9 +1995,14 @@ def render_uapi(family, cw):
>  
>              if const.get('render-max', False):
>                  cw.nl()
> -                max_name = c_upper(name_pfx + 'max')
> -                cw.p('__' + max_name + ',')
> -                cw.p(max_name + ' = (__' + max_name + ' - 1)')
> +                if const['type'] == 'flags':
> +                    max_name = c_upper(name_pfx + 'mask')
> +                    max_val = f' = {(entry.user_value() << 1) - 1},'

Hm, why not use const.get_mask() here? Rather than the last entry?

> +                    cw.p(max_name + max_val)
> +                else:
> +                    max_name = c_upper(name_pfx + 'max')
> +                    cw.p('__' + max_name + ',')
> +                    cw.p(max_name + ' = (__' + max_name + ' - 1)')
>              cw.block_end(line=';')
>              cw.nl()
>          elif const['type'] == 'const':

