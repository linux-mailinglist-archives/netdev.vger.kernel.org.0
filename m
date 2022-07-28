Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B034A583B25
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 11:22:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235102AbiG1JWC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 05:22:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234026AbiG1JWB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 05:22:01 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8F826566A;
        Thu, 28 Jul 2022 02:21:59 -0700 (PDT)
Received: from fraeml739-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4LtlRz2MkWz6853P;
        Thu, 28 Jul 2022 17:18:07 +0800 (CST)
Received: from lhreml745-chm.china.huawei.com (10.201.108.195) by
 fraeml739-chm.china.huawei.com (10.206.15.220) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 28 Jul 2022 11:21:57 +0200
Received: from [10.122.132.241] (10.122.132.241) by
 lhreml745-chm.china.huawei.com (10.201.108.195) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 28 Jul 2022 10:21:56 +0100
Message-ID: <10ddbfb4-c92e-4b16-5a04-64af3fa59c15@huawei.com>
Date:   Thu, 28 Jul 2022 12:21:55 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH v6 17/17] samples/landlock: adds network demo
Content-Language: ru
To:     =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
        <anton.sirazetdinov@huawei.com>
References: <20220621082313.3330667-1-konstantin.meskhidze@huawei.com>
 <20220621082313.3330667-18-konstantin.meskhidze@huawei.com>
 <78b7cd69-46d2-2868-8c9c-f4f29958a679@digikod.net>
From:   "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>
In-Reply-To: <78b7cd69-46d2-2868-8c9c-f4f29958a679@digikod.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.122.132.241]
X-ClientProxiedBy: lhreml751-chm.china.huawei.com (10.201.108.201) To
 lhreml745-chm.china.huawei.com (10.201.108.195)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



7/27/2022 11:26 PM, Mickaël Salaün пишет:
> 
> On 21/06/2022 10:23, Konstantin Meskhidze wrote:
>> This commit adds network demo. It's possible to
>> allow a sandoxer to bind/connect to a list of
>> particular ports restricting networks actions to
>> the rest of ports.
>> 
>> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
>> ---
>> 
>> Changes since v5:
>> * Makes network ports sandboxing optional.
>> * Fixes some logic errors.
>> * Formats code with clang-format-14.
>> 
>> Changes since v4:
>> * Adds ENV_TCP_BIND_NAME "LL_TCP_BIND" and
>> ENV_TCP_CONNECT_NAME "LL_TCP_CONNECT" variables
>> to insert TCP ports.
>> * Renames populate_ruleset() to populate_ruleset_fs().
>> * Adds populate_ruleset_net() and parse_port_num() helpers.
>> * Refactors main() to support network sandboxing.
>> 
>> ---
>>   samples/landlock/sandboxer.c | 118 +++++++++++++++++++++++++++++++----
>>   1 file changed, 107 insertions(+), 11 deletions(-)
>> 
>> diff --git a/samples/landlock/sandboxer.c b/samples/landlock/sandboxer.c
>> index 3e404e51ec64..0606c676fded 100644
>> --- a/samples/landlock/sandboxer.c
>> +++ b/samples/landlock/sandboxer.c
> 
> 
> [...]
> 
>> @@ -232,16 +308,36 @@ int main(const int argc, char *const argv[], char *const *const envp)
>>   		access_fs_rw &= ~ACCESS_ABI_2;
> 
> We need to check the ABI to make this sample work without a kernel
> supporting Landlock network access rights, and error out if the user
> explicitely asked for it anyway (with the environement variable).
> 
   Good point. Thanks for that.
   I will check it.
> 
>>   	}
>> 
>> +	/* Adds optionally network bind() support. */
>> +	env_port_name = getenv(ENV_TCP_BIND_NAME);
>> +	if (env_port_name) {
>> +		access_net_tcp |= LANDLOCK_ACCESS_NET_BIND_TCP;
>> +	}
>> +	/* Adds optionally network connect() support. */
>> +	env_port_name = getenv(ENV_TCP_CONNECT_NAME);
>> +	if (env_port_name) {
>> +		access_net_tcp |= LANDLOCK_ACCESS_NET_CONNECT_TCP;
>> +	}
>> +	ruleset_attr.handled_access_net = access_net_tcp;
>> +
>>   	ruleset_fd =
>>   		landlock_create_ruleset(&ruleset_attr, sizeof(ruleset_attr), 0);
>>   	if (ruleset_fd < 0) {
>>   		perror("Failed to create a ruleset");
>>   		return 1;
>>   	}
>> -	if (populate_ruleset(ENV_FS_RO_NAME, ruleset_fd, access_fs_ro)) {
>> +	if (populate_ruleset_fs(ENV_FS_RO_NAME, ruleset_fd, access_fs_ro)) {
>> +		goto err_close_ruleset;
>> +	}
>> +	if (populate_ruleset_fs(ENV_FS_RW_NAME, ruleset_fd, access_fs_rw)) {
>> +		goto err_close_ruleset;
>> +	}
>> +	if (populate_ruleset_net(ENV_TCP_BIND_NAME, ruleset_fd,
>> +				 LANDLOCK_ACCESS_NET_BIND_TCP)) {
>>   		goto err_close_ruleset;
>>   	}
>> -	if (populate_ruleset(ENV_FS_RW_NAME, ruleset_fd, access_fs_rw)) {
>> +	if (populate_ruleset_net(ENV_TCP_CONNECT_NAME, ruleset_fd,
>> +				 LANDLOCK_ACCESS_NET_CONNECT_TCP)) {
>>   		goto err_close_ruleset;
>>   	}
>>   	if (prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0)) {
>> --
>> 2.25.1
>> 
> .
