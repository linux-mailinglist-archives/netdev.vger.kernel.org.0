Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E52743394A
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 16:52:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231758AbhJSOyz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 10:54:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:49780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229941AbhJSOyz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Oct 2021 10:54:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 333116137D;
        Tue, 19 Oct 2021 14:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634655162;
        bh=nL3J2VL9zWYo/wi24YajKfhHZQktfPjrSciiqbNy07s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eeGlT0cOTfvNAjBhOZ74NFgUXq/5n41xtAXXR6sa4MBgyX3mPo14mJm7/QssMQkTl
         UbOjSAaFRZYDcLZLxn644OZceFsnm17mNPR+VRmSE6lH0Q6SJLTSjPQKBmPTFZ5HTL
         yshGnvfFJXF7TN14FUSUQqJ7MCkmx2qALNpev43YAYPmIMxhCNSukfMZ+nh8+5VVoU
         7e+wFysZWMkihrVq7Fa5n3LWvK1iTF6mo3D287cFLUDycWERCvhgm0KMDo4Y7LphUU
         PFI+mI5Tg1QDhmI5BwicnYiXat1ykvSLlTm+McprR0A7njT7MfnezwolSryuEK2FxW
         /gJTgZYWvDTEw==
Date:   Tue, 19 Oct 2021 07:52:41 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kumar Thangavel <kumarthangavel.hcl@gmail.com>
Cc:     Samuel Mendoza-Jonas <sam@mendozajonas.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        openbmc@lists.ozlabs.org, linux-aspeed@lists.ozlabs.org,
        patrickw3@fb.com, Amithash Prasad <amithash@fb.com>,
        velumanit@hcl.com, sdasari@fb.com
Subject: Re: [PATCH v2] Add payload to be 32-bit aligned to fix dropped
 packets
Message-ID: <20211019075241.7ba9fd0a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211019144127.GA12978@gmail.com>
References: <20211019144127.GA12978@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 19 Oct 2021 20:11:27 +0530 Kumar Thangavel wrote:
>  	len += sizeof(struct ncsi_cmd_pkt_hdr) + 4;
> -	if (nca->payload < 26)
> +	payload = ALIGN(nca->payload, 4)
> +	if (payload < 26)
>  		len += 26;
>  	else
> -		len += nca->payload;
> +		len += payload;

You round up to 4 and then add 26 if the result is smaller.  26 is not
a multiple of 4. Is this intentional?

Also you can write this on one line:

	len += max(payload, 26);
