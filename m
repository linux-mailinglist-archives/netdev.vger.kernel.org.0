Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95F6F389B39
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 04:14:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230291AbhETCOs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 22:14:48 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:4688 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230246AbhETCOs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 22:14:48 -0400
Received: from dggems701-chm.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FltW3215Fz16Q96;
        Thu, 20 May 2021 10:10:39 +0800 (CST)
Received: from dggpeml500017.china.huawei.com (7.185.36.243) by
 dggems701-chm.china.huawei.com (10.3.19.178) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 20 May 2021 10:13:25 +0800
Received: from [10.174.178.174] (10.174.178.174) by
 dggpeml500017.china.huawei.com (7.185.36.243) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 20 May 2021 10:13:25 +0800
Subject: Re: [PATCH -next resend] sfc: farch: fix compile warning in
 efx_farch_dimension_resources()
To:     Edward Cree <ecree.xilinx@gmail.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>
References: <20210519021136.1638370-1-yangyingliang@huawei.com>
 <d90bd556-efd0-1b75-7708-7217fe490cf2@gmail.com>
From:   Yang Yingliang <yangyingliang@huawei.com>
Message-ID: <3bf4adf0-ed98-ab86-cd5a-efca3ea856bc@huawei.com>
Date:   Thu, 20 May 2021 10:13:24 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <d90bd556-efd0-1b75-7708-7217fe490cf2@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.174.178.174]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500017.china.huawei.com (7.185.36.243)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 2021/5/19 22:40, Edward Cree wrote:
> On 19/05/2021 03:11, Yang Yingliang wrote:
>> Fix the following kernel build warning when CONFIG_SFC_SRIOV is disabled:
>>
>>    drivers/net/ethernet/sfc/farch.c: In function ‘efx_farch_dimension_resources’:
>>    drivers/net/ethernet/sfc/farch.c:1671:21: warning: variable ‘buftbl_min’ set but not used [-Wunused-but-set-variable]
>>      unsigned vi_count, buftbl_min, total_tx_channels;
>>
>> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
>> ---
>>   drivers/net/ethernet/sfc/farch.c | 9 +++++----
>>   1 file changed, 5 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/sfc/farch.c b/drivers/net/ethernet/sfc/farch.c
>> index 49df02ecee91..6048b08b89ec 100644
>> --- a/drivers/net/ethernet/sfc/farch.c
>> +++ b/drivers/net/ethernet/sfc/farch.c
>> @@ -1668,13 +1668,17 @@ void efx_farch_rx_pull_indir_table(struct efx_nic *efx)
>>    */
>>   void efx_farch_dimension_resources(struct efx_nic *efx, unsigned sram_lim_qw)
>>   {
>> -	unsigned vi_count, buftbl_min, total_tx_channels;
>> +	unsigned vi_count, total_tx_channels;
>>   
>>   #ifdef CONFIG_SFC_SRIOV
>>   	struct siena_nic_data *nic_data = efx->nic_data;
>> +	unsigned buftbl_min;
>>   #endif
> As I said the first time you sent this:
> Reverse xmas tree is messed up here, please fix.
> Apart from that, LGTM.

Do you mean like this:

diff --git a/drivers/net/ethernet/sfc/farch.c 
b/drivers/net/ethernet/sfc/farch.c

index 6048b08b89ec..b16f04cf7223 100644
--- a/drivers/net/ethernet/sfc/farch.c
+++ b/drivers/net/ethernet/sfc/farch.c
@@ -1668,10 +1668,10 @@ void efx_farch_rx_pull_indir_table(struct 
efx_nic *efx)
   */
  void efx_farch_dimension_resources(struct efx_nic *efx, unsigned 
sram_lim_qw)
  {
-    unsigned vi_count, total_tx_channels;
+    unsigned total_tx_channels, vi_count;

  #ifdef CONFIG_SFC_SRIOV
-    struct siena_nic_data *nic_data = efx->nic_data;
+    struct siena_nic_data *nic_data;
      unsigned buftbl_min;
  #endif

@@ -1679,6 +1679,7 @@ void efx_farch_dimension_resources(struct efx_nic 
*efx, unsigned sram_lim_qw)
      vi_count = max(efx->n_channels, total_tx_channels * 
EFX_MAX_TXQ_PER_CHANNEL);

  #ifdef CONFIG_SFC_SRIOV
+    nic_data = efx->nic_data;
      /* Account for the buffer table entries backing the datapath channels
       * and the descriptor caches for those channels.
       */


Thanks,

Yang

>
> -ed
>
>>   
>>   	total_tx_channels = efx->n_tx_channels + efx->n_extra_tx_channels;
>> +	vi_count = max(efx->n_channels, total_tx_channels * EFX_MAX_TXQ_PER_CHANNEL);
>> +
>> +#ifdef CONFIG_SFC_SRIOV
>>   	/* Account for the buffer table entries backing the datapath channels
>>   	 * and the descriptor caches for those channels.
>>   	 */
>> @@ -1682,9 +1686,6 @@ void efx_farch_dimension_resources(struct efx_nic *efx, unsigned sram_lim_qw)
>>   		       total_tx_channels * EFX_MAX_TXQ_PER_CHANNEL * EFX_MAX_DMAQ_SIZE +
>>   		       efx->n_channels * EFX_MAX_EVQ_SIZE)
>>   		      * sizeof(efx_qword_t) / EFX_BUF_SIZE);
>> -	vi_count = max(efx->n_channels, total_tx_channels * EFX_MAX_TXQ_PER_CHANNEL);
>> -
>> -#ifdef CONFIG_SFC_SRIOV
>>   	if (efx->type->sriov_wanted) {
>>   		if (efx->type->sriov_wanted(efx)) {
>>   			unsigned vi_dc_entries, buftbl_free;
>>
> .
