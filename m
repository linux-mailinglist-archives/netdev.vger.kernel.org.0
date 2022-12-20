Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E088E65187F
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 02:48:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233341AbiLTBs3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Dec 2022 20:48:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229895AbiLTBsI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Dec 2022 20:48:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 073793B2;
        Mon, 19 Dec 2022 17:45:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B0FD3B80F4B;
        Tue, 20 Dec 2022 01:45:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18657C433EF;
        Tue, 20 Dec 2022 01:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671500706;
        bh=hOgDKRG3QN2KDKqTDB9a6+ebhkTn4QldF3NgP7ikdJM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NJ83dciTECgvqrgdnpb+ZUIawQovLwJ6o5rWXILaky5MYZxj4w+7/0o+jt7dLKdIw
         Gw8FHNbYdZW0b2pb48oLRG++r5XGutH6ux1zxZy0va0VNGcCjCOWADcCe0HBJKggG0
         yq2KZ1kTWTptHQylJyFx/fMl/M0Q9UqLwp6yl9gvL+/9kL4ZV9dsSiLh3DCqwXBZuD
         /moIYFzleVgOwIeDbZGRAamS7U7eVJzRvGJiXRrb1bwq8KEzrUfpdaUXNpocZBodpo
         UT1Jiny8JoIDz5jVMk9tBOxqh8dXyrZiJv4FixhTgy+AdBLyYFogEH38fRQ11TGG1J
         QJktp6oPlJprg==
Date:   Mon, 19 Dec 2022 17:45:05 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     daniel@iogearbox.net, bpf@vger.kernel.org, netdev@vger.kernel.org,
        Anand Parthasarathy <anpartha@meta.com>, martin.lau@linux.dev,
        song@kernel.org, john.fastabend@gmail.com
Subject: Re: [PATCH bpf 1/2] bpf: pull before calling skb_postpull_rcsum()
Message-ID: <20221219174505.67014ea5@kernel.org>
In-Reply-To: <CAKH8qBvVTHXsgVLHuCmdFM1dnYEiDFovOFfXNq1=8igPCCO7jQ@mail.gmail.com>
References: <20221220004701.402165-1-kuba@kernel.org>
        <CAKH8qBvVTHXsgVLHuCmdFM1dnYEiDFovOFfXNq1=8igPCCO7jQ@mail.gmail.com>
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

On Mon, 19 Dec 2022 17:21:27 -0800 Stanislav Fomichev wrote:
> > -       skb_postpull_rcsum(skb, skb->data + off, len);
> > -       memmove(skb->data + len, skb->data, off);
> > +       old_data = skb->data;
> >         __skb_pull(skb, len);  
> 
> [..]

Very counter-productively trimmed ;)

> > +       skb_postpull_rcsum(skb, old_data + off, len);  
> 
> Are you sure about the 'old_data + off' part here (for
> CHECKSUM_COMPLETE)? Shouldn't it be old_data?

AFAIU before:

      old_data (aka skb->data before)
     /
    / off  len 
   V-----><--->
[ .=======xxxxx... buffer ...... ]
          ^
           \
            the xxx part is what we delete

after:
          skb->data (after)
         /
        v
[ .yyyyy=======... buffer ...... ]
   <---><----->
    len   off  
   ^
    \
     the yyy part is technically the old values of === but now "outside"
     of the valid packet data

> I'm assuming we need to negate the old parts that we've pulled?

Yes.

> Maybe safer/more correct to do the following?
> 
> skb_pull_rcsum(skb, off);

This just pulls from the front, we need to skip over various L2/L3
headers thanks to off. Hopefully the diagrams help, LMK if they are
wrong.

> memmove(skb->data, skb->data-off, off);
