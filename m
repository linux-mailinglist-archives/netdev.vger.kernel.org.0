Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCEAA56298A
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 05:24:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233306AbiGADXV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 23:23:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231532AbiGADXU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 23:23:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D83FB2ED6B;
        Thu, 30 Jun 2022 20:23:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6C6356226C;
        Fri,  1 Jul 2022 03:23:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AF15C34115;
        Fri,  1 Jul 2022 03:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656645798;
        bh=KZpbug7lW+gZ+75ZN+iIc9keYVBPjYjKul92BMRhmyI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BKO9lbQhXN7uiXevlFt1gKCNj5be9TIatZLXm8dCLkNJLXxW8p0syigeunNQCY8+a
         igGbGASD3ovtGE46J9qcoYcTNp+8F6OdCwJgT2ioY7UD9qwcBdTud6XLlArPqFmI5R
         A//7RcL2ms7A38QG7ej6wEcC92WXqahuJCEE8qtjMXNcJRyq2EIdWj9pja0+vzP68h
         6CwS3zWrGOvXUdnrFRgVsJvefFB3t/fBgbNWWZ2sfsab+KsPji0unz1tz91bjNSeeQ
         mzHubXQGKa3Fh0YmZlhVQ0dGlGM7reedf67NBLZGyBRCghIPWCBJ3xfz7rLcUFBtN/
         LX2ckUj3vuFdA==
Date:   Thu, 30 Jun 2022 20:23:17 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Cc:     netdev@vger.kernel.org, Taras Chornyi <tchornyi@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-kernel@vger.kernel.org (open list), lkp@intel.com,
        Yevhen Orlov <yevhen.orlov@plvision.eu>
Subject: Re: [PATCH V3 net-next 4/4] net: marvell: prestera: implement
 software MDB entries allocation
Message-ID: <20220630202317.0605dbd2@kernel.org>
In-Reply-To: <20220630111822.26004-5-oleksandr.mazur@plvision.eu>
References: <20220630111822.26004-1-oleksandr.mazur@plvision.eu>
        <20220630111822.26004-5-oleksandr.mazur@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 30 Jun 2022 14:18:22 +0300 Oleksandr Mazur wrote:
> Define bridge MDB entry (software entry):
>   - entry that get's created upon receiving MDB management events
>     (create/delete), that inherently defines a software entry,
>     which can be enabled (offloaded to the HW) or disabled (removed
>     from HW).
>     This separation is done to achieve a better highlevel
>     management of HW resources - software MDB entry could exist,
>     while it's not necessarily should be configured on the HW.
>     For example: by default, the Linux behavior would not replicate
>     multicast traffic to multicast group members if there's no
>     active multicast router and thus - no actual multicast traffic
>     can be received/sent. So, until multicast router appears on the
>     system no HW configuration should be applied, although SW MDB entries
>     should be tracked.
>     Another example would be altering state of 'multicast enabled' on
>     the bridge: MC_DISABLED should invoke disabling / clearing multicast
>     groups of specified bridge on the HW, yet upon receiving 'multicast
>     enabled' event, driver should reconfigure any existing software MDB
>     groups on the HW.
>     Keeping track of software MDB entries in such way makes it possible
>     to properly react on such events.
> Define bridge MDB port entry (software entry):
>   - entry that helps keeping track (on software - driver - level) of which
>     bridge mebemer interface joined any give MDB group;
> 
> Co-developed-by: Yevhen Orlov <yevhen.orlov@plvision.eu>
> Signed-off-by: Yevhen Orlov <yevhen.orlov@plvision.eu>
> Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>

clang says no:

drivers/net/ethernet/marvell/prestera/prestera_switchdev.c:1017:11: warning: variable 'err' is uninitialized when used here [-Wuninitialized]
                        return err;
                               ^~~
drivers/net/ethernet/marvell/prestera/prestera_switchdev.c:1012:9: note: initialize the variable 'err' to silence this warning
        int err;
               ^
                = 0
