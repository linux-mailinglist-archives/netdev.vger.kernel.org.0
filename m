Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5B5C5A04BA
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 01:33:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230481AbiHXXdw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 19:33:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232024AbiHXXdf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 19:33:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BD7680F61
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 16:32:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B8673B826C1
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 23:32:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DD04C433D6;
        Wed, 24 Aug 2022 23:32:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661383953;
        bh=pKapiAD4TnK7Pah/51fnwPcS2nBWoF3jOA8I1sk51kQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=j5bE0Q8dTthKiOQHc9y+cmRcTUeGc1rYynIIv4oyXuINiYGMisTm4Bh3UYDasQqfz
         jrJOqKuNeL99BceMYYae1dE6K0bnDjYX58vAjShT0qanIM87XnEaw7Hwrn1EaHzpaw
         f+3cgLVMyn20e/SaTTWOUAcxm3z2oXFnucprqNnYgYFtSLLs2luJO3G4jPoi4O1dC5
         cKcWbvrwnTK0V5Vv4vdEvrUxqKYbMBxXDN5HPAkZj3Ww98AHXTZEquF63E1eXO4+SD
         tDpIEkKZWhOeSiQYxXrgnWGI3KuS/mmcmlltOEzXVOFSfOw2jKFhiDVoF5XN2DieGS
         4mIs3YjsycFbg==
Date:   Wed, 24 Aug 2022 16:32:32 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Keller, Jacob E" <jacob.e.keller@intel.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Greenwalt, Paul" <paul.greenwalt@intel.com>
Subject: Re: [PATCH net-next 2/2] ice: add support for Auto FEC with FEC
 disabled via ETHTOOL_SFECPARAM
Message-ID: <20220824163232.3c3e7b28@kernel.org>
In-Reply-To: <CO1PR11MB5089AEF6A98652B577A109B1D6739@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20220823150438.3613327-1-jacob.e.keller@intel.com>
        <20220823150438.3613327-3-jacob.e.keller@intel.com>
        <20220823151745.3b6b67cb@kernel.org>
        <CO1PR11MB508971C03652EF412A43DD80D6739@CO1PR11MB5089.namprd11.prod.outlook.com>
        <20220824154727.450ff9d9@kernel.org>
        <CO1PR11MB5089262FADDECF5AA21DBFCAD6739@CO1PR11MB5089.namprd11.prod.outlook.com>
        <20220824160230.3c2f06b2@kernel.org>
        <CO1PR11MB5089AEF6A98652B577A109B1D6739@CO1PR11MB5089.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 24 Aug 2022 23:13:47 +0000 Keller, Jacob E wrote:
> > > According to the folks I talked to what we have here, we didn't
> > > understand this as being from a standard, but if it is I'd love to
> > > read on it. =20
> >=20
> > Table 110C=E2=80=931=E2=80=94Host and cable assembly combinations
> > in IEEE 802.3 2018, that's what I was thinking of. =20
>=20
> Ah. I am not sure if the state machine in firmware uses this table or
> not, but my guess is that it does.

Yeah, I thought that's what AUTO means, otherwise if everyone did their
own thing we wouldn't get link up without real autoneg enabled, right?
Now the table only specifies minimum FEC requirements, in your case (and
perhaps for others) No FEC does not get used, presumably the selection
is only done between R and RS?
