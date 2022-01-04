Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48BDE484489
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 16:29:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231601AbiADP3a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 10:29:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229957AbiADP33 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 10:29:29 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81C48C061761
        for <netdev@vger.kernel.org>; Tue,  4 Jan 2022 07:29:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=SWnAKA+vU71FHF9oIaor3jET4lPKNfCAO3t8mNJ9hCU=;
        t=1641310169; x=1642519769; b=yA5Swe1EiO0YFYEA/GFqxWubXoGXoM/7iEmNJoaedJp97Ql
        NmBzrBro8bHM2CA6rP+84uHdptSFEwiJEpfeq2PJwZpnJAyEXXYQNp4skr9YSvHuRiU+ltGZyMZ4v
        imlJMf8P/mEDh0d5thQzX+Ncm5JHkr8uChBZcSWGzzDJ5ItPMkXI4c3sZQuxiwytTsvVd4ZLL7RD9
        joK+Sn9lNzklFUV7L+ykfQPO4URgzqlnQIrR14A/AfQzvqvwAyhX8nPFmO1+MKab43GQHFRdO+/OC
        UugJzRS4qLB+08PgkwAv4HcEqJsyoIYY17WdGxTRt4mQFGMksm3ZgDysClpnhqHg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95)
        (envelope-from <johannes@sipsolutions.net>)
        id 1n4lkZ-001njy-Sv;
        Tue, 04 Jan 2022 16:29:24 +0100
Message-ID: <5836510f3ea87678e1a3bf6d9ff09c0e70942d13.camel@sipsolutions.net>
Subject: Re: [PATCH net-next 11/13] netlink: add net device refcount tracker
 to struct ethnl_req_info
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>, Eric Dumazet <edumazet@google.com>
Date:   Tue, 04 Jan 2022 16:29:23 +0100
In-Reply-To: <20211207013039.1868645-12-eric.dumazet@gmail.com>
References: <20211207013039.1868645-1-eric.dumazet@gmail.com>
         <20211207013039.1868645-12-eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.2 (3.42.2-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2021-12-06 at 17:30 -0800, Eric Dumazet wrote:
> 
> @@ -624,6 +625,7 @@ static void ethnl_default_notify(struct net_device *dev, unsigned int cmd,
>  	}
>  
>  	req_info->dev = dev;
> +	netdev_tracker_alloc(dev, &req_info->dev_tracker, GFP_KERNEL);
>  	req_info->flags |= ETHTOOL_FLAG_COMPACT_BITSETS;
> 

I may have missed a follow-up patch (did a search on netdev now, but
...), but I'm hitting warnings from this and I'm not sure it's right?

This req_info is just allocated briefly and freed again, and I'm not
even sure there's a dev_get/dev_put involved here, I didn't see any?

At least it would seem we need to free the tracker at the end of this
function, or perhaps never even create one?

johannes
