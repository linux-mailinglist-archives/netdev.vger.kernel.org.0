Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E379853C351
	for <lists+netdev@lfdr.de>; Fri,  3 Jun 2022 04:46:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237047AbiFCCq3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 22:46:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbiFCCq2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 22:46:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76F0733375;
        Thu,  2 Jun 2022 19:46:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 21D42B82155;
        Fri,  3 Jun 2022 02:46:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7517EC385A5;
        Fri,  3 Jun 2022 02:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654224383;
        bh=uxZ53R3ThWE3FSFIh9D1ha7bSA75C1JjHKEUkquN/9Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IAgJSZ0A3zKUuOxFbkQYGjaNt+dv6aplR2WymS08Fj9kT2PAFST/PiaXke5d5Rg7k
         POIIB6tZwDwa9xSC1/bVxD4HYFQA0Tly29TyV2CL0PHRHRArTKN7I+NkgHf21+eNf9
         ydC4EghpdIJZAcVrBgq2qVt+j3TSz4ghlyIqa5wL1/knGXjhb5KKLWn7ez9w2yJitR
         g5y2ZlUE4Mcl0diZnyxKfQTGjrmWd3p12dHAmHiM7kb9e/9SqQrCSR/Llo9N5kXbt/
         PQ1IVVVJMmo7P7XrVAnuLVE3VnprYtkypTo4B9pUS0cog3dZNMYTgcJPUNsO4HEbjg
         QKVwTLPu+GJog==
Date:   Thu, 2 Jun 2022 19:46:22 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kaarel =?UTF-8?B?UMOkcnRlbA==?= <kaarelp2rtel@gmail.com>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: add operstate for vcan and dummy
Message-ID: <20220602194622.0c54a256@kernel.org>
In-Reply-To: <20220602081929.21929-1-kaarelp2rtel@gmail.com>
References: <20220602081929.21929-1-kaarelp2rtel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  2 Jun 2022 11:19:29 +0300 Kaarel P=C3=A4rtel wrote:
> The idea here is simple. The vcan and the dummy network devices
> currently do not set the operational state of the interface.
> The result is that the interface state will be UNKNOWN.
>=20
> The kernel considers the unknown state to be the same as up:
> https://elixir.bootlin.com/linux/latest/source/include/linux/netdevice.h#=
L4125
>=20
> However for users this creates confusion:
> https://serverfault.com/questions/629676/dummy-network-interface-in-linux
>=20
> The change in this patch is very simple. When the interface is set up, the
> operational state is set to IF_OPER_UP.
>=20
> Signed-off-by: Kaarel P=C3=A4rtel <kaarelp2rtel@gmail.com>

You can change the carrier state from user space on a dummy device,
that will inform the kernel of the operstate:

# ip link add type dummy
# ip link show dev dummy0
8: dummy0: <BROADCAST,NOARP> mtu 1500 qdisc noop state DOWN mode DEFAULT gr=
oup default qlen 1000
    link/ether 8e:35:15:22:e3:d7 brd ff:ff:ff:ff:ff:ff
# ip link set dev dummy0 up
# ip link show dev dummy0
8: dummy0: <BROADCAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc noqueue state UNKNO=
WN mode DEFAULT group default qlen 1000
    link/ether 8e:35:15:22:e3:d7 brd ff:ff:ff:ff:ff:ff
# ip link set dev dummy0 carrier off
# ip link set dev dummy0 carrier on
# ip link show dev dummy0
8: dummy0: <BROADCAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP mo=
de DEFAULT group default qlen 1000
    link/ether 8e:35:15:22:e3:d7 brd ff:ff:ff:ff:ff:ff


Flipping all soft devices which don't have a lower or don't expect user
space management to UP is fine but doing it one by one feels icky.
Yet another random thing a driver author has to know to flip.

If people are confused about seeing UNKNOWN in ip link output maybe we
should move displaying that under the -d flag (detailed output)?
Saves space, and nobody will get confused.
