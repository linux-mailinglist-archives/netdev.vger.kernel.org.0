Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FFF34870D1
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 04:00:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345487AbiAGDAf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 22:00:35 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:51084 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344704AbiAGDAe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 22:00:34 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F2C7661EC7
        for <netdev@vger.kernel.org>; Fri,  7 Jan 2022 03:00:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B611CC36AE5;
        Fri,  7 Jan 2022 03:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641524428;
        bh=+JnDB9sZUso93AKfJ60qtlt2za0iXqKcPZFMhl61fI4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=acq3/q4JkKSAXtWBA30EAVQbX3hbg7uc8qBqYa4cJfDXDF3qpm3dLDdINQvvT4m5i
         9AslCgxrxuZdoIXQAM9/jyrtxVZtxdnntPnmwCGYx8gxo0E+ehj7ii8xF4QXVprBtq
         qL725DRGxkvqKOuFME6ggvR+dJNIUjrinbw7b7OFZLv64gvoewVYyc9rQ+QJFM5V+c
         mokIycMB3wEHm9WXEIGp/y/0KfG0ms3V/1MNOO+2Ze3ZLMJPVH4V9WnOMXEEb1Ix2c
         jcaL8kKxgbD+RnXOiHQlBysBt6a19Vzi+e3JKiGsNo63Bq70hra56Iv8K0NXGuVyx+
         qICz+hinAWrDw==
Date:   Thu, 6 Jan 2022 19:00:26 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Arthur Kiyanovski <akiyano@amazon.com>
Cc:     David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>,
        "Woodhouse, David" <dwmw@amazon.com>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        Saeed Bshara <saeedb@amazon.com>,
        "Wilson, Matt" <msw@amazon.com>,
        "Liguori, Anthony" <aliguori@amazon.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>,
        "Dagan, Noam" <ndagan@amazon.com>,
        "Agroskin, Shay" <shayagr@amazon.com>,
        "Arinzon, David" <darinzon@amazon.com>,
        Nati Koler <nkoler@amazon.com>
Subject: Re: [PATCH V1 net-next 10/10] net: ena: Extract recurring driver
 reset code into a function
Message-ID: <20220106190026.7b98d791@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220106192915.22616-11-akiyano@amazon.com>
References: <20220106192915.22616-1-akiyano@amazon.com>
        <20220106192915.22616-11-akiyano@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 6 Jan 2022 19:29:15 +0000 Arthur Kiyanovski wrote:
> Create an inline function for resetting the driver
> to reduce code duplication.

> +static inline void ena_reset_device(struct ena_adapter *adapter, enum en=
a_flags_t reset_reason)

Looks like you picked the wrong type because new W=3D1 warnings abound:

In file included from ../drivers/net/ethernet/amazon/ena/ena_netdev.c:21:
../drivers/net/ethernet/amazon/ena/ena_netdev.h: In function =E2=80=98ena_r=
eset_device=E2=80=99:
../drivers/net/ethernet/amazon/ena/ena_netdev.h:399:31: warning: implicit c=
onversion from =E2=80=98enum ena_flags_t=E2=80=99 to =E2=80=98enum ena_regs=
_reset_reason_types=E2=80=99 [-Wenum-conversion]
  399 |         adapter->reset_reason =3D reset_reason;
      |                               ^
../drivers/net/ethernet/amazon/ena/ena_netdev.c: In function =E2=80=98ena_t=
x_timeout=E2=80=99:
../drivers/net/ethernet/amazon/ena/ena_netdev.c:106:35: warning: implicit c=
onversion from =E2=80=98enum ena_regs_reset_reason_types=E2=80=99 to =E2=80=
=98enum ena_flags_t=E2=80=99 [-Wenum-conversion]
  106 |         ena_reset_device(adapter, ENA_REGS_RESET_OS_NETDEV_WD);
      |                                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~
../drivers/net/ethernet/amazon/ena/ena_netdev.c: In function =E2=80=98ena_x=
mit_common=E2=80=99:
../drivers/net/ethernet/amazon/ena/ena_netdev.c:171:42: warning: implicit c=
onversion from =E2=80=98enum ena_regs_reset_reason_types=E2=80=99 to =E2=80=
=98enum ena_flags_t=E2=80=99 [-Wenum-conversion]
  171 |                                          ENA_REGS_RESET_DRIVER_INVA=
LID_STATE);
      |                                          ^~~~~~~~~~~~~~~~~~~~~~~~~~=
~~~~~~~~~
../drivers/net/ethernet/amazon/ena/ena_netdev.c: In function =E2=80=98handl=
e_invalid_req_id=E2=80=99:
../drivers/net/ethernet/amazon/ena/ena_netdev.c:1280:41: warning: implicit =
conversion from =E2=80=98enum ena_regs_reset_reason_types=E2=80=99 to =E2=
=80=98enum ena_flags_t=E2=80=99 [-Wenum-conversion]
 1280 |         ena_reset_device(ring->adapter, ENA_REGS_RESET_INV_TX_REQ_I=
D);
      |                                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
