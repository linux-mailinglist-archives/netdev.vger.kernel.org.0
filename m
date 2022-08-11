Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7951F590775
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 22:37:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235721AbiHKUhK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 16:37:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbiHKUhI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 16:37:08 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EF8C95AF7;
        Thu, 11 Aug 2022 13:37:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A0FFECE2210;
        Thu, 11 Aug 2022 20:37:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53367C433C1;
        Thu, 11 Aug 2022 20:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660250224;
        bh=iAHSIcwc9lbNY2SNrS1flvARRGdNR3L+I0y3PoflCcI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HMjG+IDKqiprCA8C+eGLm7H7/UfNH7v7if4AvU6pWjH8Zo5AXbGeyAmrCYLv/FjJU
         btx354rFfR3j4/k4qFoanNIdC198ZccrwpuH8cijfn5l0iWk5eHSvz/vWcTl2eqLrj
         Vx0MBtPgwt163EyamiO2U0jbNZbIEnIa61fV7lHisOINxgxE6EpzceIe+B04Q20Hpz
         kJoxm5W9sobbU+QIke9mz3rIp1Qt3161bilb54A01bDeE0lWUsDxohzKYCz98pIoMa
         ndVaG0UJFntMQhdI78IeHdzCw9HinC6CyTbfK7EfyiOHZ/yZj4QGYbhrqqqMOuVpGC
         CN/HHmR/Pyslw==
Date:   Thu, 11 Aug 2022 13:37:03 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        linux-next@vger.kernel.org,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        linux-mips@vger.kernel.org
Subject: Re: build failure of next-20220811 due to 332f1795ca20 ("Bluetooth:
 L2CAP: Fix l2cap_global_chan_by_psm regression")
Message-ID: <20220811133703.30fb948e@kernel.org>
In-Reply-To: <CABBYNZKxM5Z2CUah1EB2uUDs=gEgDbrK0B9gbxeoyvtL6g=4+w@mail.gmail.com>
References: <YvVQEDs75pxSgxjM@debian>
        <20220811124637.4cdb84f1@kernel.org>
        <CABBYNZKxM5Z2CUah1EB2uUDs=gEgDbrK0B9gbxeoyvtL6g=4+w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 11 Aug 2022 13:20:52 -0700 Luiz Augusto von Dentz wrote:
> > +static inline int ba_is_any(const bdaddr_t *ba)
> > +{
> > +       return memchr_inv(ba, sizeof(*ba), 0);
> > +}  
> 
> So we can't use something like BDADDR_ANY to compare? Anyway afaik
> these were already present before the patch so I do wonder what had
> trigger it show now or perhaps it was being suppressed before and
> since we change it now start showing again?

Yeah, I mentioned that in my previous reply as well, a quick grep
counts 70 instances, IDK what makes the l2cap code different :S
Then again I don't know how the compiler deals with passing a pointer
to a constant to an inline function.... so I figured memchr_inv()
could help us avoid hitting compiler bugs.
