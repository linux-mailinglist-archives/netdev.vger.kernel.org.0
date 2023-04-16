Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DEF26E36CC
	for <lists+netdev@lfdr.de>; Sun, 16 Apr 2023 11:53:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230372AbjDPJxd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Apr 2023 05:53:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230164AbjDPJxb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Apr 2023 05:53:31 -0400
Received: from sender3-op-o18.zoho.com (sender3-op-o18.zoho.com [136.143.184.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D894AE62;
        Sun, 16 Apr 2023 02:53:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1681638761; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=E0swol1jw29yr7sbkD56kf0SXwk+LNzYdYTwvIMMhagyxm0z6vxHQZoLvxwjAjISMrIEc7XWnhviPfJy7EZOZ3lVAowfmmjdTC27FwHtQFGqQGLUkCQXXFQK84B5Nl8iAQOvy0gU1MgfZa+pogwdHLx6GaZXpUjoxH18kREFcQk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1681638761; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=GCZjhm4Hbh1Xe4YSlI4A2hA8xi0IlyPYCkMgUVWDgKg=; 
        b=abx6MaJDAXNiOU77CW+9MuEOVWOjcOjjS5/G6GwxWQN161hmmK0YoEgZpSc8mASh5p3ken7rBFBGz9OYGYGnl+yUldoERi+r+S+/oW/eFtkSu7rvFbcMCcpTw7hBdZ7wicNTcIU0TvEYTDFtZh8vR1dzxHA2s03v+cTnkH9l3rA=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1681638761;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=GCZjhm4Hbh1Xe4YSlI4A2hA8xi0IlyPYCkMgUVWDgKg=;
        b=GMZ9Mi9oXvS+IUd1T5GR+csOJt5VeL93w9TXXeG4IGa1BF0s/Jb9eHL/irN5fYOY
        a3+qZQeGd89KFxbYrY74lLcGEAzxrwGy8A5tauSRwex33XtR2UunlWHUupWsz1zTMEu
        pEFdBN9lTQ5L9q2MJoxBbmKFMGgd45zDVXG4t+1E=
Received: from [10.10.10.3] (149.91.1.15 [149.91.1.15]) by mx.zohomail.com
        with SMTPS id 1681638759506996.2741470788767; Sun, 16 Apr 2023 02:52:39 -0700 (PDT)
Message-ID: <c657f6a2-74fa-2cc1-92cf-18f25464b1e1@arinc9.com>
Date:   Sun, 16 Apr 2023 12:52:31 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [RFC/RFT v1] net: ethernet: mtk_eth_soc: drop generic vlan rx
 offload, only use DSA untagging
Content-Language: en-US
To:     Frank Wunderlich <linux@fw-web.de>, Felix Fietkau <nbd@nbd.name>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Daniel Golle <daniel@makrotopia.org>
Cc:     John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Frank Wunderlich <frank-w@public-files.de>
References: <20230416091038.54479-1-linux@fw-web.de>
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <20230416091038.54479-1-linux@fw-web.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16.04.2023 12:10, Frank Wunderlich wrote:
> From: Felix Fietkau <nbd@nbd.name>
> 
> Through testing I found out that hardware vlan rx offload support seems to
> have some hardware issues. At least when using multiple MACs and when receiving
> tagged packets on the secondary MAC, the hardware can sometimes start to emit
> wrong tags on the first MAC as well.
> 
> In order to avoid such issues, drop the feature configuration and use the
> offload feature only for DSA hardware untagging on MT7621/MT7622 devices which
> only use one MAC.

MT7621 devices most certainly use both MACs.

> 
> Tested-by: Frank Wunderlich <frank-w@public-files.de>
> Signed-off-by: Felix Fietkau <nbd@nbd.name>
> Signed-off-by: Frank Wunderlich <frank-w@public-files.de>
> ---
> used felix Patch as base and ported up to 6.3-rc6 which seems to get lost
> and the original bug is not handled again.
> 
> it reverts changes from vladimirs patch
> 
> 1a3245fe0cf8 net: ethernet: mtk_eth_soc: fix DSA TX tag hwaccel for switch port 0

Do I understand correctly that this is considered being reverted because 
the feature it fixes is being removed?

Arınç
