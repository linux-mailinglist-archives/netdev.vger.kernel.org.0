Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BEAD633EF6
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 15:31:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233994AbiKVObJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 09:31:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233916AbiKVObC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 09:31:02 -0500
X-Greylist: delayed 4084 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 22 Nov 2022 06:31:01 PST
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CD9065E44;
        Tue, 22 Nov 2022 06:31:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
        s=20170329; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=FY+JqUTCgihErrGkfvd81tTDafGHo4/Ls5aZBztvCRI=; b=AYvzjRrTruNeQnueKgELb+zCk8
        UVbGiVtGj9aoxeLpY3IHAd6Yyk/0XAO+o2htBjsFecMi89SKtq9feHUApjGt4pHm9mbOA9I+V6mQy
        eA1GZ6fQ6GWJNN3dCHh8ww04qprqnImBnhWQLBqyOQGGeGjftBRgox+qxDxtDwCs7Pe3JTcckNuWw
        22NGy7Gh2WlrpbVnmNlxHaFUiSJQ0FGaPuTPCZR61CqiCeq1X2BlTCgPo3VjT41nAbu/kZbhSbP3E
        nCOY/8g75zWymxjFr1MTnfhgzD0q7u7PDtf6dQ4r8PSil1SrtlAunMWnkjmPGBICS5bbVJH8nkYfS
        sle/jWGg==;
Received: from [177.102.6.147] (helo=[192.168.1.60])
        by fanzine2.igalia.com with esmtpsa 
        (Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
        id 1oxTEh-006xXr-3p; Tue, 22 Nov 2022 14:22:52 +0100
Message-ID: <3f0bc380-e6c9-d1fa-a22f-6ba9051d4219@igalia.com>
Date:   Tue, 22 Nov 2022 10:22:45 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.2
Subject: Re: [PATCH V3 03/11] alpha: Clean-up the panic notifier code
Content-Language: en-US
To:     linux-alpha@vger.kernel.org, Richard Henderson <rth@gcc.gnu.org>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>, richard.henderson@linaro.org
Cc:     kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        x86@kernel.org, kernel-dev@igalia.com, kernel@gpiccoli.net,
        Petr Mladek <pmladek@suse.com>
References: <20220819221731.480795-1-gpiccoli@igalia.com>
 <20220819221731.480795-4-gpiccoli@igalia.com>
From:   "Guilherme G. Piccoli" <gpiccoli@igalia.com>
In-Reply-To: <20220819221731.480795-4-gpiccoli@igalia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19/08/2022 19:17, Guilherme G. Piccoli wrote:
> The alpha panic notifier has some code issues, not following
> the conventions of other notifiers. Also, it might halt the
> machine but still it is set to run as early as possible, which
> doesn't seem to be a good idea.
> 
> So, let's clean the code and set the notifier to run as the
> latest, following the same approach other architectures are
> doing - also, remove the unnecessary include of a header already
> included indirectly.
> 
> Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
> Cc: Matt Turner <mattst88@gmail.com>
> Cc: Richard Henderson <rth@gcc.gnu.org>
> Reviewed-by: Petr Mladek <pmladek@suse.com>
> Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
> 
> ---
> 
> V3:
> - No changes.
> 
> V2:
> - Fixed rth email address;
> - Added Petr's review tag - thanks!
> 

Hi Alpha maintainers, is there anything else to be done here? I'd really
appreciate any advice on how to get this merged.

I'm also adding here Richard's linaro email (and trimming huge CC list).

Thanks in advance!
Cheers,


Guilherme
