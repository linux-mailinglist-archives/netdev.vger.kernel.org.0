Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E431199869
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 16:26:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731115AbgCaO0m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Mar 2020 10:26:42 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:8435 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731108AbgCaO0m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Mar 2020 10:26:42 -0400
Received: from [10.193.177.223] (shahjada-abul.asicdesigners.com [10.193.177.223] (may be forged))
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 02VEQW5I030762;
        Tue, 31 Mar 2020 07:26:33 -0700
Subject: Re: [PATCH net-next] cxgb4/chcr: nic-tls stats in ethtool
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, borisp@mellanox.com,
        secdev@chelsio.com
References: <20200321112336.8771-1-rohitm@chelsio.com>
 <20200322135725.6cdc37a8@kicinski-fedora-PC1C0HJN>
From:   rohit maheshwari <rohitm@chelsio.com>
Message-ID: <cad731af-19c0-f16c-0c43-332de5d3dee0@chelsio.com>
Date:   Tue, 31 Mar 2020 19:56:31 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20200322135725.6cdc37a8@kicinski-fedora-PC1C0HJN>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 23/03/20 2:27 AM, Jakub Kicinski wrote:
> On Sat, 21 Mar 2020 16:53:36 +0530 Rohit Maheshwari wrote:
>> Included nic tls statistics in ethtool stats.
>>
>> Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>
>> ---
>>   .../ethernet/chelsio/cxgb4/cxgb4_ethtool.c    | 57 +++++++++++++++++++
>>   1 file changed, 57 insertions(+)
>>
>> diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
>> index 398ade42476c..4998f1d1e218 100644
>> --- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
>> +++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
>> @@ -134,6 +134,28 @@ static char loopback_stats_strings[][ETH_GSTRING_LEN] = {
>>   	"bg3_frames_trunc       ",
>>   };
>>   
>> +#ifdef CONFIG_CHELSIO_TLS_DEVICE
>> +struct chcr_tls_stats {
>> +	u64 tx_tls_encrypted_packets;
>> +	u64 tx_tls_encrypted_bytes;
>> +	u64 tx_tls_ctx;
>> +	u64 tx_tls_ooo;
>> +	u64 tx_tls_skip_no_sync_data;
>> +	u64 tx_tls_drop_no_sync_data;
>> +	u64 tx_tls_drop_bypass_req;
> I don't understand why you need to have a structure for this, and then
> you memset it to 0, unnecessarily, but I guess that's just a matter of
> taste.
Yeah, this memset is pure stupidity, I'll remove it and this new
structure as well. Thanks for the suggestion.
>> +};
>> +
>> +static char chcr_tls_stats_strings[][ETH_GSTRING_LEN] = {
>> +	"tx_tls_encrypted_pkts  ",
>> +	"tx_tls_encrypted_bytes ",
>> +	"tx_tls_ctx             ",
>> +	"tx_tls_ooo             ",
>> +	"tx_tls_skip_nosync_data",
>> +	"tx_tls_drop_nosync_data",
>> +	"tx_tls_drop_bypass_req ",
> These, however, are not correct - please remove the spaces at the end,
> otherwise your names are different than for other vendors. And there is
> an underscore in the middle of "no_sync".
>
> When you're told to adhere to API recommendation, please adhere to it
> exactly.
These spaces are used for alignment, so the statistics will be readable
for end user. As far as I understood, these are minimum set of TLS
related statistics, with or without space it will remain same for end
user. Please let me know if I am interpreting it wrong.
  However I agree about the no_sync, I'll change it in my
next patch.


