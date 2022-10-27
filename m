Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1655860F2C7
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 10:45:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234759AbiJ0IpL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 04:45:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234551AbiJ0IpK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 04:45:10 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13F6C6175A
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 01:45:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 669C4CE257F
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 08:45:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3095CC433D6;
        Thu, 27 Oct 2022 08:45:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666860303;
        bh=TMTzSMMOCxlSkSGK4WHQGRQPBSMFXF8az3OkoKGnCAo=;
        h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
        b=ABe5VfZa/SViQZqzs1pEdon/kaNTKLcQBSQrJyWiby9PlCjkEorurLsEyHxuQUYE2
         coCtX1WwcaEnfL85oinxaYnmPvARQzDfLWpg03XaEfdJETeABcAZn7kApEXDSNhNtP
         qJoALwWSNzT6asQ6oUbh9aW3Sd9oFgy/ri9Gjw22gfbVg9rvRAPlPQgKimWRD4xYqB
         Zztde6ouYejiNnSYFYlndIqg1n7tktwXrEUnPQCV+ykPTfvxE9Q8m2naj1iZ3nkhDb
         qxn50X/AJ26ieLEWNCZOwBrk33Y/mAWVGJErT2Yr4hX7gAMZoSm5cKfbMwmbPuZvYN
         q8Sl8q0vvlgsw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <cover.1666793468.git.sd@queasysnail.net>
References: <cover.1666793468.git.sd@queasysnail.net>
Subject: Re: [PATCH net v2 0/5] macsec: offload-related fixes
From:   Antoine Tenart <atenart@kernel.org>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>
To:     Sabrina Dubroca <sd@queasysnail.net>, netdev@vger.kernel.org
Date:   Thu, 27 Oct 2022 10:45:00 +0200
Message-ID: <166686030097.40988.16309190373804586041@kwain>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quoting Sabrina Dubroca (2022-10-26 23:56:22)
> I'm working on a dummy offload for macsec on netdevsim. It just has a
> small SecY and RXSC table so I can trigger failures easily on the
> ndo_* side. It has exposed a couple of issues.
>=20
> The first patch is a revert of commit c850240b6c41 ("net: macsec:
> report real_dev features when HW offloading is enabled"). That commit
> tried to improve the performance of macsec offload by taking advantage
> of some of the NIC's features, but in doing so, broke macsec offload
> when the lower device supports both macsec and ipsec offload, as the
> ipsec offload feature flags were copied from the real device. Since
> the macsec device doesn't provide xdo_* ops, the XFRM core rejects the
> registration of the new macsec device in xfrm_api_check.
>=20
> I'm working on re-adding those feature flags when offload is
> available, but I haven't fully solved that yet. I think it would be
> safer to do that second part in net-next considering how complex
> feature interactions tend to be.
>=20
> v2:
>  - better describe the issue introduced by commit c850240b6c41 (Leon
>    Romanovsky)
>  - drop unnecessary !! (Leon Romanovsky)
>=20
> Sabrina Dubroca (5):
>   Revert "net: macsec: report real_dev features when HW offloading is
>     enabled"
>   macsec: delete new rxsc when offload fails
>   macsec: fix secy->n_rx_sc accounting
>   macsec: fix detection of RXSCs when toggling offloading
>   macsec: clear encryption keys from the stack after setting up offload

Series,
Reviewed-by: Antoine Tenart <atenart@kernel.org>

Thanks!
