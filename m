Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 028F4696F46
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 22:23:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232762AbjBNVXj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 16:23:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232749AbjBNVXg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 16:23:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 400C95580
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 13:23:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DC60CB81F19
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 21:23:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64865C4339B;
        Tue, 14 Feb 2023 21:23:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676409812;
        bh=mv13waw5Oe55N5ZxkX2TvT9tfjrF1pIrdR6I+0qQlkc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jsM288FjispzmWTJBljgGpE+Vy6fr+hGkjSoAVksMEUNODkXDz9avhvRpSL4sEoau
         bykMunIRkpnPQv1PjKLVX/ItuT+moZ7OO3xe8SH1kmr4Put1aGRsOpy2+BQG4HtlTn
         EIoWYMKgyOKeYc2y9ek2ECf5AtQTRjIomTJ0xaU3sql5xHmXahurru3TIlpbbFNJUF
         sgPJSw2hiXn2XfJQwZvTSpJTI+KB5ATOlQn8knMp0CDEmBJnjnSjcOJypvu54WAFP0
         TqQ3MjGePc0bjfOUNaAXpyG8rruUtLodpSqu3L0xr4tAUpLwSUw792S66EaPsLXvok
         0st6ctl9W4sXQ==
Date:   Tue, 14 Feb 2023 13:23:31 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Gong Ruiqi <gongruiqi1@huawei.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        lianhui tang <bluetlh@gmail.com>, <kuniyu@amazon.co.jp>,
        <rshearma@brocade.com>
Subject: Re: [PATCH net] net: mpls: fix stale pointer if allocation fails
 during device rename
Message-ID: <20230214132331.526f4fb7@kernel.org>
In-Reply-To: <d85f25cf-3c37-dff2-85fd-f8f3a5a57645@huawei.com>
References: <20230214065355.358890-1-kuba@kernel.org>
        <d85f25cf-3c37-dff2-85fd-f8f3a5a57645@huawei.com>
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

On Tue, 14 Feb 2023 17:33:36 +0800 Gong Ruiqi wrote:
> Just be curious: would this be a simpler solution?
> 
> @@ -1439,6 +1439,7 @@ static void mpls_dev_sysctl_unregister(struct
> net_device *dev,
> 
>         table = mdev->sysctl->ctl_table_arg;
>         unregister_net_sysctl_table(mdev->sysctl);
> +       mdev->sysctl = NULL;
>         kfree(table);
> 
>         mpls_netconf_notify_devconf(net, RTM_DELNETCONF, 0, mdev);
> 
> However I'm not sure if we need to preserve the old value of
> mdev->sysctl after we unregister it.

It'd work too, I decided to limit the zeroing to the exception case
because of recent discussions on the list. The argument there was that
zeroing in cases were we don't expect it to be necessary may hide bugs.
We generally try to avoid defensive programming in the kernel.
