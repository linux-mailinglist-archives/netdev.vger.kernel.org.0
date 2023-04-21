Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F10016EADDD
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 17:15:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232087AbjDUPPn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 11:15:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229877AbjDUPPl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 11:15:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D35DD13C3E
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 08:15:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 67BDB65156
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 15:15:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DFF9C4339B;
        Fri, 21 Apr 2023 15:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682090137;
        bh=zNU2HHsrJNoCSvHpUzgdJhp6e8lRRxv+A5y2pezvPtA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GN1Z0jv/sH0hXeFo3sGvDLBLaD+0i4yBHr21Bm4kNETStRxHOQl8PvAYYPnk7MXfw
         avpdMkkFYx1xESYIZmxDpUb4mwL1KSlIAhyG3z0xHaGc7tkKPVsOKxiJcuVNwXOyto
         bEiph+GPU5EEvHZlvKIOdxSrmvJpm65RACkh1DHEzGfAeQXAjZf0norLUi8deR3wwH
         0JZV3fp9U0lTRcwJg6+9x/5oIBvsKTojBf6nPHBopcVH/eA/mYQA+NJvcME9E5NhyJ
         sYWsSSbUhkJCslbP86XO+vNzjuOAkr0wKhMFgGtjW/2zvjhvc3aRQg6aQ8dgxjLf4J
         W/5SfaAl9CSWg==
Date:   Fri, 21 Apr 2023 08:15:36 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pedro Tammela <pctammela@mojatatu.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, simon.horman@corigine.com
Subject: Re: [PATCH net-next v4 3/5] net/sched: act_pedit: check static
 offsets a priori
Message-ID: <20230421081536.656febc3@kernel.org>
In-Reply-To: <6297e31c-2f0b-a364-ca5c-d5d02b640466@mojatatu.com>
References: <20230418234354.582693-1-pctammela@mojatatu.com>
        <20230418234354.582693-4-pctammela@mojatatu.com>
        <20230420194134.1b2b4fc8@kernel.org>
        <6297e31c-2f0b-a364-ca5c-d5d02b640466@mojatatu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 21 Apr 2023 12:12:54 -0300 Pedro Tammela wrote:
> On 20/04/2023 23:41, Jakub Kicinski wrote:
> > On Tue, 18 Apr 2023 20:43:52 -0300 Pedro Tammela wrote:  
> >> @@ -414,12 +420,12 @@ TC_INDIRECT_SCOPE int tcf_pedit_act(struct sk_buff *skb,
> >>   					       sizeof(_d), &_d);
> >>   			if (!d)
> >>   				goto bad;
> >> -			offset += (*d & tkey->offmask) >> tkey->shift;
> >> -		}
> >>   
> >> -		if (offset % 4) {
> >> -			pr_info("tc action pedit offset must be on 32 bit boundaries\n");
> >> -			goto bad;
> >> +			offset += (*d & tkey->offmask) >> tkey->shift;  
> > 
> > this line loads part of the offset from packet data, so it's not
> > exactly equivalent to the init time check.  
> 
> The code uses 'tkey->offmask' as a check for static offsets vs packet 
> derived offsets, which have different handling.
> By checking the static offsets at init we can move the datapath
> 'offset % 4' check for the packet derived offsets only.
> 
> Note that this change only affects the offsets defined in 'tkey->off', 
> the 'at' offset logic stays the same.
> My intention was to keep the code semantically the same.
> Did I miss anything?

You are now erroring out if the static offset is not divisible by 4,
and technically it was possible to construct a case where that'd work
previously - if static offset was 2 and we load another 2 from the
packet, no?

If so it needs to be mentioned in the commit msg.
