Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 553F9663E75
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 11:44:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232258AbjAJKoW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 05:44:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231138AbjAJKoT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 05:44:19 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A04011C03
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 02:43:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673347414;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fZBKvQMceZgcl0dsKrtIvBjnZJTQHen6mKpSsPs1Jyw=;
        b=MrWM3dKcpWnyqRgrIytCBON7tT6whM6I0CbVtOpkSzVYXdU8m7HZ2KhHuQ8aAeRyJ57h7E
        17XpfcD1AsEdxhjhheugKJP9de4LjhCNXDR+/MoL/YhyzTx1XqzT8lUv5FlhHUYvX91fUk
        SrtTlbM8LlS9uGE2kW9XViUPwKqGDrQ=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-664-FsHh_50fNSOj_KpBzuRRGQ-1; Tue, 10 Jan 2023 05:43:33 -0500
X-MC-Unique: FsHh_50fNSOj_KpBzuRRGQ-1
Received: by mail-qk1-f199.google.com with SMTP id bi3-20020a05620a318300b00702545f73d5so8389239qkb.8
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 02:43:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fZBKvQMceZgcl0dsKrtIvBjnZJTQHen6mKpSsPs1Jyw=;
        b=gnNk7Pi3GolAKKXgI8P+/KOW++B7ZBgFxwU3BFub5WGiSmjSdN5C812g1L1YnHRWiX
         MGTjMr4CapHCXlQVTg4DWGuiGG2e5c2ntz3pmRmtPScdAH40jBiZlL4QN4F9coDG+8+L
         7sSlH4x7DJ/aESZE+9JA4Ls5ga9polQbhENKAdC8ylKU3OtB2Ct3CbZ9oRkyXyNUL3KG
         L84OCCIVfTJTLX6mnhWvbSC09lLm4tQM1u+IQWGcb/r2BpVUJhliBX1G2u9Z7pu3+qQR
         GjjTpCY2rNnuyVi2vpHrDZ5LUVhH+xz1pg/LzUzvA2P0yVaR2EVaofPY977+4IdpWFvK
         emHA==
X-Gm-Message-State: AFqh2krvov6D57rbTsVf2so/CQZh+HRNs88t+wIh1AT62KSrYMy5B8Ii
        SdN5bKJ74sRUWCJqLWyyXZf/dzhgO4bF4EVDYDoRYbY+ap3mR+/HPlWB38I1/a3YRAy5421Fuvu
        DU4bvMBCjh2DMpheu
X-Received: by 2002:ac8:1249:0:b0:3a8:270:c0b8 with SMTP id g9-20020ac81249000000b003a80270c0b8mr2982710qtj.15.1673347412590;
        Tue, 10 Jan 2023 02:43:32 -0800 (PST)
X-Google-Smtp-Source: AMrXdXv00NOahDtg8Y9/N2J83JwBSjdxkH/YXNcyXRvFHAxWKvlH5MFlX0naAaYvKaG/tVYx9GXE0w==
X-Received: by 2002:ac8:1249:0:b0:3a8:270:c0b8 with SMTP id g9-20020ac81249000000b003a80270c0b8mr2982690qtj.15.1673347412360;
        Tue, 10 Jan 2023 02:43:32 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-120-128.dyn.eolo.it. [146.241.120.128])
        by smtp.gmail.com with ESMTPSA id o5-20020a05620a2a0500b006fcc437c2e8sm7011883qkp.44.2023.01.10.02.43.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jan 2023 02:43:31 -0800 (PST)
Message-ID: <79108835e679706d138afc33a19a96ed4a1f71ea.camel@redhat.com>
Subject: Re: [net PATCH] octeontx2-pf: Fix resource leakage in VF driver
 unbind
From:   Paolo Abeni <pabeni@redhat.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Hariprasad Kelam <hkelam@marvell.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        edumazet@google.com, sgoutham@marvell.com, gakula@marvell.com,
        sbhatta@marvell.com
Date:   Tue, 10 Jan 2023 11:43:28 +0100
In-Reply-To: <Y7098K4iMjPyAWww@unreal>
References: <20230109061325.21395-1-hkelam@marvell.com>
         <167334601536.23804.3249818012090319433.git-patchwork-notify@kernel.org>
         <Y7098K4iMjPyAWww@unreal>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Tue, 2023-01-10 at 12:29 +0200, Leon Romanovsky wrote:
> On Tue, Jan 10, 2023 at 10:20:15AM +0000, patchwork-bot+netdevbpf@kernel.org wrote:
> > Hello:
> > 
> > This patch was applied to netdev/net.git (master)
> > by Paolo Abeni <pabeni@redhat.com>:
> > 
> > On Mon, 9 Jan 2023 11:43:25 +0530 you wrote:
> > > resources allocated like mcam entries to support the Ntuple feature
> > > and hash tables for the tc feature are not getting freed in driver
> > > unbind. This patch fixes the issue.
> > > 
> > > Fixes: 2da489432747 ("octeontx2-pf: devlink params support to set mcam entry count")
> > > Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
> > > Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
> > > 
> > > [...]
> > 
> > Here is the summary with links:
> >   - [net] octeontx2-pf: Fix resource leakage in VF driver unbind
> >     https://git.kernel.org/netdev/net/c/53da7aec3298
> 
> I don't think that this patch should be applied.
> 
> It looks like wrong Fixes to me and I don't see clearly how structures
> were allocated on VF which were cleared in this patch.

My understanding is that the resource allocation happens via:

otx2_dl_mcam_count_set()

which is registered as the devlink parameter write operation on the vf
by the fixes commit - the patch looks legit to me.

Did I miss something?

Thanks!

Paolo

