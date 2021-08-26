Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C2F33F828C
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 08:39:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239344AbhHZGkm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 02:40:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:38172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234415AbhHZGkk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Aug 2021 02:40:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6D3BE610CA;
        Thu, 26 Aug 2021 06:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629959994;
        bh=YDdDJ8UVx6APE79kWD1KiYfDKlzcYXXRqdvvgHhmVzk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aP1s1YHNUe+n+sZuGly73Kfys6U2PxpfwFwgeAYLORkHO7O6dD9MtMQfP356DdWGl
         wrpN8612/+wvBVbxWHBr0wqM9pSv8bl9T4/vi+eECS1MbOCg9OAz+0F+EQNUsPQoX5
         4tg4ywEmo8UqB0x1lnyowZ9+UsBPOWsukJYtg3Cg=
Date:   Thu, 26 Aug 2021 08:39:44 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Peter Collingbourne <pcc@google.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Colin Ian King <colin.king@canonical.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Al Viro <viro@zeniv.linux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] net: don't unconditionally copy_from_user a struct ifreq
 for socket ioctls
Message-ID: <YSc3MGVllU8qSJXV@kroah.com>
References: <20210826012722.3210359-1-pcc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210826012722.3210359-1-pcc@google.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 25, 2021 at 06:27:22PM -0700, Peter Collingbourne wrote:
> A common implementation of isatty(3) involves calling a ioctl passing
> a dummy struct argument and checking whether the syscall failed --
> bionic and glibc use TCGETS (passing a struct termios), and musl uses
> TIOCGWINSZ (passing a struct winsize). If the FD is a socket, we will
> copy sizeof(struct ifreq) bytes of data from the argument and return
> -EFAULT if that fails. The result is that the isatty implementations
> may return a non-POSIX-compliant value in errno in the case where part
> of the dummy struct argument is inaccessible, as both struct termios
> and struct winsize are smaller than struct ifreq (at least on arm64).
> 
> Although there is usually enough stack space following the argument
> on the stack that this did not present a practical problem up to now,
> with MTE stack instrumentation it's more likely for the copy to fail,
> as the memory following the struct may have a different tag.
> 
> Fix the problem by adding an early check for whether the ioctl is a
> valid socket ioctl, and return -ENOTTY if it isn't.
> 
> Fixes: 44c02a2c3dc5 ("dev_ioctl(): move copyin/copyout to callers")
> Link: https://linux-review.googlesource.com/id/I869da6cf6daabc3e4b7b82ac979683ba05e27d4d
> Signed-off-by: Peter Collingbourne <pcc@google.com>
> Cc: <stable@vger.kernel.org> # 4.19
> ---
>  include/linux/netdevice.h |  1 +
>  net/core/dev_ioctl.c      | 64 ++++++++++++++++++++++++++++++++-------
>  net/socket.c              |  6 +++-
>  3 files changed, 59 insertions(+), 12 deletions(-)
> 
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index eaf5bb008aa9..481b90ef0d32 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -4012,6 +4012,7 @@ int netdev_rx_handler_register(struct net_device *dev,
>  void netdev_rx_handler_unregister(struct net_device *dev);
>  
>  bool dev_valid_name(const char *name);
> +bool is_dev_ioctl_cmd(unsigned int cmd);

"is_socket_ioctl_cmd()" might be a better global name here.

thanks,

greg k-h
