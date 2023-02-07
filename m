Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0370268D126
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 08:59:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230235AbjBGH7q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 02:59:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230450AbjBGH7n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 02:59:43 -0500
Received: from www530.your-server.de (www530.your-server.de [188.40.30.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB4943668A;
        Mon,  6 Feb 2023 23:59:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=geanix.com;
        s=default2211; h=Content-Type:MIME-Version:Message-ID:In-Reply-To:Date:
        References:Subject:Cc:To:From:Sender:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID;
        bh=4GbogwUJUNLBmDykXNdkmwEWnP5KjTXFxZP0GUjKGtg=; b=O5sXs3w/RTrQ6gu2hAJ2tytwWr
        gjpB5et7D6dumGyoWY/E/qGgqS5OCnWavvL+9C11pH6ZNyEtO88MAIxBmXLp5PhbcACMpETBtxGy/
        6i1kPdZzn//+KNrHvpa7gMvGkjsshhcwFmLAQp+LNQxdNUeYcC7DhpX7BGoRbFogHKUY0jsaYliBn
        22LQBzBo7/7nJMB7CCD9MexLTgTkYywVmxcTDR03+/MbmbWlZ/ij0M5Cyk6sBynZQbhHDfaWOmJ/i
        N7L106Vttalnn4WfaxKmX0LqIoBwz6Sia+bCHEgDtxrZ1FnI/N6DCvitJwDyH56/bAKv0syfUeXU5
        WDluRkBA==;
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www530.your-server.de with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <esben@geanix.com>)
        id 1pPItA-000JV3-IJ; Tue, 07 Feb 2023 08:59:41 +0100
Received: from [80.62.117.80] (helo=localhost)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <esben@geanix.com>)
        id 1pPItA-000MP3-FN; Tue, 07 Feb 2023 08:59:40 +0100
From:   esben@geanix.com
To:     Jonas Suhr Christensen <jsc@umbraculum.org>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Harini Katakam <harini.katakam@amd.com>,
        Haoyue Xu <xuhaoyue1@hisilicon.com>,
        huangjunxian <huangjunxian6@hisilicon.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Yang Yingliang <yangyingliang@huawei.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2 2/2] net: ll_temac: Reset buffer on
 dma_map_single() errors
References: <20230205201130.11303-1-jsc@umbraculum.org>
        <20230205201130.11303-3-jsc@umbraculum.org>
Date:   Tue, 07 Feb 2023 08:59:25 +0100
In-Reply-To: <20230205201130.11303-3-jsc@umbraculum.org> (Jonas Suhr
        Christensen's message of "Sun, 5 Feb 2023 21:11:28 +0100")
Message-ID: <87mt5pucrm.fsf@geanix.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Authenticated-Sender: esben@geanix.com
X-Virus-Scanned: Clear (ClamAV 0.103.7/26804/Mon Feb  6 09:47:07 2023)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jonas Suhr Christensen <jsc@umbraculum.org> writes:

> To avoid later calls to dma_unmap_single() on address'
> that fails to be mapped, free the allocated skb and
> set the pointer of the address to NULL. Eg. when a mapping
> fails temac_dma_bd_release() will try to call dma_unmap_single()
> on that address if the structure is not reset.
>
> Fixes: d07c849cd2b9 ("net: ll_temac: Add more error handling of dma_map_single() calls")
>
> Signed-off-by: Jonas Suhr Christensen <jsc@umbraculum.org>

Acked-by: Esben Haabendal <esben@geanix.com>
