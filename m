Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC27D3FD013
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 01:59:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241895AbhIAAAR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 20:00:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:41604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241307AbhIAAAQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 31 Aug 2021 20:00:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B47966103D;
        Tue, 31 Aug 2021 23:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630454359;
        bh=9ocp7haGj8k4PDj/12c24dLq+PhVSfV2pRdQdMEQx1s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ntRqIB60d/6ffL26/b3ZDThdCBhAQc45bOrkVr0SOHEz0pf4r5tHP59bxTrv6fmtK
         tApMSZJEVZ0jngyVyanc8A37Hw/emGMd/g87EZLIvTjja3l1ze94tv4n2dESojaVgR
         FDmxkMZEEZBpq85+3UQCAvFIpqw51Y3DuuimTQxFyG0AIlJ19mE35Aetg9Sg8/lMxg
         T47kIl7iLQgb8pOT6Kof1FlHSkcvDvtbvUSf2DcOrdW4EjU/BzxRUaNupKPH14VCmu
         T5/o9M2HpkXMfBB7gCdyYQCduSB8mWdFjyZNGMKJ6Iu6E6K0Tl7x0V5zYapbDAe73Z
         0IHAAKNLZUODA==
Date:   Tue, 31 Aug 2021 16:59:18 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        edwin.peer@broadcom.com, gospo@broadcom.com
Subject: Re: [PATCH net-next] bnxt_en: Fix 64-bit doorbell operation on
 32-bit kernels
Message-ID: <20210831165918.30134828@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1630448925-6740-1-git-send-email-michael.chan@broadcom.com>
References: <1630448925-6740-1-git-send-email-michael.chan@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 31 Aug 2021 18:28:45 -0400 Michael Chan wrote:
> The driver requires 64-bit doorbell writes to be atomic on 32-bit
> architectures.  So we redefined writeq as a new macro with spinlock
> protection on 32-bit architectures.  This created a new warning when
> we added a new file in a recent patchset.  writeq is defined on many
> 32-bit architectures to do the memory write non-atomically and it
> generated a new macro redefined warning.  This warning was fixed
> incorrectly in the recent patch.
>=20
> Fix this properly by adding a new bnxt_writeq() function that will
> do the non-atomic write under spinlock on 32-bit systems.  All callers
> in the driver will now call bnxt_writeq() instead.
>=20
> Reported-by: kernel test robot <lkp@intel.com>
> Fixes: f9ff578251dc ("bnxt_en: introduce new firmware message API based o=
n DMA pools")
> Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
> Signed-off-by: Michael Chan <michael.chan@broadcom.com>

Lots of these:

drivers/net/ethernet/broadcom/bnxt/bnxt.h: In function =E2=80=98bnxt_writeq=
=E2=80=99:
drivers/net/ethernet/broadcom/bnxt/bnxt.h:2116:13: error: =E2=80=98bp=E2=80=
=99 undeclared (first use in this function); did you mean =E2=80=98up=E2=80=
=99?
 2116 |  spin_lock(&bp->db_lock);
      |             ^~
      |             up
