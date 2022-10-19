Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06B42604F5A
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 20:10:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230044AbiJSSKr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 14:10:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230060AbiJSSKq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 14:10:46 -0400
Received: from novek.ru (unknown [213.148.174.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0E3E172B69
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 11:10:42 -0700 (PDT)
Received: from [192.168.0.18] (unknown [37.228.234.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id EC18E504EBE;
        Wed, 19 Oct 2022 21:06:30 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru EC18E504EBE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1666202792; bh=SakQ5bjnDU9ex47H8Sf/f3qKgIYIs+tKz87l6dIdPO0=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=DHDVpeIBd6t3F6DHJpokFu1LCfpKPMd3PNk1d1r7BFgUus1DRMyxs4/iBKu7C6UHg
         jPckMjl6+rhvLNgu2qPSJVLHNNolxFWyCUFhePY7L5afApWLESYaNEd9pP4SnCJxIJ
         labjoVBOuVSZC+I3H+9wu29p2eh+5cPY0GhoY+tc=
Message-ID: <9b9a3744-0d07-3dca-856e-82810d2ab67c@novek.ru>
Date:   Wed, 19 Oct 2022 19:10:04 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net-next v3 2/5] ptp: ocp: add Orolia timecard support
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        netdev@vger.kernel.org, Vadim Fedorenko <vadfed@fb.com>,
        Charles Parent <charles.parent@orolia2s.com>
References: <20221018090122.3361-1-vfedorenko@novek.ru>
 <20221018090122.3361-3-vfedorenko@novek.ru>
 <20221018194732.16f7d413@kernel.org>
From:   Vadim Fedorenko <vfedorenko@novek.ru>
In-Reply-To: <20221018194732.16f7d413@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19.10.2022 03:47, Jakub Kicinski wrote:
> On Tue, 18 Oct 2022 12:01:19 +0300 Vadim Fedorenko wrote:
>> From: Vadim Fedorenko <vadfed@fb.com>
>>
>> This brings in the Orolia timecard support from the GitHub repository.
>> The card uses different drivers to provide access to i2c EEPROM and
>> firmware SPI flash. And it also has a bit different EEPROM map, but
>> other parts of the code are the same and could be reused.
> 
>> +static const struct ocp_attr_group art_timecard_groups[];
>> +static const struct ocp_sma_op ocp_art_sma_op;
> 
> Clang is not on board:
> 
> drivers/ptp/ptp_ocp.c:384:32: warning: tentative definition of variable with internal linkage has incomplete non-array type 'const struct ocp_sma_op' [-Wtentative-definition-incomplete-type]
> static const struct ocp_sma_op ocp_art_sma_op;
>                                 ^
> drivers/ptp/ptp_ocp.c:349:15: note: forward declaration of 'struct ocp_sma_op'
>          const struct ocp_sma_op *sma_op;
>                       ^
> 
> You may need to throw an extern in there.
> 
> Is it not possible to just order things correctly in the first place?
> Is there a dependency cycle?

Ok, haven't tested it with clang before, but now I'm able to reproduce.
I found the way to reorder things, v4 is coming.

