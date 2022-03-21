Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 899734E335D
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 23:56:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbiCUWx1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 18:53:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230379AbiCUWxR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 18:53:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B25A3CCCD8;
        Mon, 21 Mar 2022 15:32:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0BC71B81A32;
        Mon, 21 Mar 2022 21:56:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54E19C340E8;
        Mon, 21 Mar 2022 21:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647899775;
        bh=jQ+FA2QjaDKzhT7JxN6gC825tKwyv5TqMAl0BFLjKjA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DDFKwQxYxHIeMq6DKjzK/gEjGx1Tm1BZZaD0iX+u9ECdwLmFTHHyzUeOEFJXFwEWc
         TpVJuMrbCtwkCyGZc1OFU5l0OzqiWP5aRUdAfaRL5kelTNMxX+pmobKVgTv5A5W/c3
         RXTSU+TFIkvqXOj399P6v0GK+fm7rnMN9UVcb9J/lTE8J1ZBnHUJUtZ9aKBkVPOFYt
         C7ocR/0Yc37BZfDzylTWKqTYZhHWmST/SbVr2GJ8pkzpcxAjg17zT9e8vprzShajud
         eGmilTRM3K1vNeBp7/tzIl1c5aCwUcrfxuISEQTBjYfc3e+8jc9Sxizs98HTE+Iyrm
         NGa6EZzlqmC5w==
Date:   Mon, 21 Mar 2022 14:56:13 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH net-next v2] net: remove noblock parameter from
 skb_recv_datagram()
Message-ID: <20220321145613.5ebd85ec@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220319094138.84637-1-socketcan@hartkopp.net>
References: <20220319094138.84637-1-socketcan@hartkopp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 19 Mar 2022 10:41:38 +0100 Oliver Hartkopp wrote:
> skb_recv_datagram() has two parameters 'flags' and 'noblock' that are
> merged inside skb_recv_datagram() by 'flags | (noblock ? MSG_DONTWAIT : 0=
)'
>=20
> As 'flags' may contain MSG_DONTWAIT as value most callers split the 'flag=
s'
> into 'flags' and 'noblock' with finally obsolete bit operations like this:
>=20
> skb_recv_datagram(sk, flags & ~MSG_DONTWAIT, flags & MSG_DONTWAIT, &rc);
>=20
> And this is not even done consistently with the 'flags' parameter.
>=20
> This patch removes the obsolete and costly splitting into two parameters
> and only performs bit operations when really needed on the caller side.
>=20
> One missing conversion thankfully reported by kernel test robot. I missed
> to enable kunit tests to build the mctp code.

net/vmw_vsock/vmci_transport.c: In function =E2=80=98vmci_transport_dgram_d=
equeue=E2=80=99:
net/vmw_vsock/vmci_transport.c:1735:13: warning: unused variable =E2=80=98n=
oblock=E2=80=99 [-Wunused-variable]
 1735 |         int noblock;
      |             ^~~~~~~
