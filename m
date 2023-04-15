Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D6CA6E2FBE
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 10:31:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbjDOIb3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Apr 2023 04:31:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbjDOIb1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Apr 2023 04:31:27 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C6BC11FE7
        for <netdev@vger.kernel.org>; Sat, 15 Apr 2023 01:31:23 -0700 (PDT)
Date:   Sat, 15 Apr 2023 10:31:19 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, fw@strlen.de
Subject: Re: [PATCH net-next 4/5] net: skbuff: push nf_trace down the bitfield
Message-ID: <ZDpg14bxJMcimOya@calendula>
References: <20230414160105.172125-1-kuba@kernel.org>
 <20230414160105.172125-5-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230414160105.172125-5-kuba@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 14, 2023 at 09:01:04AM -0700, Jakub Kicinski wrote:
> nf_trace is a debug feature, AFAIU, and yet it sits oddly
> high in the sk_buff bitfield. Move it down, pushing up
> dst_pending_confirm and inner_protocol_type.
> 
> Next change will make nf_trace optional (under Kconfig)
> and all optional fields should be placed after 2b fields
> to avoid 2b fields straddling bytes.
> 
> dst_pending_confirm is L3, so it makes sense next to ignore_df.
> inner_protocol_type goes up just to keep the balance.

Well, yes, this is indeed a debug feature.

But if only one single container enables debugging, this cache line
will be visited very often. The debugging infrastructure is guarded
under a static_key, which is global.
