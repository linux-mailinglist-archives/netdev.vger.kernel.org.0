Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 809975425A2
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 08:55:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350946AbiFHCqa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 22:46:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1391769AbiFHClF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 22:41:05 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B57118E44B;
        Tue,  7 Jun 2022 17:20:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A5DDBCE252F;
        Wed,  8 Jun 2022 00:19:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1AECC34114;
        Wed,  8 Jun 2022 00:19:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654647591;
        bh=fq4GpmIoMBpe6Gkv7KefRfP5KgwGRQ83n3I5kKZKWGM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RH7DATHTyY+lEXNxdqkE4reMrwRkel4Bdp3YHDJH3l8vdj9DUxExUl2WPoNz7QNnm
         TZBTZbprN1yh6oon7E2HlEm/YldiyYkHbITWDpcOAdLsnSUt0nEGx1DQsTJtslgE3J
         AwubBSFNgAaV0OiiYfB+cF6kAL7LeNKLb2iFdd/9rqRkslaedHaTcPwjwyFrvlNk98
         bxXl121UoqrpMDURAqIfMVORdioSXDgWnIsJC5c8EIfDARi0baa0nEOd/PmwvgiRwn
         sEfEeMm7bd5lwqAT8qcXA3kk9ZJpcG+1R9WkeQQ1wMNqHhzTqGzmUoPdCT04HM5Dw5
         HUCz7evZCnvzA==
Date:   Tue, 7 Jun 2022 17:19:49 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jonathan Toppins <jtoppins@redhat.com>
Cc:     netdev@vger.kernel.org, Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [net-next 1/2] bonding: netlink error message support for
 options
Message-ID: <20220607171949.764e3286@kernel.org>
In-Reply-To: <ac422216e35732c59ef8ca543fb4b381655da2bf.1654528729.git.jtoppins@redhat.com>
References: <cover.1654528729.git.jtoppins@redhat.com>
        <ac422216e35732c59ef8ca543fb4b381655da2bf.1654528729.git.jtoppins@redhat.com>
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

On Mon,  6 Jun 2022 11:26:52 -0400 Jonathan Toppins wrote:
> Add support for reporting errors via extack in both bond_newlink
> and bond_changelink.
> 
> Instead of having to look in the kernel log for why an option was not
> correct just report the error to the user via the extack variable.
> 
> What is currently reported today:
>   ip link add bond0 type bond
>   ip link set bond0 up
>   ip link set bond0 type bond mode 4
>  RTNETLINK answers: Device or resource busy
> 
> After this change:
>   ip link add bond0 type bond
>   ip link set bond0 up
>   ip link set bond0 type bond mode 4
>  Error: unable to set option because the bond is up.
> 
> Signed-off-by: Jonathan Toppins <jtoppins@redhat.com>
> ---
> 
> Notes:
>     Removed the printf support and just added static messages for various
>     error events.

Thanks! nit, missing kdoc:

drivers/net/bonding/bond_options.c:729: warning: Function parameter or member 'bad_attr' not described in '__bond_opt_set'
drivers/net/bonding/bond_options.c:729: warning: Function parameter or member 'extack' not described in '__bond_opt_set'
