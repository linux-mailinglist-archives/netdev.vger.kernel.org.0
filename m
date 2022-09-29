Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 189AD5EF96E
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 17:48:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235972AbiI2PsL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 11:48:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235969AbiI2Prc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 11:47:32 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52E3295AD2;
        Thu, 29 Sep 2022 08:47:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B8C38CE2238;
        Thu, 29 Sep 2022 15:47:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A1C7C433D6;
        Thu, 29 Sep 2022 15:47:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664466436;
        bh=HlgR/8xBDaVYV5BsI4N5ii5eqj0980HBEp69dPX6cAQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=upVX81wCysbj+Z/0kQZrZPsNOU6RcHVqOja1Ic3SEkO781//a1BpwvQ83kGkAKVEx
         9KkF+AFqBZ7fCTpLb+eJEeFn4C0TrC/pjPwTgP1/rvcZ7gGXOp45Du3fR6Wyd7g/vu
         ah/F2K0KMjes1kei5YlpSXoEh5JWMOu3+GI0eA/BDWfNJI6PjC3gpsCwdjg5MjQfGu
         ZtBBjfD762d9wOzNemcv/1ZE7VCsGq1lSqgtTiK+9GtOkgUDNjSkNOpZ2a2EhJhsMU
         cTjrWRnCxxufDFG//3crLlEHsXxvyfDkhyp3kIlmRRPtxLCPc6h+GCHpomPDSxVYSV
         9SanEONKHtWEg==
Date:   Thu, 29 Sep 2022 08:47:15 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, robh@kernel.org, johannes@sipsolutions.net,
        ecree.xilinx@gmail.com, stephen@networkplumber.org, sdf@google.com,
        f.fainelli@gmail.com, fw@strlen.de, linux-doc@vger.kernel.org,
        razor@blackwall.org, nicolas.dichtel@6wind.com
Subject: Re: [PATCH net-next 1/6] docs: add more netlink docs (incl. spec
 docs)
Message-ID: <20220929084715.3c9626f7@kernel.org>
In-Reply-To: <20220929151145.GC6761@localhost.localdomain>
References: <20220929011122.1139374-1-kuba@kernel.org>
        <20220929011122.1139374-2-kuba@kernel.org>
        <20220929133413.GA6761@localhost.localdomain>
        <20220929073224.2f3869ca@kernel.org>
        <20220929151145.GC6761@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 29 Sep 2022 17:11:45 +0200 Guillaume Nault wrote:
> Maybe we can make this more explicit.
> Something like:
> 
> -Having to rely on ``NLM_F_ECHO`` is a hack, not a valid design.
> +Users shouldn't have to use ``NLM_F_ECHO`` to get a handle on the created
> +object.
> 
> (or keep both sentences, I feel they fit well together).
> 
> Then maybe explain in the next section why support for NLM_F_ECHO is
> desirable anyway:
> 
>  Make sure to pass the request info to genl_notify() to allow ``NLM_F_ECHO``
> -to take effect.
> +to take effect. This is usefull for programs that need precise feedback from
> + the kernel (for example for logging purpose).

Folded it a little bit:

diff --git a/Documentation/core-api/netlink.rst b/Documentation/core-api/netlink.rst
index 2a97f765d0d2..7b98dd48a6af 100644
--- a/Documentation/core-api/netlink.rst
+++ b/Documentation/core-api/netlink.rst
@@ -37,15 +37,15 @@ added whether it replies with a full message or only an ACK is uAPI and
 cannot be changed. It's better to err on the side of replying.
 
 Specifically NEW and ADD commands should reply with information identifying
-the created object such as the allocated object's ID.
-
-Having to rely on ``NLM_F_ECHO`` is a hack, not a valid design.
+the created object such as the allocated object's ID (without having to
+resort to using ``NLM_F_ECHO``).
 
 NLM_F_ECHO
 ----------
 
 Make sure to pass the request info to genl_notify() to allow ``NLM_F_ECHO``
-to take effect.
+to take effect.  This is useful for programs that need precise feedback
+from the kernel (for example for logging purposes).
 
 Support dump consistency
 ------------------------


