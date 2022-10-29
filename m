Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 386F061248E
	for <lists+netdev@lfdr.de>; Sat, 29 Oct 2022 19:09:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbiJ2RJF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Oct 2022 13:09:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbiJ2RJE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Oct 2022 13:09:04 -0400
Received: from rp02.intra2net.com (rp02.intra2net.com [62.75.181.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ED1B4BA5F
        for <netdev@vger.kernel.org>; Sat, 29 Oct 2022 10:09:03 -0700 (PDT)
Received: from mail.m.i2n (unknown [172.17.128.1])
        (using TLSv1.2 with cipher ADH-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by rp02.intra2net.com (Postfix) with ESMTPS id 655DB1000C1;
        Sat, 29 Oct 2022 19:09:01 +0200 (CEST)
Received: from localhost (mail.m.i2n [127.0.0.1])
        by localhost (Postfix) with ESMTP id 3F9D0739;
        Sat, 29 Oct 2022 19:09:01 +0200 (CEST)
X-Virus-Scanned: by Intra2net Mail Security (AVE=8.3.64.216,VDF=8.19.27.2)
X-Spam-Status: 
Received: from localhost (unknown [192.168.12.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.m.i2n (Postfix) with ESMTPS id 5752060A;
        Sat, 29 Oct 2022 19:08:58 +0200 (CEST)
Date:   Sat, 29 Oct 2022 19:08:57 +0200
From:   Thomas Jarosch <thomas.jarosch@intra2net.com>
To:     Zhihao Chen <chenzhihao@meizu.com>
Cc:     netdev@vger.kernel.org, baihaowen@meizu.com,
        steffen.klassert@secunet.com, Chonglong Xu <xuchonglong@meizu.com>
Subject: Re: [PATCH] xfrm:fix access to the null pointer in
 __xfrm_state_delete()
Message-ID: <20221029170857.jvjuogigbgf7sk2s@intra2net.com>
References: <20221027142455.3975224-1-chenzhihao@meizu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221027142455.3975224-1-chenzhihao@meizu.com>
User-Agent: NeoMutt/20180716
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Chen,

You wrote on Thu, Oct 27, 2022 at 02:24:55PM +0000:
> Validate the byseq node before removing it from the hlist of state_byseq.
> km.seq cannot be used to determine whether the SA is in the byseq hlist
> because xfrm_add_sa() may initialize km.seq to 0 and the SA is not inserted
> into hlist. In later network communication, the seq field will increase
> after the valid packet is received.
> 
> In the above case, the NULL pointer will be accessed and cause a kernel
> panic when the SA is being removed from hlist by checking km.seq field in
> __xfrm_state_delete().

thanks for your patch!

The solution is pretty close already, it's pfkey_send_new_mapping() from af_key.c 
messing with "x->km.seq" if a new NAT-T mapping is detected.

I'll send a patch for the root cause on Monday, the commit message will be 
the most delicate thing. I already checked different PF_KEYv2 based IPSec 
implementations how they behave regarding SADB_X_NAT_T_NEW_MAPPING.

Some details are public here already:
https://github.com/strongswan/strongswan/issues/992#issuecomment-1294651331

If you are using a modern IPSec userspace application like strongswan 5.x,
one can use the netlink xfrm interface and disable CONFIG_NET_KEY in
the kernel to completely avoid the issue with PF_KEYv2.
Also unloading the "af_key" kernel module helps.

Perhaps it might make sense to extend your patch to WARN_ON
in case we run into this situation again in the future?
Then we would not sweep the issue under the rug.

Cheers,
Thomas
