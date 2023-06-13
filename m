Return-Path: <netdev+bounces-10390-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5BCC072E3FD
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 15:24:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4E4861C20C6E
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 13:24:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F8182D26D;
	Tue, 13 Jun 2023 13:24:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3285B522B
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 13:24:28 +0000 (UTC)
Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 809011AA
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 06:24:26 -0700 (PDT)
Received: from [141.14.220.45] (g45.guest.molgen.mpg.de [141.14.220.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: pmenzel)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id 2DBED61E5FE01;
	Tue, 13 Jun 2023 15:23:31 +0200 (CEST)
Message-ID: <1e2404ff-232b-5999-cdb2-4205c58b071f@molgen.mpg.de>
Date: Tue, 13 Jun 2023 15:23:30 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH net-next v2 1/3] net: add check for current MAC address in
 dev_set_mac_address
Content-Language: en-US
To: Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
 Piotr Gardocki <piotrx.gardocki@intel.com>
Cc: netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
 przemyslaw.kitszel@intel.com, michal.swiatkowski@linux.intel.com,
 kuba@kernel.org, anthony.l.nguyen@intel.com, simon.horman@corigine.com,
 aleksander.lobakin@intel.com
References: <20230613122420.855486-1-piotrx.gardocki@intel.com>
 <20230613122420.855486-2-piotrx.gardocki@intel.com> <ZIhq4Mb7+jGxIdAn@boxer>
From: Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <ZIhq4Mb7+jGxIdAn@boxer>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Dear Maciej,


Am 13.06.23 um 15:10 schrieb Maciej Fijalkowski:
> On Tue, Jun 13, 2023 at 02:24:18PM +0200, Piotr Gardocki wrote:
>> In some cases it is possible for kernel to come with request
>> to change primary MAC address to the address that is already
>> set on the given interface.
>>
>> This patch adds proper check to return fast from the function
>> in these cases.
> 
> Please use imperative mood here - "add proper check..."

Just a note, that in “add check …” the verb *add* is already in 
imperative mood. (You can shorten “add noun …” often to just use the 
verb for the noun. In this case:

Check current MAC address in `dev_set_mac_address`

But it’s not specific enough. Maybe:

Avoid setting same MAC address


Kind regards,

Paul


>> An example of such case is adding an interface to bonding
>> channel in balance-alb mode:
>> modprobe bonding mode=balance-alb miimon=100 max_bonds=1
>> ip link set bond0 up
>> ifenslave bond0 <eth>
>>
>> Signed-off-by: Piotr Gardocki <piotrx.gardocki@intel.com>
> 
> I'll let Kuba ack it.
> 
>> ---
>>   net/core/dev.c | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/net/core/dev.c b/net/core/dev.c
>> index c2456b3667fe..8f1c49ab17df 100644
>> --- a/net/core/dev.c
>> +++ b/net/core/dev.c
>> @@ -8754,6 +8754,8 @@ int dev_set_mac_address(struct net_device *dev, struct sockaddr *sa,
>>   		return -EINVAL;
>>   	if (!netif_device_present(dev))
>>   		return -ENODEV;
>> +	if (!memcmp(dev->dev_addr, sa->sa_data, dev->addr_len))
>> +		return 0;
>>   	err = dev_pre_changeaddr_notify(dev, sa->sa_data, extack);
>>   	if (err)
>>   		return err;
>> -- 
>> 2.34.1
>>

