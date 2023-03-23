Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 840426C6278
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 09:56:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231368AbjCWI4S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 04:56:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230367AbjCWI4C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 04:56:02 -0400
Received: from nbd.name (nbd.name [46.4.11.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A523F11654
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 01:55:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
        s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=3cbGgwF3FFv6mMqp1Gc7Q+cdYAPAWvIAWz/Y7YhW9Ho=; b=ggfo/+EOO9ouQUnYanBZxf+F0Q
        wBWMdZmjkxWKPxZT353SZqgAIG3wtrYCmUzugsjy/eTam8ARRWDE70M9oospaXU7SXFN47LpSEnlQ
        iPzugILe4KOA5YWJJ8acoh4B3mm6IQqXucMikHe0n2TX3zdYzwLvtALQkGTDWjmdU28w=;
Received: from p54ae9730.dip0.t-ipconnect.de ([84.174.151.48] helo=nf.local)
        by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <nbd@nbd.name>)
        id 1pfGjY-005yUv-UO; Thu, 23 Mar 2023 09:55:45 +0100
Message-ID: <795e8a96-7f9d-640d-465d-670ae9efbab0@nbd.name>
Date:   Thu, 23 Mar 2023 09:55:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.0
Subject: Re: [PATCH net 1/2] net: ethernet: mtk_eth_soc: fix flow block
 refcounting
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        Simon Horman <simon.horman@corigine.com>
Cc:     netdev@vger.kernel.org
References: <20230321133719.49652-1-nbd@nbd.name>
 <ZBsR0C/3+0ZsWnhf@corigine.com> <20230322223713.4e339b35@kernel.org>
From:   Felix Fietkau <nbd@nbd.name>
In-Reply-To: <20230322223713.4e339b35@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23.03.23 06:37, Jakub Kicinski wrote:
> On Wed, 22 Mar 2023 15:33:52 +0100 Simon Horman wrote:
>> On Tue, Mar 21, 2023 at 02:37:18PM +0100, Felix Fietkau wrote:
>> > Since we call flow_block_cb_decref on FLOW_BLOCK_UNBIND, we need to call
>> > flow_block_cb_incref unconditionally, even for a newly allocated cb.
>> > Fixes a use-after-free bug. Also fix the accidentally inverted refcount
>> > check on unbind.  
>> 
>> Firstly, it's usually best to have one fix per patch.
> 
> Or at least reword the commit message to make it look like it's fixing
> the refcounting logic?
I thought that was clear in the title already :)
I've considered splitting the patch in two, but decided against it, 
because it could cause bisect issues.
Right now the accidentally inverted logic is preventing the 
use-after-free bug from showing up with a single flow block, so that 
would break if I only fix one part without the other.

Will send v2 based on your suggestions.

- Felix
