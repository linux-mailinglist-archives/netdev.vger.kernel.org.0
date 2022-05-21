Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8467C52FD7A
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 16:59:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238772AbiEUO7g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 May 2022 10:59:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232481AbiEUO7e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 May 2022 10:59:34 -0400
Received: from salt.gogi.eu (salt.gogi.eu [IPv6:2001:8d8:8a9:3f10::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68E537A454
        for <netdev@vger.kernel.org>; Sat, 21 May 2022 07:59:32 -0700 (PDT)
Received: from [IPV6:2001:4090:a242:8012::acd] (unknown [IPv6:2001:4090:a242:8012::acd])
        by salt.gogi.eu (Postfix) with ESMTPSA id 0D9D4E0654
        for <netdev@vger.kernel.org>; Sat, 21 May 2022 14:59:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gogi.tv; s=helium;
        t=1653145169; bh=oC9yO2q3gzuHsh5/2z+rS8crmJP7psPr3Lf4nTWxdr0=;
        h=Date:Subject:To:References:From:In-Reply-To:From;
        b=G/MUXrmPtyi/CESvwu8jSIhO1lXsP5zFUzQ7izHnHsGSUh3O+jOW1h4apFQPnrnnC
         78kwTug7FpwAY+F+36iyHRGQiAxIKwZImDniP877I4QcqgEIURsttb9YEbfm5VB6Gs
         A1CLvN/afZ085BxMyUuzUAc2NviChhdElkeELlBVKT0usBtZSQrUm8byEn0OFxdr6m
         TaDnETNZgx/LFRPFy/P3jhMb1EuiM3H77WZkDnQynXl0F3FiofAKfFqIbxBrjA1EXM
         mtr3tdixX6juDthV53m3kkV2CgJivYOotg68U9uTOBRUQUZ9TdUG48FzmN/WT/IdIu
         ConISQur58dcA==
Message-ID: <64d3bbc1-0cb2-f4f3-0275-8c8c8ef4bd07@gogi.tv>
Date:   Sat, 21 May 2022 16:59:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: Stateless NAT rule and packets disappearing after postrouting
 hook *solved*
Content-Language: en-US
To:     netdev@vger.kernel.org
References: <aa6e4460-de47-7836-8fea-0170ea28f95f@gogi.tv>
From:   Daniel Haid <d.haid@gogi.tv>
In-Reply-To: <aa6e4460-de47-7836-8fea-0170ea28f95f@gogi.tv>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> This looks all very mysterious to me. How can I find out what is going
> on?

I found the problem: If I add 10.0.0.1 to *any* interface, then
the kernel will put that address as source into its ARP requests
and somehow my ISP will not allow that. Consequently the default
route does not work.

On the other hand, of only 127.0.0.1 is configured, then the
kernel sees this as having no address at all. I think it will
then send ARP requests with source 0.0.0.0 or something like
that, and then the link to the ISP does work.

So after all, the problem was not actually related to the kernel,
sorry everyone.

D.H.
