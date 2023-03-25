Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D69646C8AB8
	for <lists+netdev@lfdr.de>; Sat, 25 Mar 2023 04:47:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230100AbjCYDrl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 23:47:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbjCYDrj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 23:47:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FE1217158;
        Fri, 24 Mar 2023 20:47:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8506962D2A;
        Sat, 25 Mar 2023 03:47:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 993C6C433D2;
        Sat, 25 Mar 2023 03:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679716057;
        bh=ilA3dhCgPe1wOY2rXRy8hV3QUqLGzcp2mFREh7fJDHk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EzlN7Bvtat39KzzYHrbBbEw4tcxN+eY0qIVKzpC12A0238IDQip73SEgWeLBZiFMe
         HjlANOukj/m0JAtVibMvIcXRJhzK/zg49FWy1a7R4uk1lZhxoHdaNKezCf1zUgv5kQ
         c667ErcoUqU6j2+JhxNIQr25nPwKokP6XiY7h7pzU0ohYFbtxWPPppfugjyBmrLm8D
         o324OKDHI4BaZjHZTj+M+z7C0WF8Lw6/jP6XCDLxLunxgbmlAPS/PtE9H1BJmLU7rt
         MP4gL8AWbqUbmkN0Y4PUBSw8nelMwoTuzFploZPUkrWd0EHnQXN6ejPv/WHKgbKn2K
         TdEh5cQQEV2NQ==
Date:   Fri, 24 Mar 2023 20:47:36 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Donald Hunter <donald.hunter@gmail.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        donald.hunter@redhat.com
Subject: Re: [PATCH net-next v4 4/7] tools: ynl: Add fixed-header support to
 ynl
Message-ID: <20230324204736.217e622b@kernel.org>
In-Reply-To: <20230324191900.21828-5-donald.hunter@gmail.com>
References: <20230324191900.21828-1-donald.hunter@gmail.com>
        <20230324191900.21828-5-donald.hunter@gmail.com>
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

On Fri, 24 Mar 2023 19:18:57 +0000 Donald Hunter wrote:
> diff --git a/Documentation/netlink/genetlink-legacy.yaml b/Documentation/netlink/genetlink-legacy.yaml
> index d50c78b9f42d..3b8984122383 100644
> --- a/Documentation/netlink/genetlink-legacy.yaml
> +++ b/Documentation/netlink/genetlink-legacy.yaml
> @@ -261,6 +261,13 @@ properties:
>        async-enum:
>          description: Name for the enum type with notifications/events.
>          type: string
> +      # Start genetlink-legacy
> +      fixed-header: &fixed-header
> +        description: |
> +          Name of the structure defininig the optional fixed-length protocol header. This header is

Typo in 'defininig', could you also wrap at 80 chars?
Old school kernel style.

> +          placed in a message after the netlink and genetlink headers and before any attributes.
> +        type: string
> +      # End genetlink-legacy

>  class GenlMsg:
> -    def __init__(self, nl_msg):
> +    def __init__(self, nl_msg, fixed_header_members = []):

spaces around = or no spaces? I don't really know myself but I'm used
to having no spaces.

> @@ -540,7 +555,7 @@ class YnlFamily(SpecFamily):
>                          print('Unexpected message: ' + repr(gm))
>                          continue
>  
> -                rsp.append(self._decode(gm.raw_attrs, op.attr_set.name))
> +                rsp.append(self._decode(gm.raw_attrs, op.attr_set.name) | gm.fixed_header_attrs)

nit: also line wrap?
