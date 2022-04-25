Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF08250E980
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 21:31:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244946AbiDYTet (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 15:34:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230214AbiDYTes (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 15:34:48 -0400
X-Greylist: delayed 340 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 25 Apr 2022 12:31:42 PDT
Received: from proxima.lasnet.de (proxima.lasnet.de [78.47.171.185])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1F6811097A;
        Mon, 25 Apr 2022 12:31:42 -0700 (PDT)
Received: from [IPV6:2003:e9:d72c:58f3:5b3d:eb7c:dc29:a239] (p200300e9d72c58f35b3deb7cdc29a239.dip0.t-ipconnect.de [IPv6:2003:e9:d72c:58f3:5b3d:eb7c:dc29:a239])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 23698C06A5;
        Mon, 25 Apr 2022 21:26:00 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1650914760;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jyVArQHkXYmLlgKSMojirf0oYGdy7SmtDrnAIXOWePY=;
        b=kGrLNYImeCGGhmpdOHqgtmcJXhSh71tgDKY8ysZ7Y3GoWF7fvyCTW858L+nSu90JmGn/n5
        05LGyyR0bCminbK8XDlAX2ccfPJr6Nh1ePVZfQg8boS8BIPKlZV91YhbbsUYPLibOYM4bQ
        A156j1M5djkYlCpLqenc7Azz9Gz8RHXqJ4PYPskKcUmypIJ8rcut0pJjLgxeNF9u2dpJ0g
        H9IZXhjpF4+JhkFmqTceNOj5LiBB+xvurT2qKblUNKVb8vttB1OsnahpR8C0gRWekjIfyV
        kMvmTbsE4oK11mk5/qZPKLgAxFLDhQgFPqz1wBYJI3tSfPPJnGswA9N389DB4A==
Message-ID: <02b35b0d-be2f-d4fb-433b-d34a4dbb6a92@datenfreihafen.org>
Date:   Mon, 25 Apr 2022 21:25:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v6 00/10] ieee802154: Better Tx error handling
Content-Language: en-US
To:     Alexander Aring <alex.aring@gmail.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
References: <20220407100903.1695973-1-miquel.raynal@bootlin.com>
 <CAB_54W4_oDrfNFLrRMnOBqE=yxTGh97OK94Fiip1FovbHNaKBQ@mail.gmail.com>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
In-Reply-To: <CAB_54W4_oDrfNFLrRMnOBqE=yxTGh97OK94Fiip1FovbHNaKBQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello.

On 25.04.22 14:37, Alexander Aring wrote:
> Hi,
> 
> On Thu, Apr 7, 2022 at 6:09 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>>
>> The idea here is to provide a fully synchronous Tx API and also be able
>> to be sure that a transfer has finished. This will be used later by
>> another series. However, while working on this task, it appeared
>> necessary to first rework the way MLME errors were (not) propagated to
>> the upper layers. This small series tries to tackle exactly that, before
>> introducing the synchronous API.
>>
> 
> Acked-by: Alexander Aring <aahringo@redhat.com>
> 
> Thanks!


These patches have been applied to the wpan-next tree and will be
part of the next pull request to net-next. Thanks!

regards
Stefan Schmidt
