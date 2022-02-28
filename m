Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C0CB4C7DA2
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 23:41:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230368AbiB1Wmd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 17:42:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbiB1Wmc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 17:42:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FA6212E9F0;
        Mon, 28 Feb 2022 14:41:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5342DB8167C;
        Mon, 28 Feb 2022 22:41:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1307C340EE;
        Mon, 28 Feb 2022 22:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646088109;
        bh=WbO1kHYYhvtq6FuIqgeAc7WAL7qNHZIYyrHdNbB36Xo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rnf0Epn/xOImEr9/95ZkiDQkvTy5Kl9PlrMpT644RV6WxfzTYknR9lKTbSD3q5Aq5
         cASE0Ws109rbHdOH/z25LrphDhIOUxwsP8CFC5136oCggpAyiDFlJYsvojgwiBfnNL
         HUI+gzyycsKGNkHl9DwDevM3Bsz8eKklqesPW5S+2Zi6T7Qxkz1jOQ/j+9GtOSJpxz
         GiqdeDJpvS20QiiYCH3sjZje8bRAyxKoGQ1+4MeZJVaMTMqmQBAVQC/xLlE88HpeGE
         f/bxXKWqj/TFRY6AcRLk2mNwpyJ0+n/QeNtVjT6vIjBMaWuyi1LdeHg+VAOtPKNiHW
         zU6h4P8tsLjEg==
Date:   Mon, 28 Feb 2022 14:41:48 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [pull request][for-next v2 00/17] mlx5-next 2022-22-02
Message-ID: <20220228224148.gwzbabatnedfrmu3@sx1>
References: <20220223233930.319301-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220223233930.319301-1-saeed@kernel.org>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23 Feb 15:39, Saeed Mahameed wrote:
>From: Saeed Mahameed <saeedm@nvidia.com>
>
>Hi Dave, Jakub and Jason,
>
>v1->v2:
> - Fix typo in the 1st patch's title
>
>The following PR includes updates to mlx5-next branch:
>
>Headlines:
>==========
>
>1) Jakub cleans up unused static inline functions
>
>2) I did some low level firmware command interface return status changes to
>provide the caller with full visibility on the error/status returned by
>the Firmware.
>
>3) Use the new command interface in RDMA DEVX usecases to avoid flooding
>dmesg with some "expected" user error prone use cases.
>
>4) Moshe also uses the new command interface to grab the specific error
>code from MFRL register command to provide the exact error reason for
>why SW reset couldn't perform internally in FW.
>
>5) From Mark Bloch: Lag, drop packets in hardware when possible
>
>In active-backup mode the inactive interface's packets are dropped by the
>bond device. In switchdev where TC rules are offloaded to the FDB
>this can lead to packets being hit in the FDB where without offload
>they would have been dropped before reaching TC rules in the kernel.
>
>Create a drop rule to make sure packets on inactive ports are dropped
>before reaching the FDB.
>
>Listen on NETDEV_CHANGEUPPER / NETDEV_CHANGEINFODATA events and record
>the inactive state and offload accordingly.
>
>==========
>
>Please pull and let me know if there's any problem.
>
>The following changes since commit e783362eb54cd99b2cac8b3a9aeac942e6f6ac07:
>
>  Linux 5.17-rc1 (2022-01-23 10:12:53 +0200)
>
>are available in the Git repository at:
>
>  git://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux.git mlx5-next
>
>for you to fetch changes up to 45fee8edb4b333af79efad7a99de51718ebda94b:
>
>  net/mlx5: Add clarification on sync reset failure (2022-02-23 15:21:59 -0800)
>

Dave, Jakub, I expecting this to be pulled into net-next, let me know if I
did something wrong, I see the series is marked as "Awaiting upstream" in
patchworks.

