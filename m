Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C02E4BA761
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 18:44:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243800AbiBQRnQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 12:43:16 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240241AbiBQRnP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 12:43:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 513AC1A4D6A
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 09:43:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E122C61730
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 17:42:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4866C340E8;
        Thu, 17 Feb 2022 17:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645119779;
        bh=vq9ArGKjCXQlMolvPgWZCExLc78HtaKhoM/q+5k3dCg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LiEBp/lKh3nflqDv0YgjhSKoJGx2Pg1LtjFnG0SCn58o0Uw0Ml2duhOrLmzguoiDt
         JdwCRv+YmyGaD18xGVHwediBcAgKz4dRPKKx6BRrfVqCRFAijVeOGSdmDlAUOaGjWs
         8EYuwsl4M2byzJ1MivD3fLo1j9qsn20n7SUJSMcD+zs/kBV/Gg4P5xtMyK3AEqUX3m
         +U0SMbsbb9T8J0SRN8ij4xa3w8a8FpKd9Ru/70EpfjTvOe6+f9uoZtHuKIUL24/5dc
         r8exkXmbI/GV03aHoXs9dwg2SrySzSSQ/iBv05V/2d7HT4E3F0hqPyG0FXdR5NQDxT
         fTnKyP/wk4IhQ==
Date:   Thu, 17 Feb 2022 09:42:57 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Paul Blakey <paulb@nvidia.com>
Cc:     <dev@openvswitch.org>, <netdev@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        "Pravin B Shelar" <pshelar@ovn.org>, <davem@davemloft.net>,
        Eelco Chaudron <echaudro@redhat.com>,
        Oz Shlomo <ozsh@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Roi Dayan <roid@nvidia.com>,
        Ariel Levkovich <lariel@nvidia.com>
Subject: Re: [PATCH net v3 1/1] openvswitch: Fix setting ipv6 fields causing
 hw csum failure
Message-ID: <20220217094257.5c35acc3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220216135308.6354-1-paulb@nvidia.com>
References: <20220216135308.6354-1-paulb@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 16 Feb 2022 15:53:08 +0200 Paul Blakey wrote:
> +		skb->csum =
> +			~csum_block_add(csum_block_sub(~skb->csum,
> +						       (__force __wsum) (ipv6_tclass << 4), 1),
> +					(__force __wsum) (old_ipv6_tclass << 4), 1);

Please add a wcsum_replace4() helper to include/net/checksum.h
It should work like the (misnamed) csum_relace4() helper and have
similar params just wsum instead of sum16.
