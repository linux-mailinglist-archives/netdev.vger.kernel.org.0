Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DACB6C53BB
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 19:27:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230518AbjCVS1F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 14:27:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230262AbjCVS1E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 14:27:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96AF66285A
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 11:27:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 322D562267
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 18:27:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F92DC433EF;
        Wed, 22 Mar 2023 18:27:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679509622;
        bh=sbbDyJvcujuyJeht1hag+y9zwJYw9hMcKgz58ommyWY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KFfFT9X1s+CKoZFI7Ttzh29Y4qt52djWeKPvsbDmTBsCACzXipunCexVAgP3V27DR
         FMRg43ZPVw73R648K4UIwZUBnODmMWV7/pbCDs5rU0c+/1qAn49JajjhxA+kAwSIsf
         DafZHU4Qoii5cYeLuGmIZSlL3Dx4DnVft8HMWacMt/z5WLmP/ns7ZOb+pHR8l3xV7r
         w1DeSeyCa3RRnh7NVDa+/N5ea8Y/jodS+yIjXLZpphAf6xxt7auq42T8fKal2OEAFJ
         2AHpBVM1G6gaE9mSDT/UrNbVVmVMDz4GMXIJHaia/aT9jxu16Inw9zP2wftiT3jIG3
         FmMYVeUBdwBTA==
Date:   Wed, 22 Mar 2023 11:27:01 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Donald Hunter <donald.hunter@gmail.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, donald.hunter@redhat.com
Subject: Re: [PATCH net-next v2 3/6] tools: ynl: Add array-nest attr
 decoding to ynl
Message-ID: <20230322112701.6af8adf1@kernel.org>
In-Reply-To: <m2fs9xjaaq.fsf@gmail.com>
References: <20230319193803.97453-1-donald.hunter@gmail.com>
        <20230319193803.97453-4-donald.hunter@gmail.com>
        <20230321221809.26293ca7@kernel.org>
        <m2fs9xjaaq.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 22 Mar 2023 11:27:25 +0000 Donald Hunter wrote:
> > So in terms of C this treats the payload of the attr as a packed array?
> > That's not what array-nest is, array-nest wraps every entry in another
> > nlattr:
> > https://docs.kernel.org/next/userspace-api/netlink/genetlink-legacy.html#array-nest
> >
> > It's not a C array dumped into an attribute.
> >
> > IIRC I was intending to use 'binary' for packed arrays. Still use
> > sub-type to carry the type, but main type should be 'binary'.
> >
> > If that sounds reasonable could you document or remind me to document
> > this as the expected behavior? Sub-type appears completely undocumented
> > now :S  
> 
> That sounds reasonable, yes. I will also rename the method to
> 'as_c_array'. I think it should just be restricted to scalar subtypes,
> i.e. u16, u32, etc. Do you agree?

We can limit it to scalars for now. There are some arrays of structs
(from memory TC GRED had VCs defined as array of structs?) but that
should hopefully be rare and can be added later.
