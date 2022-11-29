Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D0E163B77A
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 02:54:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234989AbiK2Byz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 20:54:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235033AbiK2Byy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 20:54:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B65F4199E
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 17:54:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0DC12B8102C
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 01:54:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B564C433D6;
        Tue, 29 Nov 2022 01:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669686889;
        bh=13SioameIg4eH+Ap+2OrdlsH9c0G0mkesRPIcmhblCY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ArM3eplFUPkueO8HwvEsbc8Y3GV0J45HcmXypPhvM5yhRCFJ6XwNfckp5GJVdC6XC
         bSY3lYgnhHYRlGLdzH7/7oZbSCaP9MRPrzWCIkyGJXT2t2vsCRb+JSfXCx+KGWq+eB
         ZZzGfVlY1M1AUuiSDHLxfZUduGxMHOnz13wNUb/bo33Kr1Hi4kBPiR5IIgk3q1fskB
         LQOYsh1LRWAp9Mtq0fTu41o6lJUl90h2wgAqk6VRyISn/YHM1KekTr7MJaQEVbDXDk
         qsWTdgw5xroOAv3phPs5janOTqwV3WG0qRA48aGN+dGmRsk9MeFoliwN0a+VF9plW9
         eXiip68aJqo8Q==
Date:   Mon, 28 Nov 2022 17:54:48 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shannon Nelson <shnelson@amd.com>
Cc:     Shannon Nelson <snelson@pensando.io>, netdev@vger.kernel.org,
        davem@davemloft.net, mst@redhat.com, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org, drivers@pensando.io
Subject: Re: [RFC PATCH net-next 08/19] pds_core: initial VF configuration
Message-ID: <20221128175448.3723f5ee@kernel.org>
In-Reply-To: <51330a32-1fa1-cc0f-e06e-b4ac351cb820@amd.com>
References: <20221118225656.48309-1-snelson@pensando.io>
        <20221118225656.48309-9-snelson@pensando.io>
        <20221128102828.09ed497a@kernel.org>
        <d24a9900-154f-ad3a-fef4-73a57f0cddb0@amd.com>
        <20221128153719.2b6102cc@kernel.org>
        <75072b2a-0b69-d519-4174-6d61d027f7d4@amd.com>
        <20221128165522.62dcd7be@kernel.org>
        <51330a32-1fa1-cc0f-e06e-b4ac351cb820@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 28 Nov 2022 17:08:28 -0800 Shannon Nelson wrote:
> > Don't even start with the "our device is simple and only needs
> > the legacy API" line of arguing :/  
> 
> I'm not sure what else to say here - yes, we have a fancy and complex 
> piece of hardware plugged into the PCI slot, but the device that shows 
> up on the PCI bus is a very constrained model that doesn't know anything 
> about switchdev kinds of things.

Today it is, but I presume it's all FW underneath. So a year from now
you'll be back asking for extensions because FW devs added features.

> >> The device model presented to the host is a simple PF with VFs, not a
> >> SmartNIC, thus the pds_core driver sets up a simple PF netdev
> >> "representor" for using the existing VF control API: easy to use,
> >> everyone knows how to use it, keeps code simple.
> >>
> >> I suppose we could have the PF create a representor netdev for each
> >> individual VF to set mac address and read stats, but that seems  
> > 
> > Oh, so the "representor" you mention in the cover letter is for the PF?  
> 
> Yes, a PF representor simply so we can get access to the .ndo_set_vf_xxx 
> interfaces.  There is no network traffic running through the PF.

In that case not only have you come up with your own name for 
a SmartNIC, you also managed to misuse one of our existing terms 
in your own way! It can't pass any traffic it's just a dummy to hook
the legacy vf ndos to. It's the opposite of what a repr is.
