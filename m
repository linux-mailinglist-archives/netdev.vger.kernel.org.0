Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBC9E2A76CE
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 06:09:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731604AbgKEFIz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 00:08:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:45866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728323AbgKEFIz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Nov 2020 00:08:55 -0500
Received: from lt-jalone-7480.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0ED2C2151B;
        Thu,  5 Nov 2020 05:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604552934;
        bh=2fDf/4eOcS58i6OdJt85sYJPX6k0y8XIJFYjfdPR8Dk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=X9venhU5bS4LAN52ohfpWH+eg9B0sV/lN4xuHJgmfxDpV5fjT1u6J0Oj4caT2aPga
         n776QFyTpqhbWm1zgn+PjHVGcxuhV9YDKtyexjWcjJUqcS7VYs2B3XX9fW/gXWTx3f
         DLG6x06AyW+Tf/SxgbtfIXKk7QHsAwiZNCWmosSE=
Message-ID: <1627a52089f421c8594c9a99fd9137caa6485572.camel@kernel.org>
Subject: Re: [PATCH v2 net-next 3/3] octeontx2-af: Add devlink health
 reporters for NIX
From:   Saeed Mahameed <saeed@kernel.org>
To:     George Cherian <george.cherian@marvell.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Pirko <jiri@nvidia.com>
Cc:     kuba@kernel.org, davem@davemloft.net, sgoutham@marvell.com,
        lcherian@marvell.com, gakula@marvell.com, masahiroy@kernel.org,
        willemdebruijn.kernel@gmail.com
Date:   Wed, 04 Nov 2020 21:08:52 -0800
In-Reply-To: <20201104122755.753241-4-george.cherian@marvell.com>
References: <20201104122755.753241-1-george.cherian@marvell.com>
         <20201104122755.753241-4-george.cherian@marvell.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-11-04 at 17:57 +0530, George Cherian wrote:
> Add health reporters for RVU NPA block.
                               ^^^ NIX ?

Cc: Jiri 

Anyway, could you please spare some words on what is NPA and what is
NIX?

Regarding the reporters names, all drivers register well known generic
names such as (fw,hw,rx,tx), I don't know if it is a good idea to use
vendor specific names, if you are reporting for hw/fw units then just
use "hw" or "fw" as the reporter name and append the unit NPA/NIX to
the counter/error names.

> Only reporter dump is supported.
> 
> Output:
>  # ./devlink health
>  pci/0002:01:00.0:
>    reporter npa
>      state healthy error 0 recover 0
>    reporter nix
>      state healthy error 0 recover 0
>  # ./devlink  health dump show pci/0002:01:00.0 reporter nix
>   NIX_AF_GENERAL:
>          Memory Fault on NIX_AQ_INST_S read: 0
>          Memory Fault on NIX_AQ_RES_S write: 0
>          AQ Doorbell error: 0
>          Rx on unmapped PF_FUNC: 0
>          Rx multicast replication error: 0
>          Memory fault on NIX_RX_MCE_S read: 0
>          Memory fault on multicast WQE read: 0
>          Memory fault on mirror WQE read: 0
>          Memory fault on mirror pkt write: 0
>          Memory fault on multicast pkt write: 0
>    NIX_AF_RAS:
>          Poisoned data on NIX_AQ_INST_S read: 0
>          Poisoned data on NIX_AQ_RES_S write: 0
>          Poisoned data on HW context read: 0
>          Poisoned data on packet read from mirror buffer: 0
>          Poisoned data on packet read from mcast buffer: 0
>          Poisoned data on WQE read from mirror buffer: 0
>          Poisoned data on WQE read from multicast buffer: 0
>          Poisoned data on NIX_RX_MCE_S read: 0
>    NIX_AF_RVU:
>          Unmap Slot Error: 0
> 

Now i am a little bit skeptic here, devlink health reporter
infrastructure was never meant to deal with dump op only, the main
purpose is to diagnose/dump and recover.

especially in your use case where you only report counters, i don't
believe devlink health dump is a proper interface for this.
Many of these counters if not most are data path packet based and maybe
they should belong to ethtool.

