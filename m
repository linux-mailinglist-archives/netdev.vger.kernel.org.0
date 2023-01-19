Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FC19674C81
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 06:36:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231395AbjATFgx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 00:36:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230481AbjATFgh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 00:36:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2A8C6A311;
        Thu, 19 Jan 2023 21:33:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D7BFBB82753;
        Thu, 19 Jan 2023 22:24:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 062AFC433D2;
        Thu, 19 Jan 2023 22:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674167086;
        bh=MDJiA1Cb8ehwdjGzD4zt0t9iD2NciXzOfn5TWOgZsk8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hxshU+jw4C/stIm5JiF0CCyFxTfRELds30JJJsq9kj1p1o2OhvswV2jLZn5Tm+YHF
         +/MDm82VH88chcGDF4+t0zUn+8Rjmnk9J+lduruz8QYhYVGBjtQzS6cRh+aWDKleQi
         qHvykTzsFzM+BIFH+xYliUeg63ObDVnaOZ1EP7SEn8N1p2Xttmzja3iENdMYGVqORL
         f17phApOzaC8uII1SG4Z4DrLxE30umOjz2fLBF4i3ExPj4Q7z3NwgwIiRs60d7lmPc
         fzH6cpipLpvbe4Y27Ea7x+bxIkMhpElSDzp1Y6a1LrniijVp/X3xSXOvV8xeE+zyga
         YhfgUXb/GlvIg==
Date:   Thu, 19 Jan 2023 14:24:45 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Rob Herring <robh@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, johannes@sipsolutions.net,
        stephen@networkplumber.org, ecree.xilinx@gmail.com, sdf@google.com,
        f.fainelli@gmail.com, fw@strlen.de, linux-doc@vger.kernel.org,
        razor@blackwall.org, nicolas.dichtel@6wind.com
Subject: Re: [PATCH net-next v3 2/8] netlink: add schemas for YAML specs
Message-ID: <20230119142445.78e72105@kernel.org>
In-Reply-To: <20230119134922.3fa24ed2@kernel.org>
References: <20230119003613.111778-1-kuba@kernel.org>
        <20230119003613.111778-3-kuba@kernel.org>
        <CAL_JsqKk5RT6PmRSrq=YK7AvzCbcVkxasykJqe1df=3g-=kD7A@mail.gmail.com>
        <20230119134922.3fa24ed2@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 19 Jan 2023 13:49:22 -0800 Jakub Kicinski wrote:
> > Generally you put common schemas under '$defs' and the then reference
> > them with '$ref'.
> > 
> > $defs:
> >   some-prop-type:
> >     type: integer
> >     minimum: 0
> > 
> > properties:
> >   foo:
> >     $ref: '#/$defs/some-prop-type'
> >   bar:
> >     $ref: '#/$defs/some-prop-type'  
> 
> Thanks! Is it possible to move the common definitions to a separate
> file? I tried to create a file called defs.yaml and change the ref to:
> 
>   $ref: "defs.yaml#/$defs/len-or-define"

Oh, oh. Instead of trying to create 3 different "levels" of spec,
and having to pull out shared definitions maybe I can use the 
  if + unevaluatedProperties
to only allow certain properties depending on the value in the
"protocol" attribute...
