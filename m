Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D369D233C0F
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 01:20:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730822AbgG3XUf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 19:20:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:55528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730814AbgG3XUc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jul 2020 19:20:32 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E9ED2082E;
        Thu, 30 Jul 2020 23:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596151232;
        bh=qot+g9oi0LsOS1FV9LINIsbMOlE+OOITEXXB5/t+8TA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=U7MbYPSNtu9Sf5zyIdc1YDpc7bO603QtAVXfFTph8Mg+wTtby6xpaSQ9Mfm3KdUuD
         uvbuSQGK+U9NonUxunZDW1NxlRlsOsZ/djaspOYYIlRrLgLPyzmfPo137v43RP+D68
         x7NeKig+mLdr4akiU+xleP6mXW1dNHstk4YUXWZw=
Date:   Thu, 30 Jul 2020 16:20:30 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Martin Varghese <martinvarghesenokia@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jbenc@redhat.com,
        gnault@redhat.com, Martin Varghese <martin.varghese@nokia.com>
Subject: Re: [PATCH net] bareudp: Disallow udp port 0.
Message-ID: <20200730162030.0b5749a8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1596128631-3404-1-git-send-email-martinvarghesenokia@gmail.com>
References: <1596128631-3404-1-git-send-email-martinvarghesenokia@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 30 Jul 2020 22:33:51 +0530 Martin Varghese wrote:
> From: Martin Varghese <martin.varghese@nokia.com>
> 
> Kernel does not support udp destination port 0 on wire. Hence
> bareudp device with udp destination port 0 must be disallowed.
> 
> Fixes: 571912c69f0e ("net: UDP tunnel encapsulation module for tunnelling different protocols like MPLS, IP, NSH etc.")
> Signed-off-by: Martin Varghese <martin.varghese@nokia.com>
> ---
>  drivers/net/bareudp.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/bareudp.c b/drivers/net/bareudp.c
> index 88e7900853db..08b195d32cbe 100644
> --- a/drivers/net/bareudp.c
> +++ b/drivers/net/bareudp.c
> @@ -578,8 +578,13 @@ static int bareudp2info(struct nlattr *data[], struct bareudp_conf *conf,
>  		return -EINVAL;
>  	}
>  
> -	if (data[IFLA_BAREUDP_PORT])
> +	if (data[IFLA_BAREUDP_PORT]) {
>  		conf->port =  nla_get_u16(data[IFLA_BAREUDP_PORT]);
> +		if (!conf->port) {
> +			NL_SET_ERR_MSG(extack, "udp port 0 not supported");
> +			return -EINVAL;
> +		}
> +	}

Please use one of the NLA_POLICY_**-ies, probably NLA_POLICY_MIN() ? 
That's better for documenting, exporting for user space, and will also
point the user space to the attribute in exack automatically.
