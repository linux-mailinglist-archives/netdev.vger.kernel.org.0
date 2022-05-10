Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA9C5520A7F
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 03:07:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234122AbiEJBLM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 21:11:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234118AbiEJBLL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 21:11:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 275A67CB3B
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 18:07:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C44C8B81A2A
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 01:07:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44B11C385C5;
        Tue, 10 May 2022 01:07:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652144833;
        bh=iflYNXVWpMlsUw0T7Rz5hqdt7Xo93lnSJ9zgydfJVSk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Wwn8oWMFkzKpjFEsnnVCLtrG8KedsbDu2/xGZ1naEiff0VuBkojhDatb8YIKJI5xH
         CYktdsL71bt/UZ+aIwL6C8K6vv7LiKKpjNyxPuVMNPslfCi/OSkY4nH5kltfyyqV2O
         9z4tM9sgqP6v8XHtBkoRWA+eza5DQ9lxYtNa74ALrK7nrWoyOPRFwSi8avEnOT3Q9T
         A1gNyPBzinz4byyTzXTab/VRJbPETclzXQSP7Hu1qr4oi/CUYHDYVfdXzF7tcqLHMB
         lsdpXtCOPY3aErLng/WJdbqIn8jeIYNxCIoGeWOWvs4okfrFgcmbzgne06TK8wx+Zg
         IDdpE99gw5PSg==
Date:   Mon, 9 May 2022 18:07:12 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        Edward Cree <ecree@solarflare.com>
Subject: Re: [PATCH net] Documentation: add description for
 net.core.gro_normal_batch
Message-ID: <20220509180712.22f4a3a7@kernel.org>
In-Reply-To: <e448120735d71f16ca3e1e845730f7fc29e71ea1.1651861213.git.lucien.xin@gmail.com>
References: <e448120735d71f16ca3e1e845730f7fc29e71ea1.1651861213.git.lucien.xin@gmail.com>
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

On Fri,  6 May 2022 14:20:13 -0400 Xin Long wrote:
> Describe it in admin-guide/sysctl/net.rst like other Network core options.
> Users need to know gro_normal_batch for performance tuning.
> 
> Fixes: 323ebb61e32b ("net: use listified RX for handling GRO_NORMAL skbs")
> Reported-by: Prijesh <prpatel@redhat.com>

Does Prijesh have a last name? :)

> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  Documentation/admin-guide/sysctl/net.rst | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/Documentation/admin-guide/sysctl/net.rst b/Documentation/admin-guide/sysctl/net.rst
> index f86b5e1623c6..d8a8506f31ad 100644
> --- a/Documentation/admin-guide/sysctl/net.rst
> +++ b/Documentation/admin-guide/sysctl/net.rst
> @@ -374,6 +374,16 @@ option is set to SOCK_TXREHASH_DEFAULT (i. e. not overridden by setsockopt).
>  If set to 1 (default), hash rethink is performed on listening socket.
>  If set to 0, hash rethink is not performed.
>  
> +gro_normal_batch
> +----------------
> +
> +Maximum number of GRO_NORMAL skbs to batch up for list-RX. When GRO decides
> +not to coalesce a packet, instead of passing it to the stack immediately,
> +place it on a list. 

That makes it sounds like only packets which were not coalesced 
go on the list. IIUC everything goes on that list before traveling 
up the stack, no?

> +Pass this list to the stack at flush time or whenever

This sentences is in second person, and the previous one was in third
person.

> +the number of skbs in this list exceeds gro_normal_batch.

s/skbs/segments/

> +Default : 8
> +
>  2. /proc/sys/net/unix - Parameters for Unix domain sockets
>  ----------------------------------------------------------
>  

