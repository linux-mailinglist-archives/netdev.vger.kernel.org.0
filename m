Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A6686637EA
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 04:48:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230077AbjAJDsj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 22:48:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229559AbjAJDsh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 22:48:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E37AE3892;
        Mon,  9 Jan 2023 19:48:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 731B5614D0;
        Tue, 10 Jan 2023 03:48:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41766C433D2;
        Tue, 10 Jan 2023 03:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673322515;
        bh=k0oxUAg3YrKMFiDeGEKXfTN+oirhrrPZOBzv4qz4G3U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TebNgjhwXV4rK4gud4NX6oOD9b43IzZZzbI6TTND1KHLjTQj82pm7zY6x7avwmF8n
         fga6Lwtc0etfXzgyAi6JyZNavfYiQRA0SsqODGOL2ADmgosQDOLHf6yYmnBZ7A2c+E
         T0vUZgee1+uz1ExL9F3TyI56XD1VEvnP+FvxFPYq1FMj5fsVeSs2E/bJCGzwehAMrQ
         tgazYHyo/zTI9mPUSd3TCrYii1CYYUYJm4D+BebAqCvHXkIM29DDDr3ppou1J0a8Ar
         ZrLzANVIW40tcrB/XhjHUNheRnRnodMi2PECFHIonHHdv+sOWumd7a4lsSbeu2y6Dw
         nBr3VM7MxBrzQ==
Date:   Mon, 9 Jan 2023 19:48:34 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     <yang.yang29@zte.com.cn>
Cc:     <santosh.shilimkar@oracle.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <rds-devel@oss.oracle.com>, <linux-kernel@vger.kernel.org>,
        <xu.panda@zte.com.cn>
Subject: Re: [PATCH net-next] net/rds: use strscpy() to instead of strncpy()
Message-ID: <20230109194834.24e06def@kernel.org>
In-Reply-To: <202301091948433010050@zte.com.cn>
References: <202301091948433010050@zte.com.cn>
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

On Mon, 9 Jan 2023 19:48:43 +0800 (CST) yang.yang29@zte.com.cn wrote:
>  		BUG_ON(strlen(names[i]) >= sizeof(ctr.name));
> -		strncpy(ctr.name, names[i], sizeof(ctr.name) - 1);
> -		ctr.name[sizeof(ctr.name) - 1] = '\0';
> +		strscpy(ctr.name, names[i], sizeof(ctr.name));

You can make use of the fact that strscpy returns useful information
and the copy and the preceding BUG_ON() together. 