../drivers/net/ethernet/amazon/ena/ena_netdev.c: In function =E2=80=98ena_r=
x_skb=E2=80=99:
../drivers/net/ethernet/amazon/ena/ena_netdev.c:1444:43: warning: implicit =
conversion from =E2=80=98enum ena_regs_reset_reason_types=E2=80=99 to =E2=
=80=98enum ena_flags_t=E2=80=99 [-Wenum-conversion]
 1444 |                 ena_reset_device(adapter, ENA_REGS_RESET_INV_RX_REQ=
_ID);
      |                                           ^~~~~~~~~~~~~~~~~~~~~~~~~=
~~~
../drivers/net/ethernet/amazon/ena/ena_netdev.c: In function =E2=80=98ena_c=
lean_rx_irq=E2=80=99:
../drivers/net/ethernet/amazon/ena/ena_netdev.c:1777:43: warning: implicit =
conversion from =E2=80=98enum ena_regs_reset_reason_types=E2=80=99 to =E2=
=80=98enum ena_flags_t=E2=80=99 [-Wenum-conversion]
 1777 |                 ena_reset_device(adapter, ENA_REGS_RESET_TOO_MANY_R=
X_DESCS);
      |                                           ^~~~~~~~~~~~~~~~~~~~~~~~~=
~~~~~~~
../drivers/net/ethernet/amazon/ena/ena_netdev.c:1781:43: warning: implicit =
conversion from =E2=80=98enum ena_regs_reset_reason_types=E2=80=99 to =E2=
=80=98enum ena_flags_t=E2=80=99 [-Wenum-conversion]
 1781 |                 ena_reset_device(adapter, ENA_REGS_RESET_INV_RX_REQ=
_ID);
      |                                           ^~~~~~~~~~~~~~~~~~~~~~~~~=
~~~
../drivers/net/ethernet/amazon/ena/ena_netdev.c: In function =E2=80=98check=
_for_rx_interrupt_queue=E2=80=99:
../drivers/net/ethernet/amazon/ena/ena_netdev.c:3701:43: warning: implicit =
conversion from =E2=80=98enum ena_regs_reset_reason_types=E2=80=99 to =E2=
=80=98enum ena_flags_t=E2=80=99 [-Wenum-conversion]
 3701 |                 ena_reset_device(adapter, ENA_REGS_RESET_MISS_INTER=
RUPT);
      |                                           ^~~~~~~~~~~~~~~~~~~~~~~~~=
~~~~
../drivers/net/ethernet/amazon/ena/ena_netdev.c: In function =E2=80=98check=
_missing_comp_in_tx_queue=E2=80=99:
../drivers/net/ethernet/amazon/ena/ena_netdev.c:3738:51: warning: implicit =
conversion from =E2=80=98enum ena_regs_reset_reason_types=E2=80=99 to =E2=
=80=98enum ena_flags_t=E2=80=99 [-Wenum-conversion]
 3738 |                         ena_reset_device(adapter, ENA_REGS_RESET_MI=
SS_INTERRUPT);
      |                                                   ^~~~~~~~~~~~~~~~~=
~~~~~~~~~~~~
../drivers/net/ethernet/amazon/ena/ena_netdev.c:3764:43: warning: implicit =
conversion from =E2=80=98enum ena_regs_reset_reason_types=E2=80=99 to =E2=
=80=98enum ena_flags_t=E2=80=99 [-Wenum-conversion]
 3764 |                 ena_reset_device(adapter, ENA_REGS_RESET_MISS_TX_CM=
PL);
      |                                           ^~~~~~~~~~~~~~~~~~~~~~~~~=
~~
../drivers/net/ethernet/amazon/ena/ena_netdev.c: In function =E2=80=98check=
_for_missing_keep_alive=E2=80=99:
../drivers/net/ethernet/amazon/ena/ena_netdev.c:3885:43: warning: implicit =
conversion from =E2=80=98enum ena_regs_reset_reason_types=E2=80=99 to =E2=
=80=98enum ena_flags_t=E2=80=99 [-Wenum-conversion]
 3885 |                 ena_reset_device(adapter, ENA_REGS_RESET_KEEP_ALIVE=
_TO);
      |                                           ^~~~~~~~~~~~~~~~~~~~~~~~~=
~~~
../drivers/net/ethernet/amazon/ena/ena_netdev.c: In function =E2=80=98check=
_for_admin_com_state=E2=80=99:
../drivers/net/ethernet/amazon/ena/ena_netdev.c:3896:43: warning: implicit =
conversion from =E2=80=98enum ena_regs_reset_reason_types=E2=80=99 to =E2=
=80=98enum ena_flags_t=E2=80=99 [-Wenum-conversion]
 3896 |                 ena_reset_device(adapter, ENA_REGS_RESET_ADMIN_TO);
      |                                           ^~~~~~~~~~~~~~~~~~~~~~~
