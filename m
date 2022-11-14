Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD3346274A0
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 03:39:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235559AbiKNCje (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Nov 2022 21:39:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbiKNCjc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Nov 2022 21:39:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 290AD11A13
        for <netdev@vger.kernel.org>; Sun, 13 Nov 2022 18:39:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ABC9F60E97
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 02:39:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8764C433D6;
        Mon, 14 Nov 2022 02:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668393571;
        bh=aMg19ZTfRPQEyODL5nVHiIxdzTUIonbvAVMGNRf5bjk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pqWPlGkhElKj9lzgYc57M+43jy0ZjLdTyHmFMWs0OPLVMlOXReLeJ5RWImUht+ITh
         9Z+rfmbdP7nnCl7Gu6M7S8j9QF2nJvmjd519x5Xj0Z/NI82L9SziKy0CU6pBMZxYa2
         roRaNQCQSO9SddJsRdvnSiHKXW5ClrRptIlG+7hXzUeHvvKgycqWaOrN5bhEzLFJL5
         mUV03QXql6Bz3jsKFLuf+m+VTLNVTZ4LUfFJvbjsQD2vye3bPb6NvyQsq/AiC6bXlV
         BCq5JWbLUhZIKBUtB8ck5GtF5fPMeJmwyJnlZ0vD4RWvvI73nvbuSRVjvwiI7sEO97
         0mzgIiR3ffTfA==
Date:   Sun, 13 Nov 2022 19:39:27 -0700
From:   David Ahern <dsahern@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH net-next v2] netlink: split up copies in the ack
 construction
Message-ID: <20221114023927.GA685@u2004-local>
References: <20221027212553.2640042-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221027212553.2640042-1-kuba@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 27, 2022 at 02:25:53PM -0700, Jakub Kicinski wrote:
> diff --git a/include/uapi/linux/netlink.h b/include/uapi/linux/netlink.h
> index e2ae82e3f9f7..5da0da59bf01 100644
> --- a/include/uapi/linux/netlink.h
> +++ b/include/uapi/linux/netlink.h
> @@ -48,6 +48,7 @@ struct sockaddr_nl {
>   * @nlmsg_flags: Additional flags
>   * @nlmsg_seq:   Sequence number
>   * @nlmsg_pid:   Sending process port ID
> + * @nlmsg_data:  Message payload
>   */
>  struct nlmsghdr {
>  	__u32		nlmsg_len;
> @@ -55,6 +56,7 @@ struct nlmsghdr {
>  	__u16		nlmsg_flags;
>  	__u32		nlmsg_seq;
>  	__u32		nlmsg_pid;
> +	__u8		nlmsg_data[];

This breaks compile of iproute2 with clang. It does not like the
variable length array in the middle of a struct. While I could re-do the
structs in iproute2, I doubt it is alone in being affected by this
change.
