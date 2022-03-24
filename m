Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F233B4E68AE
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 19:31:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346287AbiCXSc4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 14:32:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352288AbiCXScu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 14:32:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F71DAF1D2;
        Thu, 24 Mar 2022 11:31:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 17125B8250A;
        Thu, 24 Mar 2022 18:31:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CF63C340EC;
        Thu, 24 Mar 2022 18:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648146675;
        bh=jK/n2An+Oirig9bmO5kKG8nx46/EBs7+Ye6ENtAtATs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Cx9gltK7PGmvdJNUBTfsNGU4XivYWJE/AVDEGJuwFiSA9s9ilAOMIlC4n0mJ02BCp
         vqIttj3GtIN0Fnd7Y7nuEEbgwyIBAgNSVdM11YHq3H1pZYjpr+bDe8SH7qu3HfzH9l
         5PUw+Vl/unNCEEFw7qlOG3nXngDq4U09Es6vrjcqqVmjwqSjx4sYN0/4+CW1ifUO31
         sfoxMjE+0/E+9wuRu54t8OoSmaKzgT1wOZFCz3AmG/UyBfNzRupedMA1OFjdiOoP59
         X+fD75EIyW9KZqL3RMCJWmtC7WCbPhR8cKiTV41oAL/b2TTuUoev3YBRy8eyAcQe7a
         SxSr1CQE+vC5Q==
Date:   Thu, 24 Mar 2022 11:31:14 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, corbet@lwn.net,
        imagedong@tencent.com, edumazet@google.com, dsahern@kernel.org,
        talalahmad@google.com, linux-doc@vger.kernel.org
Subject: Re: [RFC net-next 2/3] skbuff: rewrite the doc for data-only skbs
Message-ID: <20220324113114.3d3e6ba8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <a172a650b503f69d3de49586de2fdec2d6a71e7a.camel@redhat.com>
References: <20220323233715.2104106-1-kuba@kernel.org>
        <20220323233715.2104106-3-kuba@kernel.org>
        <a172a650b503f69d3de49586de2fdec2d6a71e7a.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 24 Mar 2022 09:50:06 +0100 Paolo Abeni wrote:
> > +/**
> > + * DOC: dataref and headerless skbs
> > + *
> > + * Transport layers send out clones of data skbs they hold for retransmissions.
> > + * To allow lower layers of the stack to prepend their headers
> > + * we split &skb_shared_info.dataref into two halves.
> > + * The lower 16 bits count the overall number of references.
> > + * The higher 16 bits indicate number of data-only references.
> > + * skb_header_cloned() checks if skb is allowed to add / write the headers.  
> 
> Thank you very much for the IMHO much needed documentation!
> 
> Please allow me to do some non-native-english-speaker biased comments;)
> 
> The previous patch uses the form  "payload data" instead of data-only,
> I think it would be clearer using consistently one or the other. I
> personally would go for "payload-data-only" (which is probably a good
> reason to pick a different option).

That starts to get long. Let me go for payload everywhere.

> > - * All users must obey the rule that the skb->data reference count must be
> > - * greater than or equal to the payload reference count.
> > + * The creator of the skb (e.g. TCP) marks its data-only skb as &sk_buff.nohdr
> > + * (via __skb_header_release()). Any clone created from marked skb will get
> > + * &sk_buff.hdr_len populated with the available headroom.
> > + * If it's the only clone in existence it's able to modify the headroom at will.  
> 
> I think it would be great if we explicitly list the expected sequence,
> e.g.
> 	<alloc skb>
> 	skb_reserve
> 	__skb_header_release
> 	skb_clone

Will do!
