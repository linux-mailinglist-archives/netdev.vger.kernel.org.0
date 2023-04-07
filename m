Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B542E6DA725
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 03:59:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239568AbjDGB7a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 21:59:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239547AbjDGB73 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 21:59:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37CA47EC6;
        Thu,  6 Apr 2023 18:59:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AFE9160ED7;
        Fri,  7 Apr 2023 01:59:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0AFDC433D2;
        Fri,  7 Apr 2023 01:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680832768;
        bh=OjAgpL4hr+PIA/oOHr5fg/6H51UIxKwatbJ6by0dwZg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=glcRKpI4T2vbTyII6CoMZXibBDjoYsB6lnEeqhK/DtYANk1bbFkqi0hd0PS25iddu
         B1moeTddxKaZ8TzHNwujfSa5CBLdjhNCj2ldv6AtC2gmVVfv2Ykz3y1mJwzchBZK9F
         FeNaxgplAAJwI5Cy4rJjtIU/RJbic+sDdImXCJSpC2M5CvILO09leNTf+YQXIct496
         Y8DfUziy5zXwqhdr8/0fqYZGnTkDsZ7QjHZ6wVrq4r7YjTmcH+Lk87IzZ0aO7/I/Ky
         IRzW0RLtTu+ie1PbuNUHv2PqDWA76Tn6rbBcmmRAtzmns9lUSdvJIB94iLtRorlEH8
         BdKqMcthPVmDQ==
Date:   Thu, 6 Apr 2023 18:59:26 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     <davem@davemloft.net>, <edumazet@google.com>, <pabeni@redhat.com>,
        <corbet@lwn.net>, <dsahern@kernel.org>, <kuniyu@amazon.com>,
        <netdev@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] tcp: restrict net.ipv4.tcp_app_win
Message-ID: <20230406185926.7da74db2@kernel.org>
In-Reply-To: <20230406063450.19572-1-yuehaibing@huawei.com>
References: <20230406063450.19572-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 6 Apr 2023 14:34:50 +0800 YueHaibing wrote:
> UBSAN: shift-out-of-bounds in net/ipv4/tcp_input.c:555:23
> shift exponent 255 is too large for 32-bit type 'int'
> CPU: 1 PID: 7907 Comm: ssh Not tainted 6.3.0-rc4-00161-g62bad54b26db-dirty #206
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0x136/0x150
>  __ubsan_handle_shift_out_of_bounds+0x21f/0x5a0
>  tcp_init_transfer.cold+0x3a/0xb9
>  tcp_finish_connect+0x1d0/0x620
>  tcp_rcv_state_process+0xd78/0x4d60
>  tcp_v4_do_rcv+0x33d/0x9d0
>  __release_sock+0x133/0x3b0
>  release_sock+0x58/0x1b0
> 
> 'maxwin' is int, shifting int for 32 or more bits is undefined behaviour.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Fixes tag?
