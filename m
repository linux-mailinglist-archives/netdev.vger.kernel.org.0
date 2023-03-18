Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 085386BF76C
	for <lists+netdev@lfdr.de>; Sat, 18 Mar 2023 03:43:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbjCRCnn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 22:43:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbjCRCnm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 22:43:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B91C22C66C;
        Fri, 17 Mar 2023 19:43:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4C60660EF8;
        Sat, 18 Mar 2023 02:43:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D2CAC433EF;
        Sat, 18 Mar 2023 02:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679107420;
        bh=GTtDg6eEme7hWuQuq7HDvrWj6uZz2yOk/cZtcAanhBI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NB5Yios8lj577cucTs1bdRjPT3j9XWw7sOylXqlZW9BHEZru0q77jJJKQx5+SZLL3
         VF1lPsYNgfx3Gnx6eJ3jxK3ubodIgaN9WPLyPBeDCq0D0yJN70COoh23VHo2F73D6S
         jhM0Tu94K+Fszb0AUwGLCUa8ZSIt+vCgkk5GBoDfwg2VvDvGUKLlWE3YC4yYca+HPI
         oRBwCcWVXOchDsbp4eTUze0shHhXId9Y42jEe/akBXGEmy0oK6y0t5C0TC5zQHfH5Q
         2uxkTBQJEGT/sD15LJPtx1kwK8Q4Q6AGoVA5ov2TktFPKMM1L2Uwz9g7iV/mTRV1TS
         qxgOShGnwVXag==
Date:   Fri, 17 Mar 2023 19:43:39 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ronak Doshi <doshir@vmware.com>
Cc:     Yunsheng Lin <linyunsheng@huawei.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Pv-drivers <Pv-drivers@vmware.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Guolin Yang <gyang@vmware.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] vmxnet3: use gro callback when UPT is enabled
Message-ID: <20230317194339.67a33db1@kernel.org>
In-Reply-To: <754F4F49-97C9-45D3-9B2F-C7DAE3FFC30E@vmware.com>
References: <20230308222504.25675-1-doshir@vmware.com>
        <e3768ae9-6a2b-3b5e-9381-21407f96dd63@huawei.com>
        <4DF8ED21-92C2-404F-9766-691AEA5C4E8B@vmware.com>
        <252026f5-f979-2c8d-90d9-7ba396d495c8@huawei.com>
        <0389636C-F179-48E1-89D2-48DE0B34FD30@vmware.com>
        <2e2ae42b-4f10-048e-4828-5cb6dd8558f5@huawei.com>
        <3EF78217-44AA-44F6-99DC-86FF1CC03A94@vmware.com>
        <207a0919-1a5a-dee6-1877-ee0b27fc744a@huawei.com>
        <AA320ADE-E149-4C0D-80D5-338B19AD31A2@vmware.com>
        <77c30632-849f-8b7b-42ef-be8b32981c15@huawei.com>
        <1743CDA0-8F35-4F60-9D22-A17788B90F9B@vmware.com>
        <20230315211329.1c7b3566@kernel.org>
        <4FC80D64-DACB-4223-A345-BCE71125C342@vmware.com>
        <20230316133405.0ffbea6a@kernel.org>
        <06e4a534-d15d-4b17-b548-4927d42152e1@huawei.com>
        <754F4F49-97C9-45D3-9B2F-C7DAE3FFC30E@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 17 Mar 2023 20:27:50 +0000 Ronak Doshi wrote:
> I don=E2=80=99t think holding this patch to investigate why it takes long=
er in GRO is worthwhile.
> That is a separate issue. UPT patches are already upstreamed to Linux and=
 cross-ported to
> relevant distros for customers to use. We need to apply this patch to avo=
id the performance
> degradation in UPT mode as LRO is not available on UPT device.
>=20
> I don=E2=80=99t see a functional issue with this patch. In UPT as LRO is =
not available, it needs to use GRO.

Fine by me, FWIW, but please respin the patch and feed some of=20
the discussion into the commit message.
