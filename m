Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85BFD6C8ABB
	for <lists+netdev@lfdr.de>; Sat, 25 Mar 2023 04:52:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231445AbjCYDw3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 23:52:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjCYDw3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 23:52:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E22B5BB4;
        Fri, 24 Mar 2023 20:52:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F058EB826F4;
        Sat, 25 Mar 2023 03:52:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FEA7C433D2;
        Sat, 25 Mar 2023 03:52:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679716345;
        bh=EONs6cdikHXLqaMzzaA2gRpEF2luZgV9MFlqozoz1j4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oVzyXNqywvjTQRoi8Mr/icQEuNt32boal3oIpjC8Au3ew8ujyxiqlprNxx0vSQ1ED
         cqKooirsH9g1LKErB1hJ2XDpEtSL9s80nZsTmtabjY716gZUQy9aK58PKCb91OrMRw
         RNle3D4HJuZFcXKPgxWS6Ysi6hEi8ojfT39KGt0Sxtlvx9gVzjxYvK105bosCy95H7
         bmmvqtRuuG/bV9f9M5UoRjt+rqFUdNb3epdTGS6q4puQzacMcVs5vZ+o20rxlTCzb9
         kXyHlOq0hF7F6RFXRSOLhNlu318dJSB4tLOMOnKqxVsyotNsbmuq+TIsfByM56YIXy
         CEbVm3EM52jCg==
Date:   Fri, 24 Mar 2023 20:52:24 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Donald Hunter <donald.hunter@gmail.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        donald.hunter@redhat.com
Subject: Re: [PATCH net-next v4 6/7] docs: netlink: document struct support
 for genetlink-legacy
Message-ID: <20230324205224.18f31f14@kernel.org>
In-Reply-To: <20230324191900.21828-7-donald.hunter@gmail.com>
References: <20230324191900.21828-1-donald.hunter@gmail.com>
        <20230324191900.21828-7-donald.hunter@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 24 Mar 2023 19:18:59 +0000 Donald Hunter wrote:
>  Legacy families can define C structures both to be used as the contents
> -of an attribute and as a fixed message header. The plan is to define
> -the structs in ``definitions`` and link the appropriate attrs.
> +of an attribute and as a fixed message header. Structs are defined
> +in ``definitions`` and referenced in operations or attributes.

We should call out that the structs in YAML are implicitly "packed"
(in the C sense of the word), so struct { u8 a; u16 b; u8 c; } is 
4 bytes not 6 bytes.

Any padding must be explicitly, C-like languages should infer the need
for explicit packing from whether the members are naturally aligned.

> +.. code-block:: yaml
> +
> +  definitions:
> +    -
> +      name: message-header
> +      type: struct
> +      members:
> +        -
> +          name: a
> +          type: u32
> +        -
> +          name: b
> +          type: string

Maybe not the most fortunate example :) cause I think that for
string/binary we'll need an explicit length. Maybe not for
last one if it's a flexible array... but that's rare in NL.

The rest LGTM, thanks!
