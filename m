Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DD1469001E
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 07:00:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229582AbjBIGA3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 01:00:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjBIGA2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 01:00:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A69C51B548
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 22:00:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3D7E3617F7
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 06:00:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D906C433EF;
        Thu,  9 Feb 2023 06:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675922426;
        bh=QF1+90GpSgT2EOuw6GpTf1X3SMzm8URiFJwcJEoGSX0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=khVIpB+Vphsj4tw5igE1znvQsSPLfBJgitGNMC3GHQAaPsYvqa5avOhSu5Agsi2zq
         AG1X0fbugwBtdBIu9GfQbUgMx9LnnjyPFdfaS+3Pz/FmGhGM8jryjqX5mxmZ5ZPiLA
         Tg93qcBFq5gfNoURWOOyeVKDEvNptD3aSvfSWQk+cCUrhNBUYNWfugEe/QX//n+8fN
         bSLaJA7f+7nopgaPoy64dwIFQbQTv/DqYXzomlKSvtpadyOrRsjX2CIAgTAFnIQY2I
         H8GdR1RRQyVJsqfarpnHI8B17ZZS9XbPf4381u6jfD+U59S6pvYR8u98ueENezhuk/
         mU0skHsrZtjIA==
Date:   Wed, 8 Feb 2023 22:00:25 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Chuck Lever <chuck.lever@oracle.com>
Cc:     pabeni@redhat.com, edumazet@google.com, netdev@vger.kernel.org,
        hare@suse.com, dhowells@redhat.com, bcodding@redhat.com,
        kolga@netapp.com, jmeneghi@redhat.com
Subject: Re: [PATCH v3 1/2] net/handshake: Create a NETLINK service for
 handling handshake requests
Message-ID: <20230208220025.0c3e6591@kernel.org>
In-Reply-To: <167580607317.5328.2575913180270613320.stgit@91.116.238.104.host.secureserver.net>
References: <167580444939.5328.5412964147692077675.stgit@91.116.238.104.host.secureserver.net>
        <167580607317.5328.2575913180270613320.stgit@91.116.238.104.host.secureserver.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 07 Feb 2023 16:41:13 -0500 Chuck Lever wrote:
> diff --git a/tools/include/uapi/linux/netlink.h b/tools/include/uapi/linux/netlink.h
> index 0a4d73317759..a269d356f358 100644
> --- a/tools/include/uapi/linux/netlink.h
> +++ b/tools/include/uapi/linux/netlink.h
> @@ -29,6 +29,7 @@
>  #define NETLINK_RDMA		20
>  #define NETLINK_CRYPTO		21	/* Crypto layer */
>  #define NETLINK_SMC		22	/* SMC monitoring */
> +#define NETLINK_HANDSHAKE	23	/* transport layer sec handshake requests */

The extra indirection of genetlink introduces some complications?
