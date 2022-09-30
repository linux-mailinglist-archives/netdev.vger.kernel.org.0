Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F8295F01F4
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 02:53:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbiI3Axa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 20:53:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbiI3AxL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 20:53:11 -0400
Received: from out1.migadu.com (out1.migadu.com [91.121.223.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4F7D20589D;
        Thu, 29 Sep 2022 17:52:28 -0700 (PDT)
Message-ID: <9d828483-21d0-18da-0870-babcb50d5c03@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1664499146;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NHJr4Xpyg9WKtImexYWG0vQTFzDQgaCHa5Ss8yShYZc=;
        b=BKi0gDIvZ4KSxHZQ+chheYRT/I4Rf1DJsoX2trucN8c/yhu1oEhhUIBOE2kf4StEQQ0U48
        C7GjnGH5mXrkFkVxBgVQ9kC8adzkJhA5gZEi356riHWljcE1hI05rfYVK7pOfMiVAvYTMR
        fhLmlThZ7ULDgsRLHn4FHV11y9ggWaQ=
Date:   Thu, 29 Sep 2022 17:52:22 -0700
MIME-Version: 1.0
Subject: Re: [PATCH bpf-next] selftests/xsk: fix double free
Content-Language: en-US
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com, bpf@vger.kernel.org
References: <20220929090133.7869-1-magnus.karlsson@gmail.com>
 <YzV28OlK+pwlm/B/@boxer>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <YzV28OlK+pwlm/B/@boxer>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/29/22 3:44 AM, Maciej Fijalkowski wrote:
> On Thu, Sep 29, 2022 at 11:01:33AM +0200, Magnus Karlsson wrote:
>> From: Magnus Karlsson <magnus.karlsson@intel.com>
>>
>> Fix a double free at exit of the test suite.
>>
>> Fixes: a693ff3ed561 ("selftests/xsk: Add support for executing tests on physical device")
>> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
>> ---
>>   tools/testing/selftests/bpf/xskxceiver.c | 3 ---
>>   1 file changed, 3 deletions(-)
>>
>> diff --git a/tools/testing/selftests/bpf/xskxceiver.c b/tools/testing/selftests/bpf/xskxceiver.c
>> index ef33309bbe49..d1a5f3218c34 100644
>> --- a/tools/testing/selftests/bpf/xskxceiver.c
>> +++ b/tools/testing/selftests/bpf/xskxceiver.c
>> @@ -1953,9 +1953,6 @@ int main(int argc, char **argv)
>>   
>>   	pkt_stream_delete(tx_pkt_stream_default);
>>   	pkt_stream_delete(rx_pkt_stream_default);
>> -	free(ifobj_rx->umem);
>> -	if (!ifobj_tx->shared_umem)
shared_umem means ifobj_rx->umem and ifobj_tx->umem are the same?  No special 
handling is needed and ifobject_delete() will handle it?

>> -		free(ifobj_tx->umem);
>>   	ifobject_delete(ifobj_tx);
>>   	ifobject_delete(ifobj_rx);
> 
> So basically we free this inside ifobject_delete().

