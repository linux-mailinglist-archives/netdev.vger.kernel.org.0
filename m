Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D616164C1F4
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 02:48:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236943AbiLNBsQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 20:48:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236937AbiLNBsP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 20:48:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F2291AF23;
        Tue, 13 Dec 2022 17:48:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 466F2B815FC;
        Wed, 14 Dec 2022 01:48:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81C2AC433D2;
        Wed, 14 Dec 2022 01:48:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670982491;
        bh=aUZevh1kIs5Dt8FUXbDMGDAUlWhmCSkHl9KCN/N7Pyw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZagSLMGjBaKb1yD3mkqbTmD6fruWqqwaMkU1GBBK1HSwgIAHaTuV+wDFiOohYlg/w
         k0PcM25F52TCY3qEdnnYCnCNVTgAFuJNhOsWsdp8jE/IguFiEE1kOUZvcLmWu55BQa
         sjMGWH6IDiiYPQSgALaxZMb1aIK7qMFgVvJj+w7jIYrhG9/u/TIQyQK3zd6F0Omca6
         6cQwx1ZCaSJE+OWmKHObaBO7M/PPt+PkJLsA0cKC3LfP16uQZIAm26Sgg83EHdempw
         r8XiFABPF2h5Y8XH8HloljYjhDaRGK8mKPVQ0sGRSfcNTkOhssh6dV3iAkCESAZhnh
         d9gNC5/RdOIxA==
Date:   Tue, 13 Dec 2022 17:48:10 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Seija K." <doremylover123@gmail.com>
Cc:     =?UTF-8?B?QmrDuHJu?= Mork <bjorn@mork.no>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: Fix for packets being rejected in the xHCI
 controller's ring buffer
Message-ID: <20221213174810.553b0196@kernel.org>
In-Reply-To: <CAA42iKxeinZ4gKfttg_K8PdRt+p-p=KjqgcbGjtxzOqn_C0F9g@mail.gmail.com>
References: <CAA42iKxeinZ4gKfttg_K8PdRt+p-p=KjqgcbGjtxzOqn_C0F9g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 13 Dec 2022 12:40:52 -0500 Seija K. wrote:
> Signed-off-by: Seija Kijin <doremylover123@gmail.com>

You need to update the Author / the From field as well as the sign-off.

> 

No empty lines between tags.

> Co-Authored-By: TarAldarion <gildeap@tcd.ie>

We need sign-offs for co-authors.

Please take the "must be your real legal name" requirement seriously,
we mean it.

> diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
> index 554d4e2a84a4..39db53a74b5a 100644
> --- a/drivers/net/usb/qmi_wwan.c
> +++ b/drivers/net/usb/qmi_wwan.c
> @@ -842,6 +842,13 @@ static int qmi_wwan_bind(struct usbnet *dev,
> struct usb_interface *intf)
> }
> dev->net->netdev_ops = &qmi_wwan_netdev_ops;
> dev->net->sysfs_groups[0] = &qmi_wwan_sysfs_attr_group;
> + /* LTE Networks don't always respect their own MTU on the receiving side;
> + * e.g. AT&T pushes 1430 MTU but still allows 1500 byte packets from
> + * far-end networks. Make the receive buffer large enough to accommodate
> + * them, and add four bytes so MTU does not equal MRU on network
> + * with 1500 MTU. Otherwise, usbnet_change_mtu() will change both.
> + */
> + dev->rx_urb_size = ETH_DATA_LEN + 4;
> err:
> return status;

The patch is still pooped, please try with git send-email.
