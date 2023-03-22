Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1ECAA6C53D7
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 19:38:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229961AbjCVSiP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 14:38:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230009AbjCVSiM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 14:38:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B3151704
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 11:38:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 91D95B81D9E
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 18:38:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19141C4339B;
        Wed, 22 Mar 2023 18:38:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679510280;
        bh=wupJz6HmbuO2FLMdoqfHSpy6DyfVjP6DX5sIC+jxXro=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=N1imi6M/UOoPInBafJLmkAzSRBIzxCL3h/oxy1WgxplvSY1Frd613hxv23vR04psL
         qcUFOczhOmCUhow6u1yZQFA5BHs9xUVfpegLKzLxvCr9US3w59H7rk/MS9F3K3PLWl
         w0PqV3Fkf7v6tixI8Ppv7dBGUFPCk14FRPWwuHsGY7mYo6L9AClOPJnYTgxUnBM2vV
         WwIw9KuyURxKAM3ZOuJZho/KMjx/6EdoseadBdJGepF5sBWKmgTpv24GldHV/JwAIB
         xjetmCZljbgMuTrRZIA2epBTV8ue4J/0t1l4pgYoSMzQABDFV4jQqZsonLfzEAALp6
         c7zfbstZKQ0UQ==
Date:   Wed, 22 Mar 2023 11:37:59 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Donald Hunter <donald.hunter@gmail.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, donald.hunter@redhat.com
Subject: Re: [PATCH net-next v2 4/6] tools: ynl: Add struct attr decoding to
 ynl
Message-ID: <20230322113759.71d44e97@kernel.org>
In-Reply-To: <m27cv9j9c3.fsf@gmail.com>
References: <20230319193803.97453-1-donald.hunter@gmail.com>
        <20230319193803.97453-5-donald.hunter@gmail.com>
        <20230321223055.21def08d@kernel.org>
        <m27cv9j9c3.fsf@gmail.com>
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

On Wed, 22 Mar 2023 11:48:12 +0000 Donald Hunter wrote:
> > On Sun, 19 Mar 2023 19:38:01 +0000 Donald Hunter wrote:  
> >>                  enum: [ unused, pad, flag, binary, u8, u16, u32, u64, s32, s64,
> >> -                        string, nest, array-nest, nest-type-value ]
> >> +                        string, nest, array-nest, nest-type-value, struct ]  
> >
> > I wonder if we should also only allow struct as a subtype of binary?
> >
> > Structs can technically grow with newer kernels (i.e. new members can
> > be added at the end). So I think for languages like C we will still
> > need to expose to the user the original length of the attribute.
> > And binary comes with a length so codgen reuse fits nicely.
> >
> > Either way - docs need to be updated.  
> 
> Yep, as I was replying to your previous comment, I started to think
> about making struct a subtype of binary. That would make a struct attr
> something like:
> 
>  -
>    name: stats
>    type: binary
>    sub-type: struct
>    struct: vport-stats

LGTM!

> I originally chose 'struct' as the attr name, following the pattern that
> 'enum' is used for enum names but I'm not sure it's clear enough. Maybe
> 'sub-type-name' would be better?

Agreed, using the sub-type's value as name of another attr 
is mixing keys and values.

But sub-type-name would then also be used for enums (I mean in 
normal type: u32 enums, not binary arrays)?
enums don't have a sub-type so there we'd have sub-type-name
and no sub-type.
Plus for binary arrays of enums we'd have:

  -
    name: stats
    type: binary
    sub-type: u32
    sub-type-name: vport-stats

Doesn't say enum anywhere :S  We'd need to assume if sub-type is
a scalar the sub-type-name is an enum?

Maybe to avoid saying struct twice we should go the enum way and
actually ditch the sub-type for structs? Presence of struct: abc
implies it's a struct, only use sub-type for scalar types?

  -
    name: stats
    type: binary
    struct: vport-stats

  -
    name: another
    type: binary
    sub-type: u32
    enum: enums-name
