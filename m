Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 606605FA461
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 21:56:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229492AbiJJT4D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 15:56:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiJJT4C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 15:56:02 -0400
Received: from novek.ru (unknown [213.148.174.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C33557BCC;
        Mon, 10 Oct 2022 12:56:01 -0700 (PDT)
Received: from [192.168.0.18] (unknown [37.228.234.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id D18FC504E68;
        Mon, 10 Oct 2022 22:52:31 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru D18FC504E68
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1665431553; bh=LiznkmJ8jKobM6DyZ5Cz+PlEaN8jmGNTRMZ8UxRmSE0=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=ChjCFxWU/tAG5qzcMkiMjgBeOBgJZioI4WOdvLD3vAVUuqeLN+sztBD0OwoPFu7Fj
         Ews+IuVsNZdVp3Th7V7/a0gVbkIIJ0alRJTmgnRSzCD+AskCU9DUoPK3Zz0Hfkyetr
         CPwja4eIHxceRObmcS4U10g207+kZTJEkwF48xVo=
Message-ID: <3a6330df-4fe0-d103-8663-80f3698d66f3@novek.ru>
Date:   Mon, 10 Oct 2022 20:55:57 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [RFC PATCH v3 4/6] dpll: get source/output name
Content-Language: en-US
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-clk@vger.kernel.org, Vadim Fedorenko <vadfed@fb.com>
References: <20221010011804.23716-1-vfedorenko@novek.ru>
 <20221010011804.23716-5-vfedorenko@novek.ru> <Y0Pp019euDMHOjJu@nanopsycho>
From:   Vadim Fedorenko <vfedorenko@novek.ru>
In-Reply-To: <Y0Pp019euDMHOjJu@nanopsycho>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10.10.2022 10:45, Jiri Pirko wrote:
> Mon, Oct 10, 2022 at 03:18:02AM CEST, vfedorenko@novek.ru wrote:
>> From: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
>>
>> Dump names of sources and outputs in response to DPLL_CMD_DEVICE_GET dump
>> request.
>>
>> Signed-off-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
>> ---
>> drivers/dpll/dpll_netlink.c | 24 ++++++++++++++++++++++++
>> include/linux/dpll.h        |  2 ++
>> include/uapi/linux/dpll.h   |  2 ++
>> 3 files changed, 28 insertions(+)
>>
>> diff --git a/drivers/dpll/dpll_netlink.c b/drivers/dpll/dpll_netlink.c
>> index a5779871537a..e3604c10b59e 100644
>> --- a/drivers/dpll/dpll_netlink.c
>> +++ b/drivers/dpll/dpll_netlink.c
>> @@ -31,12 +31,16 @@ static const struct nla_policy dpll_genl_set_source_policy[] = {
>> 	[DPLLA_DEVICE_ID]	= { .type = NLA_U32 },
>> 	[DPLLA_SOURCE_ID]	= { .type = NLA_U32 },
>> 	[DPLLA_SOURCE_TYPE]	= { .type = NLA_U32 },
>> +	[DPLLA_SOURCE_NAME]	= { .type = NLA_STRING,
>> +				    .len = DPLL_NAME_LENGTH },
>> };
>>
>> static const struct nla_policy dpll_genl_set_output_policy[] = {
>> 	[DPLLA_DEVICE_ID]	= { .type = NLA_U32 },
>> 	[DPLLA_OUTPUT_ID]	= { .type = NLA_U32 },
>> 	[DPLLA_OUTPUT_TYPE]	= { .type = NLA_U32 },
>> +	[DPLLA_OUTPUT_NAME]	= { .type = NLA_STRING,
>> +				    .len = DPLL_NAME_LENGTH },
>> };
>>
>> static const struct nla_policy dpll_genl_set_src_select_mode_policy[] = {
>> @@ -100,6 +104,7 @@ static int __dpll_cmd_dump_sources(struct dpll_device *dpll,
>> {
>> 	int i, ret = 0, type, prio;
>> 	struct nlattr *src_attr;
>> +	const char *name;
>>
>> 	for (i = 0; i < dpll->sources_count; i++) {
>> 		src_attr = nla_nest_start(msg, DPLLA_SOURCE);
>> @@ -132,6 +137,15 @@ static int __dpll_cmd_dump_sources(struct dpll_device *dpll,
>> 				break;
>> 			}
>> 		}
>> +		if (dpll->ops->get_source_name) {
>> +			name = dpll->ops->get_source_name(dpll, i);
>> +			if (name && nla_put_string(msg, DPLLA_SOURCE_NAME,
>> +						   name)) {
>> +				nla_nest_cancel(msg, src_attr);
>> +				ret = -EMSGSIZE;
>> +				break;
>> +			}
>> +		}
>> 		nla_nest_end(msg, src_attr);
>> 	}
>>
>> @@ -143,6 +157,7 @@ static int __dpll_cmd_dump_outputs(struct dpll_device *dpll,
>> {
>> 	struct nlattr *out_attr;
>> 	int i, ret = 0, type;
>> +	const char *name;
>>
>> 	for (i = 0; i < dpll->outputs_count; i++) {
>> 		out_attr = nla_nest_start(msg, DPLLA_OUTPUT);
>> @@ -167,6 +182,15 @@ static int __dpll_cmd_dump_outputs(struct dpll_device *dpll,
>> 			}
>> 			ret = 0;
>> 		}
>> +		if (dpll->ops->get_output_name) {
>> +			name = dpll->ops->get_output_name(dpll, i);
>> +			if (name && nla_put_string(msg, DPLLA_OUTPUT_NAME,
>> +						   name)) {
>> +				nla_nest_cancel(msg, out_attr);
>> +				ret = -EMSGSIZE;
>> +				break;
>> +			}
>> +		}
>> 		nla_nest_end(msg, out_attr);
>> 	}
>>
>> diff --git a/include/linux/dpll.h b/include/linux/dpll.h
>> index 3fe957a06b90..2f4964dc28f0 100644
>> --- a/include/linux/dpll.h
>> +++ b/include/linux/dpll.h
>> @@ -23,6 +23,8 @@ struct dpll_device_ops {
>> 	int (*set_output_type)(struct dpll_device *dpll, int id, int val);
>> 	int (*set_source_select_mode)(struct dpll_device *dpll, int mode);
>> 	int (*set_source_prio)(struct dpll_device *dpll, int id, int prio);
>> +	const char *(*get_source_name)(struct dpll_device *dpll, int id);
>> +	const char *(*get_output_name)(struct dpll_device *dpll, int id);
> 
> Hmm, why you exactly need the name for?
> 
As with device name, user-space app can use source/output name to easily select 
one using configuration value, for example.
> 
>> };
>>
>> struct dpll_device *dpll_device_alloc(struct dpll_device_ops *ops, const char *name,
>> diff --git a/include/uapi/linux/dpll.h b/include/uapi/linux/dpll.h
>> index f6b674e5cf01..8782d3425aae 100644
>> --- a/include/uapi/linux/dpll.h
>> +++ b/include/uapi/linux/dpll.h
>> @@ -26,11 +26,13 @@ enum dpll_genl_attr {
>> 	DPLLA_SOURCE,
>> 	DPLLA_SOURCE_ID,
>> 	DPLLA_SOURCE_TYPE,
>> +	DPLLA_SOURCE_NAME,
>> 	DPLLA_SOURCE_SUPPORTED,
>> 	DPLLA_SOURCE_PRIO,
>> 	DPLLA_OUTPUT,
>> 	DPLLA_OUTPUT_ID,
>> 	DPLLA_OUTPUT_TYPE,
>> +	DPLLA_OUTPUT_NAME,
>> 	DPLLA_OUTPUT_SUPPORTED,
>> 	DPLLA_STATUS,
>> 	DPLLA_TEMP,
>> -- 
>> 2.27.0
>>

