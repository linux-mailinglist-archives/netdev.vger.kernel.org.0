Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E8FB668B26
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 06:17:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232182AbjAMFRN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 00:17:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231634AbjAMFRK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 00:17:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8F6CC7;
        Thu, 12 Jan 2023 21:17:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6BAA0621E8;
        Fri, 13 Jan 2023 05:17:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D131C433D2;
        Fri, 13 Jan 2023 05:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673587028;
        bh=XPE03f0st6e7dXiYlxulIsVQOCCHLqaGs+W0IsPREqw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ciGEzOxez/OCF4e08FgXfsSlitf1zK9otw5V4emI1RG8tRqTWcLyp4QiSgsmypjCu
         3L/MYaimYDNYU1IzSfpiiPebb75nOLzOmjXdHYAPcMFlC7s8Vspz7cfvN1/XAmIpzN
         jTwL/EvTiU2MDvZRvhPe2hEEAUV1k5cmAoDKa8TnuY04n71mNxMsS9bmdOT5Xl9gLp
         LaVKtQdrCgAJiv4zyfRtjZjjRe5mP6pmL91MSzVbDJOVcgtg+qu2Zfu1XQKbUwPnlR
         asPazFo+t/wmU1cYwRk2tNxq/O9KcY39jjpNPctHZzX2YsF/yqKzHPCpFmb283ukwO
         UmrQji5jqZKfw==
Date:   Thu, 12 Jan 2023 21:17:07 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     <yang.yang29@zte.com.cn>
Cc:     <santosh.shilimkar@oracle.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <rds-devel@oss.oracle.com>, <linux-kernel@vger.kernel.org>,
        <xu.panda@zte.com.cn>
Subject: Re: [PATCH net-next v2] net/rds: use strscpy() to instead of
 strncpy()
Message-ID: <20230112211707.2abb31ad@kernel.org>
In-Reply-To: <202301111425483027624@zte.com.cn>
References: <202301111425483027624@zte.com.cn>
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

On Wed, 11 Jan 2023 14:25:48 +0800 (CST) yang.yang29@zte.com.cn wrote:
> From: Xu Panda <xu.panda@zte.com.cn>
> 
> The implementation of strscpy() is more robust and safer.
> That's now the recommended way to copy NUL-terminated strings.

What are the differences in behavior between strncpy() and strscpy()?

> diff --git a/net/rds/stats.c b/net/rds/stats.c
> index 9e87da43c004..7018c67418f5 100644
> --- a/net/rds/stats.c
> +++ b/net/rds/stats.c
> @@ -88,9 +88,7 @@ void rds_stats_info_copy(struct rds_info_iterator *iter,
>  	size_t i;
> 
>  	for (i = 0; i < nr; i++) {
> -		BUG_ON(strlen(names[i]) >= sizeof(ctr.name));
> -		strncpy(ctr.name, names[i], sizeof(ctr.name) - 1);
> -		ctr.name[sizeof(ctr.name) - 1] = '\0';
> +		BUG_ON(strscpy(ctr.name, names[i], sizeof(ctr.name)) < 0);
>  		ctr.value = values[i];
> 
>  		rds_info_copy(iter, &ctr, sizeof(ctr));

