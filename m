Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8507615DB1
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 09:32:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229909AbiKBIcG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 04:32:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbiKBIcE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 04:32:04 -0400
Received: from rs07.intra2net.com (rs07.intra2net.com [85.214.138.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EBC0240AF
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 01:32:03 -0700 (PDT)
Received: from mail.m.i2n (unknown [172.17.128.1])
        (using TLSv1.2 with cipher ADH-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by rs07.intra2net.com (Postfix) with ESMTPS id 1DAF01500138;
        Wed,  2 Nov 2022 09:32:01 +0100 (CET)
Received: from localhost (mail.m.i2n [127.0.0.1])
        by localhost (Postfix) with ESMTP id EE96259A;
        Wed,  2 Nov 2022 09:32:00 +0100 (CET)
X-Virus-Scanned: by Intra2net Mail Security (AVE=8.3.64.216,VDF=8.19.27.66)
X-Spam-Status: 
Received: from localhost (storm.m.i2n [172.16.1.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.m.i2n (Postfix) with ESMTPS id F41DB57B;
        Wed,  2 Nov 2022 09:31:59 +0100 (CET)
Date:   Wed, 2 Nov 2022 09:31:59 +0100
From:   Thomas Jarosch <thomas.jarosch@intra2net.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Antony Antony <antony.antony@secunet.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Leon Romanovsky <leon@kernel.org>, Roth Mark <rothm@mail.com>,
        Zhihao Chen <chenzhihao@meizu.com>,
        Tobias Brunner <tobias@strongswan.org>, netdev@vger.kernel.org
Subject: Re: [PATCH] xfrm: Fix oops in __xfrm_state_delete()
Message-ID: <20221102083159.2rqu6j27weg2cxtq@intra2net.com>
References: <20221031152612.o3h44x3whath4iyp@intra2net.com>
 <Y2CjFGCHGaMMTrHu@gondor.apana.org.au>
 <Y2FvHZiWejxRiIS8@moon.secunet.de>
 <Y2IXTc1M6K7KaQwW@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y2IXTc1M6K7KaQwW@gondor.apana.org.au>
User-Agent: NeoMutt/20180716
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Herbert,

You wrote on Wed, Nov 02, 2022 at 03:07:57PM +0800:
> > xfrm_user sets msg_seq to zero in mapping change message. seq is only useful for
> 
> Oh I had misread the patch and thought this was send_acquire.

it's a complex bug after all ^^ it took many printks() to trace
the flow of the state corruption on the production system.

> > acquire message. I think setting to zero would be a better fix.
> > 
> > -	hdr->sadb_msg_seq = x->km.seq = get_acqseq();
> > +	hdr->sadb_msg_seq = 0;
> > 
> > While increasing x->km.seq in every call to pfkey_send_new_mapping()
> > could be an issue, would it alone explan the crash?
> 
> Probably, if you change the state without moving it to the right
> hash slot then the xfrm state hash table will be inconsistent.

in the observed cases, km.seq is always zero before. So it was never added to
the byseq hash table in the first place, resulting in the NULL pointer Oops.

If km.seq would be non-zero before entering pfkey_send_new_mapping(),
then of course the xfrm_state would stay in the wrong hash table bucket.
The only other xfrm_states I've seen in my extensive tracing with a non-zero 
sequence number were ACQUIRE states and I'm not sure those will ever end up on 
the pfkey_send_new_mapping() code path. Either way, let's fix the root cause.

> We should copy the xfrm_user behaviour which is to leave x->km.seq
> alone.  So the patch should change the above line to
> 
> 	hdr->sadb_msg_seq = x->km.seq;

thanks for your feedback, I'll update the patch and send a v2.
I'll also put it in production tonight.

Cheers,
Thomas
