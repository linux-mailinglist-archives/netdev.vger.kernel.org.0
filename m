Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47CE568D123
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 08:59:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229939AbjBGH7h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 02:59:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbjBGH7f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 02:59:35 -0500
Received: from www530.your-server.de (www530.your-server.de [188.40.30.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09E2329422;
        Mon,  6 Feb 2023 23:59:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=geanix.com;
        s=default2211; h=Content-Type:MIME-Version:Message-ID:In-Reply-To:Date:
        References:Subject:Cc:To:From:Sender:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID;
        bh=WzuEijZISPj2Ldzz9gW7mjhffoOK2kPC3Je2wdm7k3c=; b=LtArN22hWbjQzdCkphsLpS+jww
        e2g9vConSId3w+DfXsrsrJSapgtsuxgVtyDpFYheJXPZNdfNyw8h6ndIDZllAK1HwM6+rPGs/JSSi
        LmFPaR5jpY3jW3mUbb6FvU9B4rPKGTlaR9RCRfxp5t6QV2gDFqAuRE0ViwqeGb/WE70MXdY5M5gya
        aRYJLo1gW2Pqu05hDrClDZY4BORUERhtiDEbeKze5hnntE9XmnzD24lWCQQIfS7ELl1Q+Ajd4vO+b
        nM8beJPDXAWuRBosjd5QmsZQ31EEOvDeclmWZ0/tXCyVUOkLEbo7+M1EmDzr8HeXo5xV4pRzcr1BH
        Ffy8qzXQ==;
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www530.your-server.de with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <esben@geanix.com>)
        id 1pPIsw-000JTi-Mb; Tue, 07 Feb 2023 08:59:27 +0100
Received: from [80.62.117.80] (helo=localhost)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <esben@geanix.com>)
        id 1pPIsw-000LBP-GM; Tue, 07 Feb 2023 08:59:26 +0100
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
        Wang Qing <wangqing@vivo.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2 1/2] net: ll_temac: Fix DMA resources leak
References: <20230205201130.11303-1-jsc@umbraculum.org>
        <20230205201130.11303-2-jsc@umbraculum.org>
Date:   Tue, 07 Feb 2023 08:59:11 +0100
In-Reply-To: <20230205201130.11303-2-jsc@umbraculum.org> (Jonas Suhr
        Christensen's message of "Sun, 5 Feb 2023 21:11:27 +0100")
Message-ID: <87r0v1ucs0.fsf@geanix.com>
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

> Add missing conversion of address when unmapping dma region causing
> unmapping to silently fail. At some point resulting in buffer
> overrun eg. when releasing device.
>
> Fixes: fdd7454ecb29 ("net: ll_temac: Fix support for little-endian platforms")
>
> Signed-off-by: Jonas Suhr Christensen <jsc@umbraculum.org>

Acked-by: Esben Haabendal <esben@geanix.com>
