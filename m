Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D9C553F1CA
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 23:35:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234963AbiFFVet (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 17:34:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234873AbiFFVes (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 17:34:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3D6C3A5EA;
        Mon,  6 Jun 2022 14:34:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6875D61578;
        Mon,  6 Jun 2022 21:34:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5056FC385A9;
        Mon,  6 Jun 2022 21:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654551282;
        bh=6JG6+yF2lDW6S0rq7jlRN1qWjalNKDxNI2CfJMOqPQg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RC8u6hgZ5f6YAmIaYM7jKvP4DiP2SdddwFAbl0XBw2wUxmqLhMqsGSGVWGrt/t360
         pPLH9+AowGysob5cAoW/+jQTv8H1J9kbRn+P4+jyUb7C0RnfL7sQYezoQIVfb0/LYn
         S6hvhJDejJ1eb1uXDQoV36ZTfXtA2klfdCIUmOkA5ahzZfXbWIhF9yTxgcVA5Nq9lX
         mAw5XlFPxfAymxDj1DJLbO3mch6hOhN54zg5CmkMm/jQKf6MRw73vnJZpecMwAS6UY
         RVDROK1XFI9DADHmo3HtxxDFvCBsKCNAXYczbm3mN8V9ZQaySK0Nq05vmV28coE89O
         u3/2CDUYA5f+Q==
Date:   Mon, 6 Jun 2022 14:34:37 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Chen Lin <chen45464546@163.com>
Cc:     nbd@nbd.name, alexander.duyck@gmail.com, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        matthias.bgg@gmail.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] net: ethernet: mtk_eth_soc: fix misuse of mem alloc
 interface netdev[napi]_alloc_frag
Message-ID: <20220606143437.25397f08@kernel.org>
In-Reply-To: <1654398757-2937-1-git-send-email-chen45464546@163.com>
References: <CAKgT0UdR-bdiZXsV_=8yJUS8zjoO6jeBS5bKNWAyxwLCiOP8ZQ@mail.gmail.com>
        <1654398757-2937-1-git-send-email-chen45464546@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun,  5 Jun 2022 11:12:37 +0800 Chen Lin wrote:
> +			new_data = (void *)__get_free_pages(GFP_ATOMIC |
> +			  __GFP_COMP | __GFP_NOWARN,
> +			  get_order(mtk_max_frag_size(MTK_MAX_LRO_RX_LENGTH)));

Please make this a helper which takes the gfp flags.
