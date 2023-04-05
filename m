Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEE026D7135
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 02:23:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232125AbjDEAXX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 20:23:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229748AbjDEAXW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 20:23:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54F55358B
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 17:23:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E4394638F5
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 00:23:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB5D0C433EF;
        Wed,  5 Apr 2023 00:23:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680654200;
        bh=ZaR/TrJIhvTI3AXjFyEfWFmb2sglI/FUamopBW/EXA8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=klFUMoZAzPmKuDhbY1DRH4MJJKwbMRTLOX/wLjkGRMVfEzi7BJMNH6/juz720C/4r
         YPoOX5005sgPGixJq6TGco1bKCvFYQ7FFhMxWMb0RZEvKAKwymyvZwdUz+c6tBqZsT
         L0WrZ4pt8DI3NG/ZLSLAB8mK3eIqDhjhSov1qDjWP21cljkPXfqIruS05iIPBwKJgg
         x6e1TTW/PE6mfK3GRP15EqOkqKYn2z/XgYwsp/5TyQMVIwFsMihR3ioYNHQw24+NII
         65w3ILLvPgHDN84YQp+BHHvsJFZaTeDaZKElntjvajxBp3cBuh+EYQrmULU648taGh
         ndLMA9/WT21bA==
Date:   Tue, 4 Apr 2023 17:23:18 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Chuck Lever <cel@kernel.org>
Cc:     pabeni@redhat.com, edumazet@google.com, borisp@nvidia.com,
        netdev@vger.kernel.org, kernel-tls-handshake@lists.linux.dev,
        john.haxby@oracle.com
Subject: Re: [PATCH v8 1/4] net/handshake: Create a NETLINK service for
 handling handshake requests
Message-ID: <20230404172318.58e4d0dd@kernel.org>
In-Reply-To: <168054756211.2138.1880630504843421368.stgit@klimt.1015granger.net>
References: <168054723583.2138.14337249041719295106.stgit@klimt.1015granger.net>
        <168054756211.2138.1880630504843421368.stgit@klimt.1015granger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 03 Apr 2023 14:46:02 -0400 Chuck Lever wrote:
> +int handshake_nl_done_doit(struct sk_buff *skb, struct genl_info *info)
> +{
> +	struct net *net = sock_net(skb->sk);
> +	struct socket *sock = NULL;
> +	struct handshake_req *req;
> +	int fd, status, err;
> +
> +	if (GENL_REQ_ATTR_CHECK(info, HANDSHAKE_A_DONE_SOCKFD))
> +		return -EINVAL;
> +	fd = nla_get_u32(info->attrs[HANDSHAKE_A_DONE_SOCKFD]);
> +
> +	err = 0;
> +	sock = sockfd_lookup(fd, &err);
> +	if (err) {
> +		err = -EBADF;
> +		goto out_status;
> +	}
> +
> +	req = handshake_req_hash_lookup(sock->sk);
> +	if (!req) {

fput() missing on this path?

> +		err = -EBUSY;
> +		goto out_status;
> +	}
> +
> +	trace_handshake_cmd_done(net, req, sock->sk, fd);
> +
> +	status = -EIO;
> +	if (info->attrs[HANDSHAKE_A_DONE_STATUS])
> +		status = nla_get_u32(info->attrs[HANDSHAKE_A_DONE_STATUS]);
> +
> +	handshake_complete(req, status, info);
> +	fput(sock->file);
> +	return 0;
> +
> +out_status:
> +	trace_handshake_cmd_done_err(net, req, sock->sk, err);
> +	return err;
> +}

> +	/*
> +	 * Arbitrary limit to prevent handshakes that do not make
> +	 * progress from clogging up the system.
> +	 */
> +	si_meminfo(&si);
> +	tmp = si.totalram / (25 * si.mem_unit);
> +	hn->hn_pending_max = clamp(tmp, 3UL, 25UL);

No idea what this does (what's mem_unit?), we'll have to trust you :)


And there are some kdoc issues here:

include/trace/events/handshake.h:112: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
 ** Request lifetime events
include/trace/events/handshake.h:149: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
