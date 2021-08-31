Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AC2F3FCB84
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 18:30:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240044AbhHaQbD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 12:31:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:49534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232154AbhHaQbC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 31 Aug 2021 12:31:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F346161059;
        Tue, 31 Aug 2021 16:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630427407;
        bh=oS6FPhfGA9uHONj8JonlYpU1cjtCApQRJpGyzgauwhU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WLfASnLau17NvNBWuflwQHWHajfCbILPqOro93Ch+gCamwOMa2WrNWPnrBa2RPkE0
         NxRJLmcN5RK+2mDmT+pFYJPqSvCRnncQjpOIpDNTGBsSCijdecCSl7bXwBWF1Tqi9F
         nV4/6a51lkKiIOXGFj/fbxxYqutVeGX58nF7sCbVstaYobEGv0jtAse6C7ZCjcucrQ
         nTooisKp9R4uG0agQQ1wSY/OpgilVkO9q38EpEUooxTFfSllgpEzG2e2fl5N1m20/L
         bE7VRDPVYjqQutzxucQFP50NYzQsHgNAPVNGRI6dxRPOdzfU1iPhqo7Z2NOiRBBHk1
         BMxKyhfzoi/HA==
Date:   Tue, 31 Aug 2021 09:30:06 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Peter Collingbourne <pcc@google.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Colin Ian King <colin.king@canonical.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Greg KH <gregkh@linuxfoundation.org>,
        David Laight <David.Laight@aculab.com>,
        Arnd Bergmann <arnd@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] net: don't unconditionally copy_from_user a struct
 ifreq for socket ioctls
Message-ID: <20210831093006.6db30672@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210826194601.3509717-1-pcc@google.com>
References: <20210826194601.3509717-1-pcc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 26 Aug 2021 12:46:01 -0700 Peter Collingbourne wrote:
> @@ -3306,6 +3308,8 @@ static int compat_ifr_data_ioctl(struct net *net, unsigned int cmd,
>  	struct ifreq ifreq;
>  	u32 data32;
>  
> +	if (!is_socket_ioctl_cmd(cmd))
> +		return -ENOTTY;
>  	if (copy_from_user(ifreq.ifr_name, u_ifreq32->ifr_name, IFNAMSIZ))
>  		return -EFAULT;
>  	if (get_user(data32, &u_ifreq32->ifr_data))

Hi Peter, when resolving the net -> net-next merge conflict I couldn't
figure out why this chunk is needed. It seems all callers of
compat_ifr_data_ioctl() already made sure it's a socket IOCTL.
Please double check my resolution (tip of net-next) and if this is
indeed unnecessary perhaps send a cleanup? Thanks!
