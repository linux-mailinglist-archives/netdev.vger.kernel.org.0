Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B37B7368086
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 14:33:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236121AbhDVMeS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 08:34:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230510AbhDVMeS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 08:34:18 -0400
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A36A1C06174A;
        Thu, 22 Apr 2021 05:33:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:To:Subject:Sender:Reply-To:Cc:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=B7Q4T6dJAsdsQ+Ix5yA7JOmBt+U9csvMzUwRnH4jDQU=; b=og3af5XO5faTW0xLx1tDv9FdVv
        7pDXIJug5QDv2LZlIJDJU2Yn3RvRtsrsMqcA61T8C+Ra849DZN3EAJurepVm7qpPRR5EcMB/HxIMf
        6J+2uOyl3Bys4hgd1nldqZg9u64987ep5WQmqZlhP28vlNodwXutRz10l3RuNQTDZnSo=;
Received: from p4ff13bc6.dip0.t-ipconnect.de ([79.241.59.198] helo=nf.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1lZYWS-0004UX-1s; Thu, 22 Apr 2021 14:33:32 +0200
Subject: Re: [PATCH net-next 05/14] net: ethernet: mtk_eth_soc: reduce MDIO
 bus access latency
To:     Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
References: <20210422040914.47788-1-ilya.lipnitskiy@gmail.com>
 <20210422040914.47788-6-ilya.lipnitskiy@gmail.com>
From:   Felix Fietkau <nbd@nbd.name>
Message-ID: <d96206db-96e2-1eb7-6b19-47c9596ccfea@nbd.name>
Date:   Thu, 22 Apr 2021 14:33:31 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210422040914.47788-6-ilya.lipnitskiy@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021-04-22 06:09, Ilya Lipnitskiy wrote:
> From: Felix Fietkau <nbd@nbd.name>
> 
> usleep_range often ends up sleeping much longer than the 10-20us provided
> as a range here. This causes significant latency in mdio bus acceses,
> which easily adds multiple seconds to the boot time on MT7621 when polling
> DSA slave ports.
> 
> Use udelay via readx_poll_timeout_atomic, since the MDIO access does not
> take much time
> 
> Signed-off-by: Felix Fietkau <nbd@nbd.name>
> [Ilya: use readx_poll_timeout_atomic instead of cond_resched]
I still prefer the cond_resched() variant. On a fully loaded system, I'd
prefer to let the MDIO access take longer instead of wasting cycles on
udelay.

- Felix
