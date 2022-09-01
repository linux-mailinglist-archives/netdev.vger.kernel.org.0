Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E1315AA189
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 23:34:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233212AbiIAVe3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 17:34:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232865AbiIAVe2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 17:34:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3631647C2;
        Thu,  1 Sep 2022 14:34:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6040DB82912;
        Thu,  1 Sep 2022 21:34:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FE7DC433D6;
        Thu,  1 Sep 2022 21:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662068065;
        bh=QDEyvqWC8nhNHLRGUxwIJUlPQJaJftGhKLRNzHJ5P74=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=es4wWPyEBqXs7O5cniqk0ZQDYixX2uAvihc+bhGyIsh2JyGFpyUygc/Qxju1MLtN7
         Magu0PQEAq2JAV6jUTObQnbTum7WH/3v+XSKhRyA9Gmxe8xG7lAB4IzNrOLrNXYjhs
         ixVzGX29jNSis7E19atE4wEEHC7sfk4CXExqgHh+SgvxRqDs2kFb+3Am8OQLvfDp3X
         zjp3UgyC+wokraQRgGfuowmFitx7M/x0B6IlmbdS0plhPi9CBOYdEasAgRGNh/gXPs
         H4IyjbCju9jrmgWQKFye5GxfofpflIIUUztsS/o8THE3DfYE8fVipt1/ZuKHp+RS4k
         YXG+yWtj96cbQ==
Date:   Thu, 1 Sep 2022 14:34:23 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        syzbot <syzkaller@googlegroups.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org,
        Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH v3] netlink: Bounds-check struct nlmsgerr creation
Message-ID: <20220901143423.2abc0ab0@kernel.org>
In-Reply-To: <20220901071336.1418572-1-keescook@chromium.org>
References: <20220901071336.1418572-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  1 Sep 2022 00:13:36 -0700 Kees Cook wrote:
>  	rep = __nlmsg_put(skb, NETLINK_CB(in_skb).portid, nlh->nlmsg_seq,
>  			  NLMSG_ERROR, payload, flags);

All we should need here is __nlmsg_put() -> nlmsg_put(),
that's idiomatic for netlink.

>  	errmsg = nlmsg_data(rep);
>  	errmsg->error = err;
> -	memcpy(&errmsg->msg, nlh, payload > sizeof(*errmsg) ? nlh->nlmsg_len : sizeof(*nlh));
> +	unsafe_memcpy(&errmsg->msg, nlh, payload > sizeof(*errmsg)
> +					 ?  nlh->nlmsg_len : sizeof(*nlh),
> +		      /* "payload" was bounds checked against nlh->nlmsg_len,
> +		       * and overflow-checked as tlvlen was constructed.
> +		       */);
