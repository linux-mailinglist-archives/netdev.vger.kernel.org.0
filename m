Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41ABC667067
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 12:02:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231868AbjALLCc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 06:02:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233656AbjALLBd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 06:01:33 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 468EC50F48;
        Thu, 12 Jan 2023 02:54:25 -0800 (PST)
Date:   Thu, 12 Jan 2023 11:54:21 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: Re: [PATCH net] uapi: linux: restore IPPROTO_MAX to 256
Message-ID: <Y7/m3SCtogiLmqjn@salvia>
References: <20230111214719.194027-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230111214719.194027-1-pablo@netfilter.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 11, 2023 at 10:47:19PM +0100, Pablo Neira Ayuso wrote:
> IPPROTO_MAX used to be 256, but with the introduction of IPPROTO_MPTCP
> definition, IPPROTO_MAX was bumped to 263.
> 
> IPPROTO_MPTCP definition is used for the socket interface from
> userspace. It is never used in the layer 4 protocol field of
> IP headers.
> 
> IPPROTO_* definitions are used anywhere in the kernel as well as in
> userspace to set the layer 4 protocol field in IP headers.
> 
> At least in Netfilter, there is code in userspace that relies on
> IPPROTO_MAX (not inclusive) to check for the maximum layer 4 protocol.
> 
> This patch restores IPPROTO_MAX to 256.
> 
> Fixes: faf391c3826c ("tcp: Define IPPROTO_MPTCP")
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> Alternatively, I can also define an internal __IPPROTO_MAX to 256 in
> userspace.  I understand an update on uapi at this stage might be
> complicated. Another possibility is to add a new definition
> IPPROTO_FIELD_MAX to uapi and set it to 256 that userspace could start
> using.

Scratch this.

This breaks inet_create() and inet6_create() which is going to break
MP-TCP with socket().

I'll post a v2 adding a new IPPROTO_FIELD_MAX definition 256.
