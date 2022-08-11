Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E068B58FEEC
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 17:13:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235573AbiHKPNQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 11:13:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230133AbiHKPNP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 11:13:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C2C08E9A3
        for <netdev@vger.kernel.org>; Thu, 11 Aug 2022 08:13:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DBC2EB82123
        for <netdev@vger.kernel.org>; Thu, 11 Aug 2022 15:13:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4776FC433C1;
        Thu, 11 Aug 2022 15:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660230792;
        bh=eBigUrgZcJfFvNKu0t9Pdqc6p0jDKxmTYIzOj7ggNEI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=krHJONQUHEXqMZd49PY3EtlYCU2HoQeCZfvkySKzae5TCJ1frmMn10q0Cv9Aj7ZQo
         4VWPzVavmOWRqqoAO2GVO1UOlaVO1euyoz3Jfi7gjsUKUfgPYjv9O8GSGYU2zLvzJ8
         BbrbfGNqcC8Bvv5zG+KXw7sSLrmDdOlmXHWRv9tDJROZnkxXKG25yiivFSvVZFz4AF
         akN73UpP1cWoqqMGMjdnXy54zmswKRG7jeghPdLCEbc+vdGm2z2L00FuD3fVwJz9M7
         /wkznLpX3aISP2xk28JjBXs3mlsD4D/Wze9Hbya6b6QOke0Aqohu8hE7ZsKYG4WyFc
         DD7bOP1hhqo4w==
Date:   Thu, 11 Aug 2022 08:13:11 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
Cc:     "shenjian (K)" <shenjian15@huawei.com>, davem@davemloft.net,
        andrew@lunn.ch, ecree.xilinx@gmail.com, hkallweit1@gmail.com,
        saeed@kernel.org, leon@kernel.org, netdev@vger.kernel.org,
        linuxarm@openeuler.org
Subject: Re: [RFCv7 PATCH net-next 36/36] net: redefine the prototype of
 netdev_features_t
Message-ID: <20220811081311.0f549b39@kernel.org>
In-Reply-To: <20220811130757.9904-1-alexandr.lobakin@intel.com>
References: <20220810030624.34711-1-shenjian15@huawei.com>
        <20220810030624.34711-37-shenjian15@huawei.com>
        <20220810113547.1308711-1-alexandr.lobakin@intel.com>
        <3df89822-7dec-c01e-0df9-15b8e6f7d4e5@huawei.com>
        <20220811130757.9904-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 11 Aug 2022 15:07:57 +0200 Alexander Lobakin wrote:

> > Yes, Jakub also mentioned this.
> >=20
> > But there are many existed features interfaces(e.g. ndo_fix_features,
> > ndo_features_check), use netdev_features_t as return value. Then we
> > have to change their prototype. =20
>=20
> We have to do 12k lines of changes already :D
> You know, 16 bytes is probably fine to return directly and it will
> be enough for up to 128 features (+64 more comparing to the
> mainline). OTOH, using pointers removes that "what if/when", so
> it's more flexible in that term. So that's why I asked for other
> folks' opinions -- 2 PoVs doesn't seem enough here.

=46rom a quick grep it seems like the and() is mostly used in some form
of:

	features =3D and(features, mask);

and we already have netdev_features_clear() which modifies its first
argument. I'd also have and() update its first arg rather than return
the result as a value. It will require changing the prototype of
ndo_features_check() :( But yeah, I reckon we shouldn't be putting of
refactoring, best if we make all the changes at once than have to
revisit this once the flags grow again and return by value starts to
be a problem.
