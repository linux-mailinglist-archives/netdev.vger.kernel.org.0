Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A3624D8DEF
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 21:11:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244032AbiCNUM2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 16:12:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233445AbiCNUM2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 16:12:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6EA313D0A
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 13:11:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 64C4961258
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 20:11:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59EB7C340E9;
        Mon, 14 Mar 2022 20:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647288676;
        bh=syMGBputaXiS9FtO0IEcCDnEXUACwyeJCzXNPB0JiD8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oyGHdYMSdmu6F8cQXJjl1c08Qb0PQaa5sv0+nzXSJjmBZyPP5CJh99mP5U8pld0wK
         /G9Ljp99td3ZcaDBUuDMiUv9j6vPj2cf0PkW2+1TK9Kkm5HhdZwMjwuRezLsN+WsM8
         TlXVYTXTWpzU+cvhI/quR/L8M6F0hpfkqHUmPInYM5VguUIVhVCkVFj59D7i7XxlQi
         BPL+sBVRAzIk11u/+yeavUqcT90UkUMr99cJ99Tsgx/dJ7STZsGTWIeIfrqiZeW7To
         GIa1+UDbEyG3QPGt64eyEhyGnMdt/STw8HLYMuNFq51v5PtCg+DHpRjVLqCdylTeqI
         vJFfjFSYczqbA==
Date:   Mon, 14 Mar 2022 13:11:14 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <sudheer.mogilappagari@intel.com>,
        <amritha.nambiar@intel.com>, <jiri@nvidia.com>,
        <leonro@nvidia.com>,
        "Bharathi Sreenivas" <bharathi.sreenivas@intel.com>
Subject: Re: [PATCH net-next 2/2] ice: Add inline flow director support for
 channels
Message-ID: <20220314131114.635d5acb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <8602316c-2d0c-8d99-1d7f-135b7d808696@intel.com>
References: <20220310231235.2721368-1-anthony.l.nguyen@intel.com>
        <20220310231235.2721368-3-anthony.l.nguyen@intel.com>
        <20220310203416.3b725bd2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <135a75f8-2da9-407b-40b2-b84ecb229110@intel.com>
        <20220311124909.7112318a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <8602316c-2d0c-8d99-1d7f-135b7d808696@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 13 Mar 2022 17:11:42 -0500 Samudrala, Sridhar wrote:
> > ethtool has RSS context which is what you should use.
> > I presume you used TCs because it's a quick shortcut for getting
> > rate control?
>=20
> When tc mqprio hw offload is used to split tx/rx queues into queue groups=
, we
> create rss contexts per queue group automatically.
> Today we are not exposing the rss indirection table for queue groups via =
ethtool.
> We will add that support by enabling get_rxfh_context() ethtool_ops.

=F0=9F=91=8D

> IIUC, you are suggesting using the rsvd fields in struct ethtool_rxfh to =
enable
> additional per-rss_context parameters.

Poosssibllyy... I'm not sure if it's initialized by user space, always?
You'll need to double check that, since we haven't been enforcing that
it's set to zero in the kernel.

If not we can limit the feature to ethtool netlink. Either way I think
we can keep the driver facing API intact.

> ethtool -X enp175s0f0 context 1 inline_fd on/off
>=20
> Will this be acceptable?

Slightly risky for me to agree because of the lack of documentation -=20
I can't be sure what the knob does, exactly.

If I'm reading the cover letter right the feature flips from hash-based
RSS to assigning flows in a round-robin fashion. Are there flows which
remain hashed or everything goes to round robin? We should document
what the eviction policy is as well.

I think we may need to polish the exact definition of what on/off means
a little more but your example command seems quite plausible at this
point.
