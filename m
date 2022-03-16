Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 156DA4DB830
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 19:50:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357766AbiCPSvs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 14:51:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354237AbiCPSvr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 14:51:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 550FA6BDDD;
        Wed, 16 Mar 2022 11:50:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0A806B81CD0;
        Wed, 16 Mar 2022 18:50:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8333C340E9;
        Wed, 16 Mar 2022 18:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647456629;
        bh=HKXqk6/mnqpMUrHS4oyqfOHpwHjzVR3TtUchgUEcPSY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QaxS/vjxuZrCi83G0FtgKlPvkavLFC8VGlXExI+owBQpahNp1Aom6lG/gS56wBYO2
         wr93aTju/ztvHbQAhDjs3OWHsKWUV2DxApFX5HB0rsJ38afWYgJkZI8wOhhSKLXW0E
         19zFXpxW4Agul/5bzCorbR2wcDrPjvryrWvIaX6g9kHaBP7Y+f+B+6LrJbqx+L6kLV
         9H0jFKR0+Zq1VtVKwSc3hu2ikY/4Srb09d8NP3K+rKU1qHPQZNJeqBBcWuYhb0Ez+J
         SXYBH4DYWpFn6xFQ9lFRFscvNNeBscyXeW1M6v43r/7MpR+uWttOOHBrdqNZvwEFqe
         CXHBCkZ3r9YkQ==
Date:   Wed, 16 Mar 2022 11:50:27 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Menglong Dong <menglong8.dong@gmail.com>
Cc:     David Ahern <dsahern@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, xeb@mail.ru,
        David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Menglong Dong <imagedong@tencent.com>,
        Eric Dumazet <edumazet@google.com>, Martin Lau <kafai@fb.com>,
        Talal Ahmad <talalahmad@google.com>,
        Kees Cook <keescook@chromium.org>,
        Alexander Lobakin <alobakin@pm.me>,
        Hao Peng <flyingpeng@tencent.com>,
        Mengen Sun <mengensun@tencent.com>, dongli.zhang@oracle.com,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Biao Jiang <benbjiang@tencent.com>
Subject: Re: [PATCH net-next 3/3] net: ipgre: add skb drop reasons to
 gre_rcv()
Message-ID: <20220316115027.7a153c4f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CADxym3Yj58gXe9kHRxNvxxMfNMYjvzbrdcq7sNAo6SQHXb98nQ@mail.gmail.com>
References: <20220314133312.336653-1-imagedong@tencent.com>
        <20220314133312.336653-4-imagedong@tencent.com>
        <20220315201706.464d5ecd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CADxym3Yj58gXe9kHRxNvxxMfNMYjvzbrdcq7sNAo6SQHXb98nQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 16 Mar 2022 14:21:24 +0800 Menglong Dong wrote:
> > I feel like gre_parse_header() is a good candidate for converting
> > to return a reason instead of errno.
> 
> Enn...isn't gre_parse_header() returning the header length? And I
> didn't find much useful reason in this function.

Ah, you're right, it returns negative error or hdr_len.
We'd need to make the reason negative, I guess that's not pretty.

What made me wonder is that it already takes a boolean for csum error
and callers don't care _which_ error gets returned. 

We can replace the csum_err output param with reason code, then?

> > >               goto drop;
> > >
> > >       if (unlikely(tpi.proto == htons(ETH_P_ERSPAN) ||
> > > -                  tpi.proto == htons(ETH_P_ERSPAN2))) {
> > > -             if (erspan_rcv(skb, &tpi, hdr_len) == PACKET_RCVD)
> > > -                     return 0;
> > > -             goto out;
> > > -     }
> > > +                  tpi.proto == htons(ETH_P_ERSPAN2)))
> > > +             ret = erspan_rcv(skb, &tpi, hdr_len);
> > > +     else
> > > +             ret = ipgre_rcv(skb, &tpi, hdr_len);  
> >
> > ipgre_rcv() OTOH may be better off taking the reason as an output
> > argument. Assuming PACKET_REJECT means NOMEM is a little fragile.  
> 
> Yeah, it seems not friendly. I think it's ok to ignore such 'NOMEM' reasons?
> Therefore, we only need to consider the PACKET_NEXT return value, and
> keep ipgre_rcv() still.
