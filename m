Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48516556F41
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 01:56:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234198AbiFVXzy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 19:55:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232190AbiFVXzx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 19:55:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE450326CE
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 16:55:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8A738B8216B
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 23:55:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A3BFC34114;
        Wed, 22 Jun 2022 23:55:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655942148;
        bh=RZNv/ClTYKcU7lvqJsn4yhRssl+j3a6w+em4P097bRQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Iq+sTuQwHEkKBSfyCah50Ls4PvCwwkj8UZGOBQwJJXGfVQrMtZieFCrBx+j1KZInf
         pimY52aMGUn5vjtA73WsghyAJCeYJtElK5bb7E9C6IRsJYib9z6GG9CH8QBns6RF8d
         0/MOB6hqPbjCZmnP3XTuQG9Jd6JNjFy+/DPkpPKArkbE/e2BuTCI7DblmS3Yci4Cxv
         Pd0OenDat5Eil5YbhjaCIcmbWAdciF0yhrvwz17oU9g+2hFp40CNp3HLRwXZTTFZdd
         p8gMx01NzSCRvpd03oMBLrl9sVFEaAEq3bXV/KaWVbSrd65C4Tsu72os8spmq3ayjV
         suRHGwY6G1T4g==
Date:   Wed, 22 Jun 2022 16:55:47 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ismael Luceno <iluceno@suse.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: Netlink NLM_F_DUMP_INTR flag lost
Message-ID: <20220622165547.71846773@kernel.org>
In-Reply-To: <20220622131218.1ed6f531@pirotess>
References: <20220615171113.7d93af3e@pirotess>
        <20220615090044.54229e73@kernel.org>
        <20220616171016.56d4ec9c@pirotess>
        <20220616171612.66638e54@kernel.org>
        <20220617150110.6366d5bf@pirotess>
        <20220622131218.1ed6f531@pirotess>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 22 Jun 2022 13:12:18 +0200 Ismael Luceno wrote:
> So, just for clarification:
> 
> Scenario 1:
> - 64 KB packet is filled.
> - protocol table shrinks
> - Next iteration finds it's done
> - next protocol clears the seq, so nothing is flaged
> - ...
> - NLMSG_DONE (not flagged)
> 
> Scenario 2:
> - 64 KB packet is filled.
> - protocol table shrinks
> - Next iteration finds it's done
> - NLMSG_DONE (flagged with NLM_F_DUMP_INTR)
> 
> So, in order to break as little as possible, I was thinking about
> introducing a new packet iff it happens we have to signal INTR between
> protocols.
> 
> Does that sound good?

Right, the question is what message can we introduce here which would
not break old user space?

The alternative of not wiping the _DUMP_INTR flag as we move thru
protocols seems more and more appealing, even tho I was initially
dismissive.

We should make sure we do one last consistency check before we return 0
from the handlers. Or even at the end of the loop in rtnl_dump_all().
