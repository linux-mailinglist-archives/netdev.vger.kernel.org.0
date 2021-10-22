Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4827543710B
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 06:48:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231761AbhJVEvL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 00:51:11 -0400
Received: from coyote.holtmann.net ([212.227.132.17]:50886 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229957AbhJVEvG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 00:51:06 -0400
Received: from smtpclient.apple (p54899aa7.dip0.t-ipconnect.de [84.137.154.167])
        by mail.holtmann.org (Postfix) with ESMTPSA id B8669CED3E;
        Fri, 22 Oct 2021 06:48:47 +0200 (CEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.120.0.1.13\))
Subject: Re: [PATCH] Bluetooth: cmtp: fix possible panic when
 cmtp_init_sockets() fails
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20211022034417.766659-1-wanghai38@huawei.com>
Date:   Fri, 22 Oct 2021 06:48:47 +0200
Cc:     Karsten Keil <isdn@linux-pingi.de>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <9D8B1F5B-8EFE-40CB-BC85-F6EC3483CC61@holtmann.org>
References: <20211022034417.766659-1-wanghai38@huawei.com>
To:     Wang Hai <wanghai38@huawei.com>
X-Mailer: Apple Mail (2.3654.120.0.1.13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Wang,

> I got a kernel BUG report when doing fault injection test:
> 
> ------------[ cut here ]------------
> kernel BUG at lib/list_debug.c:45!
> ...
> RIP: 0010:__list_del_entry_valid.cold+0x12/0x4d
> ...
> Call Trace:
> proto_unregister+0x83/0x220
> cmtp_cleanup_sockets+0x37/0x40 [cmtp]
> cmtp_exit+0xe/0x1f [cmtp]
> do_syscall_64+0x35/0xb0
> entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> If cmtp_init_sockets() in cmtp_init() fails, cmtp_init() still returns
> success. This will cause a kernel bug when accessing uncreated ctmp
> related data when the module exits.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wang Hai <wanghai38@huawei.com>
> ---
> net/bluetooth/cmtp/core.c | 6 ++++--
> 1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/net/bluetooth/cmtp/core.c b/net/bluetooth/cmtp/core.c
> index 0a2d78e811cf..ccf48f50afdf 100644
> --- a/net/bluetooth/cmtp/core.c
> +++ b/net/bluetooth/cmtp/core.c
> @@ -499,11 +499,13 @@ int cmtp_get_conninfo(struct cmtp_conninfo *ci)
> 
> static int __init cmtp_init(void)
> {
> +	int err;
> +
> 	BT_INFO("CMTP (CAPI Emulation) ver %s", VERSION);
> 
> -	cmtp_init_sockets();
> +	err = cmtp_init_sockets();
> 
> -	return 0;
> +	return err;
> }

just do return cmtp_init_sockets();

Regards

Marcel

