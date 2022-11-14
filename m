Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F7D462867A
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 18:06:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238080AbiKNRGW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 12:06:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236399AbiKNRGU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 12:06:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CDBCC45
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 09:06:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DA85D612E8
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 17:06:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA39BC433B5;
        Mon, 14 Nov 2022 17:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668445576;
        bh=6Xmd/LxvJ44tBqtxhrwc85rZ4z7DpYsa3UYFi0oBq38=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GCxEe6DchhdA7Upt6eI+XFuX6mqQmdf55aqRgBkDGWmxMAmCJX5iSkBvqWoqf9TQR
         9jixWtEEobGeVvepRzNlne0gkhPilJERwa5a/35SAj56dR3BaU1RAlSsIBZB0VJoBM
         GtUoF7yY2lM5F1ZAnd/yvAT+u4/m/ZfFhtRW0ZjCHUZPjaGipvI6AMQasljtBy8chj
         es2y+3CsodKdyY+WF4R4SRfm5wBGJz5Aq8cE4BnsmdgQl8MG5+ZghtK8eyQZxnfsLd
         ZvDvcfvpR4UCr6hbVOMegq3Peo/sUX8q9hTZHM8rG24ElombJO+0eG4rBPQpNMSEjY
         QkIDHvZNhuEVw==
Date:   Mon, 14 Nov 2022 09:06:14 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     David Ahern <dsahern@kernel.org>, davem@davemloft.net,
        netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com
Subject: Re: [PATCH net-next v2] netlink: split up copies in the ack
 construction
Message-ID: <20221114090614.2bfeb81c@kernel.org>
In-Reply-To: <20221114023927.GA685@u2004-local>
References: <20221027212553.2640042-1-kuba@kernel.org>
        <20221114023927.GA685@u2004-local>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 13 Nov 2022 19:39:27 -0700 David Ahern wrote:
> On Thu, Oct 27, 2022 at 02:25:53PM -0700, Jakub Kicinski wrote:
> > diff --git a/include/uapi/linux/netlink.h b/include/uapi/linux/netlink.h
> > index e2ae82e3f9f7..5da0da59bf01 100644
> > --- a/include/uapi/linux/netlink.h
> > +++ b/include/uapi/linux/netlink.h
> > @@ -48,6 +48,7 @@ struct sockaddr_nl {
> >   * @nlmsg_flags: Additional flags
> >   * @nlmsg_seq:   Sequence number
> >   * @nlmsg_pid:   Sending process port ID
> > + * @nlmsg_data:  Message payload
> >   */
> >  struct nlmsghdr {
> >  	__u32		nlmsg_len;
> > @@ -55,6 +56,7 @@ struct nlmsghdr {
> >  	__u16		nlmsg_flags;
> >  	__u32		nlmsg_seq;
> >  	__u32		nlmsg_pid;
> > +	__u8		nlmsg_data[];  
> 
> This breaks compile of iproute2 with clang. It does not like the
> variable length array in the middle of a struct. While I could re-do the
> structs in iproute2, I doubt it is alone in being affected by this
> change.

Kees, would you mind lending your expertise?

Not sure why something like (simplified):

struct top {
	struct nlmsghdr hdr;
	int tail;
}; 

generates a warning:

In file included from stat-mr.c:7:
In file included from ./res.h:9:
In file included from ./rdma.h:21:
In file included from ../include/utils.h:17:
../include/libnetlink.h:41:18: warning: field 'nlh' with variable sized type 'struct nlmsghdr' not at the end of a struct or class is a GNU extension [-Wgnu-variable-sized-type-not-at-end]
        struct nlmsghdr nlh;
                        ^

which is not confined to -Wpedantic. 
Seems like a useless warning :S
