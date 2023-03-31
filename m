Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 991ED6D19C7
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 10:27:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230040AbjCaI1S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 04:27:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229992AbjCaI1R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 04:27:17 -0400
X-Greylist: delayed 456 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 31 Mar 2023 01:27:15 PDT
Received: from mail.codelabs.ch (mail.codelabs.ch [IPv6:2a02:168:860f:1::35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0A9126BD
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 01:27:15 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.codelabs.ch (Postfix) with ESMTP id 94DF9220002;
        Fri, 31 Mar 2023 10:19:35 +0200 (CEST)
Received: from mail.codelabs.ch ([127.0.0.1])
        by localhost (fenrir.codelabs.ch [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id WIH-eTyPA-dY; Fri, 31 Mar 2023 10:19:34 +0200 (CEST)
Received: from [IPV6:2a01:8b81:5400:f500:6981:acb6:ba5d:c9e4] (unknown [IPv6:2a01:8b81:5400:f500:6981:acb6:ba5d:c9e4])
        by mail.codelabs.ch (Postfix) with ESMTPSA id 46FA0220001;
        Fri, 31 Mar 2023 10:19:34 +0200 (CEST)
Message-ID: <c06ff911-8ffb-0f5c-5863-d48dbf1dd084@strongswan.org>
Date:   Fri, 31 Mar 2023 10:19:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        netdev@vger.kernel.org, devel@linux-ipsec.org
Cc:     Hyunwoo Kim <v4bel@theori.io>,
        Tudor Ambarus <tudordana@google.com>,
        Eric Dumazet <edumazet@google.com>
References: <ZCZ79IlUW53XxaVr@gauss3.secunet.de>
Content-Language: en-US, de-CH-frami
From:   Tobias Brunner <tobias@strongswan.org>
Subject: Re: [devel-ipsec] [PATCH ipsec] xfrm: Don't allow optional
 intermediate templates that changes the address family
In-Reply-To: <ZCZ79IlUW53XxaVr@gauss3.secunet.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.0 required=5.0 tests=NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> When an optional intermediate template changes the address family,
> it is unclear which family the next template should have. This can
> lead to misinterpretations of IPv4/IPv6 addresses. So reject
> optional intermediate templates on insertion time.

This change breaks the installation of IPv4-in-IPv6 (or vice-versa) 
policies with IPComp, where the optional IPComp template and SA is 
installed with tunnel mode (while the ESP template/SA that follows is 
installed in transport mode) and the address family is that of the SA 
not that of the policy.

Note that mixed-family scenarios with IPComp are currently broken due to 
an address family issue, but that's a problem in xfrm_tmpl_resolve_one() 
that occurs later when packets are actually matched against policies. 
There is a simple patch for it that I haven't got around to submit to 
the list yet.

Regards,
Tobias

