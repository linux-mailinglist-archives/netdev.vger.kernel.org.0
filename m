Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD165663660
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 01:45:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234821AbjAJApG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 19:45:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234800AbjAJApE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 19:45:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11F46E080
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 16:45:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9A2F9611DE
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 00:45:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A404C433D2;
        Tue, 10 Jan 2023 00:45:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673311501;
        bh=CnkC1d6Xsjfkp4uMUM2eg4hYfglY7ggQ3tJi6S+7Ihs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TmAzrsfYBmFoXHfDSGaYddGKCsAlga+HYKXup0FFCCAuBQCXUcP22WcvXlO6AKmEP
         z1xm2n+bcRA4PBmhOhpLgceOYXUFiIuHAap/e+1IOcgTBCv9FoeOlgY3FEPAggD6bI
         h8s3OT+m/qYhmRkpD4GHZnXUPPsJXRDLbt3fpSBp86WHltGInmirSP0tCOt6T5/w+W
         e7UWHKzqgwbTIdC2pA+w3dJUo1LGiYBuWnJzv2YmwJypJj08FH4Z8ORTCMHSNmzs4+
         tPprrRk/IlmuwvWF4TmM8lP0SOMO89tBLM64alK189X0jwN7jIP5fA+vgCWud3TkY1
         c+ylXk5kTo1xg==
Date:   Mon, 9 Jan 2023 16:45:00 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Arinzon <darinzon@amazon.com>
Cc:     David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        Saeed Bshara <saeedb@amazon.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Dagan, Noam" <ndagan@amazon.com>,
        "Agroskin, Shay" <shayagr@amazon.com>,
        "Itzko, Shahar" <itzko@amazon.com>,
        "Abboud, Osama" <osamaabb@amazon.com>
Subject: Re: [PATCH V1 net-next 0/5] Add devlink support to ena
Message-ID: <20230109164500.7801c017@kernel.org>
In-Reply-To: <20230108103533.10104-1-darinzon@amazon.com>
References: <20230108103533.10104-1-darinzon@amazon.com>
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

On Sun, 8 Jan 2023 10:35:28 +0000 David Arinzon wrote:
> This patchset adds devlink support to the ena driver.

Wrong place, please take a look at=20

	struct kernel_ethtool_ringparam::tx_push

and ETHTOOL_A_RINGS_TX_PUSH. I think you just want to configure=20
the max size of the TX push, right?

The reload is also an overkill, reload should re-register all driver
objects but the devlink instance, IIRC. You're not even unregistering
the netdev. You should handle this change the same way you handle any
ring size changes.


For future reference - if you ever _actually_ need devlink please use
the devl_* APIs and take the instance locks explicitly. There has not
been a single devlink reload implementation which would get locking
right using the devlink_* APIs =F0=9F=98=94=EF=B8=8F
