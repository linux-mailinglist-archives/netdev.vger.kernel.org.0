Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5242C5AC30C
	for <lists+netdev@lfdr.de>; Sun,  4 Sep 2022 08:43:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232702AbiIDGnD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Sep 2022 02:43:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiIDGnB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Sep 2022 02:43:01 -0400
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32AF94CA3A;
        Sat,  3 Sep 2022 23:43:00 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id 5FEE3C020; Sun,  4 Sep 2022 08:42:58 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1662273778; bh=XUxJ04rfDRvv6seKolK+ZMqlBB2QN+5n0YBdPSmBOW8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZGXLq7MsxbAYij0mul8f4yq+/7C2R36x/VNclc+hNnlS71XDQbntLETX4zT35ypzU
         pPdoWc2UzcxaM08ERVdKiaRFKzC+xlCpXa9UOfS5Yo/L38n5WLLm4Wcwafk1AxN3MK
         m8CHnlJGKvsYdVQe3Vmv37tAwtY/McNfjBO0Bbo0FZ72ogytVxdCtkUcXchqvRkkOX
         ug5APh39ayttlgk7ITma9VEine8deUDmUFo5Pefg/Io56n89QJXgH789I90EH3wY6y
         lh1Vci01u3vUtM8PxuHTTh0U0BNYsRds95QGM1Yzrtu5QxYn2g6eYnIG48thU273YI
         qqwgltawk0K/g==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 845E6C009;
        Sun,  4 Sep 2022 08:42:54 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1662273777; bh=XUxJ04rfDRvv6seKolK+ZMqlBB2QN+5n0YBdPSmBOW8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ti3HpvPS4J5cpUncPFp3ngayKhAZY9WCaXJBpCFBtVi3620Kz+hbad14wicvk586K
         H83HvlddU8HZ91zmI2RFvF5UhQa7mCwf/TwvspbASEmcsxh3DWVbC0ovIqnQcnn2zT
         NfziNWplw6rdiMRpVRjzCyBqZEpee6VWXTawtdEzh8NbwTDNKK8zAelCRxiNGreZ6u
         7K0SWZpLP8v2Gu5O4QDb0Ns/IS9mESlVTed87rNTrPfXx48S4ZiQRwGv8HqpNFa7OH
         X3xtmsxiksd2MROkdqE5oZ03iYQFX8mqwIqtgkJfceqylxt5bMJZaX8akm70P7Y5+q
         QghXKmhFMqLqw==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id b43ef3ff;
        Sun, 4 Sep 2022 06:42:52 +0000 (UTC)
Date:   Sun, 4 Sep 2022 15:42:37 +0900
From:   asmadeus@codewreck.org
To:     Christian Schoenebeck <linux_oss@crudebyte.com>
Cc:     Schspa Shi <schspa@gmail.com>, ericvh@gmail.com, lucho@ionkov.net,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, v9fs-developer@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] p9: trans_fd: Fix deadlock when connection cancel
Message-ID: <YxRI3Z0k8tOm9IlD@codewreck.org>
References: <20220831180950.76907-1-schspa@gmail.com>
 <Yw/HmHcmXBVIg/SW@codewreck.org>
 <m2bkrz7qc8.fsf@gmail.com>
 <2739602.9NfmOOc9RC@silver>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2739602.9NfmOOc9RC@silver>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Christian Schoenebeck wrote on Thu, Sep 01, 2022 at 05:27:53PM +0200:
> > > If you have a test setup, would you mind testing my patch?
> > > That's the main reason I was delaying pushing it.
> > 
> > I have test it with my enviroment, it not hang anymore.
> 
> Are you fine with that Dominique, or do you want me to test your linked patch 
> as well?
> 
> You can also explicitly tell me if you need something to be reviewed/tested.

I've just resent both patches properly; that should be better for
everyone. It can't hurt to get more tests :)

I don't think we'll catch anything with Tetsuo Handa's other two fixes
as we don't really test trans_fd all that much, so I'll give it a spin
with ganesha on my end when I can find time.

Thanks!
--
Dominiquem
