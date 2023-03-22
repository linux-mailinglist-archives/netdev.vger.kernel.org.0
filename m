Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B39266C4200
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 06:19:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229917AbjCVFTJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 01:19:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230016AbjCVFS7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 01:18:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F0B44AFF9
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 22:18:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 27084B81B2F
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 05:18:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E7A5C433D2;
        Wed, 22 Mar 2023 05:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679462290;
        bh=A7d8FGjSfeA1e1ZELGCBGL+iMDJD3+gzTOWFqI7RKI0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LbHMi/tJvsSCTqDV3MSutv6bXjM1B7pXI6n5cuFmSJ4S8UO2XzB/+T4l4RXfBbuei
         NNc/iVjpHbzifXPzfMDiuLBqtO8mAhgV+BbkvL8CrRsYiolZSHMk5xdn5pxGIK10AZ
         TVjHG40x/mcalkIOBUuQHxXQGHPEQvkDgjP7EVQR36Kd4fB0ego1l4LzpJXUHV7Mdl
         ASW79rf/1USkqsNkV2jeH1hX6xvt5ZHNJbMWD7IZEwnSrpHN6Iz04I/8J4A2ERoVDT
         jKX+bKvGhOZLjNrPV4z+KbZTRJRVUH6f5a42lVxbsmOyMazG19NrPsvK6jMD+qOyP+
         RGVlGGHw+ptAA==
Date:   Tue, 21 Mar 2023 22:18:09 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Donald Hunter <donald.hunter@gmail.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, donald.hunter@redhat.com
Subject: Re: [PATCH net-next v2 3/6] tools: ynl: Add array-nest attr
 decoding to ynl
Message-ID: <20230321221809.26293ca7@kernel.org>
In-Reply-To: <20230319193803.97453-4-donald.hunter@gmail.com>
References: <20230319193803.97453-1-donald.hunter@gmail.com>
        <20230319193803.97453-4-donald.hunter@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 19 Mar 2023 19:38:00 +0000 Donald Hunter wrote:
> Add support for decoding nested arrays of scalars in netlink messages.

example?

> Signed-off-by: Donald Hunter <donald.hunter@gmail.com>
> ---
>  tools/net/ynl/lib/ynl.py | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/tools/net/ynl/lib/ynl.py b/tools/net/ynl/lib/ynl.py
> index 32536e1f9064..077ba9e8dc98 100644
> --- a/tools/net/ynl/lib/ynl.py
> +++ b/tools/net/ynl/lib/ynl.py
> @@ -93,6 +93,10 @@ class NlAttr:
>      def as_bin(self):
>          return self.raw
>  
> +    def as_array(self, type):
> +        format, _ = self.type_formats[type]
> +        return list({ x[0] for x in struct.iter_unpack(format, self.raw) })

So in terms of C this treats the payload of the attr as a packed array?
That's not what array-nest is, array-nest wraps every entry in another
nlattr:
https://docs.kernel.org/next/userspace-api/netlink/genetlink-legacy.html#array-nest

It's not a C array dumped into an attribute.

IIRC I was intending to use 'binary' for packed arrays. Still use
sub-type to carry the type, but main type should be 'binary'.

If that sounds reasonable could you document or remind me to document
this as the expected behavior? Sub-type appears completely undocumented
now :S

>      def __repr__(self):
>          return f"[type:{self.type} len:{self._len}] {self.raw}"
>  
> @@ -381,6 +385,8 @@ class YnlFamily(SpecFamily):
>                  decoded = attr.as_bin()
>              elif attr_spec["type"] == 'flag':
>                  decoded = True
> +            elif attr_spec["type"] == 'array-nest':
> +                decoded = attr.as_array(attr_spec["sub-type"])
>              else:
>                  raise Exception(f'Unknown {attr.type} {attr_spec["name"]} {attr_spec["type"]}')
>  

