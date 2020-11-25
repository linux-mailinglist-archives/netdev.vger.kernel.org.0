Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 961EC2C3553
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 01:25:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727319AbgKYAWM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 19:22:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:33474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727069AbgKYAWM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Nov 2020 19:22:12 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B4D12151B;
        Wed, 25 Nov 2020 00:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606263731;
        bh=ZDoR3s8Cgol1tMZZSgGMT8mRdMCQ/EixqRTLUEdBQ4E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=l463eH/c+H3DKo5acwFpNmBvmds2GQbCUKHP+/uUR5QMm/FAvsuvC9tOXoLA4p/Fi
         e4RG7dVZ/dlAz57UY7pUCXH6QbpdjvstvsgWfrw+dv5c+FkXYzanfnNB+BQFKDlN/m
         TktkiSzr4DPrnsK9W5JFc+JOyk5tu7KiK0PZZUeo=
Date:   Tue, 24 Nov 2020 16:22:10 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     jmaloy@redhat.com
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        tipc-discussion@lists.sourceforge.net,
        tung.q.nguyen@dektech.com.au, hoang.h.le@dektech.com.au,
        tuong.t.lien@dektech.com.au, maloy@donjonn.com, xinl@redhat.com,
        ying.xue@windriver.com, parthasarathy.bhuvaragan@gmail.com
Subject: Re: [net-next 2/3] tipc: make node number calculation reproducible
Message-ID: <20201124162210.40f4d607@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201124172834.317966-3-jmaloy@redhat.com>
References: <20201124172834.317966-1-jmaloy@redhat.com>
        <20201124172834.317966-3-jmaloy@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 24 Nov 2020 12:28:33 -0500 jmaloy@redhat.com wrote:
> +static inline u32 hash128to32(char *bytes)
> +{
> +	u32 res, *tmp = (u32 *)bytes;
> +
> +	res = ntohl(tmp[0] ^ tmp[1] ^ tmp[2] ^ tmp[3]);
> +	if (likely(res))
> +		return res;
> +	res = tmp[0] | tmp[1] | tmp[2] | tmp[3];
> +	return !res ? 0 : ntohl(18140715);
> +}

This needs to use correct types otherwise sparse gets upset:

net/tipc/addr.c: note: in included file (through ../net/tipc/addr.h):
net/tipc/core.h:218:15: warning: cast to restricted __be32
net/tipc/core.h:218:15: warning: cast to restricted __be32
net/tipc/core.h:218:15: warning: cast to restricted __be32
net/tipc/core.h:218:15: warning: cast to restricted __be32
net/tipc/core.h:218:15: warning: cast to restricted __be32
net/tipc/core.h:218:15: warning: cast to restricted __be32
net/tipc/core.h:222:27: warning: cast to restricted __be32
net/tipc/core.h:222:27: warning: cast to restricted __be32
net/tipc/core.h:222:27: warning: cast to restricted __be32
net/tipc/core.h:222:27: warning: cast to restricted __be32
net/tipc/core.h:222:27: warning: cast to restricted __be32
net/tipc/core.h:222:27: warning: cast to restricted __be32
