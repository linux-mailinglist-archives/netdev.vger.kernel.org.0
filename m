Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E13AD59021C
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 18:05:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237182AbiHKQEM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 12:04:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236098AbiHKQDt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 12:03:49 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 027A99E11B;
        Thu, 11 Aug 2022 08:50:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 39835CE2238;
        Thu, 11 Aug 2022 15:50:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15FC5C433C1;
        Thu, 11 Aug 2022 15:50:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660233031;
        bh=GIreWXw0dGBiaMbBB9V8St1d59z1e5wKB1rMCzUPCZU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BLejlDjOLzySpOPLfxEksdTbfFTpZ6NWg9VYblnhCO/gJax7nuOeLaJHJtmctL2PI
         uKtZXLswxXpqwcnDtedTrWMVhHEr5rBKjldZzTvCe0NxGpF+5JOjxcj8kwOFnTFAtB
         CwpugiHPsQJPN+fLsQTtr+pIJLdKrwlWmLVes+FZityYL9imncj/rEpwNIpxSA7Vrj
         uzL1vlqmuiaU58PqUykbLmJiu5ZOw/fN+/jdvI4PoOrIQnuX4I3Ur7Kc4BOBML7mC4
         pPO/S9oUyb5rkMdDOhtrNPWotxrq0/13f9cSnRY3c6Ju3PscO89qKeofS458gZJtcs
         DnLMWIdVkm03w==
Date:   Thu, 11 Aug 2022 08:50:22 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Benjamin Poirier <benjamin.poirier@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, sdf@google.com, jacob.e.keller@intel.com,
        vadfed@fb.com, johannes@sipsolutions.net, jiri@resnulli.us,
        dsahern@kernel.org, stephen@networkplumber.org, fw@strlen.de,
        linux-doc@vger.kernel.org
Subject: Re: [RFC net-next 3/4] ynl: add a sample python library
Message-ID: <20220811085022.1539f0e3@kernel.org>
In-Reply-To: <YvSYQe58MwWh4x+q@d3>
References: <20220811022304.583300-1-kuba@kernel.org>
        <20220811022304.583300-4-kuba@kernel.org>
        <YvSYQe58MwWh4x+q@d3>
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

On Thu, 11 Aug 2022 14:48:49 +0900 Benjamin Poirier wrote:
> The schema validation part was not working. I got it going with the
> following changes. It then flags some problems in ethtool.yaml.
> 
> diff --git a/tools/net/ynl/samples/ethtool.py b/tools/net/ynl/samples/ethtool.py
> index 63c8e29f8e5d..4c5a4629748d 100755
> --- a/tools/net/ynl/samples/ethtool.py
> +++ b/tools/net/ynl/samples/ethtool.py
> @@ -14,7 +14,7 @@ def main():
>      parser.add_argument('--ifindex', dest='ifindex', type=str)
>      args = parser.parse_args()
>  
> -    ynl = YnlFamily(args.spec)
> +    ynl = YnlFamily(args.spec, args.schema)
>  
>      if args.dev_name:
>          channels = ynl.channels_get({'header': {'dev_name': args.dev_name}})
> diff --git a/tools/net/ynl/samples/ynl.py b/tools/net/ynl/samples/ynl.py
> index 59c178e063f1..35c894b0ec19 100644
> --- a/tools/net/ynl/samples/ynl.py
> +++ b/tools/net/ynl/samples/ynl.py
> @@ -247,7 +247,7 @@ class YnlFamily:
>              self.yaml = yaml.safe_load(stream)
>  
>          if schema:
> -            with open(os.path.dirname(os.path.dirname(file_name)) + '/schema.yaml', "r") as stream:
> +            with open(schema, "r") as stream:
>                  schema = yaml.safe_load(stream)
>  
>              jsonschema.validate(self.yaml, schema)

Hah, thanks! Looks like I also changed my mind between 'val' and 'value'
for the explicit value of the enum item. I'll correct those.
