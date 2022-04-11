Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 868C24FBBDB
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 14:14:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345960AbiDKMQ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 08:16:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240584AbiDKMQz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 08:16:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1BFD40E4F;
        Mon, 11 Apr 2022 05:14:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8CC9E6163D;
        Mon, 11 Apr 2022 12:14:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E600FC385A3;
        Mon, 11 Apr 2022 12:14:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649679281;
        bh=XcjtbKiDmNUDUzHcXtTHRMT/Hnm0TsOrSzVdisG0c7A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kajbelk+29WQC+TRn+sWzyafuwhgoynnn1Rw5qA6hxUmo3AO3Xkx53v0y+98gC8MQ
         DKufahP1YjsM0Dq9qu8Ldd49kzEnPcueY3lVi+O7NeY0uSVgDJv1qI7xZfux+Csbxi
         vmsv+bgKBB0uv0tstlgNOh7MvPzbmThtD5Vfscpv3EPB6MYDxOSpnzWStzO07so8Xt
         BFTONgM5OH2hkDnOyMRpcRLjJyv/pg06VAnM/FCz1voEljK9mCGvAUzciEGWQepm7O
         dOHO9FszOb9laPJXdh5bdt2tM7SoTMQuaZXBm4v2C+LGmp8H/deH06iQfmisbJh0lk
         t60f0uPV+yVRA==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1ndswE-0004oq-JI; Mon, 11 Apr 2022 14:14:34 +0200
Date:   Mon, 11 Apr 2022 14:14:34 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Dongliang Mu <dzm91@hust.edu.cn>
Cc:     Oliver Neukum <oliver@neukum.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Dongliang Mu <mudongliangabcd@gmail.com>,
        syzbot+eabbf2aaa999cc507108@syzkaller.appspotmail.com,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] driver: usb: nullify dangling pointer in cdc_ncm_free
Message-ID: <YlQbqnYP/jcYinvz@hovoldconsulting.com>
References: <20220409120901.267526-1-dzm91@hust.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220409120901.267526-1-dzm91@hust.edu.cn>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 09, 2022 at 08:09:00PM +0800, Dongliang Mu wrote:
> From: Dongliang Mu <mudongliangabcd@gmail.com>
> 
> cdc_ncm_bind calls cdc_ncm_bind_common and sets dev->data[0]
> with ctx. However, in the unbind function - cdc_ncm_unbind,
> it calls cdc_ncm_free and frees ctx, leaving dev->data[0] as
> a dangling pointer. The following ioctl operation will trigger
> the UAF in the function cdc_ncm_set_dgram_size.
> 
> Fix this by setting dev->data[0] as zero.

This sounds like a poor band-aid. Please explain how this prevent the
ioctl() from racing with unbind(). 

Johan

> ==================================================================
> BUG: KASAN: use-after-free in cdc_ncm_set_dgram_size+0xc91/0xde0
> Read of size 8 at addr ffff8880755210b0 by task dhcpcd/3174
> 
> Call Trace:
>  <TASK>
>  __dump_stack lib/dump_stack.c:88 [inline]
>  dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
>  print_address_description.constprop.0.cold+0xeb/0x495 mm/kasan/report.c:313
>  print_report mm/kasan/report.c:429 [inline]
>  kasan_report.cold+0xf4/0x1c6 mm/kasan/report.c:491
>  cdc_ncm_set_dgram_size+0xc91/0xde0 drivers/net/usb/cdc_ncm.c:608
>  cdc_ncm_change_mtu+0x10c/0x140 drivers/net/usb/cdc_ncm.c:798
>  __dev_set_mtu net/core/dev.c:8519 [inline]
>  dev_set_mtu_ext+0x352/0x5b0 net/core/dev.c:8572
>  dev_set_mtu+0x8e/0x120 net/core/dev.c:8596
>  dev_ifsioc+0xb87/0x1090 net/core/dev_ioctl.c:332
>  dev_ioctl+0x1b9/0xe30 net/core/dev_ioctl.c:586
>  sock_do_ioctl+0x15a/0x230 net/socket.c:1136
>  sock_ioctl+0x2f1/0x640 net/socket.c:1239
>  vfs_ioctl fs/ioctl.c:51 [inline]
>  __do_sys_ioctl fs/ioctl.c:870 [inline]
>  __se_sys_ioctl fs/ioctl.c:856 [inline]
>  __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:856
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x35/0x80 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x7f00859e70e7
> RSP: 002b:00007ffedd503dd8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> RAX: ffffffffffffffda RBX: 00007f00858f96c8 RCX: 00007f00859e70e7
> RDX: 00007ffedd513fc8 RSI: 0000000000008922 RDI: 0000000000000018
> RBP: 00007ffedd524178 R08: 00007ffedd513f88 R09: 00007ffedd513f38
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007ffedd513fc8 R14: 0000000000000028 R15: 0000000000008922
>  </TASK>

> Reported-by: syzbot+eabbf2aaa999cc507108@syzkaller.appspotmail.com
> Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
> ---
>  drivers/net/usb/cdc_ncm.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/usb/cdc_ncm.c b/drivers/net/usb/cdc_ncm.c
> index 15f91d691bba..9fc2df9f0b63 100644
> --- a/drivers/net/usb/cdc_ncm.c
> +++ b/drivers/net/usb/cdc_ncm.c
> @@ -1019,6 +1019,7 @@ void cdc_ncm_unbind(struct usbnet *dev, struct usb_interface *intf)
>  
>  	usb_set_intfdata(intf, NULL);
>  	cdc_ncm_free(ctx);
> +	dev->data[0] = 0;
>  }
>  EXPORT_SYMBOL_GPL(cdc_ncm_unbind);
