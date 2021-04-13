Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 129EA35E632
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 20:21:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345861AbhDMSVf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 14:21:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:50530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236781AbhDMSVf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 14:21:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6219E613BA;
        Tue, 13 Apr 2021 18:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618338075;
        bh=A9JAFnqiJwToiAUNC+oGPFyo2QdaFpWdrqB56MNWyKA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MtPmwnldMNluAKSDCOiJX5W3qmNcfuZde3BemTGAEOoYPDHuhl22u52+XlFG81ss3
         ohmfis6JuhhnOmc7OdToa/sRVFIg3szI158RhccFtLHlm7GVc4sRMWYKFp5E/W5tV1
         DFpzKPGb9rHraxO7svESgoxrcFTWw+ctnsfU0vqbAb1Prbl2sDX+OPtL4+yoSYvGkK
         Q7PiZS5Q+x3aIw/B/+qMwKxVCn1t/BYjQ7bUop/6VY4dvF/ZxFgfFhtc+7dAkMJc06
         1OgXQyl6/ygHym5RYDoNCtbDAB9Yc21/jukvIbZOo9czMVtcLqjR07fNUBFSflNAZM
         vRnEtASLCkogQ==
Date:   Tue, 13 Apr 2021 11:21:14 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Rohit Maheshwari <rohitm@chelsio.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        john.fastabend@gmail.com, borisp@nvidia.com, secdev@chelsio.com,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Subject: Re: [net] tls/chtls: fix kernel panic with tls_toe
Message-ID: <20210413112114.2461b7a3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210413104447.965-1-rohitm@chelsio.com>
References: <20210413104447.965-1-rohitm@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 13 Apr 2021 16:14:47 +0530 Rohit Maheshwari wrote:
> If tls_toe is supported by any device, tls_toe will be enabled
> and tls context will be created for listen sockets. But the
> connections established in stack issue context delete for every
> connection close, this causes kernel panic.
>   As part of the fix, if tls_toe is supported, don't initialize
> tcp_ulp_ops. Also make sure tls context is freed only for listen
> sockets.

Still nack. Kernel TLS does not work on listening sockets, 
so the bug is that the offload TOE TLS does. Offloaded and 
non-offload TLS should be the same from uAPI perspective.
