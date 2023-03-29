Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BFAC6CF454
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 22:17:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229768AbjC2UR3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 16:17:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbjC2UR3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 16:17:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3025F30C7;
        Wed, 29 Mar 2023 13:17:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C8C56B82460;
        Wed, 29 Mar 2023 20:17:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47706C433EF;
        Wed, 29 Mar 2023 20:17:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680121045;
        bh=hL8RFP5Ifh21s7G7hUUcfXFMHxET6E1fGbTTxImEWGk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AyaxrvXAafae+DWlZ93pHbIZtf62VRj2NcOItL1m7RPnDFpfHTUBBSBo0HhJTlCIy
         RF2/QaMC2mYyoL2P7uv3OAV/kum55UPhYmlz1l6ueAbuKefnVWhlPSJp5UcpXf8rKC
         uG0n+bwyS+DvDNcq+jgHxY1sa9vaIcOahqw9o5smu7+0w1mfSPOvZMdgQl4b/Bwb+V
         HW+bGftGJI5VOBuGlUWFCuIcmgxiib+LkvUB/Ii7JLl+d0NVnaEdvB9i1ic4PdT/4k
         Rjbx+4SxyKtg86hdHUuJ/DOLY0s48924etUpzDVtGV64BMo0K6yeJQp1BlTwUIhJ94
         w27V/xR/KWkRw==
Date:   Wed, 29 Mar 2023 13:17:24 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Wolfram Sang <wsa+renesas@sang-engineering.com>
Cc:     netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Steve Glendinning <steve.glendinning@shawell.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v4] smsc911x: only update stats when interface is up
Message-ID: <20230329131724.4484a881@kernel.org>
In-Reply-To: <ZCSWJxuu1EY/zBFm@shikoro>
References: <20230329064010.24657-1-wsa+renesas@sang-engineering.com>
        <20230329123958.045c9861@kernel.org>
        <ZCSWJxuu1EY/zBFm@shikoro>
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

On Wed, 29 Mar 2023 21:48:55 +0200 Wolfram Sang wrote:
> > Hm, so you opted to not add the flag in the core?
> > To keep the backport small? I think we should just add it..
> > Clearly multiple drivers would benefit and it's not a huge change.  
> 
> I did it this way for two reasons. First, yes, this is a minimal patch
> for backporting. No dependency on core changes, very easy. Second, this
> is a solution I could develop quickly. I am interested in finding
> another solution, but I guess it needs more time, especially as it
> probably touches 15 drivers. I created an action item for it. I hope
> I'll be able to work on it somewhen. But for now, I just need the SMSC
> bug fixed and need to move to the next issue. If we later have the
> generic solution, converting this driver also won't make a lot of a
> difference.

Okay, core changes aside - does pm_runtime_put() imply an RCU sync?
Otherwise your check in get_stats is racy...
