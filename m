Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 308C05A9BA4
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 17:29:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234339AbiIAP20 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 11:28:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234246AbiIAP2M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 11:28:12 -0400
Received: from kylie.crudebyte.com (kylie.crudebyte.com [5.189.157.229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A91B37331A;
        Thu,  1 Sep 2022 08:28:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=crudebyte.com; s=kylie; h=Content-Type:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        Content-ID:Content-Description;
        bh=iVZmXkRo7BKC/ObnBuv9eAWgxqprDCQYopbDV0cm8ZA=; b=R+861XU5V5SAXZ6YWA8ropbfi1
        ZuvDKzYCbOhxZvRdUPuqyNRMmwBCmRE+eYTUGjXOCnC9kwk9L8ldpNkP7E41txt+kfyIlI4AskHiQ
        /mA3ZiLe6noHRotbtsARf/0ttGGJNC25YrILvQbJlFyiRLcXxVNQ2TwYIPMejFR/e28K5/7jXtuFX
        Ol2ngJ4ODZY+OCeFb0RXKMmSdajColXb3alNeSASgAFUeLvv9PvNX5Qej/aMEAN0wXfjv/INOaDCL
        rP9pcDsPpHRukUR4RNAWMXGLCiFb9vRWCmhiyoBvM+MJtgQJJxpg0Jz6c674sjVIlLXbeOMUmpXE/
        NBaRJWOhumtC8IV2lDBSdugPhNguo7rH0l2pdS3qlPIwTUUPPXXPfU6AND4hIBH1OsCAKaSZql42h
        P29kr0ZVK2j4dCAEe0YOXS2LFhARIvUIf/8hHRfk53oA8FmlWMkgYWdbA0qUcb8nwsLwOXgYy8zj2
        utkUOTarINxD40ClcNNmk1G8hn1Ay0gdFG47A+z8wzhCb4U9CBN6ghh7mLOnHQklCOE88998/TSMb
        H17fX4p6wuy8osELaHFJy2gM13884RKYjjKlkMS6epGR8lT6rhgAkiA33JAArWIq0U4vypd3w/Gvo
        oQ5DVn5LlzunLTQEPSdSdBHUTrDRsPDixuM6lqFvQ=;
From:   Christian Schoenebeck <linux_oss@crudebyte.com>
To:     asmadeus@codewreck.org, Schspa Shi <schspa@gmail.com>
Cc:     ericvh@gmail.com, lucho@ionkov.net, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] p9: trans_fd: Fix deadlock when connection cancel
Date:   Thu, 01 Sep 2022 17:27:53 +0200
Message-ID: <2739602.9NfmOOc9RC@silver>
In-Reply-To: <m2bkrz7qc8.fsf@gmail.com>
References: <20220831180950.76907-1-schspa@gmail.com> <Yw/HmHcmXBVIg/SW@codewreck.org>
 <m2bkrz7qc8.fsf@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Donnerstag, 1. September 2022 04:55:36 CEST Schspa Shi wrote:
> asmadeus@codewreck.org writes:
> > Schspa Shi wrote on Thu, Sep 01, 2022 at 02:09:50AM +0800:
> >> To fix it, we can add extra reference counter to avoid deadlock, and
> >> decrease it after we unlock the client->lock.
> > 
> > Thanks for the patch!
> > 
> > Unfortunately I already sent a slightly different version to the list,
> > hidden in another syzbot thread, here:
> > https://lkml.kernel.org/r/YvyD053bdbGE9xoo@codewreck.org
> > 
> > (yes, sorry, not exactly somewhere I'd expect someone to find it... 9p
> > hasn't had many contributors recently)
> > 
> > 
> > Basically instead of taking an extra lock I just released the client
> > lock before calling p9_client_cb, so it shouldn't hang anymore.
> > 
> > We don't need the lock to call the cb as in p9_conn_cancel we already
> > won't accept any new request and by this point the requests are in a
> > local list that isn't shared anywhere.
> 
> Ok, thank you for pointing that out.
> 
> > If you have a test setup, would you mind testing my patch?
> > That's the main reason I was delaying pushing it.
> 
> I have test it with my enviroment, it not hang anymore.

Are you fine with that Dominique, or do you want me to test your linked patch 
as well?

You can also explicitly tell me if you need something to be reviewed/tested.

> > Since you went out of your way to make this patch if you agree with my
> > approach I don't mind adding your sign off or another mark of having
> > worked on it.
> > 
> > Thank you,




