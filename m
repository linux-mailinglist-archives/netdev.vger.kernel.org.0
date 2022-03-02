Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82EEB4CA9C6
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 17:04:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238068AbiCBQFZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 11:05:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230369AbiCBQFY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 11:05:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51F4A7304B
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 08:04:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E3AB9617B9
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 16:04:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26976C004E1;
        Wed,  2 Mar 2022 16:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646237080;
        bh=vzeEq3lbPgMKW8WL7ZArBvrz19ZTwaBun89IMZOdimY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=t4Umbw1rUM+r/Dg1R/4KHbpSQ2L9PHddDVyuR9CeZ8nSKQZzjfi7J6I/ehv1vEMRe
         J/OMk+LahNGt/QgokAH/CwUzp8U8KcqF40ch+4TSpubrbQokgO8lu4kMn6wKK0mkUg
         vc2dhJP4PVWx9MOjQl6K+VLMPOnUEWpFUc+YQNSmTKat0QO16+2Rr7ngzT3Mv3E+6s
         0MCDWPfdAu0S7Py42OGvgncXZhCr25EWb8ZsBqGvjkuaiwU0Fku55O+OOwgRiVW5db
         ySZNLbaUgYn6DM9SMvOt5BVzGnRyzPemDFrmnrlfp3GacYYGZoBcs9tgZeeyBA3AfR
         84G0rb8YWKx2A==
Date:   Wed, 2 Mar 2022 08:04:39 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Kai =?UTF-8?B?TMO8a2U=?= <kailueke@linux.microsoft.com>,
        Paul Chaignon <paul@cilium.io>,
        Eyal Birger <eyal.birger@gmail.com>, <netdev@vger.kernel.org>
Subject: Re: [PATCH 1/2] Revert "xfrm: interface with if_id 0 should return
 error"
Message-ID: <20220302080439.2324c5d0@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220301161001.GV1223722@gauss3.secunet.de>
References: <20220301131512.1303-1-kailueke@linux.microsoft.com>
        <CAHsH6Gtzaf2vhSv5sPpBBhBww9dy8_E7c0utoqMBORas2R+_zg@mail.gmail.com>
        <d5e58052-86df-7ffa-02a0-fc4db5a7bbdf@linux.microsoft.com>
        <CAHsH6GsxaSgGkF9gkBKCcO9feSrsXsuNBdKRM_R8=Suih9oxSw@mail.gmail.com>
        <20220301150930.GA56710@Mem>
        <dcc83e93-4a28-896c-b3d3-8d675bb705eb@linux.microsoft.com>
        <20220301161001.GV1223722@gauss3.secunet.de>
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

On Tue, 1 Mar 2022 17:10:01 +0100 Steffen Klassert wrote:
> > I see this as a very generic question of changing userspace behavior or
> > not, regardless if we know how many users are affected, and from what I
> > know there are similar cases in the kernel where the response was that
> > breaking userspace is a no go - even if the intention was to be helpful
> > by having early errors.  
> 
> In general I agree that the userspace ABI has to be stable, but
> this never worked. We changed the behaviour from silently broken to
> notify userspace about a misconfiguration.
> 
> It is the question what is more annoying for the users. A bug that
> we can never fix, or changing a broken behaviour to something that
> tells you at least why it is not working.
> 
> In such a case we should gauge what's the better solution. Here
> I tend to keep it as it is.

Agreed. FWIW would be great if patch #2 started flowing towards Linus'es
tree separately if the discussion on #1 is taking longer.
