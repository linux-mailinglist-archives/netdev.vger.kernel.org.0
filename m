Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5FBC6E2E7E
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 04:06:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229924AbjDOCGN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 22:06:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbjDOCGM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 22:06:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D3874C39;
        Fri, 14 Apr 2023 19:06:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BB32D61719;
        Sat, 15 Apr 2023 02:06:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 483C6C433EF;
        Sat, 15 Apr 2023 02:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681524370;
        bh=F+qtdLH0oZFhkge6AY0Ykqz4k4fj38qMbGDX2XmCiZM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uaKoP85D6NkHWUhxRs2zayNwV8H66vAumDv9vsno1kIOc83s7lNVbfb4XOetEPRKw
         XW8jA2yt+qte3GmQNnFUsFo3bCpwTEZ8T4p70JFgtA1wsLqIe7qmDr42XYrxfJybI7
         FpWyqeES78iN7SypOX7BYickjse98mM+9aH5FX66UTz11bVYmHWXr3/NfYluB+ABCs
         GqOXALZdBLSqNeRp5vRpM3ODbnd6Lsy0mcZ0qHCGEgiqKjuks5tZgc2+nBcCs5nvyy
         PFcE8N7pR2c7PIoZXk2CS7EDSnlfACbOJ1U76jbZ+0sn0E+zjLHsM5co8kDokRzaOE
         DWSv5hrY306WQ==
Date:   Fri, 14 Apr 2023 19:06:08 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Haiyang Zhang <haiyangz@microsoft.com>
Cc:     linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        decui@microsoft.com, kys@microsoft.com, paulros@microsoft.com,
        olaf@aepfle.de, vkuznets@redhat.com, davem@davemloft.net,
        wei.liu@kernel.org, edumazet@google.com, pabeni@redhat.com,
        leon@kernel.org, longli@microsoft.com, ssengar@linux.microsoft.com,
        linux-rdma@vger.kernel.org, daniel@iogearbox.net,
        john.fastabend@gmail.com, bpf@vger.kernel.org, ast@kernel.org,
        sharmaajay@microsoft.com, hawk@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3,net-next, 3/4] net: mana: Enable RX path to handle
 various MTU sizes
Message-ID: <20230414190608.3c21f44f@kernel.org>
In-Reply-To: <1681334163-31084-4-git-send-email-haiyangz@microsoft.com>
References: <1681334163-31084-1-git-send-email-haiyangz@microsoft.com>
        <1681334163-31084-4-git-send-email-haiyangz@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 12 Apr 2023 14:16:02 -0700 Haiyang Zhang wrote:
> +	} else if (rxq->alloc_size > PAGE_SIZE) {
> +		if (is_napi)
> +			va = napi_alloc_frag(rxq->alloc_size);

Allocating frag larger than a page is not safe.
Frag allocator falls back to allocating single pages, doesn't it?
