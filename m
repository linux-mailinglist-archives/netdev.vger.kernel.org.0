Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9BD36266D7
	for <lists+netdev@lfdr.de>; Sat, 12 Nov 2022 05:05:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234245AbiKLEFj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 23:05:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234017AbiKLEFg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 23:05:36 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04340532D0;
        Fri, 11 Nov 2022 20:05:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A9BBDCE1884;
        Sat, 12 Nov 2022 04:05:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B837C433C1;
        Sat, 12 Nov 2022 04:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668225929;
        bh=nfkO2oakwXbsXV+Bx9tVN0tDdiORcPa8UJoKUe4po1o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XHngi1vXRn1yXKYcAWqqEHGNPWpF9/2uxfjNIoSQQ0AWIHZFAVEauX9LLAf13ppwe
         Hu1pxqHtFPgQc/FBeSf1Lve30eKZNI+AnWXZNvVh6sgsq+L4kZ7IwK7R8DC3xi/uDn
         GrzLQ31zwVMKp9Cgafv6C0aIuwejtkROhV8VYDoEOheacgglXCm3ydNGeqwJmgqJxq
         rs2NqegdMUvC569Ubtdth0Wte12yOuZwybbghLuDZM/8RuB6kapQTY8dEbfVIJD18A
         xoj6oaDPL7z7gnoiyXhbUiKEJ91Ki0vwmTXxIwF9beH3Ms/DZIsaaHmqB0KsIbNYz9
         bKM8jLEMK8gKg==
Date:   Fri, 11 Nov 2022 20:05:28 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Noor Azura Ahmad Tarmizi 
        <noor.azura.ahmad.tarmizi@linux.intel.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, Song Yoong Siang <yoong.siang.song@intel.com>,
        Mohd Faizal Abdul Rahim <faizal.abdul.rahim@intel.com>
Subject: Re: [PATCH net 1/1] net: stmmac: ensure tx function is not running
 in stmmac_xdp_release()
Message-ID: <20221111200528.1ca0aa29@kernel.org>
In-Reply-To: <20221110064552.22504-1-noor.azura.ahmad.tarmizi@linux.intel.com>
References: <20221110064552.22504-1-noor.azura.ahmad.tarmizi@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Nov 2022 14:45:52 +0800 Noor Azura Ahmad Tarmizi wrote:
> When stmmac_xdp_release() is called, there is a possibility that tx
> function is still running on other queues which will lead to tx queue
> timed out and reset adapter.
> 
> This commit ensure that tx function is not running xdp before release
> flow continue to run.

Do we still need that netif_trans_update() later in the function?
That looks odd.
