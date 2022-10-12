Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDBD05FCBE9
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 22:17:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229504AbiJLURd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 16:17:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbiJLURc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 16:17:32 -0400
Received: from novek.ru (unknown [213.148.174.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5846E38472;
        Wed, 12 Oct 2022 13:17:31 -0700 (PDT)
Received: from [192.168.0.18] (unknown [37.228.234.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id CF9F9504E89;
        Wed, 12 Oct 2022 23:13:59 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru CF9F9504E89
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1665605641; bh=nwzq51eDgmJENhKn30MWEpwK+URO+XaouJTOroLnKpo=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=aEOcl8NzA8myWw1KGoWK7TEcIVPw/I1U70di2u4itsIu5EWBo5Jcz7AMPCdZD7xLr
         btbWz7r1hI7sSrcjALGAZkh3jRCG+44CIhK7y0qbGnACWAyne+VBHed0URgYq4lbKl
         5SupY1+1h+VJbExRdEukhICiOPggYzsnfqUc3EJs=
Message-ID: <ad45a05b-be0d-6d9d-c1a9-4af0c956b88c@novek.ru>
Date:   Wed, 12 Oct 2022 21:17:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [RFC PATCH v3 1/6] dpll: Add DPLL framework base functions
Content-Language: en-US
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-clk@vger.kernel.org, Vadim Fedorenko <vadfed@fb.com>
References: <20221010011804.23716-1-vfedorenko@novek.ru>
 <20221010011804.23716-2-vfedorenko@novek.ru> <Y0bwq4YyeWsODPjv@nanopsycho>
From:   Vadim Fedorenko <vfedorenko@novek.ru>
In-Reply-To: <Y0bwq4YyeWsODPjv@nanopsycho>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12.10.2022 17:51, Jiri Pirko wrote:
> Mon, Oct 10, 2022 at 03:17:59AM CEST, vfedorenko@novek.ru wrote:
>> From: Vadim Fedorenko <vadfed@fb.com>
>>
>> DPLL framework is used to represent and configure DPLL devices
>> in systems. Each device that has DPLL and can configure sources
>> and outputs can use this framework.
>>
>> Signed-off-by: Vadim Fedorenko <vadfed@fb.com>
>> Co-developed-by: Jakub Kicinski <kuba@kernel.org>
>> Co-developed-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
>> ---
> 
> [..]
> 
>> +enum dpll_genl_status {
>> +	DPLL_STATUS_NONE,
>> +	DPLL_STATUS_CALIBRATING,
>> +	DPLL_STATUS_LOCKED,
>> +
>> +	__DPLL_STATUS_MAX,
>> +};
>> +#define DPLL_STATUS_MAX (__DPLL_STATUS_MAX - 1)
>> +
> 
> [..]
> 
>> +
>> +/* DPLL lock status provides information of source used to lock the device */
>> +enum dpll_genl_lock_status {
>> +	DPLL_LOCK_STATUS_UNLOCKED,
>> +	DPLL_LOCK_STATUS_EXT_1PPS,
>> +	DPLL_LOCK_STATUS_EXT_10MHZ,
>> +	DPLL_LOCK_STATUS_SYNCE,
>> +	DPLL_LOCK_STATUS_INT_OSCILLATOR,
>> +	DPLL_LOCK_STATUS_GNSS,
>> +
>> +	__DPLL_LOCK_STATUS_MAX,
>> +};
>> +#define DPLL_LOCK_STATUS_MAX (__DPLL_LOCK_STATUS_MAX - 1)
> 
> In addition to what I wrote in the previous reply where I suggested to
> have lock status independent on type or source, I think we should merge
> "status" and "lock status" to one attr/enum. Or any reason to have these
> separate?
> 
Yep, agree. No reason to have it separate anymore.

