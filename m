Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9849530D093
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 02:00:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229771AbhBCA7o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 19:59:44 -0500
Received: from mga05.intel.com ([192.55.52.43]:45307 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229570AbhBCA7j (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 19:59:39 -0500
IronPort-SDR: yFrtkUtM93CaPe1BuQV7FyfTEWxjvEbxOZm4NogY2yoO7ptho/3lPewZa0i/BVTjigytSVY/0m
 +uvJzZ/P7QCQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9883"; a="265793123"
X-IronPort-AV: E=Sophos;i="5.79,396,1602572400"; 
   d="scan'208";a="265793123"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2021 16:58:58 -0800
IronPort-SDR: XyniwURsamQc2kzhZyF+19DLf7vbQO+HG4+NdrLTtYLCovOsNZgE7HyJwclOXNo8AV6+PqAnve
 KbBrNLU7t9sA==
X-IronPort-AV: E=Sophos;i="5.79,396,1602572400"; 
   d="scan'208";a="392040160"
Received: from shao2-debian.sh.intel.com (HELO [10.239.13.11]) ([10.239.13.11])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2021 16:58:56 -0800
Subject: Re: [PATCH] selftests/tls: fix compile errors after adding
 CHACHA20-POLY1305
To:     Vadim Fedorenko <vfedorenko@novek.ru>,
        Jakub Kicinski <kuba@kernel.org>,
        Boris Pismenny <borisp@nvidia.com>,
        Aviad Yehezkel <aviadye@nvidia.com>
Cc:     netdev@vger.kernel.org, kernel test robot <oliver.sang@intel.com>
References: <20210202094500.679761-1-rong.a.chen@intel.com>
 <157e79ea-e184-ea67-d1cf-39fa069624ec@novek.ru>
From:   Rong Chen <rong.a.chen@intel.com>
Message-ID: <32232647-99f0-4f42-d1a2-66b5c75cb943@intel.com>
Date:   Wed, 3 Feb 2021 08:58:27 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <157e79ea-e184-ea67-d1cf-39fa069624ec@novek.ru>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/2/21 6:11 PM, Vadim Fedorenko wrote:
> On 02.02.2021 09:45, Rong Chen wrote:
>> The kernel test robot reported the following errors:
>>
>> tls.c: In function ‘tls_setup’:
>> tls.c:136:27: error: storage size of ‘tls12’ isn’t known
>>    union tls_crypto_context tls12;
>>                             ^~~~~
>> tls.c:150:21: error: ‘tls12_crypto_info_chacha20_poly1305’ undeclared 
>> (first use in this function)
>>     tls12_sz = sizeof(tls12_crypto_info_chacha20_poly1305);
>>                       ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> tls.c:150:21: note: each undeclared identifier is reported only once 
>> for each function it appears in
>> tls.c:153:21: error: ‘tls12_crypto_info_aes_gcm_128’ undeclared 
>> (first use in this function)
>>     tls12_sz = sizeof(tls12_crypto_info_aes_gcm_128);
>>
>> Fixes: 4f336e88a870 ("selftests/tls: add CHACHA20-POLY1305 to tls 
>> selftests")
>> Reported-by: kernel test robot <oliver.sang@intel.com>
>> Link: 
>> https://lore.kernel.org/lkml/20210108064141.GB3437@xsang-OptiPlex-9020/
>> Signed-off-by: Rong Chen <rong.a.chen@intel.com>
>> ---
>>   include/net/tls.h                 | 9 ---------
>>   include/uapi/linux/tls.h          | 9 +++++++++
>>   tools/testing/selftests/net/tls.c | 4 ++--
>>   3 files changed, 11 insertions(+), 11 deletions(-)
>>
>> diff --git a/include/net/tls.h b/include/net/tls.h
>> index 3eccb525e8f7..54f7863ad915 100644
>> --- a/include/net/tls.h
>> +++ b/include/net/tls.h
>> @@ -212,15 +212,6 @@ struct cipher_context {
>>       char *rec_seq;
>>   };
>>   -union tls_crypto_context {
>> -    struct tls_crypto_info info;
>> -    union {
>> -        struct tls12_crypto_info_aes_gcm_128 aes_gcm_128;
>> -        struct tls12_crypto_info_aes_gcm_256 aes_gcm_256;
>> -        struct tls12_crypto_info_chacha20_poly1305 chacha20_poly1305;
>> -    };
>> -};
>> -
>>   struct tls_prot_info {
>>       u16 version;
>>       u16 cipher_type;
>> diff --git a/include/uapi/linux/tls.h b/include/uapi/linux/tls.h
>> index 0d54baea1d8d..9933dd425571 100644
>> --- a/include/uapi/linux/tls.h
>> +++ b/include/uapi/linux/tls.h
>> @@ -124,6 +124,15 @@ struct tls12_crypto_info_chacha20_poly1305 {
>>       unsigned char rec_seq[TLS_CIPHER_CHACHA20_POLY1305_REC_SEQ_SIZE];
>>   };
>>   +union tls_crypto_context {
>> +    struct tls_crypto_info info;
>> +    union {
>> +        struct tls12_crypto_info_aes_gcm_128 aes_gcm_128;
>> +        struct tls12_crypto_info_aes_gcm_256 aes_gcm_256;
>> +        struct tls12_crypto_info_chacha20_poly1305 chacha20_poly1305;
>> +    };
>> +};
>> +
>>   enum {
>>       TLS_INFO_UNSPEC,
>>       TLS_INFO_VERSION,
>> diff --git a/tools/testing/selftests/net/tls.c 
>> b/tools/testing/selftests/net/tls.c
>> index e0088c2d38a5..6951c8524a27 100644
>> --- a/tools/testing/selftests/net/tls.c
>> +++ b/tools/testing/selftests/net/tls.c
>> @@ -147,10 +147,10 @@ FIXTURE_SETUP(tls)
>>       tls12.info.cipher_type = variant->cipher_type;
>>       switch (variant->cipher_type) {
>>       case TLS_CIPHER_CHACHA20_POLY1305:
>> -        tls12_sz = sizeof(tls12_crypto_info_chacha20_poly1305);
>> +        tls12_sz = sizeof(struct tls12_crypto_info_chacha20_poly1305);
>>           break;
>>       case TLS_CIPHER_AES_GCM_128:
>> -        tls12_sz = sizeof(tls12_crypto_info_aes_gcm_128);
>> +        tls12_sz = sizeof(struct tls12_crypto_info_aes_gcm_128);
>>           break;
>>       default:
>>           tls12_sz = 0;
>>
>
> I'm not sure that it's a good idea to move tls_crypto_context to uapi 
> as it's
> an internal union. Previous patches assumes that user-space uses 
> different
> structures for different cipher configurations.

Hi Vadim,

Sorry i don't have the background, could you help to fix these build errors?

Best Regards,
Rong Chen

