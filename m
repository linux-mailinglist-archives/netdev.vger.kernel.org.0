Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A37AD6E9BEE
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 20:51:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231261AbjDTSvM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 14:51:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230118AbjDTSvL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 14:51:11 -0400
Received: from mx04lb.world4you.com (mx04lb.world4you.com [81.19.149.114])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62FDF2705;
        Thu, 20 Apr 2023 11:51:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=nicpazsYFo+cOS55Zsy7iQP/8Rjk32Z/JcO9Q8jUJvQ=; b=Q3Ta1HVcX48cTOHeqzciD0Vz+J
        z4YT4VMxJBj2qjD/LklWZ7wyuBCXSh539AEk8qw/UobK4D74susDMRfkmze+4fykP83Ao9zQCCjuP
        byVw22Zjv4KfoJA2RTt/wmp5X3OeRzl59cRzkxWu9T5dJVYN8f1XHlBHK93A3Nc4IoOE=;
Received: from [88.117.57.231] (helo=[10.0.0.160])
        by mx04lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1ppZN5-0005lM-J1; Thu, 20 Apr 2023 20:51:07 +0200
Message-ID: <7dcca571-856b-36f9-cf56-4a3c63c07e4e@engleder-embedded.com>
Date:   Thu, 20 Apr 2023 20:51:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH net-next v3 1/6] tsnep: Replace modulo operation with mask
Content-Language: en-US
To:     Stephen Hemminger <stephen@networkplumber.org>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        kuba@kernel.org, edumazet@google.com, pabeni@redhat.com,
        bjorn@kernel.org, magnus.karlsson@intel.com,
        jonathan.lemon@gmail.com
References: <20230418190459.19326-1-gerhard@engleder-embedded.com>
 <20230418190459.19326-2-gerhard@engleder-embedded.com>
 <ZEFKzuPKGRv0bO35@boxer> <20230420081013.6e2040c5@hermes.local>
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
In-Reply-To: <20230420081013.6e2040c5@hermes.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AV-Do-Run: Yes
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20.04.23 17:10, Stephen Hemminger wrote:
> On Thu, 20 Apr 2023 16:23:10 +0200
> Maciej Fijalkowski <maciej.fijalkowski@intel.com> wrote:
> 
>> On Tue, Apr 18, 2023 at 09:04:54PM +0200, Gerhard Engleder wrote:
>>> TX/RX ring size is static and power of 2 to enable compiler to optimize
>>> modulo operation to mask operation. Make this optimization already in
>>> the code and don't rely on the compiler.
>>
>> I think this came out of my review, so:
>> Suggested-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
>>
>> Does this give you a minor perf boost?
> 
> If you change the loop counter to be unsigned, then Gcc (and Clang)
> will optimize this into a mask operation.  That is a better simpler fix.
> 
> If loop counter (i) is an integer, then compiler has keep the
> potential for wrap around.

I'm unsure which solution should be preferred. But I could change to
unsigned anyway.
