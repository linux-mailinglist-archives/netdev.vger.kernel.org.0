Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D12D6875A1
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 07:01:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbjBBGBJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 01:01:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbjBBGBI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 01:01:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2FF75CD2F;
        Wed,  1 Feb 2023 22:01:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8CF476154E;
        Thu,  2 Feb 2023 06:01:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6835FC433EF;
        Thu,  2 Feb 2023 06:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675317666;
        bh=W4PCtIoPHqMjZz87oYbuJcDIyOhDoAR6qCTIFYNoCP8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ujaa4ZyEv+z27/qk/4xB2YOOGBHiI10vZVEy7EzL/lWS4ArFvq+mNFcQOhYL+RKbv
         1IaHCiU2Kb7MQHWBsZ0AF06BXZ+bsvxDhihMesKtOwfal2SZMYlkMMGJLLUZ9MZv04
         1S/Cocy5n1a2JNceS2gBbCjZTxh37ico9qy2AKlMixZdnC8Zx2HU3YVFvWik7sg1XG
         bL2wOhKGK/WeIXqHjO5/Q/i7ROuDKMZx9JtqNwv3TOUPW0QsXMba1lTfFHxSVaLDEU
         qXJQq/0xgMyWGbtR9WEvGtULZxLvPehnKKY22z6OcBxBsQTMe6J5GKdyOvoIn5ltRL
         L7vKMRw46dS0g==
Date:   Wed, 1 Feb 2023 22:01:05 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Qingfang DENG <dqfext@gmail.com>
Cc:     Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: page_pool: use in_softirq() instead
Message-ID: <20230201220105.410fee4c@kernel.org>
In-Reply-To: <20230202024417.4477-1-dqfext@gmail.com>
References: <20230202024417.4477-1-dqfext@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  2 Feb 2023 10:44:17 +0800 Qingfang DENG wrote:
> From: Qingfang DENG <qingfang.deng@siflower.com.cn>
> 
> We use BH context only for synchronization, so we don't care if it's
> actually serving softirq or not.
> 
> As a side node, in case of threaded NAPI, in_serving_softirq() will
> return false because it's in process context with BH off, making
> page_pool_recycle_in_cache() unreachable.

LGTM, but I don't think this qualifies as a fix.
It's just a missed optimization, right?
