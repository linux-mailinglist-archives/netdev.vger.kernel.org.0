Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9413F699836
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 16:01:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229700AbjBPPBJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 10:01:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbjBPPBI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 10:01:08 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B573194
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 07:00:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676559620;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=V3Q1Nn1WMlaxDlcP3CrK4rgA251A7AMCt039NreCe/k=;
        b=PUYSNtilS/YKBvZ8NHJLSbODZJMIRd0O4pHKG6I5/xdvLHztE+mKLha/D42BJwDKhx5lBw
        33hZY71z9nhOU9GLX+WLKodA9kJYbOnu5eIrW98irQ/isPDSrIJSlXI/eiUVY4vSpqfQHx
        8BDhF1+FZYI3CPcYjHNwbwm4PbeVu3c=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-349-SZrc0SfvOHSoNxmGbrSpKw-1; Thu, 16 Feb 2023 10:00:18 -0500
X-MC-Unique: SZrc0SfvOHSoNxmGbrSpKw-1
Received: by mail-qk1-f198.google.com with SMTP id s7-20020ae9f707000000b007294677a6e8so1326813qkg.17
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 07:00:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1676559616;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=V3Q1Nn1WMlaxDlcP3CrK4rgA251A7AMCt039NreCe/k=;
        b=tm5NllVGqHNH6YWfJ+2SOTvwFH565uqd4lxun23PaQrj2zqEvJxii99OwmOYpCOqG2
         KMQFJh+ogMd3xFJGpnVcCeQrb41cMXWRW+GbhWngRVs0JEZBV6SQmhMQzee0NrFt5jFv
         8l6g6bD7HGUuLlbvdy89WALi28Xw2QVX73WUaV/zJd2ClSq5BWvLZBXT2gGbITwwgLWd
         B+55G6YVez45NCZAXnyP0iq7m4fIdLyKKC1gLT9jf3yJp07VYHk04dofMX16EvytobCG
         snkgvObAC9mzzg+hZq6/w+hCj7XDhzhBrZ1G1tEXQCq0VplxL5YPctRMYnlKkJDH2KRg
         6xPA==
X-Gm-Message-State: AO0yUKX9TlewRHFP7mJYr6A8OWWaL/PMgojoNrPFqwR0CICiU7FMu7dq
        s+XB5q1aWrvanQgWtDN03I6eQb8iy5TmcgJBrNviHc6AW5RvX88iiOkcPdNItQAhJ5y97es1WjV
        hu0FCfpbtQ8lNXZdb
X-Received: by 2002:a05:622a:309:b0:3b8:6bef:61df with SMTP id q9-20020a05622a030900b003b86bef61dfmr11649737qtw.6.1676559616632;
        Thu, 16 Feb 2023 07:00:16 -0800 (PST)
X-Google-Smtp-Source: AK7set+nR0PxEVlrJVrX655ZFyBhWEbt0DAVWEkpxecE6xmJQmGgcmjRqy5ouFMg5zy9nRSffbTung==
X-Received: by 2002:a05:622a:309:b0:3b8:6bef:61df with SMTP id q9-20020a05622a030900b003b86bef61dfmr11649676qtw.6.1676559616203;
        Thu, 16 Feb 2023 07:00:16 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-121-8.dyn.eolo.it. [146.241.121.8])
        by smtp.gmail.com with ESMTPSA id g66-20020a37b645000000b0073b425f6e33sm1307215qkf.100.2023.02.16.07.00.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Feb 2023 07:00:15 -0800 (PST)
Message-ID: <34e0f928109507b07b7cfe3f0a6eb9201015acf0.camel@redhat.com>
Subject: Re: [PATCH net-next 2/2] skbuff: Add likely to skb pointer in
 build_skb()
From:   Paolo Abeni <pabeni@redhat.com>
To:     Gal Pressman <gal@nvidia.com>, Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Tariq Toukan <tariqt@nvidia.com>
Date:   Thu, 16 Feb 2023 16:00:12 +0100
In-Reply-To: <646f4e37-9020-a5af-ba02-9962afa96d08@nvidia.com>
References: <20230215121707.1936762-1-gal@nvidia.com>
         <20230215121707.1936762-3-gal@nvidia.com>
         <20230215150130.6c2662ea@kernel.org>
         <646f4e37-9020-a5af-ba02-9962afa96d08@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2023-02-16 at 16:55 +0200, Gal Pressman wrote:
> On 16/02/2023 1:01, Jakub Kicinski wrote:
> > On Wed, 15 Feb 2023 14:17:07 +0200 Gal Pressman wrote:
> > > -	if (skb && frag_size) {
> > > +	if (likely(skb) && frag_size) {
> >=20
> > Should frag_size also be inside the likely?
> > See the warning in __build_skb_around().
>=20
> Agree, thanks Jakub and Paolo.
>=20
> Do you want to fix it up when you take the patch, or should I submit a v2=
?

The way to address even such small changes is via re-submissions,
please send a v2, thanks!

Paolo

