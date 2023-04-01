Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D5EC6D2EE2
	for <lists+netdev@lfdr.de>; Sat,  1 Apr 2023 09:31:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233452AbjDAHbY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Apr 2023 03:31:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233217AbjDAHbX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Apr 2023 03:31:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 038F3CA0B;
        Sat,  1 Apr 2023 00:31:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6D4BD60B18;
        Sat,  1 Apr 2023 07:31:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35FB3C433EF;
        Sat,  1 Apr 2023 07:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680334280;
        bh=yxotTr0zxaGom3LBZw261sC0CICDm5riK9vwoxtg8fI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YDZZkNj/ugAPkECw5o55NFCzhC1nKjEsKo6S66MmE4Nr/9kth8qcaifk2eruc6gDn
         VND7aobYaFwBgoNM5vYwWZD5bXsNa+cLOkPVcCEe7D/1CDjXYd5+k88r5+L9p6XUSb
         BBcSg49N5+ODSeDgGg+AfnkPaxWWLILASu7lU5RVzrQkPGjZRL2bp1O05vcini2+Xg
         IAez82XW369FhiRTKX1vIk54kTT1J/1ar2+R6cyjf17g8XiZqjLA1zfqD8sGKlsPzs
         pyb/6BqJLzdtwFPwUVyUC8k3dd9pWvOvMW+fO9sA/rAUXiaUG9MLoMef37W8mILuw5
         7/mok8SgrjMxQ==
Date:   Sat, 1 Apr 2023 09:31:16 +0200
From:   Simon Horman <horms@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH] net: ethernet: mtk_eth_soc: use be32 type to store be32
 values
Message-ID: <ZCfdxGS1Bj5LullK@kernel.org>
References: <20230401-mtk_eth_soc-sparse-v1-1-84e9fc7b8eab@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230401-mtk_eth_soc-sparse-v1-1-84e9fc7b8eab@kernel.org>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 01, 2023 at 08:43:44AM +0200, Simon Horman wrote:
> Perhaps there is a nicer way to handle this but the code
> calls for converting an array of host byte order 32bit values
> to big endian 32bit values: an ipv6 address to be pretty printed.
> 
> Use a sparse-friendly array of be32 to store these values.
> 
> Also make use of the cpu_to_be32_array helper rather
> than open coding the conversion.
> 
> Flagged by sparse:
>   drivers/net/ethernet/mediatek/mtk_ppe_debugfs.c:59:27: warning: incorrect type in assignment (different base types)
>   drivers/net/ethernet/mediatek/mtk_ppe_debugfs.c:59:27:    expected unsigned int
>   drivers/net/ethernet/mediatek/mtk_ppe_debugfs.c:59:27:    got restricted __be32 [usertype]
>   drivers/net/ethernet/mediatek/mtk_ppe_debugfs.c:161:46: warning: cast to restricted __be16
> 
> No functional changes intended.
> Compile tested only.
> 
> Signed-off-by: Simon Horman <horms@kernel.org>

Sorry, I forgot to tag this for net-next.
I can repost if needed, after an appropriate pause.
