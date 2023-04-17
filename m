Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0D076E3E67
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 06:12:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229946AbjDQEM1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 00:12:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbjDQEMY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 00:12:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5AEF1997
        for <netdev@vger.kernel.org>; Sun, 16 Apr 2023 21:12:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5203F619C0
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 04:12:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CB42C433D2;
        Mon, 17 Apr 2023 04:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681704742;
        bh=63tdQRYu7gAOpDdGdn6vnRKXi4gMouCHgJND8umF7ow=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cfl5/VKp3fPI1ybpw3xpZOfBbOMPZZ7+nT+muo/I9jmUW4CLP+/Q3x+pVKD6LIiin
         LjcqjZeZYbPlCmqN1UkMEltnPOGhW4hVCDYon41NUwv8hUgeqjlRKVf/QuOabNW6xG
         NYvm/NcPNqncLxpj1ulpQDNH+Gcf47GRb//2i81LqlaFvrbahd1a/Vb0ArCADZLsec
         BGQt6r3p3SVh1IzcBqD3G5FuxCbPNcpbPVC6POj+kbg1l5onVFysRMgraFYbUwoIrF
         B/RuExq9vVwFjMaYyHu9lgen529/i9AYEr3hEJVy3uhyy99IQmD12J0LXS+uZtU4qV
         dlMFeIZltdg4w==
Date:   Sun, 16 Apr 2023 21:12:21 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, fw@strlen.de
Subject: Re: [PATCH net-next 4/5] net: skbuff: push nf_trace down the
 bitfield
Message-ID: <20230416211221.4650013f@kernel.org>
In-Reply-To: <ZDpg14bxJMcimOya@calendula>
References: <20230414160105.172125-1-kuba@kernel.org>
        <20230414160105.172125-5-kuba@kernel.org>
        <ZDpg14bxJMcimOya@calendula>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 15 Apr 2023 10:31:19 +0200 Pablo Neira Ayuso wrote:
> On Fri, Apr 14, 2023 at 09:01:04AM -0700, Jakub Kicinski wrote:
> > nf_trace is a debug feature, AFAIU, and yet it sits oddly
> > high in the sk_buff bitfield. Move it down, pushing up
> > dst_pending_confirm and inner_protocol_type.
> > 
> > Next change will make nf_trace optional (under Kconfig)
> > and all optional fields should be placed after 2b fields
> > to avoid 2b fields straddling bytes.
> > 
> > dst_pending_confirm is L3, so it makes sense next to ignore_df.
> > inner_protocol_type goes up just to keep the balance.  
> 
> Well, yes, this is indeed a debug feature.
> 
> But if only one single container enables debugging, this cache line
> will be visited very often. The debugging infrastructure is guarded
> under a static_key, which is global.

I wasn't thinking about cacheline placement, really, although you're
right, under some custom configs it may indeed push the bit from the
second to the third cache line.

The problem is that I can't make the bit optional if it sits this far
up in the bitfield because (as mentioned) 2 bit fields start to
straddle bytes. And that leads to holes.

WiFi is a bit lucky because it has 2 bits and largest fields are also 
2b so it can't cause straddling when Kconfig'ed out.
