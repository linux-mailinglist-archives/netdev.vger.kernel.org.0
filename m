Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 355584E4ABC
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 03:10:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240966AbiCWCLu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 22:11:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231704AbiCWCLt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 22:11:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 763825C356
        for <netdev@vger.kernel.org>; Tue, 22 Mar 2022 19:10:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 281E7B81DCC
        for <netdev@vger.kernel.org>; Wed, 23 Mar 2022 02:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6226BC340ED;
        Wed, 23 Mar 2022 02:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648001416;
        bh=OLedtm3PnXIEUODWo5odDvPQ8VtUMj7EStQliWZCCTo=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=JC9sR1x4eiqkBHDAO3qJ+7KbKuuVFhz7PwnbUlvAYdd8ewlNHMN01JWy5TVJ4pkLc
         pOkBMwTGF9PY653VWf1gqgLFIBPVAt/r67xlMwq3XJJ9YS4X6ezNe4kBN99h2qsE6o
         VdqvSXrxetJqF+H4aDlphdUb4i5/pfUbf+F5gSibi21IyRa4juSX7CK9GqTIEivVAq
         QS6Ul/5JJv2gn4E9FZOi4b60zOaW9ITZVsPnva4uX9h7W+3N4kbfAQK97MBpUYtSdK
         hY/2G4sBkRhmuLrgEn9W526hHbjvRGZxIvn99bFAwL4PqEE0nL2rOsvesizL6DX1UD
         /GRofDyC7lrPQ==
Message-ID: <21c70ad0-cf4b-1681-c606-768e992bcc6a@kernel.org>
Date:   Tue, 22 Mar 2022 20:10:15 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [RFC net] Discuss seg6 potential wrong behavior
Content-Language: en-US
To:     Justin Iurman <justin.iurman@uliege.be>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        pabeni@redhat.com
References: <20220318202138.37161-1-justin.iurman@uliege.be>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220318202138.37161-1-justin.iurman@uliege.be>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/18/22 2:21 PM, Justin Iurman wrote:
> This thread aims to discuss a potential wrong behavior regarding seg6
> (as well as rpl). I'm curious to know if there is a specific reason for
> discarding the packet when seg6 is not enabled on an interface and when

that is standard. MPLS for example does the same.

> segments_left == 0. Indeed, reading RFC8754, I'm not sure this is the


> right thing to do. I think it would be more correct to process the next
> header in the packet. It does not make any sense to prevent further
> processing when the SRv6 node has literally nothing to do in that
> specific case. For that, we need to postpone the check of accept_seg6.
> And, in order to avoid a breach, we also check for accept_seg6 before
> decapsulation when segments_left == 0. Any comments on this?
> 
> Also, I'm not sure why accept_seg6 is set the current way. Are we not
> suppose to prioritize devconf_all? If "all" is set to 1, then it is

sadly, ipv6 is all over the place with 'all' vs 'dev' settings.

