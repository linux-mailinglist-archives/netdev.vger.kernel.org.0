Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 120426D9966
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 16:17:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239046AbjDFORN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 10:17:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237723AbjDFORL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 10:17:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FA335272
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 07:17:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 29B3B60C01
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 14:17:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A18CC433EF;
        Thu,  6 Apr 2023 14:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680790629;
        bh=6W2QETE0MZhfUFwOZWriS3Gmp5rs16CEmwFYkWACsyw=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=DsRLK4qQAAsv5Nv1iaZyTESmytNtghlEM6TQHhUmEHY/J/2Gx729pLNJ6wifpbJBO
         ug1OAkf08uf4hJleRQ4wnfhONOJz/YEplOBhWwGP+LI0ws0hLAOTbwzgmHuBqWLOp+
         qPO3C6WooNkxiGC7vcnsy1rj7W9d3uireo83CY3Nav420k9dXY1MfL9w1z/monYfMX
         elUK4dHXxZ7pTfHdCuO/rSb+vqx7OER8kH+9nET9Y1P3+naS3Sc0R3q5vlPZeYDrg0
         Z1V/sA/mbGB0FrLeb/FiQ2eO19lVh4MfH+b74yXMTjbig4NW29SSXI4haMm9EjSwcu
         /HuYjAfDbc0Hg==
Received: by paulmck-ThinkPad-P72.home (Postfix, from userid 1000)
        id 2D0A115404B4; Thu,  6 Apr 2023 07:17:09 -0700 (PDT)
Date:   Thu, 6 Apr 2023 07:17:09 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Alexander Duyck <alexander.duyck@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com
Subject: Re: [PATCH net-next 1/3] net: provide macros for commonly copied
 lockless queue stop/wake code
Message-ID: <dba8aec7-f236-4cb6-b53b-fabefcfa295a@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <20230401051221.3160913-2-kuba@kernel.org>
 <c39312a2-4537-14b4-270c-9fe1fbb91e89@gmail.com>
 <20230401115854.371a5b4c@kernel.org>
 <CAKgT0UeDy6B0QJt126tykUfu+cB2VK0YOoMOYcL1JQFmxtgG0A@mail.gmail.com>
 <20230403085601.44f04cd2@kernel.org>
 <CAKgT0UcsOwspt0TEashpWZ2_gFDR878NskBhquhEyCaN=uYnDQ@mail.gmail.com>
 <20230403120345.0c02232c@kernel.org>
 <CAKgT0Ue-hEycSyYvVJt0L5Z=373MyNPbgPjFZMA5j2v0hWg0zg@mail.gmail.com>
 <1e9bbdde-df97-4319-a4b7-e426c4351317@paulmck-laptop>
 <ZC5VbfkTIluwKYDn@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZC5VbfkTIluwKYDn@gondor.apana.org.au>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 06, 2023 at 01:15:25PM +0800, Herbert Xu wrote:
> On Wed, Apr 05, 2023 at 03:20:39PM -0700, Paul E. McKenney wrote:
> >
> > Mightn't preemption or interrupts cause further issues?  Or are preemption
> > and/or interrupts disabled across the relevant sections of code?
> 
> The code in question is supposed to run in softirq context.  So
> both interrupts and preemption should be disabled.

Agreed, preemption will be enabled in softirq, but interrupts can still
happen, correct?

							Thanx, Paul
