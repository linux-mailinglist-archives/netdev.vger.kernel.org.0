Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 583B659ECFE
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 22:03:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231669AbiHWUCx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 16:02:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233815AbiHWUCk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 16:02:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B38525D0C6
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 12:15:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4F11161629
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 19:15:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A05CC433C1;
        Tue, 23 Aug 2022 19:15:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661282128;
        bh=LViHEoViCLMP+Hutt4pd1t+XdPwvLPV3hiH2du5/Hto=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UUNoh4qCF94dxXPvoVR82GLYqDx0trNg5j07s7+onmF8JQaqD00Cuc+mtVpF6hF2s
         8eqSDj8RU6PV2Cnw6AZKQAD2I0illO9KEEIyzoa59aOq7xIZUAPcuIE3bPvO/TsWvK
         ACx+pJl1aRL8mCxiDidNkcnjIHhLsCpPAVQZlT1BKf7g4mjZ/wHAbkxQsmQSlCPiO2
         hCc2XO1gKk3j+xYjSNlxConly+KCUdWdQp6GqAyhLuf/6j2Zvqr1pMwMyzD2tZqkM5
         nk+adODs+fPCz1kMf6QRjtlNSspJ36Y0bujuuzNfUqzEvyE5lL/Fznr5VAB070Y9A6
         txkN8RSTlkm8A==
Date:   Tue, 23 Aug 2022 12:15:27 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>
Cc:     netdev@vger.kernel.org, dev@openvswitch.org, pshelar@ovn.org,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        ptikhomirov@virtuozzo.com, alexander.mikhalitsyn@virtuozzo.com,
        avagin@google.com, brauner@kernel.org, mark.d.gray@redhat.com,
        i.maximets@ovn.org, aconole@redhat.com
Subject: Re: [PATCH net-next v2 1/3] openvswitch: allow specifying ifindex
 of new interfaces
Message-ID: <20220823121527.46efd279@kernel.org>
In-Reply-To: <0989bea9-beb3-3eb1-eb55-3438f980d973@virtuozzo.com>
References: <20220819153044.423233-1-andrey.zhadchenko@virtuozzo.com>
        <20220819153044.423233-2-andrey.zhadchenko@virtuozzo.com>
        <20220822183715.0bf77c40@kernel.org>
        <0989bea9-beb3-3eb1-eb55-3438f980d973@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 23 Aug 2022 16:50:21 +0300 Andrey Zhadchenko wrote:
> > Are you 100% sure that all user space making this call initializes
> > dp_ifindex to 0? There is no validation in the kernel today that
> > the field is not garbage as far as I can tell.
> > 
> > If you are sure, please add the appropriate analysis to the commit msg.  
> 
> I am not sure that *all* users set dp_ifindex to zero. At least I do not 
> know about them. Primary ovs userspace ovs-vswitchd certainly set to 
> zero, others like WeaveNet do it too. But there can be more?
> What is the policy regarding this? I can add a new attribute, it is not 
> hard.

IDK how many user space components driving OvS exist out there.
We could risk it and reuse the field, but if we get it wrong 
and don't catch the regression before the final release is cut 
the result gets _really_ ugly. We will have _some_ user space
out there expecting us to use ifindex and _some_ which expects
it can pass garbage, so we can neither revert not leave it...
If that makes sense.

If using / adding attribute is not a hassle that'd be my vote.

Using fixed structs like struct ovs_header is strongly discouraged
for new families exactly because of situations like this :(
