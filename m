Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBD10575A7B
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 06:30:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229633AbiGOEab (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 00:30:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbiGOEaa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 00:30:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1C6374E09;
        Thu, 14 Jul 2022 21:30:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7881362209;
        Fri, 15 Jul 2022 04:30:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C8E2C3411E;
        Fri, 15 Jul 2022 04:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657859427;
        bh=NUqr07YYbf2xTl8Cx5qpLhNa/Ok/u5g65JGXxPghIa0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=syI8i2MSFGwqUj0EV8QyYIE1kfQUVF5R6ybvnxGhSMFyrNLVGn9XKLoK5NpReeCjX
         4jG5iQQy00V0sne6c2LZEd/+sZhICS86zAZ+vG8pGWaVQx1SA0ZoSaB0h2S5itSz1c
         X1K/70acD0MxzqBU/LNyvmt7LVCt2r5CgEDLPGlSNHpv1iRbwVWwahTcZz52xUSDKe
         dQOFHyILw5ZkoTCPu1oNlEYUQiC9yqNgKFjFJVyv61wZ4joGuUdmhKrg1fLcg2kAtv
         e+Zb63sTZd8PyvvRnGfI+QOD4Uhy9NMRO3AHRfvOphTRXF4bRcOC3vK2gwcXhGcPa9
         fsI8VE5P9lHtA==
Date:   Thu, 14 Jul 2022 21:30:25 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <pabeni@redhat.com>, <hawk@kernel.org>,
        <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <martin.lau@linux.dev>, <song@kernel.org>, <yhs@fb.com>,
        <john.fastabend@gmail.com>, <kpsingh@kernel.org>, <sdf@google.com>,
        <bigeasy@linutronix.de>, <imagedong@tencent.com>,
        <petrm@nvidia.com>, <arnd@arndb.de>, <dsahern@kernel.org>,
        <talalahmad@google.com>, <keescook@chromium.org>,
        <haoluo@google.com>, <jolsa@kernel.org>, <weiyongjun1@huawei.com>,
        <yuehaibing@huawei.com>
Subject: Re: [PATCH v3,bpf-next] bpf: Don't redirect packets with invalid
 pkt_len
Message-ID: <20220714213025.448faf8c@kernel.org>
In-Reply-To: <20220715032233.230507-1-shaozhengchao@huawei.com>
References: <20220715032233.230507-1-shaozhengchao@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 15 Jul 2022 11:22:33 +0800 Zhengchao Shao wrote:
> +#ifdef CONFIG_DEBUG_NET
> +	if (unlikely(!skb->len)) {
> +		pr_err("%s\n", __func__);
> +		skb_dump(KERN_ERR, skb, false);
> +		WARN_ON_ONCE(1);
> +	}

Is there a reason to open code WARN_ONCE() like that?

#ifdef CONFIG_DEBUG_NET
	if (WARN_ONCE(!skb->len, "%s\n", __func__))
		skb_dump(KERN_ERR, skb, false);

or

	if (IS_ENABLED(CONFIG_DEBUG_NET) &&
	    WARN_ONCE(!skb->len, "%s\n", __func__))
		skb_dump(KERN_ERR, skb, false);
