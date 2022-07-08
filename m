Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81E1656B21F
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 07:05:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237032AbiGHFDU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 01:03:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237363AbiGHFDS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 01:03:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BE26796A7;
        Thu,  7 Jul 2022 22:03:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8E70162457;
        Fri,  8 Jul 2022 05:03:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88AF9C341C0;
        Fri,  8 Jul 2022 05:03:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657256596;
        bh=mIw7w2fyivOY9oNMtVB4mvNGbmUMA8pOqVREkwcUyFY=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=t9AlP0F738ASocn9YUAkInLJoOVPzZzioRjDqRTTpLncyMorLKLD0yz3vpX+wdIkE
         7o4AT3gFsJbqCgl7KGNZrXIZ3K1Gxu9EzDdgUWJSZQfk5EmusKKLjA/PnfmwWsu99k
         m2+9ywJYIjgt6Os/JKL3hZIRHX5VY1PJ7aZDYA9d+yrH9a5ynykdhfvcsyxBBx9Xnt
         DzpFVgLualc7xBBQg79mgeWUrPzDijBGcbGRynJWBpWykQp+OuRbob97E20plAKXNh
         tc58PanetBjxv0VOmi4ESORc0VYSoIdAEjVbRIQ7BODuz5kWegYZMdigULdGkDoaI1
         Em3p50fyTmVgA==
From:   Kalle Valo <kvalo@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Gregory Greenman <gregory.greenman@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 05/13] tracing/iwlwifi: Use the new __vstring() helper
References: <20220705224453.120955146@goodmis.org>
        <20220705224749.806599472@goodmis.org>
Date:   Fri, 08 Jul 2022 08:03:11 +0300
In-Reply-To: <20220705224749.806599472@goodmis.org> (Steven Rostedt's message
        of "Tue, 05 Jul 2022 18:44:58 -0400")
Message-ID: <87ilo8tcvk.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Steven Rostedt <rostedt@goodmis.org> writes:

> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
>
> Instead of open coding a __dynamic_array() with a fixed length (which
> defeats the purpose of the dynamic array in the first place). Use the new
> __vstring() helper that will use a va_list and only write enough of the
> string into the ring buffer that is needed.
>
> Cc: Gregory Greenman <gregory.greenman@intel.com>
> Cc: Kalle Valo <kvalo@kernel.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: linux-wireless@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> ---
>  .../net/wireless/intel/iwlwifi/iwl-devtrace-msg.h    | 12 ++++--------
>  1 file changed, 4 insertions(+), 8 deletions(-)

Feel free to take this via your tree:

Acked-by: Kalle Valo <kvalo@kernel.org>

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