In file included from ../drivers/net/ethernet/amazon/ena/ena_ethtool.c:9:
../drivers/net/ethernet/amazon/ena/ena_netdev.h: In function =E2=80=98ena_r=
eset_device=E2=80=99:
../drivers/net/ethernet/amazon/ena/ena_netdev.h:399:31: warning: implicit c=
onversion from =E2=80=98enum ena_flags_t=E2=80=99 to =E2=80=98enum ena_regs=
_reset_reason_types=E2=80=99 [-Wenum-conversion]
  399 |         adapter->reset_reason =3D reset_reason;
      |                               ^
../drivers/net/ethernet/amazon/ena/ena_netdev.c: note: in included file:
../drivers/net/ethernet/amazon/ena/ena_netdev.h:399:33: warning: mixing dif=
ferent enum types:
../drivers/net/ethernet/amazon/ena/ena_netdev.h:399:33:    unsigned int enu=
m ena_flags_t
../drivers/net/ethernet/amazon/ena/ena_netdev.h:399:33:    unsigned int enu=
m ena_regs_reset_reason_types
../drivers/net/ethernet/amazon/ena/ena_netdev.h:399:33: warning: mixing dif=
ferent enum types:
../drivers/net/ethernet/amazon/ena/ena_netdev.h:399:33:    unsigned int enu=
m ena_flags_t
../drivers/net/ethernet/amazon/ena/ena_netdev.h:399:33:    unsigned int enu=
m ena_regs_reset_reason_types
../drivers/net/ethernet/amazon/ena/ena_netdev.h:399:33: warning: mixing dif=
ferent enum types:
../drivers/net/ethernet/amazon/ena/ena_netdev.h:399:33:    unsigned int enu=
m ena_flags_t
../drivers/net/ethernet/amazon/ena/ena_netdev.h:399:33:    unsigned int enu=
m ena_regs_reset_reason_types
../drivers/net/ethernet/amazon/ena/ena_netdev.h:399:33: warning: mixing dif=
ferent enum types:
../drivers/net/ethernet/amazon/ena/ena_netdev.h:399:33:    unsigned int enu=
m ena_flags_t
../drivers/net/ethernet/amazon/ena/ena_netdev.h:399:33:    unsigned int enu=
m ena_regs_reset_reason_types
../drivers/net/ethernet/amazon/ena/ena_netdev.h:399:33: warning: mixing dif=
ferent enum types:
../drivers/net/ethernet/amazon/ena/ena_netdev.h:399:33:    unsigned int enu=
m ena_flags_t
../drivers/net/ethernet/amazon/ena/ena_netdev.h:399:33:    unsigned int enu=
m ena_regs_reset_reason_types
../drivers/net/ethernet/amazon/ena/ena_netdev.h:399:33: warning: mixing dif=
ferent enum types:
../drivers/net/ethernet/amazon/ena/ena_netdev.h:399:33:    unsigned int enu=
m ena_flags_t
../drivers/net/ethernet/amazon/ena/ena_netdev.h:399:33:    unsigned int enu=
m ena_regs_reset_reason_types
../drivers/net/ethernet/amazon/ena/ena_netdev.h:399:33: warning: mixing dif=
ferent enum types:
../drivers/net/ethernet/amazon/ena/ena_netdev.h:399:33:    unsigned int enu=
m ena_flags_t
../drivers/net/ethernet/amazon/ena/ena_netdev.h:399:33:    unsigned int enu=
m ena_regs_reset_reason_types
../drivers/net/ethernet/amazon/ena/ena_netdev.h:399:33: warning: mixing dif=
ferent enum types:
../drivers/net/ethernet/amazon/ena/ena_netdev.h:399:33:    unsigned int enu=
m ena_flags_t
../drivers/net/ethernet/amazon/ena/ena_netdev.h:399:33:    unsigned int enu=
m ena_regs_reset_reason_types
../drivers/net/ethernet/amazon/ena/ena_netdev.h:399:33: warning: mixing dif=
ferent enum types:
../drivers/net/ethernet/amazon/ena/ena_netdev.h:399:33:    unsigned int enu=
m ena_flags_t
../drivers/net/ethernet/amazon/ena/ena_netdev.h:399:33:    unsigned int enu=
m ena_regs_reset_reason_types
../drivers/net/ethernet/amazon/ena/ena_netdev.h:399:33: warning: mixing dif=
ferent enum types:
../drivers/net/ethernet/amazon/ena/ena_netdev.h:399:33:    unsigned int enu=
m ena_flags_t
../drivers/net/ethernet/amazon/ena/ena_netdev.h:399:33:    unsigned int enu=
m ena_regs_reset_reason_types
../drivers/net/ethernet/amazon/ena/ena_netdev.h:399:33: warning: mixing dif=
ferent enum types:
../drivers/net/ethernet/amazon/ena/ena_netdev.h:399:33:    unsigned int enu=
m ena_flags_t
../drivers/net/ethernet/amazon/ena/ena_netdev.h:399:33:    unsigned int enu=
m ena_regs_reset_reason_types


While you're fixing things it'd also be cool to address the existing
clang warning:

drivers/net/ethernet/amazon/ena/ena_netdev.c:1892:6: warning: variable 'tx_=
bytes' set but not used [-Wunused-but-set-variable]
        u32 tx_bytes =3D 0;
            ^
