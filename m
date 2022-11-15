Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0F43629143
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 05:48:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230041AbiKOEst (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 23:48:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229872AbiKOEsr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 23:48:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E608DFACF
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 20:48:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8AC20B81677
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 04:48:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2006C433C1;
        Tue, 15 Nov 2022 04:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668487721;
        bh=kYnaa+xOYk67fjnwzxNVR8D46/qE2Wb/E3PrINTWDPY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WI4XbrueeMcxBmMbR4HU1AIfZbKBK6WDOOkRr5UuUE2R+TDG9TAHrzsxzTael4lvx
         mgYrviwe6CpfJr4ACy6guYJO2tFaNWsWBerWf8UuEogVzNTx29fJ6xAWPujG3FYt1z
         Yl2JKuRdvoIQ3N6vvhM4r9NjYQtFgYVXtTO874X1RzDjSGMj5+gFCK1o48blGioBc/
         QdDKgFigJZqhzyxSjqnd0I80qXcKiTShAiZQR07m90M47DLQsGcl9V9PueZh67DUuJ
         70FJv55PRSCO2ns7nl5N4xAFelQGFIhlS5eaLpwhaDH14qqugIt6gtnNg9blhfis1z
         vNwNYIXECLr2g==
Date:   Mon, 14 Nov 2022 20:48:39 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     wangyufen <wangyufen@huawei.com>
Cc:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        Jiri Pirko <jiri@mellanox.com>
Subject: Re: [PATCH] netdevsim: Fix memory leak of nsim_dev->fa_cookie
Message-ID: <20221114204839.6cee0697@kernel.org>
In-Reply-To: <df913f58-d301-4df7-aeca-7cb83d18793f@huawei.com>
References: <1668234485-27635-1-git-send-email-wangyufen@huawei.com>
        <20221114185028.54fd7e14@kernel.org>
        <df913f58-d301-4df7-aeca-7cb83d18793f@huawei.com>
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

On Tue, 15 Nov 2022 11:38:26 +0800 wangyufen wrote:
> Sorry, I didn't make it clear.
>=20
> The detailed process of nsim_dev_trap_report_work() is as follows:
>=20
> nsim_dev_trap_report_work()
>    nsim_dev_trap_report_work()
>      ...
>      devlink_trap_report()
>        devlink_trap_report_metadata_set()
>        <-- fa_cookie is assigned to metadata->fa_cookie here=EF=BC=8C and=
 will be freed in net_dm_hw_metadata_free()

What's assigned here and freed in net_dm_hw_metadata_free() is a copy
made with net_dm_hw_metadata_copy(), no? =20
Could you double check the whole path?
