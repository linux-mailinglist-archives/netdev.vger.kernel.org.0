Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2ED93525CC6
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 10:03:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239375AbiEMIDW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 04:03:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378013AbiEMIDQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 04:03:16 -0400
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B99273DDD1;
        Fri, 13 May 2022 01:03:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:Subject:
        From:References:Cc:To:MIME-Version:Date:Message-ID:Sender:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe
        :List-Post:List-Owner:List-Archive;
        bh=+rMuVKE+E1NTvhxSfpuvBePzfpGEiKECg1mnOJnbM8M=; b=ZcbxkLGHRNNWBGWxkfOakjRmqP
        SmffZwH64Jv6AmCgH+rNLhMpfDuED4tGeTtgJLj64hIhO8AoouSDWE9iWyLemCpX/rcirgiu4hIvB
        ZR5EdEpIAaFe9p+C5YRxydbOnfKFRSz3arfiQr65AKVuMgXN5Vv0COQBSnRJJY8u8OpI=;
Received: from p200300daa70ef2007c2a1ceaba82ff54.dip0.t-ipconnect.de ([2003:da:a70e:f200:7c2a:1cea:ba82:ff54] helo=nf.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1npQGY-0004Yb-2g; Fri, 13 May 2022 10:03:14 +0200
Message-ID: <b1fd2a80-f629-48a3-7466-0e04f2c531df@nbd.name>
Date:   Fri, 13 May 2022 10:03:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Content-Language: en-US
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        Jo-Philipp Wich <jo@mein.io>
References: <20220510202739.67068-1-nbd@nbd.name> <Yn4NnwAkoVryQtCK@salvia>
From:   Felix Fietkau <nbd@nbd.name>
Subject: Re: [RFC] netfilter: nf_tables: ignore errors on flowtable device hw
 offload setup
In-Reply-To: <Yn4NnwAkoVryQtCK@salvia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 13.05.22 09:49, Pablo Neira Ayuso wrote:
> Hi,
> 
> On Tue, May 10, 2022 at 10:27:39PM +0200, Felix Fietkau wrote:
>> In many cases, it's not easily possible for user space to know, which
>> devices properly support hardware offload.
> 
> Then, it is a matter of extending the netlink interface to expose this
> feature? Probably add a FLOW_BLOCK_PROBE or similar which allow to
> consult if this feature is available?
> 
>> Even if a device supports hardware flow offload, it is not
>> guaranteed that it will actually be able to handle the flows for
>> which hardware offload is requested.
> 
> When might this happen?
I think there are many possible reasons: The flow might be using 
features not supported by the offload driver. Maybe it doesn't have any 
space left in the offload table. I'm sure there are many other possible 
reasons it could fail.

>> Ignoring errors on the FLOW_BLOCK_BIND makes it a lot easier to set up
>> configurations that use hardware offload where possible and gracefully
>> fall back to software offload for everything else.
> 
> I understand this might be useful from userspace perspective, because
> forcing the user to re-try is silly.
> 
> However, on the other hand, the user should have some way to know from
> the control plane that the feature (hardware offload) that they
> request is not available for their setup.
In my opinion, most users of this API probably don't care and just want 
to have offload on a best effort basis. Assuming that is the case, 
wouldn't it be better if we simply have an API that indicates, which 
flowtable members hardware offload was actually enabled for?

- Felix
