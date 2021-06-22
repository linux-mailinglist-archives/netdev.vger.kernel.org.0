Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A278A3B0D99
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 21:22:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232681AbhFVTY1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 15:24:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232415AbhFVTYY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 15:24:24 -0400
Received: from proxima.lasnet.de (proxima.lasnet.de [IPv6:2a01:4f8:121:31eb:3::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3FBBC061574;
        Tue, 22 Jun 2021 12:21:49 -0700 (PDT)
Received: from [IPv6:2003:e9:d741:e18f:a31e:1420:3e5f:861e] (p200300e9d741e18fa31e14203e5f861e.dip0.t-ipconnect.de [IPv6:2003:e9:d741:e18f:a31e:1420:3e5f:861e])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id F2572C0122;
        Tue, 22 Jun 2021 21:21:43 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1624389704;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vDxaktJ+Hh7ra+obApcSLKVeXPUw+MBOxIRGYg22n6Q=;
        b=KjxR93EbICpNf4PNGWI6LxiM2xhcvdkMSvvQD9y9Ix2uTV+0N1INV9R5R4DWN51d1U+/RB
        NTxZgoOqzz9AMC8dTvO7cT5ss4HDDK3HgoRDRADi+Se/yQhGSO0aVAHqYK6/36tcP263Ux
        syyDEqldP8rClxC3vFKtAZy/7eil1q79dfZquF76GcoaNglb7tA/03AVzblulxXdkPDxvy
        pU9llNt/RUjtoMvM4IxTG9e6iFFh0hMntKHZanQr3DDNNyOafn14MuWnTdfup3fG1tB4J7
        QYCnt8zZNYMmiBZk7dsFEPfEiA0wqsQfebdLLfgi+zMwODFXXZQT7O5md1jcSA==
Subject: Re: [PATCH v2] ieee802154: hwsim: Fix memory leak in hwsim_add_one
To:     Alexander Aring <alex.aring@gmail.com>,
        Dongliang Mu <mudongliangabcd@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        syzbot+b80c9959009a9325cdff@syzkaller.appspotmail.com
References: <20210616020901.2759466-1-mudongliangabcd@gmail.com>
 <CAB_54W51MxDwN5oPxBqioaNhq-eB1QfXNMyUpmNZOWNDM3MmnA@mail.gmail.com>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
Message-ID: <4d08846a-118f-261b-9760-7953c1d4547f@datenfreihafen.org>
Date:   Tue, 22 Jun 2021 21:21:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAB_54W51MxDwN5oPxBqioaNhq-eB1QfXNMyUpmNZOWNDM3MmnA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello.

On 22.06.21 20:29, Alexander Aring wrote:
> Hi,
> 
> On Tue, 15 Jun 2021 at 22:09, Dongliang Mu <mudongliangabcd@gmail.com> wrote:
>>
>> No matter from hwsim_remove or hwsim_del_radio_nl, hwsim_del fails to
>> remove the entry in the edges list. Take the example below, phy0, phy1
>> and e0 will be deleted, resulting in e1 not freed and accessed in the
>> future.
>>
>>                hwsim_phys
>>                    |
>>      ------------------------------
>>      |                            |
>> phy0 (edges)                 phy1 (edges)
>>     ----> e1 (idx = 1)             ----> e0 (idx = 0)
>>
>> Fix this by deleting and freeing all the entries in the edges list
>> between hwsim_edge_unsubscribe_me and list_del(&phy->list).
>>
>> Reported-by: syzbot+b80c9959009a9325cdff@syzkaller.appspotmail.com
>> Fixes: 1c9f4a3fce77 ("ieee802154: hwsim: fix rcu handling")
>> Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
> 
> Acked-by: Alexander Aring <aahringo@redhat.com>
> 
> Thanks!


This patch has been applied to the wpan tree and will be
part of the next pull request to net. Thanks!

regards
Stefan Schmidt
