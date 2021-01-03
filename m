Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03AB42E8B0C
	for <lists+netdev@lfdr.de>; Sun,  3 Jan 2021 07:01:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726236AbhACF5f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jan 2021 00:57:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:51000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725829AbhACF5e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 3 Jan 2021 00:57:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6807F20784;
        Sun,  3 Jan 2021 05:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609653414;
        bh=YWP+SSVAlnqgbdHagMhrqHGe4EaTtysl9VvTnSCQfjw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WeZS+EKILd8e1c9BY3VyaQCqFlaf7zjBIuC57pJO4SOdbJrfifMa2imvpxrmoG2c1
         SI23MIc2G9xDanF2EjE+z901Koeh06UqAoKSIp9nUB4ClXrGEYPlmkWOqS5VK4cMRh
         luCjeIHc/zo+r3Y5DZQzb6u6UGbOfgTR7N9Llih3li85R02NAA3jp9/mX4+LHLk6df
         3YahvCQgbVcgAAGEGQuob5ZApovTqe+y5r32fuYMk/WfDiUWUr2VGUtgq3lps4SnYY
         7g7msCym9DHhn0j4KAVLZcXeBAinrvdlegT1UCEWvDokg+6wokTM0T7ZsiBgIcsUxh
         /q00WklVktkKA==
Date:   Sun, 3 Jan 2021 07:56:50 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Patrisious Haddad <phaddad@nvidia.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        linux-netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH iproute2-next] rdma: Add support for the netlink extack
Message-ID: <20210103055650.GA4436@unreal>
References: <20201231054217.372274-1-leon@kernel.org>
 <8d59994a-0c08-8c62-d23d-da3f74f57af5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8d59994a-0c08-8c62-d23d-da3f74f57af5@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 31, 2020 at 09:18:52AM -0700, David Ahern wrote:
> On 12/30/20 10:42 PM, Leon Romanovsky wrote:
> > diff --git a/rdma/utils.c b/rdma/utils.c
> > index 2a201aa4..927e2107 100644
> > --- a/rdma/utils.c
> > +++ b/rdma/utils.c
> > @@ -664,7 +664,7 @@ void rd_prepare_msg(struct rd *rd, uint32_t cmd, uint32_t *seq, uint16_t flags)
> >
> >  int rd_send_msg(struct rd *rd)
> >  {
> > -	int ret;
> > +	int ret, one;
> >
> >  	rd->nl = mnl_socket_open(NETLINK_RDMA);
> >  	if (!rd->nl) {
> > @@ -672,6 +672,12 @@ int rd_send_msg(struct rd *rd)
> >  		return -ENODEV;
> >  	}
> >
> > +	ret = mnl_socket_setsockopt(rd->nl, NETLINK_EXT_ACK, &one, sizeof(one));
> > +	if (ret < 0) {
> > +		pr_err("Failed to set socket option with err %d\n", ret);
> > +		goto err;
> > +	}
> > +
> >  	ret = mnl_socket_bind(rd->nl, 0, MNL_SOCKET_AUTOPID);
> >  	if (ret < 0) {
> >  		pr_err("Failed to bind socket with err %d\n", ret);
>
> you should be able to use mnlu_socket_open in ./lib/mnl_utils.c

Thanks, I'll change.

>
